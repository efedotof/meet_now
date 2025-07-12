part of 'sign_up_cubit.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = _Initial;
  const factory SignUpState.nextPage() = _NextPage;
  const factory SignUpState.error({required String error}) = _Error;
  const factory SignUpState.success() = _Success;
  const factory SignUpState.noData() = _NoData;
}
