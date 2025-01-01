// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_question_bloc.dart';

sealed class BaseGetQuestionEvent extends Equatable {
  const BaseGetQuestionEvent();

  @override
  List<Object> get props => [];
}

class GetQuestionsEvent extends BaseGetQuestionEvent {
  const GetQuestionsEvent();

  @override
  List<Object> get props => [];
}

class GetQuestionsByCommunityEvent extends BaseGetQuestionEvent {
  const GetQuestionsByCommunityEvent({
    required this.communityId,
  });
  final String communityId;

  @override
  List<Object> get props => [communityId];
}

class GetQuestionsVoteUpdateEvent extends BaseGetQuestionEvent {
  const GetQuestionsVoteUpdateEvent({
    required this.questionKey,
    required this.questions,
  });

  ///generally either "normal" or community id to distinguish key
  final String questionKey;
  final List<GetQuestion> questions;
  @override
  List<Object> get props => [questions, questionKey];
}
