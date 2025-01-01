import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/question/models/question.dart';
import 'package:threadnest/features/question/repositories/question_repositories.dart';

part 'post_question_event.dart';
part 'post_question_state.dart';

class PostQuestionBloc extends Bloc<PostQuestionEvent, PostQuestionState> {
  final QuestionRepository _repo = QuestionRepository();

  PostQuestionBloc() : super(PostQuestionInitial()) {
    on<PostQuestionEvent>(_onPostQuestion);
  }

  Future<void> _onPostQuestion(
      PostQuestionEvent event, Emitter<PostQuestionState> emit) async {
    emit(PostQuestionLoading());
    try {
      await _repo.postQuestion(event.question);
      emit(const PostQuestionLoaded());
    } catch (e) {
      emit(PostQuestionFailure(failure: Failure(message: e.toString())));
    }
  }
}
