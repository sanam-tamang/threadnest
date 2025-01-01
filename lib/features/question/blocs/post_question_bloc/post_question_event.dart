part of 'post_question_bloc.dart';

class PostQuestionEvent extends Equatable {
  final PostQuestion question;
  const PostQuestionEvent({required this.question});

  @override
  List<Object> get props => [question];
}
