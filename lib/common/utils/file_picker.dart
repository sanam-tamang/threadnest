import 'dart:io';

import 'package:file_picker/file_picker.dart';

class AppFilePicker {
  static Future<File?> pick() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'excel', 'pptx'],
    );
    if (file == null) {
      return null;
    } else if (file.files.single.path == null) {
      return null;
    }

    return File(file.files.single.path!);
  }
}
