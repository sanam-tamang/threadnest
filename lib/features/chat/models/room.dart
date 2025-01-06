import 'package:equatable/equatable.dart';

import 'package:threadnest/features/profile/models/user.dart';

class ChatRoom extends Equatable {
  final String id;
  final User chatUser;
  final String? lastMessage;
  final String? lastMessageTimestamp;
  final bool? isLastMessageRead;

  const ChatRoom(
      {required this.id,
      required this.chatUser,
      required this.lastMessage,
      required this.lastMessageTimestamp,
      required this.isLastMessageRead});

  @override
  List<Object?> get props => [id, chatUser, lastMessage, lastMessageTimestamp];

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      chatUser: User.fromMap(map['chat_partner']),
      lastMessage: map['last_message'],
      isLastMessageRead: map['is_last_message_read'],
      lastMessageTimestamp: map['last_message_time'],
    );
  }
}
