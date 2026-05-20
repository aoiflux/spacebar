import 'package:grpc/grpc.dart';

dynamic createGrpcChannel(String host, int port, {String? webUrl}) {
  return ClientChannel(
    host,
    port: port,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
}
