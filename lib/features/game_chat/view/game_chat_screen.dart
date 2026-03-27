import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/config.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_chat_cubit.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:meet_now_app/features/game_chat/widget/widget.dart';
import 'package:meet_now_app/features/search/widget/anon_search/search_progress_bar.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:skeletons_forked/skeletons_forked.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

@RoutePage()
class GameChatScreen extends StatefulWidget {
  const GameChatScreen({super.key, this.chatId});
  final String? chatId;

  @override
  State<GameChatScreen> createState() => _GameChatScreenState();
}

class _GameChatScreenState extends State<GameChatScreen> {
  late final Future<RewardedAdLoader> _adLoader;
  RewardedAd? _ad;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameChatCubit>().fetchGames();
      context.read<GamePointsCubit>().loadPoints();
    });

    MobileAds.initialize();
    _adLoader = _createRewardedAdLoader();
    _loadRewardedAd();
  }

  Future<RewardedAdLoader> _createRewardedAdLoader() {
    return RewardedAdLoader.create(
      onAdLoaded: (RewardedAd rewardedAd) {
        _ad = rewardedAd;
      },
      onAdFailedToLoad: (error) {
        _ad = null;
      },
    );
  }

  Future<void> _loadRewardedAd() async {
    final adLoader = await _adLoader;

    await adLoader.loadAd(
      adRequestConfiguration: AdRequestConfiguration(adUnitId: adsPrice),
    );
  }

  Future<void> _showAd() async {
    if (_ad == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).theAdIsNotReadyPleaseTryAgainLater),
          ),
        );
      }
      return;
    }

    _ad!.setAdEventListener(
      eventListener: RewardedAdEventListener(
        onAdShown: () {},
        onAdFailedToShow: (error) {
          _ad?.destroy();
          _ad = null;
          _loadRewardedAd();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).couldntShowTheAd)),
            );
          }
        },
        onAdClicked: () {},
        onAdDismissed: () {
          _ad?.destroy();
          _ad = null;
          _loadRewardedAd();
        },
        onAdImpression: (impressionData) {},
        onRewarded: (Reward reward) {
          context.read<GameChatCubit>().awardAdPoints(points: reward.amount);
          context.read<GamePointsCubit>().refreshPoints();
        },
      ),
    );

    await _ad?.show();
    await _ad?.waitForDismiss();
  }

  Future<void> _onRefresh() async {
    context.read<GameChatCubit>().fetchGames();
    context.read<GamePointsCubit>().refreshPoints();
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [Color(0xFFD8E3E7), Color(0xFFC8D5DA), Color(0xFFD8E3E7)],
        stops: [0.1, 0.5, 0.9],
      ),
      darkShimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF222222),
          Color(0xFF242424),
          Color(0xFF2B2B2B),
          Color(0xFF242424),
          Color(0xFF222222),
        ],
        stops: [0.0, 0.2, 0.5, 0.8, 1],
        begin: Alignment(-2.4, -0.2),
        end: Alignment(2.4, 0.2),
        tileMode: TileMode.clamp,
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: RefreshIndicator(
                      onRefresh: () => _onRefresh(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: InkWell(
                              onTap: () {
                                _showAd();
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 56,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.brightnessOf(context) ==
                                              Brightness.dark
                                          ? Colors.white70
                                          : Colors.black87,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: (Theme.brightnessOf(context) ==
                                                  Brightness.dark
                                              ? Colors.white70
                                              : Colors.black87)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.play_circle_filled,
                                      color:
                                          Theme.brightnessOf(context) ==
                                                  Brightness.dark
                                              ? Colors.black
                                              : Colors.white,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      S.of(context).getPointsQuickly,
                                      style: TextStyle(
                                        color:
                                            Theme.brightnessOf(context) ==
                                                    Brightness.dark
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: BlocBuilder<GameChatCubit, GameChatState>(
                              builder: (context, state) {
                                return state.when(
                                  initial: () => const GamesSkeleton(),
                                  loading: () => const GamesSkeleton(),
                                  loaded:
                                      (games) => GamesGrid(
                                        games: games,
                                        chatId: widget.chatId,
                                      ),
                                  error:
                                      (message) =>
                                          ErrorsWidget(message: message),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const AppBarWidget(),
                ],
              ),
            ),
            const SearchProgressBar(),
          ],
        ),
      ),
    );
  }
}
