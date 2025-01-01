import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AppImagePicker {
  static Future<File?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
