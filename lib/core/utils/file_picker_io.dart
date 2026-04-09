import 'package:file_picker/file_picker.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';

/// Desktop/Mobile implementation - uses file path for efficient streaming
Future<PickedFileData?> pickFile() async {
  final result = await FilePicker.platform.pickFiles();
  if (result == null || result.files.isEmpty) {
    return null;
  }

  final platformFile = result.files.first;
  final path = platformFile.path;

  if (path == null) {
    throw Exception('File path is null on desktop platform');
  }

  return PickedFileData(
    name: platformFile.name,
    path: path,
    platformFile: null,
  );
}
