import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/features/search/cubit/search_cubit.dart';
import 'package:meet_now_app/features/search/cubit/user_stats_cubit.dart';
import 'package:meet_now_app/features/search/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserStatsCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      // appBar: AppBar(
      //   title: Container(
      //     decoration: BoxDecoration(
      //       color:
      //           theme.brightness == Brightness.dark
      //               ? Colors.white70
      //               : Colors.black87,
      //       borderRadius: BorderRadius.circular(25),
      //       boxShadow: [
      //         BoxShadow(
      //           color: (theme.brightness == Brightness.dark
      //                   ? Colors.white70
      //                   : Colors.black87)
      //               .withAlpha(20),
      //           blurRadius: 15,
      //           offset: const Offset(0, 4),
      //         ),
      //       ],
      //     ),
      //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      //     child: AnimatedDefaultTextStyle(
      //       duration: const Duration(milliseconds: 300),
      //       style: theme.textTheme.titleLarge!.copyWith(
      //         color:
      //             theme.brightness == Brightness.dark
      //                 ? Colors.black87
      //                 : Colors.white70,
      //         fontWeight: FontWeight.w700,
      //         letterSpacing: 0.5,
      //       ),
      //       child: Text(S.of(context).search),
      //     ),
      //   ),
      //   scrolledUnderElevation: 0,
      //   surfaceTintColor: Colors.transparent,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            final cubit = context.read<SearchCubit>();
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  theme.brightness == Brightness.dark
                                      ? Colors.white70
                                      : Colors.black87,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: (theme.brightness == Brightness.dark
                                          ? Colors.white70
                                          : Colors.black87)
                                      .withAlpha(20),
                                  blurRadius: 15,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: theme.textTheme.titleLarge!.copyWith(
                                color:
                                    theme.brightness == Brightness.dark
                                        ? Colors.black87
                                        : Colors.white70,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                              child: Text(S.of(context).search),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        FilterCard(
                          padding: const EdgeInsets.all(16),
                          child: BlocBuilder<UserStatsCubit, UserStatsState>(
                            builder: (context, state) {
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: state.maybeWhen(
                                  loaded:
                                      (userStats) =>
                                          StatsBar(userStats: userStats),
                                  orElse: () => const LoadingStatsBar(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),

                        FilterCard(
                          child: Column(
                            children: [
                              SectionTitle(text: S.of(context).selectGender),
                              const SizedBox(height: 24),
                              const GenderToggle(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        if (state.gender.isNotEmpty) ...[
                          FilterCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SectionTitle(text: S.of(context).selectAge),
                                const SizedBox(height: 24),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children:
                                      cubit.ageFromList.map((ageStart) {
                                        return SizedBox(
                                          width: 80,
                                          child: AgeOption(ageStart: ageStart),
                                        );
                                      }).toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],

                        if (state.gender.isNotEmpty &&
                            state.ageFrom != null) ...[
                          FilterCard(
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      onChanged:
                                          (value) => cubit.searchCities(value),
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(color: colors.onSurface),
                                      decoration: InputDecoration(
                                        labelText: S.of(context).cityOptional,
                                        labelStyle: theme.textTheme.bodyLarge!
                                            .copyWith(
                                              color: colors.onSurface.withAlpha(
                                                60,
                                              ),
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: colors.outline.withAlpha(50),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: colors.outline.withAlpha(50),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: colors.primary,
                                            width: 2,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: colors.surface,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 18,
                                            ),
                                      ),
                                    ),
                                    if (state.cities.isNotEmpty)
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        margin: const EdgeInsets.only(top: 8),
                                        decoration: BoxDecoration(
                                          color: colors.surface,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 20,
                                              offset: const Offset(0, 8),
                                              color: colors.shadow.withAlpha(
                                                15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: state.cities.length,
                                          itemBuilder: (context, index) {
                                            final city = state.cities[index];
                                            return Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                onTap: () {
                                                  cubit.setCity(city.nameCity);
                                                  cubit.clearCities();
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 16,
                                                      ),
                                                  child: Text(
                                                    city.nameCity,
                                                    style: theme
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          color:
                                                              colors.onSurface,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  decoration: BoxDecoration(
                                    color: colors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: colors.outline.withAlpha(30),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () => cubit.toggleVerified(),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          children: [
                                            AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color:
                                                    state.verified
                                                        ? colors.primary
                                                        : Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color:
                                                      state.verified
                                                          ? colors.primary
                                                          : colors.outline
                                                              .withAlpha(50),
                                                  width: 2,
                                                ),
                                              ),
                                              child:
                                                  state.verified
                                                      ? Icon(
                                                        Icons.check,
                                                        size: 16,
                                                        color: colors.onPrimary,
                                                      )
                                                      : null,
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                S.of(context).onlyVerified,
                                                style: theme
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      color: colors.onSurface,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                ValueListenableBuilder<Box>(
                                  valueListenable:
                                      context
                                          .read<StorageHiveInterface>()
                                          .listenableInterestBox,
                                  builder: (context, box, child) {
                                    final allInterests =
                                        box.values.cast<Interest>().toList();
                                    return FilterButton(
                                      title: S.of(context).interests,
                                      count: state.interests.length,
                                      onPressed: () async {
                                        final result = await showDialog<
                                          List<String>
                                        >(
                                          context: context,
                                          builder:
                                              (context) => MultiSelectDialog(
                                                title: S.of(context).interests,
                                                items:
                                                    allInterests
                                                        .map(
                                                          (i) => i.title ?? '',
                                                        )
                                                        .toList(),
                                                selectedItems:
                                                    allInterests
                                                        .where(
                                                          (i) => state.interests
                                                              .contains(i.id),
                                                        )
                                                        .map(
                                                          (i) => i.title ?? '',
                                                        )
                                                        .toList(),
                                              ),
                                        );
                                        if (result != null) {
                                          final selectedIds =
                                              allInterests
                                                  .where(
                                                    (i) => result.contains(
                                                      i.title ?? '',
                                                    ),
                                                  )
                                                  .map((i) => i.id)
                                                  .toList();
                                          cubit.setInterests(selectedIds);
                                        }
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),

                                ValueListenableBuilder<Box>(
                                  valueListenable:
                                      context
                                          .read<StorageHiveInterface>()
                                          .listenablePurposeBox,
                                  builder: (context, box, child) {
                                    final allPurpose =
                                        box.values.cast<Purpose>().toList();
                                    return FilterButton(
                                      title: S.of(context).purposes,
                                      count: state.purposes.length,
                                      onPressed: () async {
                                        final result = await showDialog<
                                          List<String>
                                        >(
                                          context: context,
                                          builder:
                                              (context) => MultiSelectDialog(
                                                title: S.of(context).purposes,
                                                items:
                                                    allPurpose
                                                        .map(
                                                          (i) => i.title ?? '',
                                                        )
                                                        .toList(),
                                                selectedItems:
                                                    allPurpose
                                                        .where(
                                                          (i) => state.purposes
                                                              .contains(i.id),
                                                        )
                                                        .map(
                                                          (i) => i.title ?? '',
                                                        )
                                                        .toList(),
                                              ),
                                        );
                                        if (result != null) {
                                          final selectedIds =
                                              allPurpose
                                                  .where(
                                                    (i) => result.contains(
                                                      i.title ?? '',
                                                    ),
                                                  )
                                                  .map((i) => i.id)
                                                  .toList();
                                          cubit.setPurposes(selectedIds);
                                        }
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
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
      ),
      floatingActionButton: const CustomFloatActionButton(),
    );
  }
}
