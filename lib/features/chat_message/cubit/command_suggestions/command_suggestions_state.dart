part of 'command_suggestions_cubit.dart';

@freezed
class CommandSuggestionsState with _$CommandSuggestionsState {
  const factory CommandSuggestionsState.initial() = _Initial;
  const factory CommandSuggestionsState.visible({
    required List<String> suggestions,
  }) = _Visible;
  const factory CommandSuggestionsState.hidden() = _Hidden;
}
