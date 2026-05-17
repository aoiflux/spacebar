import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:grpc/grpc.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:pointycastle/digests/sha3.dart';
import 'package:spacebar/core/cnst/cnst.dart';
import 'package:spacebar/core/common/models/evidence_file_model.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/common/models/progress_state.dart';
import 'package:spacebar/core/utils/util_io.dart';
import 'package:spacebar/core/utils/util_web.dart';
import 'package:spacebar/features/evi_store/data/sources/stream_file_io.dart';
import 'package:spacebar/features/evi_store/domain/repos/istorerepo.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

abstract interface class IEviStoreRemoteDataSource {
  Future<EvidenceFileModel?> appendIfExists(
    PickedFileData fileData, {
    OnProgressChanged? onProgress,
  });
  Future<EvidenceFileModel> streamFile(
    String fileType,
    PickedFileData fileData, {
    OnProgressChanged? onProgress,
  });
}

class GrpcStoreImpl implements IEviStoreRemoteDataSource {
  final Logger logger;
  late final DuesServiceClient client;
  GrpcStoreImpl(this.logger, this.client);

  String _fileHash = "";

  String _metadataFilePath(PickedFileData fileData) {
    final preferred = fileData.name.trim();
    if (preferred.isNotEmpty) {
      return preferred;
    }

    final rawPath = fileData.path ?? '';
    if (rawPath.isEmpty) {
      return 'uploaded_file';
    }

    final normalized = rawPath.replaceAll('\\', '/');
    final parts = normalized.split('/');
    return parts.isNotEmpty && parts.last.trim().isNotEmpty
        ? parts.last.trim()
        : 'uploaded_file';
  }

  String _uploadMetadataPath(PickedFileData fileData) {
    final baseName = _metadataFilePath(fileData);
    final cleanedHash = _fileHash.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final prefixLen = cleanedHash.length > 16 ? 16 : cleanedHash.length;
    final hashPrefix = cleanedHash.isNotEmpty
        ? cleanedHash.substring(0, prefixLen)
        : DateTime.now().millisecondsSinceEpoch.toString();
    return '${hashPrefix}_$baseName';
  }

  bool _isRetryableCreateFileMappingError(Object e) {
    if (e is! GrpcError) {
      return false;
    }

    final msg = (e.message ?? '').toLowerCase();
    return e.code == StatusCode.unknown &&
        (msg.contains('createfilemapping') ||
            msg.contains('externally altered') ||
            msg.contains('no longer valid'));
  }

  bool _isWebXhrInvalidStateError(Object e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('invalidstateerror') &&
        msg.contains('xmlhttprequest') &&
        (msg.contains('must be opened') || msg.contains('failed to execute'));
  }

  bool _isRetryableWebChunkFailure(http.Response res) {
    // Keep retry policy conservative and idempotent-friendly.
    return res.statusCode == 408 ||
        res.statusCode == 409 ||
        res.statusCode == 425 ||
        res.statusCode == 429 ||
        res.statusCode >= 500;
  }

  String _shortBody(String body) {
    final normalized = body.replaceAll('\n', ' ').trim();
    if (normalized.length <= 280) {
      return normalized;
    }
    return '${normalized.substring(0, 280)}...';
  }

