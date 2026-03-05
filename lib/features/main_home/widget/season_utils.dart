import 'package:flutter/material.dart';

enum Season { winter, spring, summer, autumn }

class SeasonUtils {
  static Season getCurrentSeason() {
    final now = DateTime.now();
    final month = now.month;

    if (month >= 3 && month <= 5) return Season.spring;
    if (month >= 6 && month <= 8) return Season.summer;
    if (month >= 9 && month <= 11) return Season.autumn;
    return Season.winter;
  }

  static Color getSeasonColor(Season season) {
    switch (season) {
      case Season.winter:
        return Colors.lightBlue;
      case Season.spring:
        return Colors.pinkAccent.shade100;
      case Season.summer:
        return Colors.yellow.shade600;
      case Season.autumn:
        return Colors.orange.shade700;
    }
  }

  static String getSeasonName(Season season) {
    switch (season) {
      case Season.winter:
        return 'Зима';
      case Season.spring:
        return 'Весна';
      case Season.summer:
        return 'Лето';
      case Season.autumn:
        return 'Осень';
    }
  }
}
