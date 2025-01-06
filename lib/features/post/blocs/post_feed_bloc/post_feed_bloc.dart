import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/post/models/post_model.dart';
import 'package:threadnest/features/post/repositories/post_repositories.dart';

part 'post_feed_event.dart';
part 'post_feed_state.dart';

///Not only questions but also the sharing your posts
class PostFeedBloc extends Bloc<PostFeedEvent, PostFeedState> {
  final PostRepositories _repo;

  PostFeedBloc({required PostRepositories repo})
      : _repo = repo,
        super(PostFeedInitial()) {
    on<PostFeedEvent>(_onPostQuestion);
  }

  Future<void> _onPostQuestion(
      PostFeedEvent event, Emitter<PostFeedState> emit) async {
    emit(PostFeedLoading());
    try {
      await _repo.postFeed(event.postFeed);
      emit(const PostFeedLoaded());
    } catch (e) {
      emit(PostFeedFailure(failure: Failure(message: e.toString())));
    }
  }
}
