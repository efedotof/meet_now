import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/search/cubit/news/news_cubit.dart';
import 'package:meet_now_app_server/model/social/news_response/news_response.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerAds extends StatefulWidget {
  const BannerAds({
    super.key,
    required this.maxBannerHeight,
    this.autoScrollDuration = const Duration(seconds: 5),
  });

  final double maxBannerHeight;
  final Duration autoScrollDuration;

  @override
  State<BannerAds> createState() => _BannerAdsState();
}

class _BannerAdsState extends State<BannerAds> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  final Map<String, String?> _presignedUrls = {};
  List<NewsResponse>? _previousNews;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<NewsCubit>().getActiveNews();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _startAutoScroll(List<NewsResponse> news) {
    _stopAutoScroll();
    if (news.length <= 1) return;
    _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (timer) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % news.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  Future<void> _openActionUrl(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _fetchPresignedUrlIfNeeded(String originalUrl) {
    if (_presignedUrls.containsKey(originalUrl)) return;
    _presignedUrls[originalUrl] = null;
    _loadPresignedUrl(originalUrl);
  }

  Future<void> _loadPresignedUrl(String originalUrl) async {
    try {
      final presignedUrl = await context
          .read<UploadImageInterface>()
          .getPresignedUrl(originalUrl);
      if (mounted) {
        setState(() {
          _presignedUrls[originalUrl] = presignedUrl;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _presignedUrls[originalUrl] = null;
        });
      }
    }
  }

  void _prefetchPresignedUrls(List<NewsResponse> news) {
    for (final item in news) {
      final imageUrl = item.imageUrl;
      if (imageUrl != null) {
        _fetchPresignedUrlIfNeeded(imageUrl);
      }
    }
  }

  bool _hasNewsChanged(List<NewsResponse> newNews) {
    if (_previousNews == null) return true;
    if (newNews.length != _previousNews!.length) return true;
    for (int i = 0; i < newNews.length; i++) {
      if (newNews[i].id != _previousNews![i].id) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (error) => const SizedBox.shrink(),
          news: (news) {
            if (news.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _startAutoScroll(news);
              });

              if (_hasNewsChanged(news)) {
                _presignedUrls.clear();
                _previousNews = news;
                _prefetchPresignedUrls(news);
              }

              return _buildBannerWidget(news);
            } else {
              _stopAutoScroll();
              _previousNews = null;
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Widget _buildBannerWidget(List<NewsResponse> news) {
    return GestureDetector(
      onPanDown: (_) => _stopAutoScroll(),
      onPanCancel: () => _startAutoScroll(news),
      onPanEnd: (_) => _startAutoScroll(news),
      child: Container(
        height: widget.maxBannerHeight,
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: news.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                final item = news[index];
                final imageUrl = item.imageUrl;
                final presignedUrl =
                    imageUrl != null ? _presignedUrls[imageUrl] : null;

                return GestureDetector(
                  onTap: () => _openActionUrl(item.actionUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (presignedUrl != null)
                          Image.network(
                            presignedUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, _, _) => Container(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer,
                                ),
                          )
                        else
                          Container(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (news.length > 1)
              Positioned(
                top: 12,
                right: 16,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    news.length,
                    (i) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            i == _currentPage
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
