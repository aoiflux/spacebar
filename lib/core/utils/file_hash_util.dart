import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class FileHashUtil {
  static const int chunkSize = 1024 * 1024;

  static Future<String> calculateSha256(String filePath) async {
    final file = File(filePath);
    final stream = file.openRead();
    final hash = await sha256.bind(stream).first;
    return hash.toString();
  }

  static String calculateChunkHash(Uint8List chunk) {
    final hash = sha256.convert(chunk);
    return hash.toString();
  }

  static Future<int> getFileSize(String filePath) async {
    final file = File(filePath);
    return await file.length();
  }

  static Stream<Uint8List> readFileInChunks(String filePath) async* {
    final file = File(filePath);
    final stream = file.openRead();
    
    await for (var chunk in stream) {
      yield Uint8List.fromList(chunk);
    }
  }
}
