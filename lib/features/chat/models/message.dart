import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String content;
  final String? imageUrl;
  final bool isRead;
  final String senderId;
  final String timestamp;
  const Message({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.isRead,
    required this.senderId,
    required this.timestamp,
  });

  @override
  List<Object?> get props {
    return [
      id,
      content,
      imageUrl,
      isRead,
      senderId,
      timestamp,
    ];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'imageUrl': imageUrl,
      'isRead': isRead,
      'senderId': senderId,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      content: map['content'],
      imageUrl: map['image_url'],
      isRead: map['is_read'],
      senderId: map['sender_id'],
      timestamp: map['sent_time'],
    );
  }
}
