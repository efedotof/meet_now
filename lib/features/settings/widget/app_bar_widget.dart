import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:meet_now_app/features/gift/widget/skeleton_points.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget>
    with WidgetsBindingObserver {
  bool _isMobileLayout = false;
  static const double mobileBreakpoint = 768;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayout();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      _checkLayout();
    }
  }

  void _checkLayout() {
    final double width = MediaQuery.of(context).size.width;
    final bool newIsMobileLayout = width < mobileBreakpoint;

    if (mounted && _isMobileLayout != newIsMobileLayout) {
      setState(() {
        _isMobileLayout = newIsMobileLayout;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayout();
    });

    bool isDesktopPlatform = false;
    if (!kIsWeb) {
      isDesktopPlatform =
          Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    }

    final bool useDesktopAppBar =
        (kIsWeb || isDesktopPlatform) && !_isMobileLayout;

    final double containerWidthMultiplier = useDesktopAppBar ? 0.4 : 0.5;

    return Positioned(
      top: 20,
      left: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment:
              useDesktopAppBar
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 45,
              width:
                  MediaQuery.of(context).size.width * containerWidthMultiplier,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: Text(
                S.of(context).settings,
                style: TextStyle(color: isDark ? Colors.black : Colors.white),
              ),
            ),

            if (useDesktopAppBar) const SizedBox(width: 20),

            BlocBuilder<GamePointsCubit, GamePointsState>(
              builder: (context, state) {
                return state.when(
                  initial: () => SkeletonPoints(),
                  loading: () => SkeletonPoints(),
                  loaded:
                      (int points, String? lastError) => GestureDetector(
                        onTap: () => context.pushRoute(GiftRoute()),
                        child: Container(
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
      ),
    );
  }
}
