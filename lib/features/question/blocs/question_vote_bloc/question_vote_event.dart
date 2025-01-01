// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'question_vote_bloc.dart';

sealed class QuestionVoteEvent extends Equatable {
  const QuestionVoteEvent();

  @override
  List<Object> get props => [];
}

class QuestionVoteUpEvent extends QuestionVoteEvent {
  const QuestionVoteUpEvent({
    required this.questionKey,
    required this.question,
  });
  final String questionKey;
  final GetQuestion question;

  @override
  List<Object> get props => [question, questionKey];
}

class QuestionVoteDownEvent extends QuestionVoteEvent {
  const QuestionVoteDownEvent({
    required this.questionKey,
    required this.question,
  });
  final String questionKey;
  final GetQuestion question;

  @override
  List<Object> get props => [question, questionKey];
}
