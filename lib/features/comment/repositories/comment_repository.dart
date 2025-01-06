import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentRepository {
  final Supabase _supabase = Supabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> postComment(
      {required String postId, required String content}) async {
    try {
      await _supabase.client.from('post_comments').insert({
        "post_id": postId,
        'text': content,
        'commented_by': _auth.currentUser?.uid
      });
    } catch (e) {
      rethrow;
    }
  }
}
