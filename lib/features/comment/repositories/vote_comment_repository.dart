import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VoteCommentRepository {
  final Supabase _supabase = Supabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> upvote({required String commentId}) async {
    try {
      await _supabase.client.from('post_comment_votes').insert({
        "vote_type": "up",
        'voted_by': _auth.currentUser?.uid,
        'comment_id': commentId
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downvote({required String commentId}) async {
    try {
      await _supabase.client.from('post_comment_votes').insert({
        "vote_type": "down",
        'voted_by': _auth.currentUser?.uid,
        'comment_id': commentId
      });
    } catch (e) {
      rethrow;
    }
  }
}
