import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threadnest/core/repositories/file_uploader.dart';
import 'package:threadnest/features/profile/models/user.dart' as local;

class UserRepository {
  final _supbase = Supabase.instance;
  final _auth = FirebaseAuth.instance;
  final BaseFileUploader _fileUploader;
  UserRepository({
    required BaseFileUploader fileUploader,
  }) : _fileUploader = fileUploader;
  Future<local.User> getUser({required String? userId}) async {
    userId ??= _auth.currentUser?.uid;
    try {
      final map = await _supbase.client
          .from('users')
          .select()
          .eq('id', userId!)
          .single();

      final user = local.User.fromMap(map);
      log(user.toString());
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editUser({String? name, String? bio, File? imageFile}) async {
    String userId = _auth.currentUser!.uid;

    try {
      final imageUrl = imageFile != null
          ? await _fileUploader.imageUploader(imageFile)
          : null;
      final data = {'name': name, 'bio': bio};

      if (imageUrl != null) {
        data.addAll({'image_url': imageUrl});
      }
      await _supbase.client.from('users').update(data).eq('id', userId);
    } catch (e) {
      rethrow;
    }
  }
}
