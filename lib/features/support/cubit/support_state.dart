part of 'support_cubit.dart';

@freezed
class SupportState with _$SupportState {
  const factory SupportState.initial() = _Initial;
  const factory SupportState.loading() = _Loading;
  const factory SupportState.myQuestionsLoaded(List<Question> questions) =
      _MyQuestionsLoaded;
  const factory SupportState.questionDetail(Question question) =
      _QuestionDetail;
  const factory SupportState.questionCreated(Question question) =
      _QuestionCreated;
  const factory SupportState.statusUpdated(Question question) = _StatusUpdated;
  const factory SupportState.error(String message) = _Error;
}
