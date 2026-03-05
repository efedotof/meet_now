import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/language/cubit/language_cubit.dart';

class LanguageList extends StatelessWidget {
  final Locale currentLocale;
  final List<Locale> supportedLocales;
  final bool isMobile;

  const LanguageList({
    super.key,
    required this.currentLocale,
    required this.supportedLocales,
    required this.isMobile,
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
    return Container(
      margin:
          isMobile
              ? null
              : const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: ListView.builder(
        padding:
            isMobile
                ? EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.12,
                )
                : EdgeInsets.zero,
        itemCount: supportedLocales.length,
        itemBuilder: (context, index) {
          final locale = supportedLocales[index];
          final isSelected = currentLocale.languageCode == locale.languageCode;

          return Container(
            margin:
                isMobile ? EdgeInsets.zero : const EdgeInsets.only(bottom: 8),
            decoration:
                isMobile
                    ? null
                    : BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color:
                          isSelected
                              ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.1)
                              : Colors.transparent,
                    ),
            child: ListTile(
              title: Text(
                _getLanguageName(locale),
                style:
                    isMobile
                        ? null
                        : Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
              ),
              trailing:
                  isSelected
                      ? Icon(
                        Icons.check,
                        color:
                            isMobile
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.primary,
                      )
                      : null,
              contentPadding:
                  isMobile
                      ? null
                      : const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
              shape:
                  isMobile
                      ? null
                      : RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
              onTap: () {
                context.read<LanguageCubit>().changeLanguage(locale);
              },
            ),
          );
        },
      ),
    );
  }
}
