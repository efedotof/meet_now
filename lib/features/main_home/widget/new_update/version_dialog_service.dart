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
          imageUrl: null,
          title: 'Что нового в этом обновлении',
          description:
              '\n\n\nМы обновили приложение, чтобы вам было удобнее и безопаснее.\n\n'
              'Листайте дальше, чтобы узнать подробности.',
        ),
        const WhatNewSlide(
          imageUrl: 'https://mnapp.ru/assets/update1_2.png',
          title: 'Баннер',
          description:
              'На главном экране теперь отображается информационный баннер.\n\n'
              'В нём публикуются:\n'
              '• Актуальные новости и акции приложения\n'
              '• Полезные советы по использованию\n'
              '• Анонсы будущих обновлений\n\n'
              'Баннер автоматически обновляется и не мешает навигации',
        ),
        const WhatNewSlide(
          imageUrl: 'https://mnapp.ru/assets/update2_2.png',
          title: 'Быстрый поиск собеседника',
          description:
              'Функция мгновенно находит случайного собеседника противоположного пола.\n\n'
              'Как это работает:\n'
              '• Сразу создаётся постоянный чат\n'
              '• Собеседник видит ваше имя, фото и информацию из профиля\n'
              '• Чат сохраняется в списке диалогов\n'
              '• Поиск не фильтрует возраст и другие параметры\n\n'
              'Будьте внимательны: вы можете встретить любого человека. '
              'Не делитесь личной информацией, если не уверены в безопасности.\n\n'
              'Лимиты использования:\n'
              '• Премиум-пользователи — безлимитный поиск (тратятся очки)\n'
              '• Обычные пользователи — 1 раз в день',
        ),
        const WhatNewSlide(
          imageUrl: null,
          title: 'Автоудаление неактивных пользователей',
          description:
              'С этого момента действует автоудаление пользователей.\n\n'
              'Если вы не заходили в приложение в течение 30 дней, ваш аккаунт будет автоматически безвозвратно удалён.\n\n'
              'Исключение составляют пользователи с ролью premium, admin, moderator.',
        ),
        const WhatNewSlide(
          imageUrl: null,
          title: 'Улучшение приватности общения',
          description:
              'Теперь каждое ваше сообщение шифруется путём присвоения чату уникального ключа.\n\n'
              'Этот ключ расшифровывается только с помощью ключей, которые хранятся непосредственно на вашем устройстве.\n\n'
              'Никто, включая нас, не может прочитать ваши переписки — безопасность гарантирована.',
        ),
        const WhatNewSlide(
          imageUrl: null,
          title: 'Жалобы на пользователей',
          description:
              'Теперь вы можете отправить жалобу на пользователя, если его поведение нарушает правила.\n\n'
              'Где находится кнопка жалобы:\n'
              '• В постоянном чате — справа сверху, возле имени собеседника\n'
              '• Во временном чате — слева снизу\n\n'
              'ВАЖНОЕ ПРЕДУПРЕЖДЕНИЕ:\n'
              'Если на вашем аккаунте накопится 10 общих жалоб, ваш аккаунт будет заблокирован.\n\n'
              'Для восстановления доступа обратитесь в поддержку.',
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
