import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'package:meet_now_app_server/repository/message/paginated_messages_response.dart';

part 'chat_message_state.dart';
part 'chat_message_cubit.freezed.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  StreamSubscription<List<Message>>? _messagesSubscription;
  StreamSubscription<Message>? _singleMessageSubscription;
  StreamSubscription<PaginatedMessagesResponse>? _paginatedMessagesSubscription;
  StreamSubscription<AgreeChatResponse>? _chatAgreeNotificationSubscription;
  StreamSubscription<AgreeChatResponse>? _chatAgreeResponseSubscription;
  StreamSubscription<AgreeChatResponse>? _chatPermanentCreatedSubscription;

  final MessageInterface _messageInterface;
  final FriendInterface _friendInterface;
  final UploadImageInterface _uploadImageInterface;
  final SocketServiceInterface _socketInterface;
  final ChatInterface _chatInterface;
  final UserInterface _userInterface;

  String? _currentChatId;
  String? _senderId;
  String? _recipientId;
  bool? _isTemporary;

  final int _pageSize = 20;
  bool _isLoadingMore = false;
  bool _hasMoreMessages = true;
  int _currentPage = 0;

  final List<String> _unreadMessagesIds = [];
  Timer? _markAsReadTimer;

  ChatMessageCubit({
    required UserInterface userInterface,
    required ChatInterface chatInterface,
    required UploadImageInterface uploadImageInterface,
    required SocketServiceInterface socketInterface,
    required GamesInterface gamesInterface,
    required FriendInterface friendInterface,
    required MessageInterface messageInterface,
  }) : _userInterface = userInterface,
       _chatInterface = chatInterface,
       _socketInterface = socketInterface,
       _uploadImageInterface = uploadImageInterface,
       _friendInterface = friendInterface,
       _messageInterface = messageInterface,
       super(const ChatMessageState.initial()) {
    _setupChatAgreeSubscriptions();
  }

  void initialize({
    required BuildContext context,
    required bool isTemporary,
    required String chatId,
    required String senderId,
    required String recipientId,
  }) {
    if (_currentChatId == chatId) {
      return;
    }

    _isTemporary = isTemporary;
    _currentChatId = chatId;
    _senderId = senderId;
    _recipientId = recipientId;

    _resetPagination();

    _disposeSubscriptions();
    emit(const ChatMessageState.loading());

    try {
      _paginatedMessagesSubscription = _messageInterface.paginatedMessagesStream
          .listen(
            _handlePaginatedMessages,
            onError: (e) {
              if (!isClosed) {
                emit(ChatMessageState.error('Failed to load messages: $e'));
              }
            },
            cancelOnError: false,
          );

      _singleMessageSubscription = _messageInterface.singleMessageStream.listen(
        _handleSingleMessage,
        onError: (e) {
          _reconnectMessageSubscriptions();
        },
        cancelOnError: false,
      );

      _loadInitialMessages();

      _startMarkAsReadTimer();
    } catch (e) {
      if (!isClosed) {
        emit(ChatMessageState.error('Failed to initialize: $e'));
      }
    }
  }

  void _handlePaginatedMessages(PaginatedMessagesResponse response) {
    if (!isClosed) {
      state.maybeMap(
        loaded: (state) {
          List<Message> updatedMessages;

          if (response.currentPage == 0) {
            updatedMessages = response.messages;
          } else {
            updatedMessages = [...response.messages, ...state.messages];
          }

          _collectUnreadMessagesIds(updatedMessages);

          emit(
            state.copyWith(
              messages: updatedMessages,
              hasMore: response.hasNext,
              currentPage: response.currentPage,
              isLoadingMore: false,
            ),
          );
        },
        orElse: () {
          _collectUnreadMessagesIds(response.messages);

          emit(
            ChatMessageState.loaded(
              messages: response.messages,
              isTemporary: _isTemporary!,
              hasMore: response.hasNext,
              currentPage: response.currentPage,
              isLoadingMore: false,
            ),
          );
        },
      );
    }
  }

  void markMessagesAsReadByIds(List<String> messageIds) {
    final messages = _getMessagesByIds(messageIds);
    if (messages.isNotEmpty) {
      markMessagesAsRead(messages);
    }
  }

  List<Message> _getMessagesByIds(List<String> messageIds) {
    return state.maybeMap(
      loaded:
          (state) =>
              state.messages
                  .where(
                    (message) =>
                        message.id != null && messageIds.contains(message.id),
                  )
                  .toList(),
      orElse: () => [],
    );
  }

  void _handleSingleMessage(Message newMessage) {
    if (newMessage.chatId != _currentChatId &&
        newMessage.tempChatId != _currentChatId) {
      return;
    }

    if (newMessage.senderId != _senderId && !newMessage.read) {
      _messageInterface.markMessagesAsRead([newMessage.id!]);
    }

    if (!isClosed) {
      state.maybeMap(
        loaded: (state) {
          final existingIndex = state.messages.indexWhere(
            (msg) => msg.id == newMessage.id,
          );

          List<Message> updatedMessages;
          if (existingIndex != -1) {
            updatedMessages = List<Message>.from(state.messages);
            updatedMessages[existingIndex] = newMessage;
          } else {
            updatedMessages = [...state.messages, newMessage];
          }

          if (newMessage.senderId != _senderId && !newMessage.read) {
            _unreadMessagesIds.add(newMessage.id!);
          }

          emit(state.copyWith(messages: updatedMessages));
        },
        orElse: () {
          emit(
            ChatMessageState.loaded(
              messages: [newMessage],
              isTemporary: _isTemporary!,
              hasMore: false,
              currentPage: 0,
              isLoadingMore: false,
            ),
          );
        },
      );
    }
  }

  void _collectUnreadMessagesIds(List<Message> messages) {
    for (final message in messages) {
      if (message.senderId != _senderId && !message.read) {
        _unreadMessagesIds.add(message.id!);
      }
    }
  }

  void _startMarkAsReadTimer() {
    _markAsReadTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _sendMarkAsRead();
    });
  }

  void _sendMarkAsRead() {
    if (_unreadMessagesIds.isNotEmpty) {
      final idsToMark = List<String>.from(_unreadMessagesIds);
      _unreadMessagesIds.clear();

      _messageInterface.markMessagesAsRead(idsToMark);
    }
  }

  void markMessagesAsRead(List<Message> messages) {
    final unreadMessages =
        messages
            .where(
              (message) =>
                  (message.senderId != _senderId && !message.read) ||
                  _unreadMessagesIds.contains(message.id),
            )
            .map((message) => message.id)
            .where((id) => id != null)
            .cast<String>()
            .toList();

    if (unreadMessages.isNotEmpty) {
      _messageInterface.markMessagesAsRead(unreadMessages);

      _unreadMessagesIds.removeWhere((id) => unreadMessages.contains(id));

      state.maybeMap(
        loaded: (state) {
          final updatedMessages =
              state.messages.map((message) {
                if (unreadMessages.contains(message.id)) {
                  return message.copyWith(read: true);
                }
                return message;
              }).toList();

          emit(state.copyWith(messages: updatedMessages));
        },
        orElse: () {},
      );
    }
  }

  void _loadInitialMessages() {
    if (_currentChatId == null) return;

    _currentPage = 0;
    _hasMoreMessages = true;

    _messageInterface.requestPaginatedMessages(
      _currentChatId!,
      _currentPage,
      _pageSize,
    );
  }

  void loadMoreMessages() {
    if (_currentChatId == null ||
        !_hasMoreMessages ||
        _isLoadingMore ||
        state.maybeMap(loaded: (s) => s.isLoadingMore, orElse: () => false)) {
      return;
    }

    _isLoadingMore = true;

    state.maybeMap(
      loaded: (state) {
        emit(state.copyWith(isLoadingMore: true));
      },
      orElse: () {},
    );

    final nextPage = _currentPage + 1;
    _messageInterface.requestPaginatedMessages(
      _currentChatId!,
      nextPage,
      _pageSize,
    );
  }

  Future<User?> getOtherUser({required String otherUser}) async {
    final user = await _userInterface.getOtherUser(userId: otherUser);

    if (user.id != "") {
      return user;
    } else {
      return null;
    }
  }

  void _resetPagination() {
    _currentPage = 0;
    _hasMoreMessages = true;
    _isLoadingMore = false;
    _unreadMessagesIds.clear();
    _markAsReadTimer?.cancel();
  }

  void _setupChatAgreeSubscriptions() {
    _chatAgreeNotificationSubscription = _socketInterface
        .chatAgreeNotificationStream
        .listen(_handleChatAgreeNotification);
    _chatAgreeResponseSubscription = _socketInterface.chatAgreeResponseStream
        .listen(_handleChatAgreeResponse);
    _chatPermanentCreatedSubscription = _socketInterface
        .chatPermanentCreatedStream
        .listen(_handleChatPermanentCreated);
  }

  void _handleChatAgreeNotification(AgreeChatResponse response) {
    if (response.tempChatId == _currentChatId) {
      state.maybeMap(
        loaded: (state) {
          emit(
            state.copyWith(
              showContinueRequest: true,
              agreeChatResponse: response,
            ),
          );
        },
        orElse: () {},
      );
    }
  }

  void _handleChatAgreeResponse(AgreeChatResponse response) {
    if (response.tempChatId == _currentChatId) {
      if (response.bothAgreed == true &&
          response.permanentChatCreated == true) {
        _handleSuccessfulAgreement(response);
      } else if (response.errorMessage != null) {
        _handleAgreementError(response);
      }
    }
  }

  void _handleChatPermanentCreated(AgreeChatResponse response) {
    if (response.tempChatId == _currentChatId &&
        response.permanentChatCreated == true) {
      _handleSuccessfulAgreement(response);
    }
  }

  void _handleSuccessfulAgreement(AgreeChatResponse response) {
    _isTemporary = false;
    _currentChatId = response.permanentChat?.chatId;

    state.maybeMap(
      loaded: (state) {
        emit(
          state.copyWith(
            showContinueRequest: false,
            isTemporary: false,
            agreeChatResponse: response,
          ),
        );
      },
      orElse: () {},
    );
  }

  void _handleAgreementError(AgreeChatResponse response) {
    state.maybeMap(
      loaded: (state) {
        emit(
          state.copyWith(
            showContinueRequest: false,
            isWaitingForResponse: false,
            agreeChatResponse: response,
          ),
        );
      },
      orElse: () {},
    );
  }

  void sendContinueRequest() {
    if (_currentChatId == null || _isTemporary == false) return;
    _socketInterface.agreeToContinue(_currentChatId!);

    state.maybeMap(
      loaded: (state) {
        emit(
          state.copyWith(
            showContinueRequest: false,
            isWaitingForResponse: true,
          ),
        );
      },
      orElse: () {},
    );
  }

  void respondToContinueRequest(bool agree) {
    if (_currentChatId == null) return;

    if (agree) {
      _socketInterface.agreeToContinue(_currentChatId!);
    }

    state.maybeMap(
      loaded: (state) {
        emit(
          state.copyWith(
            showContinueRequest: false,
            isWaitingForResponse: false,
          ),
        );
      },
      orElse: () {},
    );
  }

  void hideContinueRequest() {
    state.maybeMap(
      loaded: (state) {
        emit(
          state.copyWith(
            showContinueRequest: false,
            isWaitingForResponse: false,
          ),
        );
      },
      orElse: () {},
    );
  }

  void sendStickerMessage(Sticker sticker) {
    if (_senderId == null || _recipientId == null || _isTemporary == null) {
      return;
    }

    final message = Message(
      senderId: _senderId!,
      recipientId: _recipientId!,
      text: "",
      createdAt: DateTime.now(),
      chatId: _isTemporary! ? null : _currentChatId,
      tempChatId: _isTemporary! ? _currentChatId : null,
      read: false,
      contentType: 'sticker',
      media: [
        MessageMedia(
          contentType: 'sticker',
          stickerId: sticker.id,
          mediaUrl: sticker.imageUrl,
          mimeType: 'image/jpeg',
          fileSize: 0,
          sortOrder: 0,
        ),
      ],
    );

    state.maybeMap(
      loaded: (state) {
        final optimisticMessage = message.copyWith(createdAt: DateTime.now());
        emit(state.copyWith(messages: [...state.messages, optimisticMessage]));
        _messageInterface.sendMessage(message);
      },
      orElse: () => _messageInterface.sendMessage(message),
    );
  }

  void sendTextMessage(String text) {
    if (text.isEmpty) return;
    if (_senderId == null || _recipientId == null || _isTemporary == null) {
      return;
    }

    final message = Message(
      senderId: _senderId!,
      recipientId: _recipientId!,
      text: text,
      createdAt: DateTime.now(),
      chatId: _isTemporary! ? null : _currentChatId,
      tempChatId: _isTemporary! ? _currentChatId : null,
      read: false,
      contentType: 'text',
      media: [],
    );

    state.maybeMap(
      loaded: (state) {
        final optimisticMessage = message.copyWith(createdAt: DateTime.now());
        emit(state.copyWith(messages: [...state.messages, optimisticMessage]));
        _messageInterface.sendMessage(message);
      },
      orElse: () => _messageInterface.sendMessage(message),
    );
  }

  void sendMediaMessage(List<MediaItem> mediaItems, {String text = ''}) {
    if (mediaItems.isEmpty) return;
    if (_senderId == null || _recipientId == null || _isTemporary == null) {
      return;
    }

    final tempMessage = Message(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      senderId: _senderId!,
      recipientId: _recipientId!,
      text: text,
      createdAt: DateTime.now(),
      chatId: _isTemporary! ? null : _currentChatId,
      tempChatId: _isTemporary! ? _currentChatId : null,
      read: false,
      contentType: _determineContentType(mediaItems),
      media:
          mediaItems
              .map(
                (mediaItem) => MessageMedia(
                  id:
                      'temp_media_${DateTime.now().millisecondsSinceEpoch}_${mediaItems.indexOf(mediaItem)}',
                  contentType: _mapMediaTypeToContentType(mediaItem.type),
                  mimeType: mediaItem.type,
                  fileSize: mediaItem.size,
                  mediaUrl: null,
                  thumbnailUrl: null,
                  sortOrder: mediaItems.indexOf(mediaItem),
                ),
              )
              .toList(),
    );

    state.maybeMap(
      loaded: (state) {
        emit(state.copyWith(messages: [...state.messages, tempMessage]));
      },
      orElse: () {
        emit(
          ChatMessageState.loaded(
            messages: [tempMessage],
            isTemporary: _isTemporary!,
          ),
        );
      },
    );

    _uploadAndSendMediaMessage(mediaItems, tempMessage, text);
  }

  Future<void> _uploadAndSendMediaMessage(
    List<MediaItem> mediaItems,
    Message tempMessage,
    String text,
  ) async {
    if (_senderId == null || _recipientId == null || _isTemporary == null) {
      return;
    }

    try {
      final uploadedMedia = await _uploadMediaFiles(mediaItems);

      final failedUploads =
          uploadedMedia.where((media) => media.mediaUrl == null).toList();
      if (failedUploads.isNotEmpty && !isClosed) {
        _updateTempMessageWithError(
          tempMessage.id!,
          'Не удалось загрузить ${failedUploads.length} файлов',
        );
        return;
      }

      final finalMessage = Message(
        senderId: _senderId!,
        recipientId: _recipientId!,
        text: text,
        createdAt: DateTime.now(),
        chatId: _isTemporary! ? null : _currentChatId,
        tempChatId: _isTemporary! ? _currentChatId : null,
        read: false,
        contentType: _determineContentType(mediaItems),
        media: uploadedMedia,
      );

      try {
        _messageInterface.sendMessage(finalMessage);
        if (!isClosed) {
          _replaceTempMessage(tempMessage.id!, finalMessage);
        }
      } catch (e) {
        if (!isClosed) {
          _updateTempMessageWithError(
            tempMessage.id!,
            'Failed to send message: $e',
          );
        }
      }
    } catch (e) {
      if (!isClosed) {
        _updateTempMessageWithError(tempMessage.id!, e.toString());
      }
    }
  }

  Future<List<MessageMedia>> _uploadMediaFiles(
    List<MediaItem> mediaItems,
  ) async {
    final uploadedMedia = <MessageMedia>[];

    try {
      final uris = mediaItems.map((item) => item.uri).toList();

      final fileUrls = await _uploadImageInterface.uploadMultipleMedia(uris);

      for (int i = 0; i < mediaItems.length; i++) {
        final mediaItem = mediaItems[i];
        final mediaUrl = i < fileUrls.length ? fileUrls[i] : '';

        if (mediaUrl.isNotEmpty) {
          String? thumbnailUrl;
          if (mediaItem.type == 'video') {
            thumbnailUrl = await _generateVideoThumbnail(mediaItem, mediaUrl);
          }

          uploadedMedia.add(
            MessageMedia(
              contentType: _mapMediaTypeToContentType(mediaItem.type),
              mediaUrl: mediaUrl,
              thumbnailUrl: thumbnailUrl,
              fileSize: mediaItem.size,
              mimeType: mediaItem.type,
              sortOrder: i,
            ),
          );
        } else {
          uploadedMedia.add(
            MessageMedia(
              contentType: _mapMediaTypeToContentType(mediaItem.type),
              mediaUrl: null,
              fileSize: mediaItem.size,
              mimeType: mediaItem.type,
              sortOrder: i,
            ),
          );
        }
      }
    } catch (e) {
      for (int i = 0; i < mediaItems.length; i++) {
        final mediaItem = mediaItems[i];
        uploadedMedia.add(
          MessageMedia(
            contentType: _mapMediaTypeToContentType(mediaItem.type),
            mediaUrl: null,
            fileSize: mediaItem.size,
            mimeType: mediaItem.type,
            sortOrder: i,
          ),
        );
      }
    }

    return uploadedMedia;
  }

  void _replaceTempMessage(String tempMessageId, Message finalMessage) {
    state.maybeMap(
      loaded: (state) {
        final updatedMessages =
            state.messages.map((message) {
              if (message.id == tempMessageId) {
                return finalMessage;
              }
              return message;
            }).toList();

        emit(state.copyWith(messages: updatedMessages));
      },
      orElse: () {
        emit(
          ChatMessageState.loaded(
            messages: [finalMessage],
            isTemporary: _isTemporary!,
          ),
        );
      },
    );
  }

  void _updateTempMessageWithError(String tempMessageId, String error) {
    state.maybeMap(
      loaded: (state) {
        final updatedMessages =
            state.messages.map((message) {
              if (message.id == tempMessageId) {
                return message.copyWith(text: 'Ошибка загрузки: $error');
              }
              return message;
            }).toList();

        emit(state.copyWith(messages: updatedMessages));
      },
      orElse: () {},
    );
  }

  String _determineContentType(List<MediaItem> mediaItems) {
    if (mediaItems.length == 1) {
      return _mapMediaTypeToContentType(mediaItems.first.type);
    }
    return 'file';
  }

  String _mapMediaTypeToContentType(String mediaType) {
    switch (mediaType) {
      case 'image':
        return 'image';
      case 'video':
        return 'video';
      default:
        return 'file';
    }
  }

  Future<void> finishTempChat({required TemporaryChat? temporaryModel}) async {
    try {
      if (temporaryModel != null) {
        _chatInterface.finistTemporaryChat(tempChat: temporaryModel);
      }
    } catch (e) {
      //
    }
  }

  Future<String?> _generateVideoThumbnail(
    MediaItem videoItem,
    String videoUrl,
  ) async {
    return null;
  }

  void reconnect({
    required BuildContext context,
    required bool isTemporary,
    required String chatId,
    required String senderId,
    required String recipientId,
  }) {
    if (_currentChatId != null) {
      _disposeSubscriptions();
      emit(const ChatMessageState.loading());
      initialize(
        context: context,
        isTemporary: isTemporary,
        chatId: chatId,
        senderId: senderId,
        recipientId: recipientId,
      );
    }
  }

  void _reconnectMessageSubscriptions() {
    _disposeMessageSubscriptions();

    _paginatedMessagesSubscription = _messageInterface.paginatedMessagesStream
        .listen(
          _handlePaginatedMessages,
          onError: (e) {
            Future.delayed(const Duration(seconds: 3), () {
              if (!isClosed) _reconnectMessageSubscriptions();
            });
          },
          cancelOnError: false,
        );

    _singleMessageSubscription = _messageInterface.singleMessageStream.listen(
      _handleSingleMessage,
      onError: (e) {
        Future.delayed(const Duration(seconds: 3), () {
          if (!isClosed) _reconnectMessageSubscriptions();
        });
      },
      cancelOnError: false,
    );

    if (_currentChatId != null) {
      _loadInitialMessages();
    }
  }

  void sendGiftMessage(Gift gift) {
    if (_senderId == null || _recipientId == null || _isTemporary == null) {
      return;
    }

    final message = Message(
      senderId: _senderId!,
      recipientId: _recipientId!,
      text: '🎁 Подарок!',
      createdAt: DateTime.now(),
      chatId: _isTemporary! ? null : _currentChatId,
      tempChatId: _isTemporary! ? _currentChatId : null,
      read: false,
      contentType: 'gift',
      media: [],
      gift: gift,
    );

    state.maybeMap(
      loaded: (state) {
        final optimisticMessage = message.copyWith(createdAt: DateTime.now());

        emit(state.copyWith(messages: [...state.messages, optimisticMessage]));

        _messageInterface.sendMessage(message);
      },
      orElse: () {
        _messageInterface.sendMessage(message);
      },
    );
  }

  void _disposeMessageSubscriptions() {
    _paginatedMessagesSubscription?.cancel();
    _paginatedMessagesSubscription = null;
    _singleMessageSubscription?.cancel();
    _singleMessageSubscription = null;
  }

  void _disposeSubscriptions() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    _paginatedMessagesSubscription?.cancel();
    _paginatedMessagesSubscription = null;
    _singleMessageSubscription?.cancel();
    _singleMessageSubscription = null;
    _chatAgreeNotificationSubscription?.cancel();
    _chatAgreeNotificationSubscription = null;
    _chatAgreeResponseSubscription?.cancel();
    _chatAgreeResponseSubscription = null;
    _chatPermanentCreatedSubscription?.cancel();
    _chatPermanentCreatedSubscription = null;

    _markAsReadTimer?.cancel();
    _markAsReadTimer = null;
  }

  @override
  Future<void> close() {
    _sendMarkAsRead();
    _disposeSubscriptions();
    return super.close();
  }

  Future<void> friendRequest({
    required BuildContext context,
    required String toUserId,
  }) async {
    if (toUserId.isEmpty) return;

    try {
      await _friendInterface.sendFriendRequest(toUserId: toUserId);
    } catch (e) {
      //
    }
  }
}
