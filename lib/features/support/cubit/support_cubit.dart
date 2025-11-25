import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/repository/support/support_interface.dart';
import 'package:meet_now_app_server/model/supports/create_question_request/create_question_request.dart';
import 'package:meet_now_app_server/model/social/question/question.dart';
import 'package:meet_now_app_server/model/social/question/question_status.dart';

part 'support_state.dart';
part 'support_cubit.freezed.dart';

class SupportCubit extends Cubit<SupportState> {
  SupportCubit({required SupportInterface supportInterface})
    : _supportInterface = supportInterface,
      super(SupportState.initial());

  final SupportInterface _supportInterface;

  Future<void> getMyQuestions() async {
    try {
      emit(SupportState.loading());
      final questions = await _supportInterface.getMyQuestions();
      emit(SupportState.myQuestionsLoaded(questions));
    } catch (e) {
      emit(SupportState.error(e.toString()));
    }
  }

  Future<void> getQuestion(String questionId) async {
    try {
      emit(SupportState.loading());
      final question = await _supportInterface.getQuestion(questionId);
      emit(SupportState.questionDetail(question));
    } catch (e) {
      emit(SupportState.error(e.toString()));
    }
  }

  Future<void> createQuestion(CreateQuestionRequest request) async {
    try {
      emit(SupportState.loading());
      final question = await _supportInterface.createQuestion(request);
      emit(SupportState.questionCreated(question));
    } catch (e) {
      emit(SupportState.error(e.toString()));
    }
  }

  Future<void> updateQuestionStatus(
    String questionId,
    QuestionStatus status,
  ) async {
    try {
      emit(SupportState.loading());
      final question = await _supportInterface.updateQuestionStatus(
        questionId,
        status,
      );
      emit(SupportState.statusUpdated(question));
    } catch (e) {
      emit(SupportState.error(e.toString()));
    }
  }
}
