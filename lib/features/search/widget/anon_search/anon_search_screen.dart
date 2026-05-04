import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:meet_now_app/features/search/cubit/matchmaking/matchmaking_cubit.dart';
import 'package:meet_now_app/features/search/cubit/search/search_cubit.dart';
import 'package:meet_now_app/features/search/cubit/user_stats/user_stats_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/social/interes/interest.dart';
import 'package:meet_now_app_server/model/social/purpose/purpose.dart';
import 'package:meet_now_app_server/storage/storage_hive/storage_hive_interface.dart';

import 'adaptive_chat_dialog.dart';
import 'age_option.dart';
import 'banner_ads.dart';
import 'custom_float_action_button.dart';
import 'filter_button.dart';
import 'filter_card.dart';
import 'gender_toggle.dart';
import 'loading_stats_bar.dart';
import 'multi_select_dialog.dart';
import 'quick_match_button.dart';
import 'section_title.dart';
import 'stats_bar.dart';

class AnonSearchScreen extends StatefulWidget {
  const AnonSearchScreen({super.key});

  @override
  State<AnonSearchScreen> createState() => _AnonSearchScreenState();
}

class _AnonSearchScreenState extends State<AnonSearchScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserStatsCubit>().initialize();
  }

  bool _hasNavigated = false;
  bool _isChatModalOpen = false;
  ValueListenable<Box<Interest>>? _interestsListenable;
  ValueListenable<Box<Purpose>>? _purposesListenable;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_interestsListenable == null || _purposesListenable == null) {
      _loadListenables();
    }
  }

  Future<void> _loadListenables() async {
    final storage = context.read<StorageHiveInterface>();
    final interests = await storage.getListenableInterestBox();
    final purposes = await storage.getListenablePurposeBox();
    if (mounted) {
      setState(() {
        _interestsListenable = interests;
        _purposesListenable = purposes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<SearchCubit, SearchState>(
          listener: (context, state) => _handleSearchNavigation(context, state),
        ),
        BlocListener<MatchmakingCubit, MatchmakingState>(
          listener:
              (context, state) => _handleMatchmakingNavigation(context, state),
        ),
      ],
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          final cubit = context.read<SearchCubit>();
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Stack(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BannerAds(
                                maxBannerHeight:
                                    MediaQuery.of(context).size.height * 0.2,
                              ),
                              const SizedBox(height: 50),
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
                                        color: (theme.brightness ==
                                                    Brightness.dark
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
                                child: BlocBuilder<
                                  UserStatsCubit,
                                  UserStatsState
                                >(
                                  builder: (context, userStatsState) {
                                    return AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      child: userStatsState.maybeWhen(
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
                                    SectionTitle(
                                      text: S.of(context).selectGender,
                                    ),
                                    const SizedBox(height: 24),
                                    const GenderToggle(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),

                              if (state.gender.isNotEmpty) ...[
                                FilterCard(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SectionTitle(
                                        text: S.of(context).selectAge,
                                      ),
                                      const SizedBox(height: 24),
                                      Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children:
                                            cubit.ageFromList.map((ageStart) {
                                              return SizedBox(
                                                width: 80,
                                                child: AgeOption(
                                                  ageStart: ageStart,
                                                ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            onChanged:
                                                (value) =>
                                                    cubit.searchCities(value),
                                            style: theme.textTheme.bodyLarge!
                                                .copyWith(
                                                  color: colors.onSurface,
                                                ),
                                            decoration: InputDecoration(
                                              labelText:
                                                  S.of(context).cityOptional,
                                              labelStyle: theme
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: colors.onSurface
                                                        .withAlpha(60),
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: colors.outline
                                                      .withAlpha(50),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                  color: colors.outline
                                                      .withAlpha(50),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                                              margin: const EdgeInsets.only(
                                                top: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: colors.surface,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 20,
                                                    offset: const Offset(0, 8),
                                                    color: colors.shadow
                                                        .withAlpha(15),
                                                  ),
                                                ],
                                              ),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: state.cities.length,
                                                itemBuilder: (context, index) {
                                                  final city =
                                                      state.cities[index];
                                                  return Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                      onTap: () {
                                                        cubit.setCity(
                                                          city.nameCity,
                                                        );
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
                                                                    colors
                                                                        .onSurface,
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
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colors.surface,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: colors.outline.withAlpha(30),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            onTap: () => cubit.toggleVerified(),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                              : Colors
                                                                  .transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            state.verified
                                                                ? colors.primary
                                                                : colors.outline
                                                                    .withAlpha(
                                                                      50,
                                                                    ),
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child:
                                                        state.verified
                                                            ? Icon(
                                                              Icons.check,
                                                              size: 16,
                                                              color:
                                                                  colors
                                                                      .onPrimary,
                                                            )
                                                            : null,
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .onlyVerified,
                                                      style: theme
                                                          .textTheme
                                                          .bodyLarge!
                                                          .copyWith(
                                                            color:
                                                                colors
                                                                    .onSurface,
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

                                      if (_interestsListenable != null)
                                        ValueListenableBuilder<Box<Interest>>(
                                          valueListenable:
                                              _interestsListenable!,
                                          builder: (context, box, child) {
                                            final allInterests =
                                                box.values
                                                    .cast<Interest>()
                                                    .toList();
                                            return FilterButton(
                                              title: S.of(context).interests,
                                              count: state.interests.length,
                                              onPressed: () async {
                                                final result = await showDialog<
                                                  List<String>
                                                >(
                                                  context: context,
                                                  builder:
                                                      (
                                                        context,
                                                      ) => MultiSelectDialog(
                                                        title:
                                                            S
                                                                .of(context)
                                                                .interests,
                                                        items:
                                                            allInterests
                                                                .map(
                                                                  (i) =>
                                                                      i.title ??
                                                                      '',
                                                                )
                                                                .toList(),
                                                        selectedItems:
                                                            allInterests
                                                                .where(
                                                                  (i) => state
                                                                      .interests
                                                                      .contains(
                                                                        i.id,
                                                                      ),
                                                                )
                                                                .map(
                                                                  (i) =>
                                                                      i.title ??
                                                                      '',
                                                                )
                                                                .toList(),
                                                      ),
                                                );
                                                if (result != null) {
                                                  final selectedIds =
                                                      allInterests
                                                          .where(
                                                            (i) =>
                                                                result.contains(
                                                                  i.title ?? '',
                                                                ),
                                                          )
                                                          .map((i) => i.id)
                                                          .toList();
                                                  cubit.setInterests(
                                                    selectedIds,
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        )
                                      else
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      const SizedBox(height: 16),

                                      if (_purposesListenable != null)
                                        ValueListenableBuilder<Box<Purpose>>(
                                          valueListenable: _purposesListenable!,
                                          builder: (context, box, child) {
                                            final allPurpose =
                                                box.values
                                                    .cast<Purpose>()
                                                    .toList();
                                            return FilterButton(
                                              title: S.of(context).purposes,
                                              count: state.purposes.length,
                                              onPressed: () async {
                                                final result = await showDialog<
                                                  List<String>
                                                >(
                                                  context: context,
                                                  builder:
                                                      (
                                                        context,
                                                      ) => MultiSelectDialog(
                                                        title:
                                                            S
                                                                .of(context)
                                                                .purposes,
                                                        items:
                                                            allPurpose
                                                                .map(
                                                                  (i) =>
                                                                      i.title ??
                                                                      '',
                                                                )
                                                                .toList(),
                                                        selectedItems:
                                                            allPurpose
                                                                .where(
                                                                  (i) => state
                                                                      .purposes
                                                                      .contains(
                                                                        i.id,
                                                                      ),
                                                                )
                                                                .map(
                                                                  (i) =>
                                                                      i.title ??
                                                                      '',
                                                                )
                                                                .toList(),
                                                      ),
                                                );
                                                if (result != null) {
                                                  final selectedIds =
                                                      allPurpose
                                                          .where(
                                                            (i) =>
                                                                result.contains(
                                                                  i.title ?? '',
                                                                ),
                                                          )
                                                          .map((i) => i.id)
                                                          .toList();
                                                  cubit.setPurposes(
                                                    selectedIds,
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        )
                                      else
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
                              ],

                              if (state.chatDeliveryStatus.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: colors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color:
                                          state.isChatDeliveryConfirmed
                                              ? colors.primary.withAlpha(100)
                                              : colors.error.withAlpha(100),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        state.isChatDeliveryConfirmed
                                            ? Icons.check_circle
                                            : Icons.timer,
                                        color:
                                            state.isChatDeliveryConfirmed
                                                ? colors.primary
                                                : colors.error,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          state.chatDeliveryStatus,
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(
                                                color: colors.onSurface,
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
                  ),
                ],
              ),
            ),
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const QuickMatchButton(),
                const SizedBox(height: 16),
                const CustomFloatActionButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleSearchNavigation(BuildContext context, SearchState state) {
    if (_hasNavigated || _isChatModalOpen || !state.isSearching) return;

    final isMatched =
        state.searchStatus == 'MATCH_FOUND' || state.searchStatus == 'MATCHED';

    if (state.matchedChat != null && isMatched) {
      _hasNavigated = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final bool shouldOpenInModal = kIsWeb || Platform.isWindows;

          if (shouldOpenInModal) {
            _isChatModalOpen = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (context) => AdaptiveChatDialog(
                    chat: state.matchedChat!,
                    onClose: () {
                      Navigator.of(context).pop();
                    },
                  ),
            ).then((_) {
              _isChatModalOpen = false;
              _hasNavigated = false;
            });
          } else {
            context.pushRoute(
              ChatMessageRoute(
                temporaryChatModel: state.matchedChat!,
                chatKey: state.matchedChat!.tempChatId,
              ),
            );
          }

          context.read<SearchCubit>().clearMatchedChat();
          _hasNavigated = false;
        }
      });
    }
  }

  void _handleMatchmakingNavigation(
    BuildContext context,
    MatchmakingState state,
  ) {
    state.whenOrNull(
      found: (permanentChat) {
        context.pushRoute(
          ChatMessageRoute(
            chatModel: permanentChat,
            chatKey: permanentChat.chatId,
            temporaryChatModel: null,
          ),
        );
        context.read<MatchmakingCubit>().reset();
      },
      error: (error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      },
      noResults: (message) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  @override
  void dispose() {
    _hasNavigated = false;
    _isChatModalOpen = false;
    super.dispose();
  }
}
