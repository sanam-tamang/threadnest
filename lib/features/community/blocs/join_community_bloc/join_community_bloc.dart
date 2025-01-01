import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/community/repositories/community_repositories.dart';

part 'join_community_event.dart';
part 'join_community_state.dart';

///This community is useful when you want to join/unjoin certain community
class JoinCommunityBloc extends Bloc<JoinCommunityEvent, JoinCommunityState> {
  final CommunityRepository _repository = CommunityRepository();
  JoinCommunityBloc() : super(JoinCommunityInitial()) {
    on<JoinCommunityEvent>((event, emit) async {
      emit(JoinCommunityLoading());
      try {
        await _repository.joinCommunity(communityId: event.communityId);
        emit(const JoinCommunityLoaded());
      } catch (e) {
        emit(JoinCommunityFailure(failure: Failure(message: e.toString())));
      }
    });
  }
}
