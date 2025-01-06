part of 'chat_room_bloc.dart';

sealed class ChatRoomState extends Equatable {
  const ChatRoomState();

  @override
  List<Object> get props => [];
}

final class ChatRoomInitial extends ChatRoomState {}

final class ChatRoomLoading extends ChatRoomState {}

final class ChatRoomLoaded extends ChatRoomState {
  final List<ChatRoom> rooms;

  const ChatRoomLoaded({required this.rooms});

  @override
  List<Object> get props => [rooms];
}

final class ChatRoomFailure extends ChatRoomState {
  final Failure failure;

  const ChatRoomFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
