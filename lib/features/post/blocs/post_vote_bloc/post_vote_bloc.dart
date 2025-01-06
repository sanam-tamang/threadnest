import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/post/blocs/get_posts_bloc/get_posts_bloc.dart';
import 'package:threadnest/features/post/models/post_model.dart';

import 'package:threadnest/features/post/repositories/post_vote_repository.dart';

part 'post_vote_event.dart';
part 'post_vote_state.dart';

class PostVoteBloc extends Bloc<PostVoteEvent, PostVoteState> {
  final GetPostsBloc _bloc;
  final PostVoteRepository _repo;

  PostVoteBloc({required GetPostsBloc bloc, required PostVoteRepository repo})
      : _bloc = bloc,
        _repo = repo,
        super(PostVoteInitial()) {
    on<PostVoteUpEvent>(_onUpvote);
    on<PostVoteDownEvent>(_onDownvote);
  }

  Future<void> _onUpvote(
      PostVoteUpEvent event, Emitter<PostVoteState> emit) async {
    //This code helps to perform local update
    final getPostBlocState = _bloc.state;
    if (getPostBlocState is GetPostLoaded) {
      final posts = getPostBlocState.posts[event.postKey];
      final newPosts = posts?.map((e) {
        if (e.id == event.post.id && event.post.voteStatus == null) {
          return event.post
              .copyWith(voteStatus: "up", upvotes: event.post.upvotes + 1);
        } else {
          return e;
        }
      }).toList();
      _bloc.add(GetPostVoteUpdateEvent(
          posts: newPosts ?? [], postKey: event.postKey));
    }

    emit(PostVoteLoading());

    try {
      await _repo.upvote(event.post);

      emit(PostVoteLoaded());
    } catch (e) {
      emit(PostVoteFailure(failure: Failure(message: e.toString())));
    }
  }

  Future<void> _onDownvote(
      PostVoteDownEvent event, Emitter<PostVoteState> emit) async {
    //This code helps to perform local update
    final getPostBlocState = _bloc.state;
    if (getPostBlocState is GetPostLoaded) {
      final posts = getPostBlocState.posts[event.postKey];
      final newPosts = posts?.map((e) {
        if (e.id == event.post.id && event.post.voteStatus == null) {
          return event.post.copyWith(
              voteStatus: "down", downvotes: event.post.downvotes + 1);
        } else {
          return e;
        }
      }).toList();
      _bloc.add(GetPostVoteUpdateEvent(
          posts: newPosts ?? [], postKey: event.postKey));
    }

    emit(PostVoteLoading());

    try {
      await _repo.downvote(event.post);

      emit(PostVoteLoaded());
    } catch (e) {
      emit(PostVoteFailure(failure: Failure(message: e.toString())));
    }
  }
}
