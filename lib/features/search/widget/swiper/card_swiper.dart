import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app_server/model/swipe/swipe_candidate_response/swipe_candidate_response.dart';
import 'package:meet_now_app_server/repository/upload_image/upload_image_interface.dart';

import 'card_swiper_view.dart';

class CardSwiper extends StatefulWidget {
  const CardSwiper({
    super.key,
    required this.item,
    required this.isTop,
    this.nextImageKey,
    this.onInfoPressed,
  });

  final SwipeCandidateResponse item;
  final bool isTop;
  final String? nextImageKey;
  final VoidCallback? onInfoPressed;

  @override
  State<CardSwiper> createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper>
    with AutomaticKeepAliveClientMixin {
  int _currentImageIndex = 0;
  Timer? _autoSwitchTimer;
  static const _autoSwitchDuration = Duration(seconds: 3);

  final Map<int, String> _presignedUrls = {};
  final Map<int, bool> _loadingIndex = {};
  final Map<int, bool> _errorIndex = {};

  List<String> get _imageKeys => widget.item.images;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadAllPresignedUrls();
    _initAutoSwitch();
  }

  @override
  void didUpdateWidget(covariant CardSwiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.images != oldWidget.item.images) {
      setState(() {
        _currentImageIndex = 0;
        _presignedUrls.clear();
        _loadingIndex.clear();
        _errorIndex.clear();
      });
      _loadAllPresignedUrls();
      _restartAutoSwitch();
    } else if (widget.isTop != oldWidget.isTop) {
      widget.isTop ? _startAutoSwitch() : _stopAutoSwitch();
    }
  }

  @override
  void dispose() {
    _stopAutoSwitch();
    super.dispose();
  }

  void _initAutoSwitch() {
    if (widget.isTop && _imageKeys.length > 1) _startAutoSwitch();
  }

  void _startAutoSwitch() {
    _stopAutoSwitch();
    _autoSwitchTimer = Timer.periodic(_autoSwitchDuration, (_) {
      if (mounted && _imageKeys.isNotEmpty) _nextImage(auto: true);
    });
  }

  void _stopAutoSwitch() => _autoSwitchTimer?.cancel();

  void _restartAutoSwitch() {
    (widget.isTop && _imageKeys.length > 1)
        ? _startAutoSwitch()
        : _stopAutoSwitch();
  }

  Future<void> _loadAllPresignedUrls() async {
    if (_imageKeys.isEmpty) return;
    final repository = context.read<UploadImageInterface>();
    for (int i = 0; i < _imageKeys.length; i++) {
      _loadSingleUrl(i, repository);
    }
  }

  Future<void> _loadSingleUrl(
    int index,
    UploadImageInterface repository,
  ) async {
    if (_presignedUrls.containsKey(index)) return;
    try {
      if (mounted) setState(() => _loadingIndex[index] = true);
      final url = await repository.getPresignedUrl(_imageKeys[index]);
      if (mounted) {
        setState(() {
          _presignedUrls[index] = url;
          _loadingIndex[index] = false;
          _errorIndex[index] = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingIndex[index] = false;
          _errorIndex[index] = true;
        });
      }
    }
  }

  void _nextImage({bool auto = false}) {
    if (_imageKeys.isEmpty) return;
    setState(() {
      _currentImageIndex = (_currentImageIndex + 1) % _imageKeys.length;
    });
    if (!auto && mounted) _restartAutoSwitch();
  }

  void _previousImage() {
    if (_imageKeys.isEmpty) return;
    setState(() {
      _currentImageIndex =
          (_currentImageIndex - 1 + _imageKeys.length) % _imageKeys.length;
    });
    if (mounted) _restartAutoSwitch();
  }

  void _openFullscreen() {
    final url = _presignedUrls[_currentImageIndex];
    if (url == null) return;
    _stopAutoSwitch();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => FullscreenMediaView(
              urlMedia: true,
              urlMedial: url,
              showSelectionIndicator: false,
            ),
      ),
    ).then((_) {
      if (mounted) _restartAutoSwitch();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return CardSwiperView(
      item: widget.item,
      currentImageUrl: _presignedUrls[_currentImageIndex],
      currentImageIndex: _currentImageIndex,
      totalImages: _imageKeys.length,
      isLoading: _loadingIndex[_currentImageIndex] ?? false,
      hasError: _errorIndex[_currentImageIndex] ?? false,
      onNext: () => _nextImage(auto: false),
      onPrevious: _previousImage,
      onRetry:
          () => _loadSingleUrl(
            _currentImageIndex,
            context.read<UploadImageInterface>(),
          ),
      onImageTap: _openFullscreen,
      onInfoPressed: widget.onInfoPressed,
    );
  }
}
