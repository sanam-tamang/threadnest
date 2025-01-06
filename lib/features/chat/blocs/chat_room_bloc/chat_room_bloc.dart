import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/chat/models/room.dart';
import 'package:threadnest/features/chat/repositories/chat_room_repository.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final ChatRoomRepository _repo;
  StreamSubscription<List<ChatRoom>>? _roomSubscription;
  ChatRoomBloc({required ChatRoomRepository repo})
      : _repo = repo,
        super(ChatRoomInitial()) {
    on<GetChatRoomEvent>(_onGetChatRoom);
    on<_ChatRoomLoadedEvent>(
        (event, emit) => emit(ChatRoomLoaded(rooms: event.rooms)));
    on<_ChatRoomFailureEvent>(
        (event, emit) => emit(ChatRoomFailure(failure: event.failure)));
  }

  void _onGetChatRoom(ChatRoomEvent event, Emitter<ChatRoomState> emit) {
    _roomSubscription?.cancel();
    emit(ChatRoomLoading());
    _roomSubscription = _repo.fetchChatRooms().listen((data) {
      add(_ChatRoomLoadedEvent(rooms: data));
    }, onError: (error) {
      add(_ChatRoomFailureEvent(failure: Failure(message: error.toString())));
    });
  }

  @override
  Future<void> close() {
    _roomSubscription?.cancel();
    return super.close();
  }
}
