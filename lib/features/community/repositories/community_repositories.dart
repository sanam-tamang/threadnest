import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threadnest/features/community/models/community.dart';

class CommunityRepository {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> createCommunity(
      {required String name,
      required String description,
      required String? imageUrl,
      required String ownerId}) async {
    try {
      await Supabase.instance.client.from('communities').insert({
        'owner_id': ownerId,
        'image_url': imageUrl,
        'name': name,
        'description': description
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Community>> getCommunities() async {
    try {
      final supabase = Supabase.instance;
      // final data = await supabase.client
      //     .from('communities')
      //     .select('*,user_communities(*)')
      //     .eq('user_communities.userId', auth.currentUser!.uid);
      final data = await supabase.client
          .from('communities')
          .select('*, user_communities(user_id)')
          .eq("user_communities.user_id", auth.currentUser!.uid);

      final List<Community> communities = List.from(data).map((e) {
        bool isMember = e['user_communities'] == null
            ? false
            : e['user_communities'].isNotEmpty
                ? true
                : false;

        e.addAll({'is_member': isMember});

        return Community.fromMap(e);
      }).toList();
      return communities;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Community>> getJoinedCommunities() async {
    try {
      final data = await Supabase.instance.client
          .from('user_communities')
          .select('communities(*)')
          .eq("user_id", auth.currentUser!.uid);

      log(data.toString());

      final communities = List.from(data).map((e) {
        final Map<String, dynamic> newData = e['communities'];

        //to give something that it know it has user that t
        newData.addAll({'is_memeber': true});
        return Community.fromMap(newData);
      }).toList();
      return communities;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> joinCommunity({required String communityId}) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('user_communities').insert({
        'user_id': auth.currentUser!.uid,
        'community_id': communityId,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> leaveCommunity({required String communityId}) async {
    final supabase = Supabase.instance.client;

    try {
      await supabase
          .from('user_communities')
          .delete()
          .eq('user_id', auth.currentUser!.uid)
          .eq('community_id', communityId);
    }  catch (e) {

      rethrow;
    }
  }
}
