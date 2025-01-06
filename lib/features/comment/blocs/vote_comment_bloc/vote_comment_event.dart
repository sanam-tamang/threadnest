// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'vote_comment_bloc.dart';

sealed class VoteCommentEvent extends Equatable {
  const VoteCommentEvent();
  @override
  List<Object> get props => [];
}

class VoteUpCommentEvent extends VoteCommentEvent {
  const VoteUpCommentEvent({required this.commentId});
  final String commentId;
  @override
  List<Object> get props => [commentId];
}

class VoteDownCommentEvent extends VoteCommentEvent {
  const VoteDownCommentEvent({required this.commentId});
  final String commentId;
  @override
  List<Object> get props => [commentId];
}
