import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/profile/repositories/user_repository.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  final UserRepository _repo;

  EditUserBloc({required UserRepository repo})
      : _repo = repo,
        super(EditUserInitial()) {
    on<EditUserEvent>((event, emit) async {
      emit(EditUserLoading());
      try {
        await _repo.editUser(
            name: event.name, bio: event.bio, imageFile: event.imageFile);
        emit(EditUserLoaded());
      } catch (e) {
        emit(EditUserFailure(failure: Failure(message: e.toString())));
      }
    });
  }
}
