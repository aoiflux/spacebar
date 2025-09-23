# spacebar

## Generate proto files
```
dart pub global activate protoc_plugin
protoc --dart_out=grpc:lib/generated protos/dues.proto
```