import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/comment/repositories/vote_comment_repository.dart';

part 'vote_comment_event.dart';
part 'vote_comment_state.dart';

class VoteCommentBloc extends Bloc<VoteCommentEvent, VoteCommentState> {
  final VoteCommentRepository _repo;

  VoteCommentBloc({required VoteCommentRepository repo})
      : _repo = repo,
        super(VoteCommentInitial()) {
    on<VoteUpCommentEvent>(_onvoteupEvent);
    on<VoteDownCommentEvent>(_onvotedownEvent);
  }

  Future<void> _onvoteupEvent(
    VoteUpCommentEvent event,
    Emitter<VoteCommentState> emit,
  ) async {
    emit(VoteCommentLoading());
    try {
      await _repo.upvote(commentId: event.commentId);
      emit(VoteCommentLoaded());
    } catch (e) {
      emit(VoteCommentFailure(failure: Failure(message: e.toString())));
    }
  }

  Future<void> _onvotedownEvent(
      VoteDownCommentEvent event, Emitter<VoteCommentState> emit) async {
    emit(VoteCommentLoading());
    try {
      await _repo.downvote(commentId: event.commentId);
      emit(VoteCommentLoaded());
    } catch (e) {
      emit(VoteCommentFailure(failure: Failure(message: e.toString())));
    }
  }
}
