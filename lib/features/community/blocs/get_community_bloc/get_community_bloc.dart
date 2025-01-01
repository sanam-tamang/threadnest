import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/community/models/community.dart';
import 'package:threadnest/features/community/repositories/community_repositories.dart';

part 'get_community_event.dart';
part 'get_community_state.dart';

class GetCommunityBloc extends Bloc<GetCommunityEvent, GetCommunityState> {
  final CommunityRepository _repository = CommunityRepository();
  GetCommunityBloc() : super(GetCommunityInitial()) {
    on<GetCommunityEvent>((event, emit) async {
      emit(GetCommunityLoading());
      try {
        final communities = await _repository.getCommunities();
        emit(GetCommunityLoaded(communities: communities));
      } catch (e) {
        emit(GetCommunityFailure(failure: Failure(message: e.toString())));
      }
    });
  }
}
