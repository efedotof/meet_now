import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:meet_now_app/features/about_app/widget/widget.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'MeetNow',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Твой мир знакомств и общения',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Познакомься с личностью — прежде чем увидеть лицо.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '📃 Описание приложения',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'MeetNow — уникальное приложение для знакомств, где первое впечатление строится не на внешности, а на общении. '
              'Забудь о бесконечных свайпах! Просто нажми "Поиск", пообщайся в анонимном чате, и если вы оба захотите — откройте анкеты и продолжите знакомство.',
            ),
            const SizedBox(height: 24),
            Text(
              '🔧 Основной функционал MeetNow',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            FeatureItem(
              icon: '💬',
              title: 'Анонимный старт (Blind Chat)',
              description:
                  'Временный чат со скрытой информацией. Время общения ограничено 5-10 минутами.',
            ),
            FeatureItem(
              icon: '🔓',
              title: 'Взаимное раскрытие анкет',
              description:
                  'Анкеты открываются только при взаимном согласии обоих пользователей.',
            ),
            FeatureItem(
              icon: '👥',
              title: 'Добавление в друзья',
              description:
                  'Возможность продолжить общение и добавить в друзья после раскрытия анкет.',
            ),
            FeatureItem(
              icon: '📚',
              title: 'Анкета пользователя',
              description:
                  'Подробная информация о пользователе, включая интересы и биографию.',
            ),
            const SizedBox(height: 24),
            Text(
              '🌟 Дополнительные функции',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                MyChip(label: '💡 Темы для общения'),
                MyChip(label: '🎭 Аватары вместо фото'),
                MyChip(label: '🎲 Вопрос дня'),
                MyChip(label: '🧩 Совпадение по интересам'),
                MyChip(label: '🔔 Второй шанс'),
                MyChip(label: '🕹 Мини-игры в чате'),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '🔐 Безопасность и приватность',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Все чаты шифруются\n• Жалобы/блокировка в 1 клик\n• Функция "Скрыть себя от поиска"',
            ),
            const SizedBox(height: 24),
            Text(
              '📲 Технологии',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Flutter (кросс-платформенность)\n• PostgreSQL\n• Java + SpringBoot',
            ),
            const SizedBox(height: 24),
            Text(
              '📞 Обратная связь',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email поддержки'),
              subtitle: const Text('support@meetnow.ru'),
              onTap: () => _launchUrl('mailto:support@meetnow.ru'),
            ),
            ListTile(
              leading: const Icon(Icons.travel_explore),
              title: const Text('Telegram канал'),
              subtitle: const Text('@meetnow_official'),
              onTap: () => _launchUrl('https://t.me/meetnow_official'),
            ),
          ],
        ),
      ),
    );
  }
}
