import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/search_mode/search_mode_cubit.dart';
import 'package:meet_now_app/features/search_mode/widget/search_mode_card.dart';
import 'package:meet_now_app/features/search_mode/widget/app_bar_widget.dart';
import 'package:meet_now_app/features/settings/cubit/user_date_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class SearchModeScreen extends StatelessWidget {
  const SearchModeScreen({super.key});

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
                child: BlocBuilder<SearchModeCubit, SearchModeState>(
                  builder: (context, state) {
                    final isSearch = state.when(
                      isSearch: () => true,
                      isCardSwiper: () => false,
                    );

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
                                    color: Colors.black.withValues(alpha: 0.1),
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
                                S.of(context).searchMode,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SearchModeCard(
                                    title: S.of(context).anonymousSearch,
                                    description:
                                        S
                                            .of(context)
                                            .anonymousSearchDescription,
                                    isSelected: isSearch,
                                    icon: Icons.no_accounts,
                                    onTap: () {
                                      context.read<SearchModeCubit>().setMode(
                                        false,
                                      );
                                    },
                                    gradientColors: [
                                      Colors.grey[800]!,
                                      Colors.grey[600]!,
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  SearchModeCard(
                                    title: S.of(context).cardSwiperMode,
                                    description:
                                        S.of(context).cardSwiperDescription,
                                    isSelected: !isSearch,
                                    icon: Icons.swipe,
                                    onTap: () async {
                                      final userCubit =
                                          context.read<UserDateCubit>();
                                      userCubit.refreshUser();
                                      final user = userCubit.currentUser;

                                      if (user == null) {
                                        _showInfoDialog(
                                          context,
                                          title: S.of(context).error,
                                          message: S.of(context).userNotLoaded,
                                        );
                                        return;
                                      }

                                      final hasPremium = user.roles.contains(
                                        'PREMIUM',
                                      );
                                      final hasPhotos =
                                          user.images != null &&
                                          user.images!.isNotEmpty;

                                      if (hasPremium && hasPhotos) {
                                        context.read<SearchModeCubit>().setMode(
                                          true,
                                        );
                                      } else {
                                        String message;
                                        if (!hasPremium && !hasPhotos) {
                                          message =
                                              S
                                                  .of(context)
                                                  .premiumAndPhotosRequired;
                                        } else if (!hasPremium) {
                                          message =
                                              S.of(context).premiumRequired;
                                        } else {
                                          message =
                                              S.of(context).photosRequired;
                                        }

                                        _showInfoDialog(
                                          context,
                                          title: S.of(context).accessDenied,
                                          message: message,
                                        );
                                      }
                                    },
                                    gradientColors: [
                                      Colors.red[400]!,
                                      Colors.pink[300]!,
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

  void _showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(S.of(context).ok),
              ),
            ],
          ),
    );
  }
}
