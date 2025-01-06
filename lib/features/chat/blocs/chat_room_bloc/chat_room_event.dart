part of 'chat_room_bloc.dart';

sealed class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();

  @override
  List<Object> get props => [];
}

class GetChatRoomEvent extends ChatRoomEvent {
  const GetChatRoomEvent();

  @override
  List<Object> get props => [];
}

class _ChatRoomLoadedEvent extends ChatRoomEvent {
  const _ChatRoomLoadedEvent({required this.rooms});
  final List<ChatRoom> rooms;
  @override
  List<Object> get props => [rooms];
}

class _ChatRoomFailureEvent extends ChatRoomEvent {
  const _ChatRoomFailureEvent({required this.failure});

  final Failure failure;
  @override
  List<Object> get props => [failure];
}
