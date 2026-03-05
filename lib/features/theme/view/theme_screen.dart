import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/notification/widget/switch_item.dart';
import 'package:meet_now_app/features/theme/cubit/particles_cubit.dart';
import 'package:meet_now_app/features/theme/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';

@RoutePage()
class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final maxContentWidth = screenWidth > 600 ? 500.0 : screenWidth * 0.9;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxContentWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Text(
                              S.of(context).chooseTheme,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              S.of(context).themeChangesAffect,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ThemeCard(
                              title: S.of(context).lightTheme,
                              description: S.of(context).lightDescription,
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
                              title: S.of(context).darkTheme,
                              description: S.of(context).darkDescription,
                              isSelected: state.brightness == Brightness.dark,
                              brightness: Brightness.dark,
                              themeColors: [
                                Colors.black,
                                const Color(0xFF1E1E1E),
                                Colors.white,
                              ],
                              icon: Icons.dark_mode,
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<ParticlesCubit, ParticlesState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  loaded:
                                      (isParticles) => SwitchItem(
                                        title:
                                            S
                                                .of(context)
                                                .particlesOnTheMainScreen,
                                        subtitle:
                                            S
                                                .of(context)
                                                .enabledisableParticleAnimation,
                                        value: isParticles,
                                        onChanged: (value) {
                                          context
                                              .read<ParticlesCubit>()
                                              .toggleParticles(value);
                                        },
                                        icon: Icons.animation,
                                      ),
                                  error:
                                      (message) => Column(
                                        children: [
                                          Text(
                                            S
                                                .of(context)
                                                .particleSettingsLoadingErrorMessage,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          const SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed:
                                                () =>
                                                    context
                                                        .read<ParticlesCubit>()
                                                        .loadSettings(),
                                            child: Text(S.of(context).retry),
                                          ),
                                        ],
                                      ),
                                  orElse:
                                      () => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const AppBarWidget(),
        ],
      ),
    );
  }
}
