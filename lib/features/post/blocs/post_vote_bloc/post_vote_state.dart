part of 'post_vote_bloc.dart';

sealed class PostVoteState extends Equatable {
  const PostVoteState();

  @override
  List<Object> get props => [];
}

final class PostVoteInitial extends PostVoteState {}

final class PostVoteLoading extends PostVoteState {}

final class PostVoteLoaded extends PostVoteState {}

final class PostVoteFailure extends PostVoteState {
  final Failure failure;

  const PostVoteFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
