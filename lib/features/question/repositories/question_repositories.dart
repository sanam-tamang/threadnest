import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threadnest/core/repositories/file_uploader.dart';
import 'package:threadnest/features/question/models/question.dart';

class QuestionRepository {
  final _supabase = Supabase.instance;
  final _auth = FirebaseAuth.instance;
  final _fileUploader = FileUploader();

  Future<void> postQuestion(PostQuestion question) async {
    try {
      final imageUrl = await _fileUploader.imageUploader(question.imageFile);
      final documentUrl =
          await _fileUploader.fileUploader(question.documentFile);
      await _supabase.client.from('posts').insert({
        "title": question.title,
        "content": question.content,
        "image_url": imageUrl,
        "document_url": documentUrl,
        "community_id": question.communityId,
        "user_id": _auth.currentUser!.uid
      });
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GetQuestion>> getQuestions() async {
    try {
      final List data = await _supabase.client.rpc(
          'get_posts_with_author_and_community',
          params: {"current_user_id": _auth.currentUser!.uid});

      log(data.toString());

      final posts = List.from(data).map((e) => GetQuestion.fromMap(e)).toList();

      return posts;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GetQuestion>> getQuestionsWithCommunity(
      {required String communityId}) async {
    try {
      final List data = await _supabase.client
          .rpc('get_posts_according_to_community_id', params: {
        'current_community_id': communityId,
        "current_user_id": _auth.currentUser!.uid,
      });

      log(data.toString());

      final posts = List.from(data).map((e) => GetQuestion.fromMap(e)).toList();

      return posts;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
