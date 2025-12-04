import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/language/cubit/language_cubit.dart';

class LanguageList extends StatelessWidget {
  final Locale currentLocale;
  final List<Locale> supportedLocales;

  const LanguageList({
    super.key,
    required this.currentLocale,
    required this.supportedLocales,
  });

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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(supportedLocales.length, (index) {
        final locale = supportedLocales[index];
        return ListTile(
          title: Text(_getLanguageName(locale)),
          trailing:
              currentLocale.languageCode == locale.languageCode
                  ? const Icon(Icons.check)
                  : null,
          onTap: () {
            context.read<LanguageCubit>().changeLanguage(locale);
          },
        );
      }),
    );
    // return ListView.builder(
    //   itemCount: supportedLocales.length,
    //   itemBuilder: (context, index) {
    //     final locale = supportedLocales[index];
    // return ListTile(
    //   title: Text(_getLanguageName(locale)),
    //   trailing:
    //       currentLocale.languageCode == locale.languageCode
    //           ? const Icon(Icons.check)
    //           : null,
    //   onTap: () {
    //     context.read<LanguageCubit>().changeLanguage(locale);
    //   },
    // );
    //   },
    // );
  }
}
