import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/comment/repositories/comment_repository.dart';

part 'post_comment_event.dart';
part 'post_comment_state.dart';

class PostCommentBloc extends Bloc<PostCommentEvent, PostCommentState> {
  final CommentRepository _repo;
  PostCommentBloc({required CommentRepository repo})
      : _repo = repo,
        super(PostCommentInitial()) {
    on<PostCommentEvent>((event, emit) async {
      emit(PostCommentLoading());
      try {
        await _repo.postComment(content: event.content, postId: event.postId);
        emit(PostCommentLoaded());
      } catch (e) {
        emit(PostCommentFailure(failure: Failure(message: e.toString())));
      }
    });
  }
}
