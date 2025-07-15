import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/theme/widget/widget.dart';
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';

@RoutePage()
class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор темы'), centerTitle: true),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Выберите тему оформления',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Изменения коснутся всего интерфейса приложения',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 32),
                ThemeCard(
                  title: 'Светлая тема',
                  description: 'Чистый и яркий дизайн',
                  isSelected: state.brightness == Brightness.light,
                  brightness: Brightness.light,
                  themeColors: [
                    Colors.white,
                    const Color(0xFFF5F5F5),
                    Colors.black,
                  ],
                  icon: Icons.light_mode,
                ),
                const SizedBox(height: 24),
                ThemeCard(
                  title: 'Темная тема',
                  description: 'Стильный и современный дизайн',
                  isSelected: state.brightness == Brightness.dark,
                  brightness: Brightness.dark,
                  themeColors: [
                    Colors.black,
                    const Color(0xFF1E1E1E),
                    Colors.white,
                  ],
                  icon: Icons.dark_mode,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
