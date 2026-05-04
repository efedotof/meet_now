import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'what_new_dialog.dart';
import 'what_new_slide.dart';

class VersionDialogService {
  static const String _keyShownVersion = 'shown_dialog_version';

  static Future<void> checkAndShowDialog(
    BuildContext context, {
    List<WhatNewSlide>? slides,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();

    final currentVersion = packageInfo.version;
    final shownVersion = prefs.getString(_keyShownVersion);

    if (shownVersion != currentVersion) {
      final defaultSlides = [
        const WhatNewSlide(
          imageUrl: 'https://mnapp.ru/assets/update1.png',
          title: 'Баннер',
          description: 'Добавлен баннер.',
        ),
        const WhatNewSlide(
          imageUrl: 'https://mnapp.ru/assets/update2.png',
          title: 'Быстрый поиск собеседника',
          description:
              'Добавлена возможность быстрого поиска собеседника. Для премиум пользователей можно бесконечно раз начинать, но необходимы очки. Для остальных пользователей можно 1 раз в день.',
        ),
      ];

      if (!context.mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WhatNewDialog(slides: slides ?? defaultSlides),
      );

      await prefs.setString(_keyShownVersion, currentVersion);
    }
  }
}
