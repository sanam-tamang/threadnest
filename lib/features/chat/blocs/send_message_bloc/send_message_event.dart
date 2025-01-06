// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'send_message_bloc.dart';

class SendMessageEvent extends Equatable {
  const SendMessageEvent({
    required this.roomId,
    required this.content,
  });
  final String roomId;
  final String content;
  @override
  List<Object> get props => [roomId, content];
}
