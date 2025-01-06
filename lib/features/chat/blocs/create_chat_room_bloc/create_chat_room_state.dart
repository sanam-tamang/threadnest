part of 'create_chat_room_bloc.dart';

sealed class CreateChatRoomState extends Equatable {
  const CreateChatRoomState();

  @override
  List<Object?> get props => [];
}

final class CreateChatRoomInitial extends CreateChatRoomState {}

final class CreateChatRoomLoading extends CreateChatRoomState {}

final class CreateChatRoomLoaded extends CreateChatRoomState {
  final String roomId;
  final User chatPartner;

  ///helps to create new loaded effect
  /// even if I am fetching data from cache

  final String? currentDate;
  const CreateChatRoomLoaded(
      {this.currentDate, required this.roomId, required this.chatPartner});

  @override
  List<Object?> get props => [roomId, chatPartner, currentDate];
}

final class CreateChatRoomFailure extends CreateChatRoomState {
  final Failure failure;

  const CreateChatRoomFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
