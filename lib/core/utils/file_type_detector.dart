import 'dart:io';

class FileTypeDetector {
  static String detectFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'img':
      case 'dd':
      case 'raw':
        return 'disk_image';
      case 'e01':
      case 'ex01':
        return 'encase_image';
      case 'aff':
      case 'afd':
        return 'aff_image';
      case 'vmdk':
        return 'vmware_disk';
      case 'vdi':
        return 'virtualbox_disk';
      case 'vhd':
      case 'vhdx':
        return 'hyperv_disk';
      default:
        return 'unknown';
    }
  }

  static Future<String> detectFileSystem(String filePath) async {
    // This is a placeholder - actual filesystem detection would require
    // reading file headers and analyzing partition tables
    // For now, return unknown
    return 'unknown';
  }

  static String getFileTypeDescription(String fileType) {
    switch (fileType) {
      case 'disk_image':
        return 'Raw Disk Image';
      case 'encase_image':
        return 'EnCase Evidence File';
      case 'aff_image':
        return 'Advanced Forensic Format';
      case 'vmware_disk':
        return 'VMware Virtual Disk';
      case 'virtualbox_disk':
        return 'VirtualBox Virtual Disk';
      case 'hyperv_disk':
        return 'Hyper-V Virtual Disk';
      default:
        return 'Unknown File Type';
    }
  }
}