  Map<String, dynamic> _parseJsonObjectBody(String body, String context) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) {
      throw Exception('$context returned an empty response body.');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(trimmed);
    } on FormatException catch (e) {
      throw Exception('$context returned invalid JSON: ${e.message}');
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('$context returned a non-object JSON payload.');
    }
    return decoded;
  }

  Future<void> _prepareFileHash(PickedFileData fileData) async {
    final fileHashResult = fileData.isWeb
        ? await getFileHashWeb(fileData)
        : await getFileHashDesktop(fileData);

    fileHashResult.match((error) {
      _fileHash = "";
      throw Exception('Failed to compute file hash: ${error.message}');
    }, (hash) => _fileHash = hash);

    if (_fileHash.trim().isEmpty) {
      throw Exception('File hash is empty. Please retry selecting the file.');
    }
  }

  Uri _normalizeWebUploadBaseUri(Uri uri) {
    final normalizedPath = uri.path.replaceAll(RegExp(r'/+$'), '');
    return uri.replace(path: normalizedPath);
  }

  Uri _resolveWebUploadBaseUri() {
    final explicit = const String.fromEnvironment(
      'WEB_UPLOAD_BASE_URL',
      defaultValue: '',
    ).trim();
    if (explicit.isNotEmpty) {
      final parsed = Uri.tryParse(explicit);
      if (parsed != null && parsed.hasScheme) {
        return _normalizeWebUploadBaseUri(parsed);
      }

      final relative = explicit.startsWith('/') ? explicit : '/$explicit';
      return _normalizeWebUploadBaseUri(Uri.base.resolve(relative));
    }

    final grpcWebUrl = const String.fromEnvironment(
      'GRPC_WEB_URL',
      defaultValue: '',
    ).trim();
    if (grpcWebUrl.isNotEmpty) {
      final uri = Uri.parse(grpcWebUrl);
      if (uri.hasScheme) {
        return _normalizeWebUploadBaseUri(
          Uri(
            scheme: uri.scheme,
            host: uri.host,
            port: uri.hasPort ? uri.port : null,
          ),
        );
      }
      return _normalizeWebUploadBaseUri(Uri.base.resolve(grpcWebUrl));
    }

    final scheme = Uri.base.scheme.isNotEmpty ? Uri.base.scheme : 'http';
    final host = (GrpCnst.host == 'localhost' && Uri.base.host.isNotEmpty)
        ? Uri.base.host
        : GrpCnst.host;
    return Uri(scheme: scheme, host: host, port: GrpCnst.port);
  }

  Uri _webUploadEndpointUri(Uri baseUri, String leaf) {
    final basePath = baseUri.path.replaceAll(RegExp(r'/+$'), '');
    final uploadRoot = basePath.endsWith('/web/upload')
        ? basePath
        : '$basePath/web/upload';
    final normalizedRoot = uploadRoot.startsWith('/')
        ? uploadRoot
        : '/$uploadRoot';
    return baseUri.replace(path: '$normalizedRoot/$leaf');
  }

  Future<int> _postWebChunkWithRetry({
    required Uri baseUri,
    required String uploadId,
    required List<int> chunk,
    required int chunkIndex,
    required int chunkOffset,
  }) async {
    const maxAttempts = 3;
    const useResumableHeaders = bool.fromEnvironment(
      'WEB_UPLOAD_RESUMABLE_HEADERS',
      defaultValue: false,
    );
    final idempotencyKey = '$uploadId-$chunkIndex-$chunkOffset-${chunk.length}';

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      final sw = Stopwatch()..start();
      final headers = <String, String>{
        'Content-Type': 'application/octet-stream',
        'Upload-Id': uploadId,
      };
      if (useResumableHeaders) {
        headers['Chunk-Index'] = '$chunkIndex';
        headers['Chunk-Offset'] = '$chunkOffset';
        headers['Idempotency-Key'] = idempotencyKey;
      }

      http.Response response;
      try {
        response = await http.post(
          _webUploadEndpointUri(baseUri, 'chunk'),
          headers: headers,
          body: chunk,
        );
      } on http.ClientException catch (e) {
        logger.w(
          'Chunk fetch failed uploadId=$uploadId index=$chunkIndex '
          'attempt=$attempt/$maxAttempts resumableHeaders=$useResumableHeaders '
          'error=$e',
        );
        if (attempt == maxAttempts) {
          rethrow;
        }
        await Future<void>.delayed(Duration(milliseconds: 200 * attempt));
        continue;
      }
      sw.stop();

      final ok = response.statusCode >= 200 && response.statusCode < 300;
      if (ok || response.statusCode == 409) {
        // 409 can mean duplicate idempotent chunk on retry; treat as success.
        if (response.statusCode == 409) {
          logger.w(
            'Chunk deduplicated by server (409) uploadId=$uploadId index=$chunkIndex offset=$chunkOffset',
          );
        }
        return sw.elapsedMilliseconds;
      }

      final retryable = _isRetryableWebChunkFailure(response);
      logger.w(
        'Chunk upload failure uploadId=$uploadId index=$chunkIndex '
        'attempt=$attempt/$maxAttempts status=${response.statusCode} '
        'retryable=$retryable body=${_shortBody(response.body)}',
      );
      if (!retryable || attempt == maxAttempts) {
        throw Exception(
          'Web upload chunk failed (${response.statusCode}): ${response.body}',
        );
      }

      await Future<void>.delayed(Duration(milliseconds: 200 * attempt));
    }

    throw Exception('Web upload chunk failed after retries.');
  }

  Future<EvidenceFileModel> _streamFileWebHttp(
    String fileType,
    PickedFileData fileData, {
    OnProgressChanged? onProgress,
  }) async {
    try {
      final baseUri = _resolveWebUploadBaseUri();
      final fileName = _metadataFilePath(fileData);
      final platformFile = fileData.webFile;
      final digest = SHA3Digest(256);
      final bufferedChunks = <Uint8List>[];
      int totalSize = 0;

      logger.i(
        'Web upload init: baseUri=$baseUri file=$fileName declaredSize=${platformFile.size}',
      );

      if (_fileHash.trim().isEmpty) {
        onProgress?.call(ProgressUpdate(stage: ProgressStage.hashing));

        final inMemoryBytes = platformFile.bytes;
        if (inMemoryBytes != null && inMemoryBytes.isNotEmpty) {
          final bytes = Uint8List.fromList(inMemoryBytes);
          digest.update(bytes, 0, bytes.length);
          bufferedChunks.add(bytes);
          totalSize = bytes.length;
        } else {
          final stream = platformFile.readStream;
          if (stream == null) {
            throw Exception('Web file stream is unavailable for upload.');
          }

          await for (final rawChunk in stream) {
            if (rawChunk.isEmpty) {
              continue;
            }
            final chunk = rawChunk is Uint8List
                ? Uint8List.fromList(rawChunk)
                : Uint8List.fromList(rawChunk);
            digest.update(chunk, 0, chunk.length);
            bufferedChunks.add(chunk);
            totalSize += chunk.length;
          }
        }

        if (totalSize == 0) {
          throw Exception('Selected web file is empty.');
        }

        final out = Uint8List(digest.digestSize);
        digest.doFinal(out, 0);
        _fileHash = base64Encode(out);
        onProgress?.call(ProgressUpdate(stage: ProgressStage.hashDone));
      } else {
        final inMemoryBytes = platformFile.bytes;
        if (inMemoryBytes != null && inMemoryBytes.isNotEmpty) {
          final bytes = Uint8List.fromList(inMemoryBytes);
          bufferedChunks.add(bytes);
          totalSize = bytes.length;
        } else {
          final stream = platformFile.readStream;
          if (stream == null) {
            throw Exception('Web file stream is unavailable for upload.');
          }

          await for (final rawChunk in stream) {
            if (rawChunk.isEmpty) {
              continue;
            }
            final chunk = rawChunk is Uint8List
                ? Uint8List.fromList(rawChunk)
                : Uint8List.fromList(rawChunk);
            bufferedChunks.add(chunk);
            totalSize += chunk.length;
          }
        }

        if (totalSize == 0) {
          throw Exception('Selected web file is empty.');
        }
      }

      logger.i(
        'Web upload prepared: file=$fileName totalSize=$totalSize chunksBuffered=${bufferedChunks.length}',
      );

      final startUri = _webUploadEndpointUri(baseUri, 'start');
      final startRes = await http.post(
        startUri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'file_path': fileName,
          'file_type': fileType,
          'file_hash': _fileHash,
        }),
      );

      logger.i(
        'Web upload start response: uri=$startUri status=${startRes.statusCode} body=${_shortBody(startRes.body)}',
      );

      if (startRes.statusCode < 200 || startRes.statusCode >= 300) {
        throw Exception(
          'Web upload start failed (${startRes.statusCode}): ${startRes.body}',
        );
      }

      final startJson = _parseJsonObjectBody(startRes.body, 'Web upload start');
      final uploadId = (startJson['upload_id'] ?? '').toString();
      if (uploadId.isEmpty) {
        throw Exception('Web upload start response missing upload_id.');
      }
      logger.i('Web upload session started: uploadId=$uploadId');

      const minChunkSize = 1 * 1024 * 1024;
      const maxChunkSize = 8 * 1024 * 1024;
      const chunkStep = 1 * 1024 * 1024;
      int adaptiveChunkSize = 2 * 1024 * 1024;

      onProgress?.call(ProgressUpdate(stage: ProgressStage.streaming));

      final pending = BytesBuilder(copy: false);
      int sentBytes = 0;
      int chunkIndex = 0;

      Future<void> flushPending({required bool forceAll}) async {
        var data = pending.takeBytes();
        int cursor = 0;

        while (cursor < data.length) {
          final remaining = data.length - cursor;
          if (!forceAll && remaining < adaptiveChunkSize) {
            final left = data.sublist(cursor);
            pending.add(left);
            return;
          }

          final take = forceAll
              ? remaining
              : (remaining < adaptiveChunkSize ? remaining : adaptiveChunkSize);
          final chunk = data.sublist(cursor, cursor + take);
          final elapsedMs = await _postWebChunkWithRetry(
            baseUri: baseUri,
            uploadId: uploadId,
            chunk: chunk,
            chunkIndex: chunkIndex,
            chunkOffset: sentBytes,
          );

          sentBytes += chunk.length;
          chunkIndex++;

          if (elapsedMs < 350 && adaptiveChunkSize < maxChunkSize) {
            adaptiveChunkSize += chunkStep;
            if (adaptiveChunkSize > maxChunkSize) {
              adaptiveChunkSize = maxChunkSize;
            }
          } else if (elapsedMs > 1800 && adaptiveChunkSize > minChunkSize) {
            adaptiveChunkSize -= chunkStep;
            if (adaptiveChunkSize < minChunkSize) {
              adaptiveChunkSize = minChunkSize;
            }
          }

          final progress = totalSize > 0 ? sentBytes / totalSize : null;
          onProgress?.call(
            ProgressUpdate(
              stage: ProgressStage.streaming,
              progress: progress,
              message: '${(sentBytes ~/ 1024)} / ${(totalSize ~/ 1024)} KB',
            ),
          );

          cursor += take;
        }
      }

      for (final incoming in bufferedChunks) {
        if (incoming.isEmpty) {
          continue;
        }
        pending.add(incoming);
        await flushPending(forceAll: false);
      }

      await flushPending(forceAll: true);
      logger.i(
        'Web upload chunks complete: uploadId=$uploadId sentBytes=$sentBytes',
      );

      final finalizeUri = _webUploadEndpointUri(baseUri, 'finalize');
      final finalizeRes = await http.post(
        finalizeUri,
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'upload_id': uploadId,
          if (_fileHash.isNotEmpty) 'file_hash': _fileHash,
        }),
      );

      logger.i(
        'Web upload finalize response: uri=$finalizeUri status=${finalizeRes.statusCode} body=${_shortBody(finalizeRes.body)}',
      );

      if (finalizeRes.statusCode < 200 || finalizeRes.statusCode >= 300) {
        throw Exception(
          'Web upload finalize failed (${finalizeRes.statusCode}): ${finalizeRes.body}',
        );
      }

      final finalizeJson = _parseJsonObjectBody(
        finalizeRes.body,
        'Web upload finalize',
      );
      final eviRaw = finalizeJson['evi_file'];
      if (eviRaw is! Map<String, dynamic>) {
        throw Exception('Web upload finalize response missing evi_file.');
      }

      final rawChunkMap = eviRaw['chunk_map'];
      final chunkMap = <String, int>{};
      if (rawChunkMap is Map) {
        rawChunkMap.forEach((key, value) {
          final k = key.toString();
          if (value is num) {
            chunkMap[k] = value.toInt();
          } else {
            chunkMap[k] = int.tryParse(value.toString()) ?? 0;
          }
        });
      }

      final normalizedChunkMap = HashMap<String, int>.from(chunkMap);
      final compressedSize = normalizedChunkMap.values.fold(
        0,
        (sum, size) => sum + size,
      );
      final fileId = (eviRaw['file_id'] ?? '').toString();
      final finalizedSize = eviRaw['file_size'] is num
          ? (eviRaw['file_size'] as num).toInt()
          : totalSize;

      if (fileId.isEmpty) {
        throw Exception('Web upload finalize response missing file_id.');
      }

      return EvidenceFileModel(
        fileName: fileName,
        fileId: fileId,
        totalSize: finalizedSize,
        compressedSize: compressedSize,
        chunkMap: normalizedChunkMap,
      );
    } catch (e, st) {
      logger.e('Web upload pipeline failed: $e', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<EvidenceFileModel?> appendIfExists(
    PickedFileData fileData, {
    OnProgressChanged? onProgress,
  }) async {
    if (fileData.isWeb) {
      // Web HTTP upload flow can rely on backend hash/metadata in finalize.
      return null;
    }

    onProgress?.call(ProgressUpdate(stage: ProgressStage.hashing));

    await _prepareFileHash(fileData);

    onProgress?.call(ProgressUpdate(stage: ProgressStage.hashDone));

    onProgress?.call(ProgressUpdate(stage: ProgressStage.appendCheck));

    AppendIfExistsReq req = AppendIfExistsReq(
      filePath: _metadataFilePath(fileData),
      fileHash: _fileHash,
    );

    AppendIfExistsRes res = await client.appendIfExists(req);
    if (res.err.isNotEmpty) {
      throw Exception('Append check failed: ${res.err}');
    }

    if (!res.exists) {
      return null;
    }

    HashMap<String, Int64> resMap = HashMap.from(res.eviFile.chunkMap);
    HashMap<String, int> chunkMap = HashMap();
    resMap.forEach((key, value) {
      chunkMap[key] = value.toInt();
    });
    EvidenceFileModel model = EvidenceFileModel(
      fileName: fileData.path ?? fileData.name,
      totalSize: res.eviFile.fileSize.toInt(),
      chunkMap: chunkMap,
      compressedSize: chunkMap.values.fold(0, (sum, size) => sum + size),
      fileId: res.eviFile.fileId,
    );
    return model;
  }

  @override
  Future<EvidenceFileModel> streamFile(
    String fileType,
    PickedFileData fileData, {
    OnProgressChanged? onProgress,
  }) async {
    // Prepare file metadata
    if (!fileData.isWeb && _fileHash.isEmpty) {
      onProgress?.call(ProgressUpdate(stage: ProgressStage.hashing));

      await _prepareFileHash(fileData);
      onProgress?.call(ProgressUpdate(stage: ProgressStage.hashDone));
    }

    if (fileData.isWeb) {
      final model = await _streamFileWebHttp(
        fileType,
        fileData,
        onProgress: onProgress,
      );
      onProgress?.call(ProgressUpdate(stage: ProgressStage.streamDone));
      _fileHash = "";
      return model;
    }

    bool useTempStaging = true;
    Stream<StreamFileReq> buildRequestStream(int attempt) {
      final attemptMetadataPath = '${_uploadMetadataPath(fileData)}_a$attempt';
      return streamFileDesktop(
        fileType: fileType,
        fileData: fileData,
        fileHash: _fileHash,
        metadataFilePath: attemptMetadataPath,
        stageToTempCopy: useTempStaging,
        logger: logger,
        onProgress: onProgress,
      );
    }

    try {
      // Call the streaming RPC
      StreamFileRes res;
      const maxAttempts = 3;
      int attempt = 0;
      while (true) {
        attempt++;
        try {
          res = await client.streamFile(buildRequestStream(attempt));
          break;
        } catch (e) {
          final canRetry =
              _isRetryableCreateFileMappingError(e) && attempt < maxAttempts;
          if (!canRetry) {
            rethrow;
          }

          if (!fileData.isWeb && !useTempStaging) {
            useTempStaging = true;
            logger.w('Switching to staged temp copy upload mode for retry');
          }

          final backoffMs = 250 * attempt;
          logger.w(
            'Retrying streamFile due to CreateFileMapping error '
            '(attempt $attempt/$maxAttempts, backoff ${backoffMs}ms)',
          );
          await Future<void>.delayed(Duration(milliseconds: backoffMs));
        }
      }

      if (!res.done) {
        throw Exception('Streaming failed: ${res.err}');
      }

      if (res.err.isNotEmpty) {
        throw Exception('Server error: ${res.err}');
      }

      onProgress?.call(ProgressUpdate(stage: ProgressStage.streamDone));

      HashMap<String, Int64> resMap = HashMap.from(res.eviFile.chunkMap);
      HashMap<String, int> chunkMap = HashMap();
      resMap.forEach((key, value) {
        chunkMap[key] = value.toInt();
      });

      final model = EvidenceFileModel(
        fileName: fileData.path ?? fileData.name,
        totalSize: res.eviFile.fileSize.toInt(),
        chunkMap: chunkMap,
        compressedSize: chunkMap.values.fold(0, (sum, size) => sum + size),
        fileId: res.eviFile.fileId,
      );

      // Reset state for next call
      _fileHash = "";

      return model;
    } catch (e) {
      if (_isWebXhrInvalidStateError(e)) {
        logger.e('Error streaming file: web XHR invalid state: $e');
        _fileHash = "";
        throw Exception(
          'Web upload failed: current backend upload RPC uses client-streaming, '
          'which is not reliably supported over gRPC-web/XHR in this setup. '
          'Use desktop upload or add a unary web upload endpoint on backend.',
        );
      }

      if (_isRetryableCreateFileMappingError(e)) {
        logger.e(
          'Error streaming file after retries: backend storage volume is unstable: $e',
        );
        _fileHash = "";
        throw Exception(
          'Upload failed because backend storage volume became unavailable '
          '(CreateFileMapping). Please verify or restart the gRPC backend '
          'storage and retry.',
        );
      }

      logger.e('Error streaming file: $e');
      _fileHash = "";
      rethrow;
    }
  }
}
