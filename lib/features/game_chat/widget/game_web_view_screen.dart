import 'dart:async';
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
  WebViewController? _controller;
  bool _isInitializing = true;
  bool _isLoading = true;
  bool _isClosing = false;
  double _progress = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    try {
      late final PlatformWebViewControllerCreationParams params;

      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final WebViewController controller =
          WebViewController.fromPlatformCreationParams(params);
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.setBackgroundColor(const Color(0x00000000));
      await controller.enableZoom(true);

      await controller.setUserAgent(
        'Mozilla/5.0 (Linux; Android 10; SM-G973F) '
        'AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/118.0.0.0 Mobile Safari/537.36',
      );

      await controller.setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _progress = 0;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
              _progress = 1.0;
            });

            await Future.delayed(const Duration(milliseconds: 500));
            await _injectPopupSupport(controller);
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _errorMessage = error.description;
            });
          },
          onUrlChange: (UrlChange change) {
            final url = change.url;
            if (url != null && _shouldCloseWebView(url)) {
              _closeWebViewAndUpdatePoints();
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      );

      await controller.loadRequest(Uri.parse(widget.url));

      if (controller.platform is AndroidWebViewController) {
        final androidController =
            controller.platform as AndroidWebViewController;
        AndroidWebViewController.enableDebugging(true);
        await androidController.setMediaPlaybackRequiresUserGesture(false);
      }

      if (controller.platform is WebKitWebViewController) {
        final webKitController = controller.platform as WebKitWebViewController;
        await webKitController.setAllowsBackForwardNavigationGestures(true);
      }

      setState(() {
        _controller = controller;
        _isInitializing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка инициализации: $e';
        _isInitializing = false;
      });
    }
  }

  Future<void> _injectPopupSupport(WebViewController controller) async {
    try {
      await controller.runJavaScript('''
        window._originalOpen = window.open;
        
        function safeOpenPopup(url) {
          try {
            if (!document.body) {
              console.log('Document body not ready yet');
              return null;
            }
            
            var currentUrl = window.location.href;
            var tokenMatch = currentUrl.match(/[?&]token=([^&]*)/);
            var token = tokenMatch ? tokenMatch[1] : '';
            
            var popupUrl = url;
            if (token && url && !url.includes('token=')) {
              popupUrl = url + (url.includes('?') ? '&' : '?') + 'token=' + token;
            }
            
            var iframe = document.createElement('iframe');
            iframe.style.position = 'fixed';
            iframe.style.top = '0';
            iframe.style.left = '0';
            iframe.style.width = '100%';
            iframe.style.height = '100%';
            iframe.style.border = 'none';
            iframe.style.zIndex = '9999';
            iframe.src = popupUrl;
            
            var container = document.createElement('div');
            container.style.position = 'fixed';
            container.style.top = '0';
            container.style.left = '0';
            container.style.width = '100%';
            container.style.height = '100%';
            container.style.backgroundColor = 'rgba(0,0,0,0.5)';
            container.style.zIndex = '9998';
            
            var closeBtn = document.createElement('button');
            closeBtn.innerHTML = '✕';
            closeBtn.style.position = 'fixed';
            closeBtn.style.top = '10px';
            closeBtn.style.right = '10px';
            closeBtn.style.zIndex = '10000';
            closeBtn.style.background = 'white';
            closeBtn.style.border = 'none';
            closeBtn.style.borderRadius = '50%';
            closeBtn.style.width = '30px';
            closeBtn.style.height = '30px';
            closeBtn.style.fontSize = '20px';
            closeBtn.style.cursor = 'pointer';
            
            closeBtn.addEventListener('click', function(e) {
              e.stopPropagation();
              if (container && container.parentNode) {
                document.body.removeChild(container);
              }
            });
            
            container.appendChild(closeBtn);
            container.appendChild(iframe);
            document.body.appendChild(container);
            
            return {
              closed: false,
              close: function() {
                if (container && container.parentNode) {
                  document.body.removeChild(container);
                }
              }
            };
          } catch (error) {
            console.error('Error in openPopup:', error);
            return null;
          }
        }
        
        window.open = function(url, name, specs) {
          if (!url) {
            return window._originalOpen(url, name, specs);
          }
          
          var currentOrigin = window.location.origin;
          var targetOrigin;
          
          try {
            targetOrigin = new URL(url, window.location.href).origin;
          } catch (e) {
            return window._originalOpen(url, name, specs);
          }
          
          if (currentOrigin === targetOrigin && !url.includes('popup=true')) {
            return window._originalOpen(url, name, specs);
          }
          
          var popup = safeOpenPopup(url);
          if (popup) {
            return popup;
          }
          
          return window._originalOpen(url, name, specs);
        };
        
        function handleBlankLinks(e) {
          try {
            var target = e.target;
            var maxDepth = 10; // Максимальная глубина поиска
            
            for (var i = 0; i < maxDepth && target && target !== document; i++) {
              if (target.tagName === 'A' && target.target === '_blank') {
                e.preventDefault();
                e.stopPropagation();
                
                // Открываем во всплывающем окне
                safeOpenPopup(target.href);
                return false;
              }
              target = target.parentNode;
            }
          } catch (error) {
            console.error('Error handling blank link:', error);
          }
        }
        
        if (document.body) {
          document.body.addEventListener('click', handleBlankLinks, true);
        } else {
          document.addEventListener('DOMContentLoaded', function() {
            if (document.body) {
              document.body.addEventListener('click', handleBlankLinks, true);
            }
          });
        }
        
        // Безопасные обертки для alert, confirm, prompt
        if (typeof window.alert !== 'function') {
          window.alert = function(message) {
            console.log('Alert:', message);
            return undefined;
          };
        }
        
        if (typeof window.confirm !== 'function') {
          window.confirm = function(message) {
            console.log('Confirm:', message);
            return true;
          };
        }
        
        if (typeof window.prompt !== 'function') {
          window.prompt = function(message, defaultValue) {
            console.log('Prompt:', message, defaultValue);
            return defaultValue || '';
          };
        }
      ''');

      await controller.runJavaScript('''
        if (!navigator.mediaDevices) {
          navigator.mediaDevices = {};
        }
        
        if (!navigator.geolocation) {
          navigator.geolocation = {
            getCurrentPosition: function(success, error, options) {
              console.log('Geolocation requested');
              if (success) {
                success({
                  coords: {
                    latitude: 55.7558,
                    longitude: 37.6173,
                    accuracy: 100,
                    altitude: null,
                    altitudeAccuracy: null,
                    heading: null,
                    speed: null
                  },
                  timestamp: Date.now()
                });
              }
            },
            watchPosition: function(success, error, options) {
              console.log('Geolocation watch started');
              return 1;
            },
            clearWatch: function(id) {
              console.log('Geolocation watch cleared');
            }
          };
        }
      ''');
    } catch (e) {
      //
    }
  }

  bool _shouldCloseWebView(String url) {
    return url.contains('game/close') ||
        url.contains('game/finish') ||
        url.contains('points/update') ||
        (url.contains('close') && url.contains('game')) ||
        false;
  }

  Future<void> _closeWebViewAndUpdatePoints() async {
    if (_isClosing) return;
    _isClosing = true;

    try {
      final pointsCubit = context.read<GamePointsCubit>();
      await pointsCubit.refreshPoints();
    } catch (e) {
      //
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _refreshPage() async {
    if (_controller == null) return;

    setState(() {
      _isLoading = true;
      _progress = 0;
      _errorMessage = null;
    });
    await _controller!.reload();
  }

  Future<void> _goBack() async {
    if (_controller == null) return;

    if (await _controller!.canGoBack()) {
      await _controller!.goBack();
    } else {
      await _closeWebViewAndUpdatePoints();
    }
  }

  Future<void> _goForward() async {
    if (_controller == null) return;

    if (await _controller!.canGoForward()) {
      await _controller!.goForward();
    }
  }

  Future<void> _clearCacheAndReload() async {
    if (_controller == null) return;

    try {
      await _controller!.clearCache();
      await _controller!.clearLocalStorage();
      await _refreshPage();
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                'Подготовка игры...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (_controller == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.white.withAlpha(178),
              ),
              const SizedBox(height: 20),
              Text(
                'Не удалось загрузить игру',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage ?? 'Проверьте подключение к интернету',
                style: TextStyle(
                  color: Colors.white.withAlpha(178),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _isInitializing = true;
                    _errorMessage = null;
                  });
                  _initializeWebView();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Попробовать снова'),
              ),
            ],
          ),
        ),
      );
    }

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
          bottom: false,
          child: Column(
            children: [
              if (_isLoading || _progress < 1.0)
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                  minHeight: 3,
                  borderRadius: BorderRadius.zero,
                ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withAlpha(25),
                      width: 1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    _NavigationButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onPressed: _goBack,
                      tooltip: 'Назад',
                    ),

                    _NavigationButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      onPressed: _goForward,
                      tooltip: 'Вперед',
                    ),

                    _NavigationButton(
                      icon: Icons.refresh_rounded,
                      onPressed: _refreshPage,
                      tooltip: 'Обновить',
                    ),

                    if (_isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colors.primary,
                            ),
                          ),
                        ),
                      ),

                    const Spacer(),

                    Expanded(
                      child: Text(
                        widget.gameName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const Spacer(),

                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      color: isDark ? Colors.grey[900] : Colors.white,
                      onSelected: (value) {
                        if (value == 'clear_cache') {
                          _clearCacheAndReload();
                        } else if (value == 'reload') {
                          _refreshPage();
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: 'reload',
                              child: Row(
                                children: [
                                  const Icon(Icons.refresh, size: 20),
                                  const SizedBox(width: 8),
                                  const Text('Перезагрузить'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'clear_cache',
                              child: Row(
                                children: [
                                  const Icon(Icons.clear_all, size: 20),
                                  const SizedBox(width: 8),
                                  const Text('Очистить кэш'),
                                ],
                              ),
                            ),
                          ],
                    ),

                    _NavigationButton(
                      icon: Icons.close_rounded,
                      onPressed: _closeWebViewAndUpdatePoints,
                      tooltip: 'Закрыть',
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(controller: _controller!),

                    if (_isLoading && _progress < 0.9)
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(217),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(76),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${(_progress * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Загрузка игры...',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(204),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (!_isLoading && _progress == 0 && _errorMessage != null)
                      Center(
                        child: Container(
                          width: 280,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(229),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(127),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.wifi_off_rounded,
                                size: 60,
                                color: Colors.white.withAlpha(178),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Проблемы с загрузкой',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage ??
                                    'Не удалось загрузить игру. Проверьте подключение к интернету.',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(178),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _closeWebViewAndUpdatePoints,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        side: const BorderSide(
                                          color: Color.fromARGB(
                                            76,
                                            255,
                                            255,
                                            255,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Закрыть'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: _refreshPage,
                                      style: FilledButton.styleFrom(
                                        backgroundColor: colors.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Попробовать снова'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
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
        try {
          final pointsCubit = context.read<GamePointsCubit>();
          pointsCubit.refreshPoints();
        } catch (e) {
          //
        }
      });
    }
    super.dispose();
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  const _NavigationButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white, size: 22),
      tooltip: tooltip,
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white.withAlpha(25),
      ),
    );
  }
}
