import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class GameWebViewScreen extends StatefulWidget {
  const GameWebViewScreen({
    super.key,
    required this.url,
    required this.gameName,
  });

  final String url;
  final String gameName;

  @override
  State<GameWebViewScreen> createState() => _GameWebViewScreenState();
}

class _GameWebViewScreenState extends State<GameWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();

    final platform = WebViewPlatform.instance;
    if (platform is WebKitWebViewPlatform) {
      _controller = WebViewController.fromPlatformCreationParams(
        AndroidWebViewControllerCreationParams(),
      );
    } else if (platform is AndroidWebViewPlatform) {
      _controller = WebViewController.fromPlatformCreationParams(
        AndroidWebViewControllerCreationParams(),
      );
    } else {
      _controller = WebViewController();
    }

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {},
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (_) {
            setState(() {
              _isLoading = false;
            });
          },
          onUrlChange: (urlChange) {
            final url = urlChange.url;
            if (url != null && _shouldCloseWebView(url)) {
              _closeWebViewAndUpdatePoints();
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  bool _shouldCloseWebView(String url) {
    return url.contains('game/close') ||
        url.contains('game/finish') ||
        url.contains('points/update') ||
        false;
  }

  Future<void> _closeWebViewAndUpdatePoints() async {
    if (_isClosing) return;
    _isClosing = true;

    try {
      final pointsCubit = context.read<GamePointsCubit>();
      await pointsCubit.refreshPoints();
    } catch (e) {
      debugPrint('Error updating points: $e');
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _refreshPage() async {
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _closeWebViewAndUpdatePoints();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _refreshPage,
                color: colors.primary,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: WebViewWidget(controller: _controller),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 12,
                top: 12,
                child: Material(
                  color: Colors.black54,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _closeWebViewAndUpdatePoints(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(15),
                    child: const Center(
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (!_isClosing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final pointsCubit = context.read<GamePointsCubit>();
        pointsCubit.refreshPoints();
      });
    }
    super.dispose();
  }
}
