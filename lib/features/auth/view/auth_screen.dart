import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/language/cubit/language_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meet_now_app/theme/theme_cubit/theme_cubit.dart';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  static const double mobileButtonWidth = double.infinity;
  static const double desktopButtonWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    final bool isDesktop =
        kIsWeb || Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    final double buttonWidth =
        isDesktop ? desktopButtonWidth : mobileButtonWidth;

    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return Scaffold(
              body: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors:
                        isDark
                            ? [
                              const Color(0xFF16213E),
                              const Color(0xFF1A1A2E),
                              Colors.black,
                            ]
                            : [
                              const Color(0xFFD1E8E2),
                              const Color(0xFFC7D3D8),
                              Colors.white,
                            ],
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              S.of(context).clickToChangeTheSubject,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white38 : Colors.black45,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                final cubit = context.read<ThemeCubit>();
                                final isDark = state.isDark;

                                cubit.setThemeBrightness(
                                  isDark ? Brightness.light : Brightness.dark,
                                );
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color:
                                      isDark
                                          ? colors.primary
                                          : colors.onSurface,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: colors.primary,
                                      blurRadius: 15,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.handshake,
                                  size: 60,
                                  color: isDark ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          "MNA",
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          S.of(context).connectAndCommunicateEasily,
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 48),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: buttonWidth),
                          child: ElevatedButton(
                            onPressed:
                                () => context.pushRoute(const SignInRoute()),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor:
                                  isDark ? Colors.white : Colors.black,
                              foregroundColor:
                                  isDark ? Colors.black : Colors.white,
                            ),
                            child: Text(
                              S.of(context).login,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: buttonWidth),
                          child: OutlinedButton(
                            onPressed:
                                () => context.pushRoute(const SignUpRoute()),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                              side: BorderSide(color: colors.primary, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              S.of(context).register,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     SizedBox(
                        //       width: MediaQuery.of(context).size.width * 0.2,
                        //       child: Expanded(
                        //         child: Divider(color: colors.secondary),
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 16),
                        //       child: Text(
                        //         "or continue with", // "или продолжить с"
                        //         style: TextStyle(color: colors.secondary),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: MediaQuery.of(context).size.width * 0.2,
                        //       child: Expanded(
                        //         child: Divider(color: colors.secondary),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        // const SizedBox(height: 24),
                        // if (!isDesktop)
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       IconButton(
                        //         iconSize: 48,
                        //         onPressed: () => context.pushRoute(QrCodeRoute()),
                        //         icon: Container(
                        //           padding: const EdgeInsets.all(12),
                        //           decoration: BoxDecoration(
                        //             shape: BoxShape.circle,
                        //             color:
                        //                 isDark
                        //                     ? Colors.grey.shade900
                        //                     : Colors.grey.shade200,
                        //           ),
                        //           child: const Icon(Icons.qr_code, size: 30),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isDark ? Colors.white12 : Colors.black12,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isDark
                                            ? Colors.white24
                                            : Colors.black26,
                                    width: 1,
                                  ),
                                ),
                                child: languageState.when(
                                  initial:
                                      () => const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                  loaded: (currentLocale, supportedLocales) {
                                    final languageName = _getLanguageName(
                                      currentLocale,
                                    );

                                    return GestureDetector(
                                      onTap:
                                          () => context.pushRoute(
                                            const LanguageRoute(),
                                          ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.language,
                                            size: 20,
                                            color:
                                                isDark
                                                    ? Colors.white70
                                                    : Colors.black87,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            languageName,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  isDark
                                                      ? Colors.white70
                                                      : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            size: 20,
                                            color:
                                                isDark
                                                    ? Colors.white54
                                                    : Colors.black54,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  error:
                                      (message) => Text(
                                        S.of(context).language,
                                        style: TextStyle(
                                          color: colors.error,
                                          fontSize: 14,
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      default:
        return locale.languageCode.toUpperCase();
    }
  }
}
