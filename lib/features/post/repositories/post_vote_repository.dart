import 'package:firebase_auth/firebase_auth.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threadnest/features/post/models/post_model.dart';

class PostVoteRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _supabase = Supabase.instance.client;
  Future<void> upvote(GetPost question) async {
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

  Future<void> downvote(GetPost question) async {
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
