import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
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
  late WebViewController _controller;
  bool _isInitializing = true;
  bool _isLoading = true;
  bool _isClosing = false;
  double _progress = 0;
  String? _errorMessage;
  bool _popupScriptInjected = false;
  int? _lastScore;
  final List<Map<String, dynamic>> _requestLogs = [];

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    try {
      developer.log(
        'Инициализация WebView для URL: ${widget.url}',
        name: 'GameWebView',
      );

      late final PlatformWebViewControllerCreationParams params;

      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
        developer.log('Используется WebKit WebView', name: 'GameWebView');
      } else {
        params = const PlatformWebViewControllerCreationParams();
        developer.log(
          'Используется платформозависимый WebView',
          name: 'GameWebView',
        );
      }

      final controller = WebViewController.fromPlatformCreationParams(params);

      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.setBackgroundColor(const Color(0x00000000));
      await controller.enableZoom(true);

      await controller.setUserAgent(
        'Mozilla/5.0 (Linux; Android 10; SM-G973F) '
        'AppleWebKit/537.36 (KHTML, like Gecko) '
        'Chrome/118.0.0.0 Mobile Safari/537.36',
      );

      developer.log('UserAgent установлен', name: 'GameWebView');

      controller.addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          _handleJavaScriptMessage(message.message);
        },
      );

      controller.setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100;
            });
            developer.log('Прогресс загрузки: $progress%', name: 'GameWebView');
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _progress = 0;
              _popupScriptInjected = false;
            });
            developer.log(
              'Начало загрузки страницы: $url',
              name: 'GameWebView',
            );
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
              _progress = 1.0;
            });
            developer.log(
              'Загрузка страницы завершена: $url',
              name: 'GameWebView',
            );

            if (!_popupScriptInjected) {
              developer.log(
                'Инъекция скрипта мониторинга...',
                name: 'GameWebView',
              );
              await Future.delayed(const Duration(milliseconds: 500));
              await _injectGameCommunicationScript(controller);
              _popupScriptInjected = true;
            }
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _errorMessage = '${error.errorCode}: ${error.description}';
            });
            developer.log(
              'Ошибка загрузки ресурса: код=${error.errorCode}, описание=${error.description}, тип=${error.errorType}',
              name: 'GameWebView',
            );
          },
          onUrlChange: (UrlChange change) {
            final url = change.url;
            if (url != null) {
              developer.log('URL изменен: $url', name: 'GameWebView');
              _handleUrlChange(url);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            developer.log(
              'Запрос навигации: ${request.url}',
              name: 'GameWebView',
            );

            if (request.url.contains('/api/') ||
                request.url.contains('api.mnapp.ru')) {
              developer.log(
                'Разрешена навигация к API URL',
                name: 'GameWebView',
              );
              return NavigationDecision.navigate;
            }

            developer.log(
              'Обнаружен POST запрос на: ${request.url}',
              name: 'GameWebView',
            );
            _logRequest('POST', request.url, null);

            return NavigationDecision.navigate;
          },
        ),
      );

      developer.log('Загрузка URL: ${widget.url}', name: 'GameWebView');
      await controller.loadRequest(Uri.parse(widget.url));

      if (controller.platform is AndroidWebViewController) {
        final androidController =
            controller.platform as AndroidWebViewController;
        AndroidWebViewController.enableDebugging(true);
        await androidController.setMediaPlaybackRequiresUserGesture(false);
        developer.log('Android WebView настроен', name: 'GameWebView');
      }

      if (controller.platform is WebKitWebViewController) {
        final webKitController = controller.platform as WebKitWebViewController;
        await webKitController.setAllowsBackForwardNavigationGestures(true);
        developer.log('WebKit WebView настроен', name: 'GameWebView');
      }

      setState(() {
        _controller = controller;
        _isInitializing = false;
      });

      developer.log('WebView инициализирован успешно', name: 'GameWebView');
    } catch (e, stackTrace) {
      developer.log(
        'Ошибка инициализации WebView: $e\nStack trace: $stackTrace',
        name: 'GameWebView',
        error: e,
        stackTrace: stackTrace,
      );
      setState(() {
        _errorMessage = 'Ошибка инициализации: ${e.toString()}';
        _isInitializing = false;
      });
    }
  }

  void _logRequest(String method, String url, dynamic data) {
    final logEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'method': method,
      'url': url,
      'data': data,
    };
    _requestLogs.add(logEntry);
    developer.log('Запрос записан: $logEntry', name: 'GameWebView');

    if (_requestLogs.length > 50) {
      _requestLogs.removeAt(0);
    }
  }

  Future<void> _injectGameCommunicationScript(
    WebViewController controller,
  ) async {
    try {
      final script = '''

        window.FlutterGameCommunicator = {
          sendToFlutter: function(data) {
            try {
              if (window.FlutterChannel) {
                const jsonData = JSON.stringify(data);
                console.log('[FlutterGameCommunicator] Отправка в Flutter:', jsonData);
                window.FlutterChannel.postMessage(jsonData);
                return true;
              } else {
                console.warn('[FlutterGameCommunicator] FlutterChannel не доступен');
              }
            } catch (e) {
              console.error('[FlutterGameCommunicator] Ошибка отправки в Flutter:', e);
            }
            return false;
          },
          
          monitorGameState: function() {
            console.log('[FlutterGameCommunicator] Запуск мониторинга состояния игры');
            
            const checkGameLoaded = setInterval(() => {
              try {
                console.log('[FlutterGameCommunicator] Проверка загрузки игры...');
                console.log('[FlutterGameCommunicator] window.state:', window.state);
                console.log('[FlutterGameCommunicator] window.CONFIG:', window.CONFIG);
                console.log('[FlutterGameCommunicator] window.sendGameResults:', typeof window.sendGameResults);
                
                if (typeof window.state !== 'undefined' && typeof window.CONFIG !== 'undefined') {
                  console.log('[FlutterGameCommunicator] Игра загружена, отмена интервала');
                  clearInterval(checkGameLoaded);
                  
                  this.sendToFlutter({
                    type: 'GAME_READY',
                    score: window.state.score || 0,
                    lives: window.state.lives || 0,
                    level: window.state.level || 1,
                    hasSendGameResults: typeof window.sendGameResults === 'function',
                    timestamp: Date.now()
                  });
                  
                  if (typeof window.state === 'object' && window.state !== null) {
                    const originalScore = window.state.score;
                    console.log('[FlutterGameCommunicator] Начальный счет:', originalScore);
                    
                    try {
                      const scoreHandler = {
                        set: function(target, property, value) {
                          if (property === 'score') {
                            const changed = originalScore !== value;
                            target[property] = value;
                            
                            if (changed && window.FlutterGameCommunicator) {
                              console.log('[FlutterGameCommunicator] Счет изменен:', value);
                              window.FlutterGameCommunicator.sendToFlutter({
                                type: 'SCORE_UPDATE',
                                score: value,
                                oldScore: originalScore,
                                timestamp: Date.now()
                              });
                            }
                            return true;
                          }
                          target[property] = value;
                          return true;
                        }
                      };
                      
                      window.state = new Proxy(window.state, scoreHandler);
                      console.log('[FlutterGameCommunicator] Proxy для window.state установлен');
                    } catch (e) {
                      console.log('[FlutterGameCommunicator] Proxy не поддерживается, используется polling:', e);
                    }
                  }
                  
                  if (typeof window.sendGameResults === 'function') {
                    console.log('[FlutterGameCommunicator] Перехват функции sendGameResults');
                    const originalSendGameResults = window.sendGameResults;
                    
                    window.sendGameResults = async function(...args) {
                      console.log('[FlutterGameCommunicator] sendGameResults вызвана с аргументами:', args);
                      console.log('[FlutterGameCommunicator] Текущий счет перед отправкой:', window.state?.score || 0);
                      
                      window.FlutterGameCommunicator.sendToFlutter({
                        type: 'GAME_RESULT_SENDING',
                        score: window.state?.score || 0,
                        arguments: args,
                        timestamp: Date.now()
                      });
                      
                      try {
                        const result = await originalSendGameResults.apply(this, args);
                        
                        console.log('[FlutterGameCommunicator] sendGameResults успешно завершена, результат:', result);
                        
                        window.FlutterGameCommunicator.sendToFlutter({
                          type: 'GAME_RESULT_SENT',
                          score: window.state?.score || 0,
                          success: true,
                          result: result,
                          timestamp: Date.now()
                        });
                        
                        return result;
                      } catch (error) {
                        console.error('[FlutterGameCommunicator] Ошибка в sendGameResults:', error);
                        window.FlutterGameCommunicator.sendToFlutter({
                          type: 'GAME_RESULT_ERROR',
                          error: error.message,
                          score: window.state?.score || 0,
                          timestamp: Date.now()
                        });
                        throw error;
                      }
                    };
                    
                    console.log('[FlutterGameCommunicator] Функция sendGameResults перехвачена');
                  } else {
                    console.warn('[FlutterGameCommunicator] Функция sendGameResults не найдена');
                  }
                  
                  if (typeof window.endGame === 'function') {
                    console.log('[FlutterGameCommunicator] Перехват функции endGame');
                    const originalEndGame = window.endGame;
                    window.endGame = function(...args) {
                      const score = window.state?.score || 0;
                      console.log('[FlutterGameCommunicator] endGame вызвана, счет:', score);
                      
                      window.FlutterGameCommunicator.sendToFlutter({
                        type: 'GAME_ENDED',
                        score: score,
                        finalScore: true,
                        timestamp: Date.now()
                      });
                      
                      return originalEndGame.apply(this, args);
                    };
                  }
                  
                  let lastUrl = location.href;
                  console.log('[FlutterGameCommunicator] Начальный URL:', lastUrl);
                  
                  new MutationObserver(() => {
                    if (location.href !== lastUrl) {
                      console.log('[FlutterGameCommunicator] URL изменен:', location.href);
                      lastUrl = location.href;
                      if (location.href.includes('complete') || 
                          location.href.includes('finish') ||
                          location.href.includes('game_over')) {
                        
                        console.log('[FlutterGameCommunicator] Обнаружен URL завершения игры');
                        window.FlutterGameCommunicator.sendToFlutter({
                          type: 'URL_CHANGED_TO_COMPLETE',
                          url: location.href,
                          score: window.state?.score || 0,
                          timestamp: Date.now()
                        });
                      }
                    }
                  }).observe(document, {childList: true, subtree: true});
                  
                  console.log('[FlutterGameCommunicator] Мониторинг игры инициализирован');
                }
              } catch (e) {
                console.error('[FlutterGameCommunicator] Ошибка в мониторинге игры:', e);
              }
            }, 500);
          }
        };
        

        setTimeout(() => {
          console.log('[FlutterGameCommunicator] Запуск мониторинга через 1 секунду');
          if (window.FlutterGameCommunicator) {
            window.FlutterGameCommunicator.monitorGameState();
          }
        }, 1000);
        
     
        window.getCurrentGameScore = function() {
          const score = window.state?.score || 0;
          console.log('[FlutterGameCommunicator] getCurrentGameScore возвращает:', score);
          return score;
        };
        

        window.addEventListener('beforeunload', function(e) {
          console.log('[FlutterGameCommunicator] Событие beforeunload');
          if (window.FlutterGameCommunicator && window.state) {
            window.FlutterGameCommunicator.sendToFlutter({
              type: 'BEFORE_UNLOAD',
              score: window.state.score || 0,
              timestamp: Date.now()
            });
          }
        });
        
        document.addEventListener('visibilitychange', function() {
          console.log('[FlutterGameCommunicator] visibilitychange, hidden:', document.hidden);
          if (document.hidden && window.FlutterGameCommunicator && window.state) {
            window.FlutterGameCommunicator.sendToFlutter({
              type: 'PAGE_HIDDEN',
              score: window.state.score || 0,
              timestamp: Date.now()
            });
          }
        });
        
        (function() {
          console.log('[FlutterGameCommunicator] Инициализация мониторинга сетевых запросов');
          
          const originalFetch = window.fetch;
          if (originalFetch) {
            window.fetch = function(...args) {
              const [resource, init] = args;
              const url = resource instanceof Request ? resource.url : resource;
              const method = (init?.method || 'GET').toUpperCase();
              
              console.log(`[FlutterGameCommunicator] Fetch запрос: `, init);
              
              if (method === 'POST') {
                console.log('[FlutterGameCommunicator] Обнаружен POST запрос через fetch:', {
                  url: url,
                  body: init?.body,
                  headers: init?.headers
                });
                
                if (window.FlutterGameCommunicator) {
                  window.FlutterGameCommunicator.sendToFlutter({
                    type: 'FETCH_POST_REQUEST',
                    url: url,
                    method: method,
                    body: init?.body,
                    timestamp: Date.now()
                  });
                }
              }
              
              const startTime = Date.now();
              return originalFetch.apply(this, args)
                .then(response => {
                  console.log(`[FlutterGameCommunicator] Fetch ответ: `, response);
                  
                  if (method === 'POST' && window.FlutterGameCommunicator) {
                    window.FlutterGameCommunicator.sendToFlutter({
                      type: 'FETCH_POST_RESPONSE',
                      url: url,
                      status: response.status,
                      statusText: response.statusText,
                      duration: Date.now() - startTime,
                      timestamp: Date.now()
                    });
                    
                    response.clone().text().then(text => {
                      console.log('[FlutterGameCommunicator] Тело ответа fetch:', text);
                      window.FlutterGameCommunicator.sendToFlutter({
                        type: 'FETCH_POST_RESPONSE_BODY',
                        url: url,
                        body: text,
                        timestamp: Date.now()
                      });
                    });
                  }
                  
                  return response;
                })
                .catch(error => {
                  console.error('[FlutterGameCommunicator] Ошибка fetch:', error);
                  if (method === 'POST' && window.FlutterGameCommunicator) {
                    window.FlutterGameCommunicator.sendToFlutter({
                      type: 'FETCH_POST_ERROR',
                      url: url,
                      error: error.message,
                      timestamp: Date.now()
                    });
                  }
                  throw error;
                });
            };
            console.log('[FlutterGameCommunicator] Fetch перехвачен');
          }
          
          const originalXHROpen = XMLHttpRequest.prototype.open;
          const originalXHRSend = XMLHttpRequest.prototype.send;
          
          XMLHttpRequest.prototype.open = function(method, url) {
            this._method = method;
            this._url = url;
            console.log(`[FlutterGameCommunicator] XHR открыт: `);
            return originalXHROpen.apply(this, arguments);
          };
          
          XMLHttpRequest.prototype.send = function(body) {
            const method = this._method?.toUpperCase();
            const url = this._url;
            
            console.log(`[FlutterGameCommunicator] XHR отправка: `, body);
            
            if (method === 'POST') {
              console.log('[FlutterGameCommunicator] Обнаружен POST запрос через XHR:', {
                url: url,
                body: body
              });
              
              if (window.FlutterGameCommunicator) {
                window.FlutterGameCommunicator.sendToFlutter({
                  type: 'XHR_POST_REQUEST',
                  url: url,
                  method: method,
                  body: body,
                  timestamp: Date.now()
                });
              }
            }
            
            const startTime = Date.now();
            
            this.addEventListener('load', function() {
              console.log(`[FlutterGameCommunicator] XHR ответ: }`, this.responseText);
              
              if (method === 'POST' && window.FlutterGameCommunicator) {
                window.FlutterGameCommunicator.sendToFlutter({
                  type: 'XHR_POST_RESPONSE',
                  url: url,
                  status: this.status,
                  statusText: this.statusText,
                  response: this.responseText,
                  duration: Date.now() - startTime,
                  timestamp: Date.now()
                });
              }
            });
            
            this.addEventListener('error', function() {
              console.error('[FlutterGameCommunicator] Ошибка XHR:', this.status, url);
              if (method === 'POST' && window.FlutterGameCommunicator) {
                window.FlutterGameCommunicator.sendToFlutter({
                  type: 'XHR_POST_ERROR',
                  url: url,
                  error: 'XHR error',
                  timestamp: Date.now()
                });
              }
            });
            
            return originalXHRSend.apply(this, arguments);
          };
          
          console.log('[FlutterGameCommunicator] Мониторинг сетевых запросов инициализирован');
        })();
      ''';

      developer.log('Инъекция скрипта мониторинга...', name: 'GameWebView');
      await controller.runJavaScript(script);
      developer.log(
        'Скрипт мониторинга успешно инъецирован',
        name: 'GameWebView',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Ошибка при инъекции скрипта коммуникации: $e\nStack trace: $stackTrace',
        name: 'GameWebView',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _handleJavaScriptMessage(String message) {
    try {
      developer.log('Получено JS сообщение: $message', name: 'GameWebView');

      final data = json.decode(message);
      final type = data['type'];

      developer.log(
        'JS Message тип: $type, данные: ${json.encode(data)}',
        name: 'GameWebView',
      );

      switch (type) {
        case 'SCORE_UPDATE':
          final score = data['score'];
          final oldScore = data['oldScore'];
          if (score != null) {
            developer.log(
              'Обновление счета: $oldScore → $score',
              name: 'GameWebView',
            );
            _lastScore = score;
          }
          break;

        case 'GAME_RESULT_SENDING':
          final score = data['score'];
          final arguments = data['arguments'];
          developer.log(
            'Игра отправляет результаты на сервер, счет: $score, аргументы: $arguments',
            name: 'GameWebView',
          );
          _logRequest('GAME_RESULT_SENDING', 'sendGameResults', data);
          break;

        case 'GAME_RESULT_SENT':
          final score = data['score'];
          final result = data['result'];
          developer.log(
            'Результаты игры успешно отправлены, счет: $score, результат: $result',
            name: 'GameWebView',
          );
          _logRequest('GAME_RESULT_SENT', 'sendGameResults', data);
          _schedulePointsRefresh();
          break;

        case 'GAME_ENDED':
          final score = data['score'];
          if (score != null) {
            _lastScore = score;
          }
          developer.log(
            'Игра завершена со счетом: $score',
            name: 'GameWebView',
          );
          _schedulePointsRefresh();
          break;

        case 'URL_CHANGED_TO_COMPLETE':
          final url = data['url'];
          final score = data['score'];
          developer.log(
            'URL изменился на страницу завершения: $url, счет: $score',
            name: 'GameWebView',
          );
          _schedulePointsRefresh();
          break;

        case 'BEFORE_UNLOAD':
        case 'PAGE_HIDDEN':
          final score = data['score'];
          if (score != null && score > 0) {
            _lastScore = score;
            developer.log(
              'Сохранение счета перед уходом: $score',
              name: 'GameWebView',
            );
            _saveAndUpdatePoints(score);
          }
          break;

        case 'GAME_READY':
          final hasSendGameResults = data['hasSendGameResults'];
          developer.log(
            'Игра готова, мониторинг включен, sendGameResults доступна: $hasSendGameResults',
            name: 'GameWebView',
          );
          break;

        case 'GAME_RESULT_ERROR':
          final error = data['error'];
          final score = data['score'];
          developer.log(
            'Ошибка отправки результатов: $error, счет: $score',
            name: 'GameWebView',
          );
          if (score != null && score > 0) {
            _saveAndUpdatePoints(score);
          }
          break;

        case 'FETCH_POST_REQUEST':
        case 'XHR_POST_REQUEST':
          developer.log(
            'Обнаружен POST запрос ($type): ${data['url']}, тело: ${data['body']}',
            name: 'GameWebView',
          );
          _logRequest('POST', data['url'], data['body']);
          break;

        case 'FETCH_POST_RESPONSE':
        case 'XHR_POST_RESPONSE':
          developer.log(
            'Ответ на POST запрос ($type): ${data['url']}, статус: ${data['status']}, длительность: ${data['duration']}мс',
            name: 'GameWebView',
          );
          break;

        case 'FETCH_POST_RESPONSE_BODY':
          developer.log(
            'Тело ответа на POST запрос: ${data['url']}, тело: ${data['body']}',
            name: 'GameWebView',
          );
          break;

        case 'FETCH_POST_ERROR':
        case 'XHR_POST_ERROR':
          developer.log(
            'Ошибка POST запроса ($type): ${data['url']}, ошибка: ${data['error']}',
            name: 'GameWebView',
          );
          break;

        default:
          developer.log(
            'Неизвестный тип JS сообщения: $type',
            name: 'GameWebView',
          );
          break;
      }
    } catch (e, stackTrace) {
      developer.log(
        'Ошибка парсинга JS сообщения: $e, message: $message\nStack trace: $stackTrace',
        name: 'GameWebView',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _handleUrlChange(String url) {
    developer.log('Обработка изменения URL: $url', name: 'GameWebView');

    if (url.contains('game/close') ||
        url.contains('game/finish') ||
        url.contains('points/update') ||
        url.contains('game_complete') ||
        (url.contains('complete') && url.contains('game')) ||
        false) {
      developer.log('Обнаружен URL завершения игры: $url', name: 'GameWebView');
      _getFinalScoreAndClose();
    }
  }

  Future<void> _getFinalScoreAndClose() async {
    if (_isClosing) {
      developer.log('Уже в процессе закрытия', name: 'GameWebView');
      return;
    }

    developer.log('Получение финального счета и закрытие', name: 'GameWebView');

    try {
      int? finalScore;

      if (_lastScore != null && _lastScore! > 0) {
        finalScore = _lastScore;
        developer.log(
          'Используем последний известный счет: $finalScore',
          name: 'GameWebView',
        );
      } else {
        developer.log(
          'Попытка получить счет через JavaScript',
          name: 'GameWebView',
        );

        final score = await _controller.runJavaScriptReturningResult('''
          (function() {
            console.log('[GameWebView] Получение финального счета через JS');
            if (typeof window.getCurrentGameScore === 'function') {
              const score = window.getCurrentGameScore();
              console.log('[GameWebView] Счет через getCurrentGameScore:', score);
              return score;
            } else if (typeof window.state !== 'undefined' && window.state.score !== undefined) {
              const score = window.state.score;
              console.log('[GameWebView] Счет через window.state:', score);
              return score;
            }
            console.log('[GameWebView] Счет не найден, возвращаем 0');
            return 0;
          })();
        ''');

        developer.log(
          'Результат выполнения JS для счета: $score',
          name: 'GameWebView',
        );

        if (score is num) {
          finalScore = score.toInt();
        } else if (score is String) {
          finalScore = int.tryParse(score) ?? 0;
        } else {
          finalScore = 0;
        }
      }

      developer.log(
        'Финальный счет перед закрытием: $finalScore',
        name: 'GameWebView',
      );

      if (finalScore != null && finalScore > 0) {
        await _saveAndUpdatePoints(finalScore);
      } else {
        developer.log(
          'Счет не найден или равен 0, пропускаем сохранение',
          name: 'GameWebView',
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Ошибка получения финального счета: $e\nStack trace: $stackTrace',
        name: 'GameWebView',
        error: e,
        stackTrace: stackTrace,
      );
    }

    await _closeWebViewAndUpdatePoints();
  }

  Future<void> _saveAndUpdatePoints(int score) async {
    if (score <= 0) {
      developer.log('Счет <= 0, пропускаем сохранение', name: 'GameWebView');
      return;
    }

    try {
      _lastScore = score;
      developer.log('Сохранение очков: $score', name: 'GameWebView');

      _schedulePointsRefresh();
    } catch (e, stackTrace) {
      developer.log(
        'Ошибка сохранения очков: $e\nStack trace: $stackTrace',
        name: 'GameWebView',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _schedulePointsRefresh() {
    developer.log(
      'Планирование обновления очков через 2 секунды',
      name: 'GameWebView',
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!_isClosing && mounted) {
        _refreshPoints();
      } else {
        developer.log(
          'Не обновляем очки: закрытие или unmounted',
          name: 'GameWebView',
        );
      }
    });
  }

  Future<void> _refreshPoints() async {
    if (!mounted) {
      developer.log(
        'Widget не mounted, пропускаем обновление очков',
        name: 'GameWebView',
      );
      return;
    }

    try {
      developer.log(
        'Обновление очков через GamePointsCubit',
        name: 'GameWebView',
      );
      final pointsCubit = context.read<GamePointsCubit>();
      await pointsCubit.refreshPoints();
      developer.log('Очки успешно обновлены', name: 'GameWebView');

      developer.log('Логи запросов:', name: 'GameWebView');
      for (final log in _requestLogs) {
        developer.log('  $log', name: 'GameWebView');
      }
    } catch (e, stackTrace) {
      developer.log(
        'Ошибка обновления очков: $e\nStack trace: $stackTrace',
        name: 'GameWebView',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _closeWebViewAndUpdatePoints() async {
    if (_isClosing) {
      developer.log('Уже в процессе закрытия', name: 'GameWebView');
      return;
    }

    _isClosing = true;
    developer.log('Начало процесса закрытия WebView', name: 'GameWebView');

    await Future.delayed(const Duration(milliseconds: 500));

    await _refreshPoints();

    if (mounted) {
      developer.log('Навигация назад', name: 'GameWebView');
      Navigator.of(context).pop();
    } else {
      developer.log(
        'Widget не mounted, не можем навигировать',
        name: 'GameWebView',
      );
    }
  }

  Future<void> _refreshPage() async {
    developer.log('Перезагрузка страницы', name: 'GameWebView');

    setState(() {
      _isLoading = true;
      _progress = 0;
      _errorMessage = null;
      _popupScriptInjected = false;
    });

    try {
      await _controller.reload();
      developer.log('Страница перезагружена', name: 'GameWebView');
    } catch (e, stackTrace) {
      developer.log(
        'Ошибка перезагрузки: $e\nStack trace: $stackTrace',
        name: 'GameWebView',
        error: e,
        stackTrace: stackTrace,
      );
      setState(() {
        _errorMessage = 'Ошибка перезагрузки: $e';
      });
    }
  }

  Future<void> _goBack() async {
    developer.log('Нажата кнопка назад', name: 'GameWebView');

    if (await _controller.canGoBack()) {
      developer.log('WebView может идти назад', name: 'GameWebView');
      await _controller.goBack();
    } else {
      developer.log(
        'WebView не может идти назад, закрываем',
        name: 'GameWebView',
      );
      await _closeWebViewAndUpdatePoints();
    }
  }

  Future<void> _goForward() async {
    developer.log('Нажата кнопка вперед', name: 'GameWebView');

    if (await _controller.canGoForward()) {
      developer.log('WebView может идти вперед', name: 'GameWebView');
      await _controller.goForward();
    } else {
      developer.log('WebView не может идти вперед', name: 'GameWebView');
    }
  }

  Future<void> _clearCacheAndReload() async {
    developer.log('Очистка кэша и перезагрузка', name: 'GameWebView');

    try {
      await _controller.clearCache();
      developer.log('Кэш очищен', name: 'GameWebView');
      await _refreshPage();
    } catch (e, stackTrace) {
      developer.log(
        'Ошибка очистки кэша: $e\nStack trace: $stackTrace',
        name: 'GameWebView',
        error: e,
        stackTrace: stackTrace,
      );
      setState(() {
        _errorMessage = 'Ошибка очистки кэша: $e';
      });
    }
  }

  Future<void> _enableWebViewDebugging() async {
    developer.log('Включение отладки WebView', name: 'GameWebView');

    try {
      if (_controller.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        developer.log('Отладка Android WebView включена', name: 'GameWebView');

        await _controller.runJavaScript('''
          console.log('=== WebView Debug Mode Enabled ===');
          console.log('UserAgent:', navigator.userAgent);
          console.log('Cookies enabled:', navigator.cookieEnabled);
          console.log('LocalStorage:', !!window.localStorage);
          console.log('SessionStorage:', !!window.sessionStorage);
          console.log('window.FlutterGameCommunicator:', !!window.FlutterGameCommunicator);
          console.log('window.FlutterChannel:', !!window.FlutterChannel);
          console.log('window.state:', window.state);
          console.log('window.CONFIG:', window.CONFIG);
          console.log('window.sendGameResults:', typeof window.sendGameResults);
          console.log('window.endGame:', typeof window.endGame);
          console.log('window.getCurrentGameScore:', typeof window.getCurrentGameScore);
          console.log('==================================');
        ''');

        developer.log('JS для отладки выполнен', name: 'GameWebView');
      } else {
        developer.log(
          'Не Android WebView, отладка может быть недоступна',
          name: 'GameWebView',
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'Ошибка при включении отладки: $e\nStack trace: $stackTrace',
        name: 'GameWebView',
        error: e,
        stackTrace: stackTrace,
      );
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
                'Загрузка игры...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        developer.log(
          'onPopInvokedWithResult: didPop=$didPop, result=$result',
          name: 'GameWebView',
        );
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
                        developer.log(
                          'Выбрано меню: $value',
                          name: 'GameWebView',
                        );
                        switch (value) {
                          case 'reload':
                            _refreshPage();
                            break;
                          case 'clear_cache':
                            _clearCacheAndReload();
                            break;
                          case 'debug':
                            _enableWebViewDebugging();
                            break;
                          case 'show_logs':
                            _showRequestLogs();
                            break;
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
                            PopupMenuItem(
                              value: 'debug',
                              child: Row(
                                children: [
                                  const Icon(Icons.bug_report, size: 20),
                                  const SizedBox(width: 8),
                                  const Text('Отладка WebView'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'show_logs',
                              child: Row(
                                children: [
                                  const Icon(Icons.list, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Логи запросов (${_requestLogs.length})',
                                  ),
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
                    WebViewWidget(controller: _controller),

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
                                'Загрузка...',
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
                                'Ошибка загрузки',
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
                                      child: const Text('Повторить'),
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

  void _showRequestLogs() {
    developer.log(
      '=== ЛОГИ ЗАПРОСОВ (${_requestLogs.length}) ===',
      name: 'GameWebView',
    );
    for (final log in _requestLogs) {
      developer.log(
        '${log['timestamp']} ${log['method']} ${log['url']}',
        name: 'GameWebView',
      );
    }
    developer.log('================================', name: 'GameWebView');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Логи запросов выведены в консоль (${_requestLogs.length} записей)',
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    developer.log('dispose() вызван', name: 'GameWebView');

    if (!_isClosing && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          developer.log('Попытка обновить очки в dispose', name: 'GameWebView');
          final pointsCubit = context.read<GamePointsCubit>();
          pointsCubit.refreshPoints();
        } catch (e, stackTrace) {
          developer.log(
            'Ошибка в dispose: $e\nStack trace: $stackTrace',
            name: 'GameWebView',
            error: e,
            stackTrace: stackTrace,
          );
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
