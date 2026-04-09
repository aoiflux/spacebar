import 'package:file_picker/file_picker.dart';

/// Unified file representation that works across platforms
class PickedFileData {
  /// File name with extension
  final String name;

  /// File path (available on desktop/mobile, may be null on web)
  final String? path;

  /// Platform-specific file object (web.File on web, null on other platforms)
  final Object? platformFile;

  const PickedFileData({required this.name, this.path, this.platformFile});

  /// Returns true if this file is from the web platform
  bool get isWeb => platformFile != null;

  /// Returns true if this file is from desktop/mobile platform
  bool get isDesktop => path != null;

  /// Returns the web.File object when on web platform
  /// Throws if called on non-web platform
  PlatformFile get webFile {
    if (platformFile == null) {
      throw UnsupportedError('platformFile is null - not on web platform');
    }
    return platformFile as PlatformFile;
  }
}
