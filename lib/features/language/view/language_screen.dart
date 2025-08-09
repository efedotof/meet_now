import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/language/cubit/language_cubit.dart';
import 'package:meet_now_app/features/language/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).language)),
      body: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loaded:
                (currentLocale, supportedLocales) => LanguageList(
                  currentLocale: currentLocale,
                  supportedLocales: supportedLocales,
                ),
            error: (message) => Center(child: Text(message)),
          );
        },
      ),
    );
  }
}
