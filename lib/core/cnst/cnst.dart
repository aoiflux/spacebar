class GrpCnst {
  static const host = "localhost";
  static const port = 50051;
}

class FileType {
  // Keep legacy value for compatibility with older deployments.
  static const evi = "evi";

  // Values expected by current DUES backend validation.
  static const windowsExfat = "windows_exfat";
  static const linuxExt4 = "linux_ext4";
  static const other = "something_else";

  static String resolveFromFileName(String fileName) {
    final lower = fileName.toLowerCase();

    if (lower.endsWith('.dd') ||
        lower.endsWith('.img') ||
        lower.endsWith('.raw') ||
        lower.endsWith('.001')) {
      return linuxExt4;
    }

    if (lower.endsWith('.e01') ||
        lower.endsWith('.ex01') ||
        lower.endsWith('.vhd') ||
        lower.endsWith('.vhdx')) {
      return windowsExfat;
    }

    return other;
  }
}
