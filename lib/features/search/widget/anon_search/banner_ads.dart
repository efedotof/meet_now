import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meet_now_app/config.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class BannerAds extends StatefulWidget {
  const BannerAds({
    super.key,
    required this.maxBannerHeight,
    this.retryInterval = const Duration(seconds: 30),
  });

  final double maxBannerHeight;
  final Duration retryInterval;

  @override
  State<BannerAds> createState() => _BannerAdsState();
}

class _BannerAdsState extends State<BannerAds> {
  BannerAd? _banner;
  bool _isAdAvailable = false;
  bool _isLoading = false;
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _initializeAndLoad();
  }

  Future<void> _initializeAndLoad() async {
    await MobileAds.initialize();

    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 100));
    _loadAd();
  }

  void _loadAd() {
    if (adsBanner.isEmpty) {
      setState(() {
        _isLoading = false;
        _isAdAvailable = false;
      });
      return;
    }

    if (_isAdAvailable || _isLoading) {
      return;
    }

    if (_banner != null) {
      _banner!.destroy();
      _banner = null;
    }

    setState(() {
      _isLoading = true;
      _isAdAvailable = false;
    });

    _banner = _createBanner();
  }

  BannerAd _createBanner() {
    return BannerAd(
      adUnitId: adsBanner,
      adSize: _getAdSize(),
      adRequest: const AdRequest(),
      onAdLoaded: () {
        if (!mounted) return;

        _retryTimer?.cancel();
        _retryTimer = null;

        setState(() {
          _isLoading = false;
          _isAdAvailable = true;
        });
      },
      onAdFailedToLoad: (error) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _isAdAvailable = false;
        });

        _banner?.destroy();
        _banner = null;

        if (_retryTimer == null || !_retryTimer!.isActive) {
          _retryTimer = Timer(widget.retryInterval, _loadAd);
        }
      },
      onAdClicked: () {},
      onLeftApplication: () {},
      onReturnedToApplication: () {},
      onImpression: (impressionData) {},
    );
  }

  BannerAdSize _getAdSize() {
    final screenWidth = MediaQuery.of(context).size.width.round();
    return BannerAdSize.inline(
      width: screenWidth - 20,
      maxHeight: widget.maxBannerHeight.round(),
    );
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _banner?.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isAdAvailable ? 1.0 : 0.0,
      child: Container(
        width: MediaQuery.of(context).size.width - 20,
        height: _isAdAvailable ? widget.maxBannerHeight : 10,
        decoration: BoxDecoration(
          color:
              Theme.brightnessOf(context) == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: (Theme.brightnessOf(context) == Brightness.dark
                      ? Colors.white70
                      : Colors.black87)
                  .withAlpha(20),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child:
            _banner != null
                ? AdWidget(bannerAd: _banner!)
                : const SizedBox.shrink(),
      ),
    );
  }
}
