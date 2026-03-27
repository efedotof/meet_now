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
          imageUrl: 'https://mnapp.ru/assets/update1.jpg',
          title: 'Магазин в настройках',
          description:
              'Вынесли магазин на страницу с настройками для более простого доступа.',
        ),
        const WhatNewSlide(
          imageUrl: 'https://mnapp.ru/assets/update2.jpg',
          title: 'Обновлённый дизайн',
          description: 'Обновили дизайн магазина и инвентаря.',
        ),
        const WhatNewSlide(
          imageUrl: 'https://mnapp.ru/assets/updage3.jpg',
          title: 'Новый режим поиска',
          description:
              'Новая вкладка в настройках для смены режима поиска. Теперь доступны 2 варианта поиска: Привычные свайпы и карточки, и анонимный поиск.',
        ),
        const WhatNewSlide(
          imageUrl: 'https://mnapp.ru/assets/update4.jpg',
          title: 'Непрочитанные сообщения',
          description:
              'Добавлено отображение количества непрочитанных сообщений.',
        ),
        const WhatNewSlide(
          imageUrl: 'https://mnapp.ru/assets/update5.jpg',
          title: 'Премиум‑режим поиска',
          description:
              'Новый режим поиска: Привычные свайпы и карточки. Однако, для доступа к этому режиму необходимо иметь изображения профиля, а также премиум статус, который можно получить бесплатно купив его в магазине за заработанные очки.',
        ),
        const WhatNewSlide(
          imageUrl: 'https://mnapp.ru/assets/update6.jpg',
          title: 'Быстрые очки',
          description:
              'Добавлен способ быстрого получения очков, посмотрев рекламу.',
        ),
        const WhatNewSlide(
          imageUrl: 'https://mnapp.ru/assets/update7.jpg',
          title: 'Исправление ошибок',
          description:
              'Исправлена ошибка в отображении ответов на вопросы пользователей.',
        ),
        const WhatNewSlide(
          imageUrl: 'https://mnapp.ru/assets/update8.jpg',
          title: 'Уведомления',
          description: 'Восстановили работу уведомлений.',
        ),
        const WhatNewSlide(
          imageUrl: null,
          title: 'Динамическое ценообразование подарков',
          description:
              'Обновление: теперь цены на подарки формируются автоматически!\n\n'
              'С сегодняшнего дня стоимость подарков больше не фиксирована — она зависит от общего экономического состояния приложения.\n'
              'Мы внедрили динамическое ценообразование, чтобы сделать рынок подарков более живым и справедливым.\n\n'
              'Как это работает?\n'
              '• Цена каждого подарка автоматически пересчитывается один раз в сутки.\n'
              '• Главный фактор — средний баланс очков всех пользователей.\n'
              '• Если в приложении много накопленных очков (средний баланс высокий), цены снижаются — это отличный момент, чтобы потратить очки на подарки.\n'
              '• Если средний баланс падает, цены повышаются — выгоднее копить очки, чтобы потом купить желаемое.\n\n'
              'Важно:\n'
              '• Базовая цена (указана в карточке подарка) — это минимальная стоимость, ниже она не опустится.\n'
              '• Цена никогда не вырастет больше чем в 3 раза от базовой — резких скачков не будет.\n\n'
              'Таким образом, теперь вы можете влиять на экономику сообщества: чем активнее пользователи тратят очки, тем доступнее становятся подарки для всех.\n'
              'Следите за изменениями цен и планируйте покупки!',
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
