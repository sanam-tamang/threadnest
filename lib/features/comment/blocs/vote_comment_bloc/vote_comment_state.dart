part of 'vote_comment_bloc.dart';

sealed class VoteCommentState extends Equatable {
  const VoteCommentState();

  @override
  List<Object> get props => [];
}

final class VoteCommentInitial extends VoteCommentState {}

final class VoteCommentLoading extends VoteCommentState {}

final class VoteCommentLoaded extends VoteCommentState {}

final class VoteCommentFailure extends VoteCommentState {
  final Failure failure;

  const VoteCommentFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
