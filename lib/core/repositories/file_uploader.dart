import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

sealed class BaseFileUploader {
  Future<String?> imageUploader(File? file);
  Future<String?> fileUploader(File? file);
}

class FileUploader implements BaseFileUploader {
  @override
  Future<String?> imageUploader(File? file) async {
    if (file == null) return null;
    try {
      final currentDate = DateTime.now().toIso8601String();
      final path = 'uploads/$currentDate';
      final imageUrlPath = await Supabase.instance.client.storage
          .from('images')
          .upload(path, file);

      return imageUrlPath;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> fileUploader(File? file) async {
    if (file == null) return null;
    try {
      final currentDate = DateTime.now().toIso8601String();
      final path = 'uploads/$currentDate+${file.path.split("/").last}';
      final fileUrl = await Supabase.instance.client.storage
          .from('file')
          .upload(path, file);

      return fileUrl;
    } catch (e) {
      rethrow;
    }
  }
}
