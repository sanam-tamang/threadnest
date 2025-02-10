import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/post/blocs/get_post_by_id_bloc/get_post_by_id_bloc.dart';
import 'package:threadnest/features/post/blocs/get_posts_bloc/get_posts_bloc.dart';
import 'package:threadnest/features/post/models/post_model.dart';

import 'package:threadnest/features/post/repositories/post_vote_repository.dart';

part 'post_vote_event.dart';
part 'post_vote_state.dart';

class PostVoteBloc extends Bloc<PostVoteEvent, PostVoteState> {
  final GetPostsBloc _bloc;
  final GetPostByIdBloc _getPostByIdBloc;
  final PostVoteRepository _repo;

  PostVoteBloc(
      {required GetPostsBloc bloc,
      required PostVoteRepository repo,
      required GetPostByIdBloc getPostByIdBloc})
      : _bloc = bloc,
        _repo = repo,
        _getPostByIdBloc = getPostByIdBloc,
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
          final post = event.post
              .copyWith(voteStatus: "up", upvotes: event.post.upvotes + 1);
          _getPostByIdBloc.add(UpdatePostByIdEvent(post));
          return post;
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
          final post = event.post.copyWith(
              voteStatus: "down", downvotes: event.post.downvotes + 1);
          ;
          _getPostByIdBloc.add(UpdatePostByIdEvent(post));

          return post;
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
