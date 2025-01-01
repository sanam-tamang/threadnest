part of 'question_vote_bloc.dart';

sealed class QuestionVoteState extends Equatable {
  const QuestionVoteState();

  @override
  List<Object> get props => [];
}

final class QuestionVoteInitial extends QuestionVoteState {}

final class QuestionVoteLoading extends QuestionVoteState {}

final class QuestionVoteLoaded extends QuestionVoteState {}

final class QuestionVoteFailure extends QuestionVoteState {
  final Failure failure;

  const QuestionVoteFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
