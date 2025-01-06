// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_chat_room_bloc.dart';

class CreateChatRoomEvent extends Equatable {
  const CreateChatRoomEvent({required this.chatPartnerUserId});
  final String chatPartnerUserId;
  @override
  List<Object> get props => [chatPartnerUserId];
}
