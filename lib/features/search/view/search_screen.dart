import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/search_cubit.dart';
import 'package:meet_now_app/features/search/widget/widget.dart';

@RoutePage()
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Поиск"), elevation: 0),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Выберите пол",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white24 : Colors.black12,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              context.read<SearchCubit>().genders.map((gender) {
                                final isSelected = state.gender == gender;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap:
                                        () => context
                                            .read<SearchCubit>()
                                            .selectGender(gender),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 24,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            isSelected
                                                ? theme
                                                    .elevatedButtonTheme
                                                    .style
                                                    ?.backgroundColor
                                                    ?.resolve({})
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          gender,
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                color:
                                                    isSelected
                                                        ? theme
                                                            .elevatedButtonTheme
                                                            .style
                                                            ?.foregroundColor
                                                            ?.resolve({})
                                                        : theme
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.color,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                      const SizedBox(height: 40),
                      if (state.gender.isNotEmpty) ...[
                        Text(
                          "Выберите возраст",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),

                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children:
                              context.read<SearchCubit>().ageFromList.map((
                                ageStart,
                              ) {
                                return SizedBox(
                                  width:
                                      (MediaQuery.of(context).size.width - 96) /
                                      2,
                                  child: AgeOption(
                                    ageStart: ageStart,
                                    state: state,
                                    context: context,
                                    theme: theme,
                                    isDark: isDark,
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            final canSearch =
                state.gender.isNotEmpty &&
                state.ageFrom != null &&
                !state.isLoading;
            return ElevatedButton(
              onPressed:
                  canSearch
                      ? () => context.read<SearchCubit>().startRandomSearch(
                        context: context,
                      )
                      : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor:
                    canSearch
                        ? theme.elevatedButtonTheme.style?.backgroundColor
                            ?.resolve({})
                        : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  state.isLoading
                      ? CircularProgressIndicator(
                        color: theme.elevatedButtonTheme.style?.foregroundColor
                            ?.resolve({}),
                      )
                      : Text(
                        "Начать поиск",
                        style: theme.elevatedButtonTheme.style?.textStyle
                            ?.resolve({}),
                      ),
            );
          },
        ),
      ),
    );
  }
}
