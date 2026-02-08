import 'package:grpc/grpc.dart';

dynamic createGrpcChannel(String host, int port) {
  return ClientChannel(
    host,
    port: port,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
}
