import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/chat/models/message.dart';
import 'package:threadnest/features/chat/repositories/message_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository _repo;
  StreamSubscription<List<Message>>? _messageSubscription;
  MessageBloc({required MessageRepository repo})
      : _repo = repo,
        super(MessageInitial()) {
    on<GetMessageEvent>(_onGetMessageEvent);
    on<MessagesReceived>(
        (event, emit) => emit(MessageLoaded(messages: event.messages)));
    on<MessageError>((event, emit) =>
        emit(MessageFailure(failure: Failure(message: event.error))));
  }

  void _onGetMessageEvent(GetMessageEvent event, Emitter<MessageState> emit) {
    emit(MessageLoading());

    _messageSubscription?.cancel();
    _messageSubscription = _repo.getMessages(event.roomId).listen(
      (messages) {
        if (!isClosed) {
          add(MessagesReceived(messages: messages));
        }
      },
      onError: (error) {
        if (!isClosed) {
          add(MessageError(error: error.toString()));
        }
      },
    );
  }

  @override
  Future<void> close() async {
    await _messageSubscription?.cancel();
    return super.close();
  }
}
