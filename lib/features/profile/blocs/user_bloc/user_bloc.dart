
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/profile/models/user.dart';
import 'package:threadnest/features/profile/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repo;
  final Map<String, User> _users =
      {}; //need to put list of user , visited by current user
  UserBloc({required UserRepository repo})
      : _repo = repo,
        super(UserInitial()) {
    on<GetUserEvent>(_onGetUser);
 
  }

  Future<void> _onGetUser(GetUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
      String? currentlyVisitedUser =
          event.currentlyVisitedProfileId ?? currentUserId;

      if (_users.containsKey(currentlyVisitedUser) && event.refresh!=true) {
        emit(UserLoaded(user: _users[currentlyVisitedUser]!));
        return;
      }
      final user = await _repo.getUser(userId: currentlyVisitedUser);

      _users[currentlyVisitedUser!] = user;

      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserFailure(failure: Failure(message: e.toString())));
    }
  }

}
