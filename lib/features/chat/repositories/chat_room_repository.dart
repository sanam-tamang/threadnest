import 'package:firebase_auth/firebase_auth.dart' as f_auth;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threadnest/features/chat/models/room.dart';
import 'package:threadnest/features/profile/models/user.dart' as local;

class ChatRoomRepository {
  final _supabase = Supabase.instance.client;
  final f_auth.FirebaseAuth _auth = f_auth.FirebaseAuth.instance;
  Stream<List<ChatRoom>> fetchChatRooms() async* {
    final currentUserId = _auth.currentUser?.uid;

    if (currentUserId == null) {
      yield [];
      return;
    }

    try {
      // Initial fetch of chat rooms
      final initialResponse = await _supabase.rpc(
        'fetch_chat_partners',
        params: {'current_user_id': currentUserId},
      );
      final initialRooms = List.from(initialResponse)
          .map((room) => ChatRoom.fromMap(room))
          .toList();

      yield initialRooms;

      // Listen to real-time changes in the `messages` table
      final messageStream = _supabase
          .from('messages')
          .stream(primaryKey: ['id']).order('sent_time', ascending: false);

      await for (final event in messageStream) {
        // Re-fetch chat rooms whenever there is a change in messages
        final updatedResponse = await _supabase.rpc(
          'fetch_chat_partners',
          params: {'current_user_id': currentUserId},
        );

        final updatedRooms = List.from(updatedResponse)
            .map((room) => ChatRoom.fromMap(room))
            .toList();

        yield updatedRooms;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<({String roomId, local.User chatPartner})> createOrGetChatRoom({
    required String chatPartnerUserId,
  }) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      final response = await _supabase.rpc('get_or_create_chat_room', params: {
        "current_user_id": currentUserId,
        "chat_partner_id": chatPartnerUserId
      });
      if (response.isNotEmpty) {
        final map = response.first;
        final String roomId = map['room_id'];
        final String partnerId = map['partner_id'];
        final String partnerName = map['chat_partner_name'];
        final String? partnerImageUrl = map['chat_partner_image_url'];
        final String? partnerBio = map['chat_partner_bio'];
        final local.User chatPartner = local.User(
            id: partnerId,
            name: partnerName,
            imageUrl: partnerImageUrl,
            bio: partnerBio);
        return (roomId: roomId, chatPartner: chatPartner);
      } else {
        throw "Chat room is not created";
      }
    } catch (e) {
      rethrow;
    }
  }
}
