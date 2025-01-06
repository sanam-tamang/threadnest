import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/community_admin/repositories/community_admin_repositories.dart';

part 'remove_community_post_event.dart';
part 'remove_community_post_state.dart';

class RemoveCommunityPostBloc
    extends Bloc<RemoveCommunityPostEvent, RemoveCommunityPostState> {
  final CommunityAdminRepositories _repo;

  RemoveCommunityPostBloc({required CommunityAdminRepositories repo})
      : _repo = repo,
        super(RemoveCommunityPostInitial()) {
    on<RemoveCommunityPostEvent>((event, emit) async {
      emit(RemoveCommunityPostLoading());

      try {
        await _repo.removePost(
            communityId: event.communityId, postId: event.postId);

        emit(RemoveCommunityLoaded());
      } catch (e) {
        emit(RemoveCommunityPostFailure(
            failure: Failure(message: e.toString())));
      }
    });
  }
}
