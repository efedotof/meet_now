import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/swipe/match_response/match_response.dart';
import 'package:meet_now_app_server/model/swipe/user_like_response/user_like_response.dart';
import 'package:meet_now_app_server/repository/swipe/swipe_interface.dart';
import 'package:meet_now_app_server/model/swipe/swipe_candidate_response/swipe_candidate_response.dart';

part 'card_swiper_state.dart';
part 'card_swiper_cubit.freezed.dart';

class CardSwiperCubit extends Cubit<CardSwiperState> {
  CardSwiperCubit({required this.interface}) : super(CardSwiperState.initial());

  final SwipeInterface interface;

  Future<void> loadAllData() async {
    await Future.wait([
      _loadNextCandidate(),
      loadMatches(),
      getUserWhoLikeMe(),
    ]);
  }

  void updateGender(String? gender) =>
      emit(state.copyWith(gender: gender, currentCandidate: null));
  void updateAgeRange(int? minAge, int? maxAge) => emit(
    state.copyWith(minAge: minAge, maxAge: maxAge, currentCandidate: null),
  );
  void updateVerified(bool? verified) =>
      emit(state.copyWith(verified: verified, currentCandidate: null));
  void updateInterests(List<String> interests) =>
      emit(state.copyWith(interests: interests, currentCandidate: null));
  void updatePurposes(List<String> purposes) =>
      emit(state.copyWith(purposes: purposes, currentCandidate: null));

  void toggleInterest(String interest) {
    final newInterests = List<String>.from(state.interests);
    if (newInterests.contains(interest)) {
      newInterests.remove(interest);
    } else {
      newInterests.add(interest);
    }
    emit(state.copyWith(interests: newInterests, currentCandidate: null));
  }

  void togglePurpose(String purpose) {
    final newPurposes = List<String>.from(state.purposes);
    if (newPurposes.contains(purpose)) {
      newPurposes.remove(purpose);
    } else {
      newPurposes.add(purpose);
    }
    emit(state.copyWith(purposes: newPurposes, currentCandidate: null));
  }

  void applyFilters() {
    emit(state.copyWith(currentCandidate: null, isLoading: false));
    _loadNextCandidate();
  }

  Future<void> _loadNextCandidate() async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final candidate = await interface.getCandidate(
        floor: _convertGender(state.gender),
        minAge: state.minAge,
        maxAge: state.maxAge,
        verified: state.verified,
        interests: state.interests.isEmpty ? null : state.interests,
        purposes: state.purposes.isEmpty ? null : state.purposes,
      );
      emit(state.copyWith(currentCandidate: candidate, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> swipeRight() async {
    final candidate = state.currentCandidate;
    if (candidate == null) return;
    try {
      await interface.likeUser(candidate.id);
      await _loadNextCandidate();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> swipeLeft() async {
    final candidate = state.currentCandidate;
    if (candidate == null) return;
    try {
      await interface.dislikeUser(candidate.id);
      await _loadNextCandidate();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> refreshCandidate() async {
    await _loadNextCandidate();
  }

  String? _convertGender(String? gender) {
    if (gender == null) return null;
    switch (gender.toLowerCase()) {
      case 'м':
      case 'муж':
      case 'male':
        return 'male';
      case 'ж':
      case 'жен':
      case 'female':
        return 'female';
      default:
        return null;
    }
  }

  Future<void> loadMatches() async {
    if (state.isLoadingMatches) return;
    emit(state.copyWith(isLoadingMatches: true, matchesErrorMessage: null));
    try {
      final matches = await interface.getMatches();
      emit(state.copyWith(matches: matches, isLoadingMatches: false));
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMatches: false,
          matchesErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> getUserWhoLikeMe() async {
    if (state.isLoadingLikes) return;
    emit(state.copyWith(isLoadingLikes: true, likesErrorMessage: null));
    try {
      final userLikes = await interface.getUsersWhoLikeMe();
      emit(state.copyWith(userLikes: userLikes, isLoadingLikes: false));
    } catch (e) {
      emit(
        state.copyWith(isLoadingLikes: false, likesErrorMessage: e.toString()),
      );
    }
  }
}
