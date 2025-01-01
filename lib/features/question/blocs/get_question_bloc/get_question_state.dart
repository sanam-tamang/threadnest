// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_question_bloc.dart';

sealed class GetQuestionState extends Equatable {
  const GetQuestionState();

  @override
  List<Object?> get props => [];
}

final class GetQuestionInitial extends GetQuestionState {}

final class GetQuestionLoading extends GetQuestionState {}

final class GetQuestionLoaded extends GetQuestionState {
  const GetQuestionLoaded({required this.questions, this.currentState});

  ///it works like key as a normal when we get questions in our home /feed
  ///and when we fetch data from certain community need to put key as a community id and value and there posts
  ///
  final Map<String, List<GetQuestion>> questions;

  ///it will help to update state , because bloc not able to fully understand t
  final String? currentState;

  @override
  List<Object?> get props => [questions, currentState];
}

final class GetQuestionFailure extends GetQuestionState {
  final Failure failure;

  const GetQuestionFailure({required this.failure});
  @override
  List<Object> get props => [failure];
}
