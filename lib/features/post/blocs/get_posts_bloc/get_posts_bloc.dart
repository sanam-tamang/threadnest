import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/post/models/post_model.dart';
import 'package:threadnest/features/post/repositories/post_repositories.dart';
part 'get_posts_event.dart';
part 'get_posts_state.dart';

///Get all things like sharefile it should have like getposts bloc for better readability
class GetPostsBloc extends Bloc<BasePostEvent, GetPostState> {
  final PostRepositories _repo;

  final Map<String, List<GetPost>> localPosts = {};

  GetPostsBloc({required PostRepositories repo})
      : _repo = repo,
        super(GetPostInitial()) {
    on<GetPostsEvent>(_onGetPosts);
    on<GetPostsByCommunityEvent>(_onGetPostsByCommunity);
    on<GetPostVoteUpdateEvent>(_onUpdatePostVote);
  }

  Future<void> _onGetPosts(
      GetPostsEvent event, Emitter<GetPostState> emit) async {
    emit(GetPostLoading());
    try {
      final questions = await _repo.getPosts();
      localPosts['normal'] = questions;

      emit(GetPostLoaded(posts: localPosts));
    } catch (e) {
      emit(GetPostFailure(failure: Failure(message: e.toString())));
    }
  }

  Future<void> _onGetPostsByCommunity(
      GetPostsByCommunityEvent event, Emitter<GetPostState> emit) async {
    emit(GetPostLoading());
    try {
      final questions =
          await _repo.getPostsByCommunity(communityId: event.communityId);
      localPosts[event.communityId] = questions;
      emit(GetPostLoaded(posts: localPosts));
    } catch (e) {
      emit(GetPostFailure(failure: Failure(message: e.toString())));
    }
  }

  void _onUpdatePostVote(
      GetPostVoteUpdateEvent event, Emitter<GetPostState> emit) {
    localPosts[event.postKey] = event.posts;

    emit(GetPostLoaded(posts: localPosts, currentState: "${DateTime.now()}"));
  }
}
