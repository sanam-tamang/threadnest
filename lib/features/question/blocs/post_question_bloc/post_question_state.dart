// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_question_bloc.dart';

sealed class PostQuestionState extends Equatable {
  const PostQuestionState();

  @override
  List<Object> get props => [];
}

final class PostQuestionInitial extends PostQuestionState {}

final class PostQuestionLoading extends PostQuestionState {}

final class PostQuestionLoaded extends PostQuestionState {
  const PostQuestionLoaded();

  @override
  List<Object> get props => [];
}

final class PostQuestionFailure extends PostQuestionState {
  final Failure failure;

  const PostQuestionFailure({required this.failure});
  @override
  List<Object> get props => [failure];
}
