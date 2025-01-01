import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/core/failure/failure.dart';
import 'package:threadnest/features/question/blocs/get_question_bloc/get_question_bloc.dart';
import 'package:threadnest/features/question/models/question.dart';
import 'package:threadnest/features/question/repositories/question_vote_repository.dart';

part 'question_vote_event.dart';
part 'question_vote_state.dart';

class QuestionVoteBloc extends Bloc<QuestionVoteEvent, QuestionVoteState> {
  final GetQuestionBloc _bloc;
  final QuestionVoteRepository _repo;

  QuestionVoteBloc(
      {required GetQuestionBloc bloc, required QuestionVoteRepository repo})
      : _bloc = bloc,
        _repo = repo,
        super(QuestionVoteInitial()) {
    on<QuestionVoteUpEvent>(_onUpvote);
    on<QuestionVoteDownEvent>(_onDownvote);
  }

  Future<void> _onUpvote(
      QuestionVoteUpEvent event, Emitter<QuestionVoteState> emit) async {
    //This code helps to perform local update
    final getQuestionBlocState = _bloc.state;
    if (getQuestionBlocState is GetQuestionLoaded) {
      final questions = getQuestionBlocState.questions[event.questionKey];
      final newQuestions = questions?.map((e) {
        if (e.id == event.question.id && event.question.voteStatus == null) {
          return event.question
              .copyWith(voteStatus: "up", upvotes: event.question.upvotes + 1);
        } else {
          return e;
        }
      }).toList();
      _bloc.add(GetQuestionsVoteUpdateEvent(
          questions: newQuestions ?? [], questionKey: event.questionKey));
    }

    emit(QuestionVoteLoading());

    try {
      await _repo.downvote(event.question);

      emit(QuestionVoteLoaded());
    } catch (e) {
      emit(QuestionVoteFailure(failure: Failure(message: e.toString())));
    }
  }

  Future<void> _onDownvote(
      QuestionVoteDownEvent event, Emitter<QuestionVoteState> emit) async {
    //This code helps to perform local update
    final getQuestionBlocState = _bloc.state;
    if (getQuestionBlocState is GetQuestionLoaded) {
      final questions = getQuestionBlocState.questions[event.questionKey];
      final newQuestions = questions?.map((e) {
        if (e.id == event.question.id && event.question.voteStatus == null) {
          return event.question.copyWith(
              voteStatus: "down", downvotes: event.question.downvotes + 1);
        } else {
          return e;
        }
      }).toList();
      _bloc.add(GetQuestionsVoteUpdateEvent(
          questions: newQuestions ?? [], questionKey: event.questionKey));
    }

    emit(QuestionVoteLoading());

    try {
      await _repo.upvote(event.question);

      emit(QuestionVoteLoaded());
    } catch (e) {
      emit(QuestionVoteFailure(failure: Failure(message: e.toString())));
    }
  }
}
