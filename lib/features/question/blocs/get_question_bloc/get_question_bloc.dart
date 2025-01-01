import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/question/models/question.dart';
import 'package:threadnest/features/question/repositories/question_repositories.dart';
part 'get_question_event.dart';
part 'get_question_state.dart';

class GetQuestionBloc extends Bloc<BaseGetQuestionEvent, GetQuestionState> {
  final QuestionRepository _repo = QuestionRepository();

  Map<String, List<GetQuestion>> localQuestions = {};

  GetQuestionBloc() : super(GetQuestionInitial()) {
    on<GetQuestionsEvent>(_onGetQuestion);
    on<GetQuestionsVoteUpdateEvent>(_onQuestionVoteUpdateEvent);
    on<GetQuestionsByCommunityEvent>(_onGetQuestionsByCommunity);
  }

  Future<void> _onGetQuestion(
      GetQuestionsEvent event, Emitter<GetQuestionState> emit) async {
    emit(GetQuestionLoading());
    try {
      final questions = await _repo.getQuestions();
      localQuestions['normal'] = questions;

      emit(GetQuestionLoaded(questions: localQuestions));
    } catch (e) {
      emit(GetQuestionFailure(failure: Failure(message: e.toString())));
    }
  }

  Future<void> _onGetQuestionsByCommunity(GetQuestionsByCommunityEvent event,
      Emitter<GetQuestionState> emit) async {
    emit(GetQuestionLoading());
    try {
      final questions =
          await _repo.getQuestionsWithCommunity(communityId: event.communityId);
      localQuestions[event.communityId] = questions;
      emit(GetQuestionLoaded(questions: localQuestions));
    } catch (e) {
      emit(GetQuestionFailure(failure: Failure(message: e.toString())));
    }
  }

  void _onQuestionVoteUpdateEvent(
      GetQuestionsVoteUpdateEvent event, Emitter<GetQuestionState> emit) {
    localQuestions[event.questionKey] = event.questions;

    emit(GetQuestionLoaded(
        questions: localQuestions, currentState: "${DateTime.now()}"));
  }
}
