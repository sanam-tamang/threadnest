part of 'send_message_bloc.dart';

sealed class SendMessageState extends Equatable {
  const SendMessageState();

  @override
  List<Object> get props => [];
}

final class SendMessageInitial extends SendMessageState {}

final class SendMessageLoading extends SendMessageState {}

final class SendMessageLoaded extends SendMessageState {}

final class SendMessageFailure extends SendMessageState {
  final Failure failure;

  const SendMessageFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
