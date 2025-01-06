import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityAdminRepositories {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Supabase _supabase = Supabase.instance;

  Future<void> removePost(
      {required String communityId, required String postId}) async {
    try {
      await _supabase.client.from('removed_posts').insert({
        'removed_by': _auth.currentUser!.uid,
        'post_id': postId,
        'community_id': communityId
      });
    } catch (e) {
      rethrow;
    }
  }
}
