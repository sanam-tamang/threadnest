import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';

import 'package:threadnest/features/chat/repositories/chat_room_repository.dart';
import 'package:threadnest/features/profile/models/user.dart';

part 'create_chat_room_event.dart';
part 'create_chat_room_state.dart';

class CreateChatRoomBloc
    extends Bloc<CreateChatRoomEvent, CreateChatRoomState> {
  final ChatRoomRepository _repo;
  final Map<String, ({String roomId, User chatPartner})> _rooms = {};

  CreateChatRoomBloc({required ChatRoomRepository repo})
      : _repo = repo,
        super(CreateChatRoomInitial()) {
    on<CreateChatRoomEvent>((event, emit) async {
      try {
        emit(CreateChatRoomLoading());
        if (_rooms.containsKey(event.chatPartnerUserId)) {
          String roomId = _rooms[event.chatPartnerUserId]!.roomId;
          User chatPartner = _rooms[event.chatPartnerUserId]!.chatPartner;
          emit(CreateChatRoomLoaded(
              roomId: roomId,
              chatPartner: chatPartner,
              currentDate: DateTime.now().toIso8601String()));
          return;
        }
        final chatRoom = await _repo.createOrGetChatRoom(
            chatPartnerUserId: event.chatPartnerUserId);

        _rooms[event.chatPartnerUserId] = chatRoom;

        emit(CreateChatRoomLoaded(
            roomId: chatRoom.roomId, chatPartner: chatRoom.chatPartner));
      } catch (e) {
        emit(CreateChatRoomFailure(failure: Failure(message: e.toString())));
      }
    });
  }
}
