import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/chat/repositories/message_repository.dart';

part 'send_message_event.dart';
part 'send_message_state.dart';

class SendMessageBloc extends Bloc<SendMessageEvent, SendMessageState> {
  final MessageRepository _repo;
  SendMessageBloc({required MessageRepository repo})
      : _repo = repo,
        super(SendMessageInitial()) {
    on<SendMessageEvent>((event, emit) async {
      emit(SendMessageLoading());

      try {
        await _repo.sendMessage(roomId: event.roomId, content: event.content);
        emit(SendMessageLoaded());
      } catch (e) {
        emit(SendMessageFailure(failure: Failure(message: e.toString())));
      }
    });
  }
}
