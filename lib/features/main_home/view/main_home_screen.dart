import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/main_home/cubit/main_home_cubit.dart';
import 'package:meet_now_app/features/main_home/widget/widget.dart';
import 'package:meet_now_app/features/theme/cubit/particles_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/storage/agree_rules/agree_rules_interface.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

@RoutePage()
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen>
    with WidgetsBindingObserver {
  bool _isDialogShown = false;
  bool _isMobileLayout = false;
  late AgreeRulesInterface _agreeRulesInterface;

  static const double mobileBreakpoint = 600;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _agreeRulesInterface = context.read<AgreeRulesInterface>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowRulesDialog();
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
    if (!mounted) return;

    final double width = MediaQuery.of(context).size.width;
    final bool newIsMobileLayout = width < mobileBreakpoint;

    if (_isMobileLayout != newIsMobileLayout) {
      setState(() {
        _isMobileLayout = newIsMobileLayout;
      });
    }
  }

  void _checkAndShowRulesDialog() {
    if (!mounted) return;

    if (!_agreeRulesInterface.isAgreeRules() && !_isDialogShown) {
      _isDialogShown = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _showCommunityRulesDialog();
        }
      });
    }
  }

  Future<void> _showCommunityRulesDialog() async {
    if (_agreeRulesInterface.isAgreeRules() || !mounted) return;

    _isDialogShown = true;

    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder:
          (context) => PopScope(
            canPop: false,
            child: CommunityRulesDialog(
              agreeRulesInterface: _agreeRulesInterface,
              onDisagree: () {
                Navigator.of(context).pop(false);
              },
              onAgree: () {
                Navigator.of(context).pop(true);
              },
            ),
          ),
    );

    _isDialogShown = false;

    if (result == true) {
      await _agreeRulesInterface.setAgree(value: true);
    } else {
      if (mounted) {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDialogShown,
      child: Stack(
        children: [
          Container(color: Theme.of(context).scaffoldBackgroundColor),
          BlocBuilder<ParticlesCubit, ParticlesState>(
            builder: (context, state) {
              final particlesEnabled = state.maybeWhen(
                loaded: (isParticles) => isParticles,
                orElse: () => true,
              );

              return SeasonBackground(
                particleCount: _isMobileLayout ? 12 : 25,
                enabled: particlesEnabled,
                child: Container(),
              );
            },
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              return AutoTabsRouter(
                routes: [
                  const SearchRoute(),
                  const ChatRoute(),
                  GameChatRoute(),
                  const SettingsRoute(),
                ],
                transitionBuilder:
                    (context, child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                builder: (context, child) {
                  final tabsRouter = AutoTabsRouter.of(context);
                  final bool showDesktopLayout = !_isMobileLayout;

                  return BlocBuilder<MainHomeCubit, MainHomeState>(
                    builder: (context, state) {
                      bool isDesktopPlatform = false;
                      if (!kIsWeb) {
                        isDesktopPlatform =
                            Platform.isWindows ||
                            Platform.isMacOS ||
                            Platform.isLinux;
                      }

                      if (kIsWeb || isDesktopPlatform) {
                        if (_isMobileLayout) {
                          return Scaffold(
                            backgroundColor: Colors.transparent,
                            body: child,
                            bottomNavigationBar: MobileBottomNavigationBar(
                              tabsRouter: tabsRouter,
                            ),
                          );
                        }

                        return Scaffold(
                          backgroundColor: Colors.transparent,
                          body: Row(
                            children: [
                              WebVerticalNavigationBar(tabsRouter: tabsRouter),
                              Expanded(child: child),
                            ],
                          ),
                          bottomNavigationBar: null,
                        );
                      }

                      if (showDesktopLayout) {
                        return Scaffold(
                          backgroundColor: Colors.transparent,
                          body: Row(
                            children: [
                              NavigationRail(
                                selectedIndex: tabsRouter.activeIndex,
                                onDestinationSelected:
                                    tabsRouter.setActiveIndex,
                                labelType: NavigationRailLabelType.all,
                                destinations: [
                                  NavigationRailDestination(
                                    icon: const Icon(Icons.search),
                                    label: Text(S.of(context).search),
                                  ),
                                  NavigationRailDestination(
                                    icon: const Icon(Icons.message),
                                    label: Text(S.of(context).chat),
                                  ),
                                  NavigationRailDestination(
                                    icon: const Icon(Icons.gamepad),
                                    label: Text(S.of(context).game),
                                  ),
                                  NavigationRailDestination(
                                    icon: const Icon(Icons.settings),
                                    label: Text(S.of(context).settings),
                                  ),
                                ],
                              ),
                              Expanded(child: child),
                            ],
                          ),
                          bottomNavigationBar: null,
                        );
                      }

                      return Scaffold(
                        backgroundColor: Colors.transparent,
                        body: child,
                        bottomNavigationBar: MobileBottomNavigationBar(
                          tabsRouter: tabsRouter,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
