
import 'package:firebase_auth/firebase_auth.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threadnest/features/question/models/question.dart';

class QuestionVoteRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _supabase = Supabase.instance.client;
  Future<void> upvote(GetQuestion question) async {
    try {
      final data = await _supabase
          .from('post_votes')
          .select()
          .eq('post_id', question.id)
          .eq('user_id', _auth.currentUser!.uid);
      if (data.isEmpty) {
        await _supabase.from('post_votes').insert({
          'user_id': _auth.currentUser!.uid,
          'post_id': question.id,
          'vote_type': "up"
        });
      } else {
        throw "already voted";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downvote(GetQuestion question) async {
    try {
      final data = await _supabase
          .from('post_votes')
          .select()
          .eq('post_id', question.id)
          .eq('user_id', _auth.currentUser!.uid);
      if (data.isEmpty) {
        await _supabase.from('post_votes').insert({
          'user_id': _auth.currentUser!.uid,
          'post_id': question.id,
          'vote_type': "down"
        });
      } else {
        throw "already voted";
      }
    } catch (e) {
      rethrow;
    }
  }
}
