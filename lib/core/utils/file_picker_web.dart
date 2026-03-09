import 'package:file_picker/file_picker.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';

Future<PickedFileData?> pickFile() async {
  final result = await FilePicker.platform.pickFiles(withReadStream: true);
  if (result == null || result.files.isEmpty) {
    return null;
  }

  final platformFile = result.files.first;
  if (platformFile.readStream == null) {
    return null;
  }

  return PickedFileData(
    name: platformFile.name,
    path: null,
    platformFile: platformFile,
  );
}
