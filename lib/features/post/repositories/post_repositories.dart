import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threadnest/core/repositories/file_uploader.dart';
import 'package:threadnest/features/post/models/post_model.dart';

class PostRepositories {
  final _supabase = Supabase.instance;
  final _auth = FirebaseAuth.instance;
  final _fileUploader = FileUploader();

  Future<void> postFeed(PostFeed feed) async {
    try {
      final imageUrl = await _fileUploader.imageUploader(feed.imageFile);
      final documentUrl = await _fileUploader.fileUploader(feed.documentFile);
      await _supabase.client.from('posts').insert({
        "title": feed.title,
        "content": feed.content,
        "image_url": imageUrl,
        "document_url": documentUrl,
        "community_id": feed.communityId,
        "user_id": _auth.currentUser!.uid
      });
      return;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GetPost>> getPosts() async {
    try {
      final List data = await _supabase.client.rpc(
          'get_posts_with_author_and_community',
          params: {"current_user_id": _auth.currentUser!.uid});

      log(data.toString());

      final posts = List.from(data).map((e) => GetPost.fromMap(e)).toList();

      return posts;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<GetPost>> getPostsByCommunity(
      {required String communityId}) async {
    try {
      final List data = await _supabase.client
          .rpc('get_posts_according_to_community_id', params: {
        'current_community_id': communityId,
        "current_user_id": _auth.currentUser!.uid,
      });

      log(data.toString());

      final posts = List.from(data).map((e) => GetPost.fromMap(e)).toList();

      return posts;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<GetPost> getPostFromIdWithComments({required String postId}) async {
    try {
      final data =
          await _supabase.client.rpc('get_post_with_comments', params: {
        'current_post_id': postId,
        "current_user_id": _auth.currentUser!.uid,
      });
      log(data.toString());

      final post = GetPost.fromMap(data.first);

      return post;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
