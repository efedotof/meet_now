part of 'news_cubit.dart';

@freezed
class NewsState with _$NewsState {
  const factory NewsState.initial() = _Initial;
  const factory NewsState.loading() = _Loading;
  const factory NewsState.news({required List<NewsResponse> news}) = _News;
  const factory NewsState.error({required String error}) = _Error;
}
