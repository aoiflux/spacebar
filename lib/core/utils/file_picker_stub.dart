// Stub file - should not be used directly
import 'package:file_picker/file_picker.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';

Future<PickedFileData?> pickFile() async {
  throw UnsupportedError('File picker not supported on this platform');
}

PickedFileData platformFileToPickedFileData(PlatformFile platformFile) {
  throw UnsupportedError('File picker not supported on this platform');
}

Future<List<PickedFileData>?> pickMultipleFiles() async {
  throw UnsupportedError('File picker not supported on this platform');
}
