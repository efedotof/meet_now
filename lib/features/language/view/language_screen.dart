import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/language/cubit/language_cubit.dart';
import 'package:meet_now_app/features/language/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? double.infinity : 500,
                  maxHeight: isMobile ? double.infinity : 600,
                ),
                child: BlocBuilder<LanguageCubit, LanguageState>(
                  builder: (context, state) {
                    return state.when(
                      initial:
                          () =>
                              const Center(child: CircularProgressIndicator()),
                      loaded: (currentLocale, supportedLocales) {
                        return Container(
                          margin: EdgeInsets.all(isMobile ? 0 : 20),
                          decoration:
                              isMobile
                                  ? null
                                  : BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!isMobile) ...[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 30,
                                    left: 24,
                                    right: 24,
                                  ),
                                  child: Text(
                                    S.of(context).selectLanguage,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              Expanded(
                                child: LanguageList(
                                  currentLocale: currentLocale,
                                  supportedLocales: supportedLocales,
                                  isMobile: isMobile,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      error:
                          (message) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(message),
                            ),
                          ),
                    );
                  },
                ),
              ),
            ),
          ),
          const AppBarWidget(),
        ],
      ),
    );
  }
}
