import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/language/cubit/language_cubit.dart';
import 'package:meet_now_app/features/language/widget/widget.dart';

@RoutePage()
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: BlocBuilder<LanguageCubit, LanguageState>(
              builder: (context, state) {
                return state.when(
                  initial:
                      () => const Center(child: CircularProgressIndicator()),
                  loaded:
                      (currentLocale, supportedLocales) => Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.12,
                          ),
                          LanguageList(
                            currentLocale: currentLocale,
                            supportedLocales: supportedLocales,
                          ),
                        ],
                      ),
                  error: (message) => Center(child: Text(message)),
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
