import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/search_cubit.dart';
import 'package:meet_now_app/features/search/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).search), elevation: 0),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final cubit = context.read<SearchCubit>();

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
                        S.of(context).selectGender,
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
                              cubit.genders.map((gender) {
                                final isSelected = state.gender == gender;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => cubit.selectGender(gender),
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
                          S.of(context).selectAge,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children:
                              cubit.ageFromList
                                  .map(
                                    (ageStart) => SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                              96) /
                                          2,
                                      child: AgeOption(ageStart: ageStart),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                      if (state.gender.isNotEmpty && state.ageFrom != null) ...[
                        const SizedBox(height: 40),
                        TextField(
                          onChanged: (value) => cubit.setCity(value),
                          decoration: InputDecoration(
                            labelText: S.of(context).cityOptional,
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: theme.cardTheme.color,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: state.verified,
                              onChanged: (_) => cubit.toggleVerified(),
                            ),
                            Text(S.of(context).onlyVerified),
                          ],
                        ),
                        const SizedBox(height: 20),
                        OutlinedButton(
                          onPressed: () async {
                            final result = await showDialog<List<String>>(
                              context: context,
                              builder:
                                  (context) => MultiSelectDialog(
                                    title: S.of(context).interests,
                                    items: cubit.availableInterests,
                                    selectedItems: state.interests,
                                  ),
                            );
                            if (result != null) {
                              cubit.setInterests(result);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${S.of(context).interests} (${state.interests.length})',
                                style: theme.textTheme.bodyLarge,
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_drop_down, size: 24),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        OutlinedButton(
                          onPressed: () async {
                            final result = await showDialog<List<String>>(
                              context: context,
                              builder:
                                  (context) => MultiSelectDialog(
                                    title: S.of(context).purposes,
                                    items: cubit.availablePurposes,
                                    selectedItems: state.purposes,
                                  ),
                            );
                            if (result != null) {
                              cubit.setPurposes(result);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${S.of(context).purposes} (${state.purposes.length})',
                                style: theme.textTheme.bodyLarge,
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_drop_down, size: 24),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
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
            final canSearch = state.gender.isNotEmpty && state.ageFrom != null;
            final cubit = context.read<SearchCubit>();
            return PulseAnimation(
              isAnimating: state.isSearching,
              child: ElevatedButton(
                onPressed:
                    canSearch
                        ? () => cubit.toggleSearch(context: context)
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
                    state.isSearching
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Stop search"),
                            const SizedBox(width: 8),
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ],
                        )
                        : Text(S.of(context).startSearch),
              ),
            );
          },
        ),
      ),
    );
  }
}
