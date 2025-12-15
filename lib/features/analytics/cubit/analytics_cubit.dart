import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/model/chats/chat_game/game_statistics_response/game_statistics_response.dart';
import 'package:meet_now_app_server/model/gifts/admin_gift_stats_dto/admin_gift_stats_dto.dart';
import 'package:meet_now_app_server/model/social/city/city_statistics_response/city_statistics_response.dart';
import 'package:meet_now_app_server/model/social/friends_request/friend_statistics_dto/friend_statistics_dto.dart';
import 'package:meet_now_app_server/model/social/icebreaker_topec/ice_breaker_statistics_response/ice_breaker_statistics_response.dart';
import 'package:meet_now_app_server/model/social/purpose/purpose_interest_statistics_response/purpose_interest_statistics_response.dart';
import 'package:meet_now_app_server/model/social/session_statistics/session_statistics.dart';
import 'package:meet_now_app_server/model/social/sticker/sticker_statistics_response/sticker_statistics_response.dart';
import 'package:meet_now_app_server/model/statistics/admin_system_statistics_dto/admin_system_statistics_dto.dart';
import 'package:meet_now_app_server/model/statistics/user_growth_statistics_dto/user_growth_statistics_dto.dart';
import 'package:meet_now_app_server/repository/admin/admin_interface.dart';

part 'analytics_state.dart';
part 'analytics_cubit.freezed.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit({required AdminInterface adminInterface})
    : _adminInterface = adminInterface,
      super(AnalyticsState.initial()) {
    _loadAnalyticsData();
  }

  final AdminInterface _adminInterface;

  Future<void> _loadAnalyticsData() async {
    emit(state.copyWith(isLoading: true));

    try {
      final systemStats = await _adminInterface.getSystemStatistics();
      final growthStats = await _adminInterface.getUserGrowthStatistics(
        days: 30,
      );
      final friendStats = await _adminInterface.getFriendStatistics();
      final giftStats = await _adminInterface.getAdminGiftStats();
      final gameStats = await _adminInterface.getGameStatistics();
      final stickerStats = await _adminInterface.getStickerStatistics();
      final purposeStats = await _adminInterface.getStatistics();
      final icebreakerStats = await _adminInterface.getIcebreakerStatistics();
      final cityStats = await _adminInterface.getCityStatistics();
      final sessionStats = await _adminInterface.getSessionStatistics();

      final analyticsData = AnalyticsData.fromApiResponses(
        systemStats: systemStats,
        growthStats: growthStats,
        friendStats: friendStats,
        giftStats: giftStats,
        gameStats: gameStats,
        stickerStats: stickerStats,
        purposeStats: purposeStats,
        icebreakerStats: icebreakerStats,
        cityStats: cityStats,
        sessionStats: sessionStats,
      );

      emit(state.copyWith(isLoading: false, data: analyticsData, error: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> changeDateRange(CustomDateTimeRange newRange) async {
    emit(state.copyWith(dateRange: newRange, isLoading: true));
    await _loadAnalyticsData();
  }

  void changeChartType(ChartType chartType) {
    emit(state.copyWith(selectedChart: chartType));
  }

  Future<void> refresh() async {
    emit(state.copyWith(isLoading: true));
    await _loadAnalyticsData();
  }

  Future<void> exportData() async {
    try {
      await _adminInterface.exportGamesData();
    } catch (e) {
      emit(state.copyWith(error: 'Export failed: ${e.toString()}'));
    }
  }
}
