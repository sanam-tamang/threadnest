import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:threadnest/features/chat/models/message.dart';

class MessageRepository {
  final _supabase = Supabase.instance.client;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<List<Message>> getMessages(String roomId) async* {
    try {
      final stream = _supabase
          .from('messages')
          .stream(primaryKey: ['id'])
          .eq('room_id', roomId)
          .order('sent_time', ascending: true);

      yield* stream
          .map((event) => event.map((e) => Message.fromMap(e)).toList());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage({
    required String roomId,
    required String content,
  }) async {
    final currentUserId = _auth.currentUser?.uid;
    try {
      await _supabase.from('messages').insert({
        'room_id': roomId,
        'sender_id': currentUserId,
        'content': content,
        'is_read': false,
        'sent_time': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markMessagesAsRead(String roomId, String recipientId) async {
    try {
      await _supabase
          .from('messages')
          .update({'is_read': true})
          .eq('room_id', roomId)
          .neq('sender_id', recipientId); // Only mark messages from others
    } catch (e) {
      rethrow;
    }
  }
}
