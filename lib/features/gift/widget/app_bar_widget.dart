import 'package:auto_route/auto_route.dart';
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
    return BlocBuilder<GiftCubit, GiftState>(
      builder: (context, state) {
        final currentView = state.maybeMap(
          loaded: (loaded) => loaded.currentView,
          orElse: () => GiftView.shop,
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: isDark ? Colors.white70 : Colors.black87,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.maybePop(),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: isDark ? Colors.black : Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder<GamePointsCubit, GamePointsState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          Text(S.of(context).balance_num),
                          state.when(
                            initial: () => const SkeletonPoints(),
                            loading: () => const SkeletonPoints(),
                            loaded: (balance, str) => Text('$balance'),
                            refreshing: () => const SkeletonPoints(),
                            error: (e) => const SkeletonPoints(),
                          ),
                          Text(' ${S.of(context).points}'),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 10),

                  GestureDetector(
                    onTap: () {
                      context.read<GiftCubit>().changeView(
                        currentView == GiftView.shop
                            ? GiftView.purchased
                            : GiftView.shop,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        currentView == GiftView.shop
                            ? Icons.card_giftcard
                            : Icons.shop,
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
