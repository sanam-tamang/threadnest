import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/community/repositories/community_repositories.dart';

part 'leave_community_event.dart';
part 'leave_community_state.dart';

class LeaveCommunityBloc
    extends Bloc<LeaveCommunityEvent, LeaveCommunityState> {
  final CommunityRepository _repo;
  LeaveCommunityBloc({required CommunityRepository repo})
      : _repo = repo,
        super(LeaveCommunityInitial()) {
    on<LeaveCommunityEvent>((event, emit) async {
      emit(LeaveCommunityLoading());
      try {
        await _repo.leaveCommunity(communityId: event.communityId);
        emit(LeaveCommunityLoaded());
      } catch (e) {
        emit(LeaveCommunityFailure(failure: Failure(message: e.toString())));
      }
    });
  }
}
