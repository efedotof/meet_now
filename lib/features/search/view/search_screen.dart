import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/search_cubit.dart';

@RoutePage()
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Поиск")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Выберите пол",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children:
                        context.read<SearchCubit>().genders.map((gender) {
                          final isSelected = state.gender == gender;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: ChoiceChip(
                                avatar:
                                    isSelected
                                        ? Icon(Icons.check, color: Colors.white)
                                        : null,
                                label: Text(gender),
                                selected: isSelected,
                                onSelected:
                                    (_) => context
                                        .read<SearchCubit>()
                                        .selectGender(gender),
                                selectedColor: theme.colorScheme.primary,
                                backgroundColor: theme.cardColor,
                                labelStyle: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 14),
                  if (state.gender.isNotEmpty) ...[
                    const Text(
                      "Выберите возраст",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children:
                            context.read<SearchCubit>().ageFromList.map((
                              ageStart,
                            ) {
                              final ageLabel = "$ageStart–${ageStart + 3}";
                              final isSelected = state.ageFrom == ageStart;
                              return ChoiceChip(
                                avatar:
                                    isSelected
                                        ? Icon(Icons.check, color: Colors.white)
                                        : null,
                                label: Text(ageLabel),
                                selected: isSelected,
                                onSelected:
                                    (_) => context
                                        .read<SearchCubit>()
                                        .selectAge(ageStart),
                                selectedColor: theme.colorScheme.primary,
                                backgroundColor: theme.cardColor,
                                labelStyle: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : theme.colorScheme.onSurface,
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
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
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child:
                  state.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Начать поиск"),
            );
          },
        ),
      ),
    );
  }
}
