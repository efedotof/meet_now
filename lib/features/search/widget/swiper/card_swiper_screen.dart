import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/card_swiper/card_swiper_cubit.dart';
import 'package:meet_now_app/features/settings/widget/user_avatar.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/swipe/swipe_candidate_response/swipe_candidate_response.dart';

import 'action_button_widget.dart';
import 'card_swiper.dart';
import 'indicator_widget.dart';
import 'search_filter_drawer.dart';
import 'details_panel.dart';
import 'skeleton_card_swiper.dart';

class CardSwiperScreen extends StatefulWidget {
  const CardSwiperScreen({super.key});

  @override
  State<CardSwiperScreen> createState() => _CardSwiperScreenState();
}

class _CardSwiperScreenState extends State<CardSwiperScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late final AnimationController _animationController;
  late final AnimationController _panelController;

  Offset _dragOffset = Offset.zero;
  bool _isAnimating = false;
  Offset? _animationStart;
  Offset? _animationTarget;
  bool _isFavoriteActive = false;
  bool _panelVisible = false;
  SwipeCandidateResponse? _selectedItem;

  static const double _swipeThreshold = 0.4;

  bool _isMobileLayout = false;
  static const double mobileBreakpoint = 600;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(_updateDragFromAnimation);
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayout();
      if (mounted) {
        context.read<CardSwiperCubit>().loadAllData();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.removeListener(_updateDragFromAnimation);
    _animationController.dispose();
    _panelController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) _checkLayout();
  }

  void _checkLayout() {
    final double width = MediaQuery.of(context).size.width;
    final bool newIsMobileLayout = width < mobileBreakpoint;
    if (mounted && _isMobileLayout != newIsMobileLayout) {
      setState(() => _isMobileLayout = newIsMobileLayout);
    }
  }

  void _updateDragFromAnimation() {
    if (_animationStart != null && _animationTarget != null) {
      setState(() {
        _dragOffset =
            Offset.lerp(
              _animationStart,
              _animationTarget,
              _animationController.value,
            )!;
      });
    }
  }

  bool _isBeyondThreshold(Size screenSize) {
    return _dragOffset.dx.abs() > screenSize.width * _swipeThreshold;
  }

  void _startSwipeAnimation(Offset targetOffset, {VoidCallback? onComplete}) {
    if (_isAnimating) return;
    _isAnimating = true;
    _animationStart = _dragOffset;
    _animationTarget = targetOffset;
    _animationController.forward(from: 0.0).then((_) {
      if (mounted) {
        setState(() {
          _isAnimating = false;
          _animationStart = null;
          _animationTarget = null;
        });
        onComplete?.call();
      }
    });
  }

  void _onPanEnd(DragEndDetails details, Size screenSize) {
    if (_isAnimating) return;
    if (_isBeyondThreshold(screenSize)) {
      final sign = _dragOffset.dx.sign;
      final targetX = sign * screenSize.width * 1.2;
      final direction = sign > 0 ? 'right' : 'left';
      _startSwipeAnimation(
        Offset(targetX, _dragOffset.dy),
        onComplete: () {
          if (direction == 'right') {
            context.read<CardSwiperCubit>().swipeRight();
          } else {
            context.read<CardSwiperCubit>().swipeLeft();
          }
          setState(() => _dragOffset = Offset.zero);
        },
      );
    } else {
      _startSwipeAnimation(Offset.zero);
    }
  }

  void _openPanel(SwipeCandidateResponse item) {
    setState(() {
      _selectedItem = item;
      _panelVisible = true;
    });
    _panelController.forward();
  }

  void _closePanel() {
    _panelController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _panelVisible = false;
          _selectedItem = null;
        });
      }
    });
  }

  void _showMatchesBottomSheet() async {
    setState(() => _isFavoriteActive = true);
    final cubit = context.read<CardSwiperCubit>();
    if (cubit.state.matches.isEmpty && !cubit.state.isLoadingMatches) {
      cubit.loadMatches();
    }
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              S.of(context).matchHistory,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<CardSwiperCubit, CardSwiperState>(
                builder: (context, state) {
                  if (state.isLoadingMatches) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.matchesErrorMessage != null) {
                    return Center(
                      child: Text(
                        state.matchesErrorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (state.matches.isEmpty) {
                    return Center(
                      child: Text(S.of(context).youDontHaveAnyMatchesYet),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.matches.length,
                    itemBuilder: (context, index) {
                      final match = state.matches[index];
                      return ListTile(
                        onTap:
                            () => context.pushRoute(
                              ProfileRoute(userId: match.userId),
                            ),
                        leading: UserAvatar(
                          avatarKey: match.avatar,
                          radius: 24.0,
                        ),
                        title: Text('${match.firstname} ${match.subname}'),
                        subtitle: Text('@${match.username}'),
                        trailing: Text(
                          match.matchedAt != null
                              ? _formatDate(match.matchedAt!)
                              : "",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
    if (mounted) setState(() => _isFavoriteActive = false);
  }

  void _showLikesBottomSheet() async {
    final cubit = context.read<CardSwiperCubit>();
    if (cubit.state.userLikes.isEmpty && !cubit.state.isLoadingLikes) {
      cubit.getUserWhoLikeMe();
    }
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              S.of(context).likesHistory,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<CardSwiperCubit, CardSwiperState>(
                builder: (context, state) {
                  if (state.isLoadingLikes) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.likesErrorMessage != null) {
                    return Center(
                      child: Text(
                        state.likesErrorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (state.userLikes.isEmpty) {
                    return Center(child: Text(S.of(context).noLikesYet));
                  }
                  return ListView.builder(
                    itemCount: state.userLikes.length,
                    itemBuilder: (context, index) {
                      final like = state.userLikes[index];
                      return ListTile(
                        onTap:
                            () => context.pushRoute(
                              ProfileRoute(userId: like.id),
                            ),
                        leading: UserAvatar(
                          avatarKey: like.avatar,
                          radius: 24.0,
                        ),
                        title: Text('${like.firstname} ${like.subname}'),
                        subtitle: Text(
                          '@${like.username}${' • ${like.age} ${S.of(context).years}'}',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktopPlatform = false;
    if (!kIsWeb) {
      isDesktopPlatform =
          Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    }
    final bool useDesktopLayout =
        (kIsWeb || isDesktopPlatform) && !_isMobileLayout;

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLayout());

    return BlocConsumer<CardSwiperCubit, CardSwiperState>(
      listener: (context, state) {
        setState(() => _dragOffset = Offset.zero);
        if (_panelVisible) _closePanel();
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final candidate = state.currentCandidate;
        final screenSize = MediaQuery.of(context).size;
        final isLoading = state.isLoading;
        final hasError = state.errorMessage != null;

        Widget screenContent = Stack(
          children: [
            Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color:
                            Theme.brightnessOf(context) == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.filter_list,
                                  color:
                                      Theme.brightnessOf(context) ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Colors.white,
                                ),
                                onPressed:
                                    () =>
                                        _scaffoldKey.currentState?.openDrawer(),
                              ),
                              Text(
                                S.of(context).cardSwiperMode,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.brightnessOf(context) ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: _showLikesBottomSheet,
                                    customBorder: const CircleBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.thumb_up_alt_outlined,
                                        color:
                                            Theme.brightnessOf(context) ==
                                                    Brightness.dark
                                                ? Colors.black
                                                : Colors.white,
                                      ),
                                    ),
                                  ),
                                  if (state.userLikes.isNotEmpty)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          state.userLikes.length.toString(),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Stack(
                                children: [
                                  InkWell(
                                    onTap: _showMatchesBottomSheet,
                                    customBorder: const CircleBorder(),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      curve: Curves.easeInOut,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            _isFavoriteActive
                                                ? Colors.red
                                                : Colors.transparent,
                                      ),
                                      child: Icon(
                                        _isFavoriteActive
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color:
                                            Theme.brightnessOf(context) ==
                                                    Brightness.dark
                                                ? (_isFavoriteActive
                                                    ? Colors.white
                                                    : Colors.black)
                                                : (_isFavoriteActive
                                                    ? Colors.white
                                                    : Colors.white),
                                      ),
                                    ),
                                  ),
                                  if (state.matches.isNotEmpty)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          state.matches.length.toString(),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              width: screenSize.width * 0.9,
                              height: screenSize.height * 0.7,
                              child: Stack(
                                children: [
                                  if (candidate != null && !isLoading)
                                    Positioned.fill(
                                      child: GestureDetector(
                                        onPanUpdate: (details) {
                                          if (_isAnimating) return;
                                          setState(
                                            () => _dragOffset += details.delta,
                                          );
                                        },
                                        onPanEnd:
                                            (details) =>
                                                _onPanEnd(details, screenSize),
                                        child: Transform.translate(
                                          offset: _dragOffset,
                                          child: Transform.rotate(
                                            angle: _dragOffset.dx * 0.002,
                                            child: CardSwiper(
                                              key: ValueKey(candidate.id),
                                              item: candidate,
                                              isTop: true,
                                              onInfoPressed:
                                                  () => _openPanel(candidate),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  else if (isLoading)
                                    const Center(child: SkeletonCardSwiper()),
                                ],
                              ),
                            ),
                          ),
                          if (_dragOffset.dx > 20)
                            Positioned(
                              top: constraints.maxHeight * 0.2,
                              right: constraints.maxWidth * 0.15,
                              child: IndicatorWidget(
                                text: S.of(context).like,
                                color: Colors.green,
                              ),
                            ),
                          if (_dragOffset.dx < -20)
                            Positioned(
                              top: constraints.maxHeight * 0.2,
                              left: constraints.maxWidth * 0.15,
                              child: IndicatorWidget(
                                text: S.of(context).nope,
                                color: Colors.red,
                              ),
                            ),
                          if (_panelVisible)
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _panelController,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                                child: SizedBox(
                                  height: constraints.maxHeight * 0.6,
                                  child: DetailsPanel(
                                    item: _selectedItem!,
                                    onClose: _closePanel,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          Theme.brightnessOf(context) == Brightness.dark
                              ? Colors.white70
                              : Colors.black87,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ActionButtonWidget(
                          icon: Icons.thumb_down,
                          color: Colors.red,
                          onPressed:
                              () => context.read<CardSwiperCubit>().swipeLeft(),
                        ),
                        const SizedBox(width: 20),
                        ActionButtonWidget(
                          icon: Icons.refresh,
                          color: Colors.blue,
                          onPressed:
                              () =>
                                  context
                                      .read<CardSwiperCubit>()
                                      .refreshCandidate(),
                        ),
                        const SizedBox(width: 20),
                        ActionButtonWidget(
                          icon: Icons.thumb_up,
                          color: Colors.green,
                          onPressed:
                              () =>
                                  context.read<CardSwiperCubit>().swipeRight(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (candidate == null && !isLoading && !hasError)
              IgnorePointer(
                child: Center(child: Text(S.of(context).thereAreNoMoreCards)),
              ),
            if (hasError)
              IgnorePointer(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.errorMessage!),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed:
                            () =>
                                context
                                    .read<CardSwiperCubit>()
                                    .refreshCandidate(),
                        child: Text(S.of(context).retry),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );

        if (useDesktopLayout) {
          screenContent = SizedBox.expand(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: screenContent,
              ),
            ),
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          drawer: const SearchFilterDrawer(),
          backgroundColor: Colors.transparent,
          body: screenContent,
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 7) {
      return '${date.day}.${date.month}.${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${S.of(context).daysAgo}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${S.of(context).hoursAgo}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${S.of(context).minAgo}';
    } else {
      return S.of(context).just_now;
    }
  }
}
