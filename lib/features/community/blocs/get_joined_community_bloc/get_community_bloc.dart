import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/community/models/community.dart';
import 'package:threadnest/features/community/repositories/community_repositories.dart';

part 'get_community_event.dart';
part 'get_community_state.dart';

class GetJoinedCommunityBloc
    extends Bloc<GetJoinedCommunityEvent, GetJoinedCommunityState> {
  final CommunityRepository _repository;
  GetJoinedCommunityBloc({required CommunityRepository repo})
      : _repository = repo,
        super(GetJoinedCommunityInitial()) {
    on<GetJoinedCommunityEvent>((event, emit) async {
      emit(GetJoinedCommunityLoading());
      try {
        final communities = await _repository.getJoinedCommunities();
        emit(GetJoinedCommunityLoaded(communities: communities));
      } catch (e) {
        emit(
            GetJoinedCommunityFailure(failure: Failure(message: e.toString())));
      }
    });
  }
}
