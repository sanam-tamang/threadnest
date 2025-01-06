part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}

final class MessageLoading extends MessageState {}

final class MessageLoaded extends MessageState {
  final List<Message> messages;

  const MessageLoaded({required this.messages});

  @override
  List<Object> get props => [messages];
}

final class MessageFailure extends MessageState {
  final Failure failure;

  const MessageFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
