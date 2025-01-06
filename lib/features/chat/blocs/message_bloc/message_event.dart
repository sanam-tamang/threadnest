part of 'message_bloc.dart';

sealed class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class GetMessageEvent extends MessageEvent {
  const GetMessageEvent({required this.roomId});
  final String roomId;

  @override
  List<Object> get props => [roomId];
}

class MessagesReceived extends MessageEvent {
  final List<Message> messages;

  const MessagesReceived({required this.messages});

  @override
  List<Object> get props => [messages];
}

class MessageError extends MessageEvent {
  final String error;

  const MessageError({required this.error});

  @override
  List<Object> get props => [error];
}
