import 'package:grpc/grpc_web.dart';

dynamic createGrpcChannel(String host, int port, {String? webUrl}) {
  final overrideUrl = webUrl?.trim() ?? '';
  final uri = overrideUrl.isNotEmpty
      ? Uri.parse(overrideUrl)
      : (() {
          final scheme = Uri.base.scheme.isNotEmpty ? Uri.base.scheme : 'http';
          if (host.startsWith('/')) {
            return Uri(path: host);
          }
          return port > 0
              ? Uri(scheme: scheme, host: host, port: port)
              : Uri(scheme: scheme, host: host);
        })();

  return GrpcWebClientChannel.xhr(uri);
}
