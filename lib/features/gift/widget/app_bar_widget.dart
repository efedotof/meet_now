import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:meet_now_app/features/gift/cubit/gift_cubit.dart';
import 'package:meet_now_app/features/gift/widget/skeleton_points.dart';
import 'package:meet_now_app/generated/l10n.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final menuTextColor = isDark ? Colors.black : Colors.white;
    final menuIconColor = isDark ? Colors.black : Colors.white;
    final menuBackgroundColor = isDark ? Colors.white70 : Colors.black87;

    return BlocBuilder<GiftCubit, GiftState>(
      builder: (context, state) {
        final currentView = state.maybeMap(
          loaded: (loadedState) => loadedState.currentView.name,
          orElse: () => S.of(context).shop,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => context.maybePop(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),

              Container(
                height: 45,
                width:
                    kIsWeb || Platform.isWindows
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: PopupMenuButton<GiftView>(
                  onSelected: (GiftView value) {
                    context.read<GiftCubit>().changeView(value);
                  },
                  offset: const Offset(0, 45),

                  color: menuBackgroundColor,
                  surfaceTintColor: menuBackgroundColor,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 200,
                    maxWidth: 300,
                  ),
                  padding: EdgeInsets.zero,

                  itemBuilder: (BuildContext context) {
                    return GiftView.values.map((view) {
                      return PopupMenuItem<GiftView>(
                        value: view,
                        height: 48,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                view == GiftView.shop
                                    ? Icons.shopping_cart
                                    : Icons.inventory_2,
                                size: 20,
                                color: menuIconColor,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                view.name,
                                style: TextStyle(
                                  color: menuTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList();
                  },
                  splashRadius: 20,
                  tooltip: S.of(context).select_a_section,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            currentView,
                            style: TextStyle(
                              color: isDark ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: isDark ? Colors.black : Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              BlocBuilder<GamePointsCubit, GamePointsState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => SkeletonPoints(),
                    loading: () => SkeletonPoints(),
                    loaded:
                        (int points, String? lastError) => Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.currency_bitcoin,
                                size: 20,
                                color: isDark ? Colors.black : Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "$points ${S.of(context).points}",
                                style: TextStyle(
                                  color: isDark ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    refreshing:
                        () => Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                S.of(context).points,
                                style: TextStyle(
                                  color: isDark ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    error:
                        (e) => Container(
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.red.withAlpha(80),
                          ),
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                S.of(context).error,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
