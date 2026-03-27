part of 'document_cubit.dart';

@freezed
class DocumentState with _$DocumentState {
  const factory DocumentState.loading() = _Loading;
  const factory DocumentState.loaded({required String document}) = _Loaded;
  const factory DocumentState.error({required String error}) = _Error;
}
