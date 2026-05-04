import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'package:meet_now_app_server/model/chats/continue_chat_proposal_response_dto/continue_chat_proposal_response_dto.dart';
import 'package:meet_now_app_server/model/chats/continue_chat_response_dto/continue_chat_response_dto.dart';
import 'package:meet_now_app_server/repository/message/paginated_messages_response.dart';
import 'package:meet_now_app_server/storage/rsa_keys/crypto_service.dart';
import 'package:meet_now_app_server/storage/rsa_keys/rsa_encryption_service.dart';
import 'package:meet_now_app_server/storage/rsa_keys/rsa_keys_interface.dart';
import 'package:cryptography/cryptography.dart';
part 'chat_message_state.dart';
part 'chat_message_cubit.freezed.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  StreamSubscription<List<Message>>? _messagesSubscription;
  StreamSubscription<Message>? _singleMessageSubscription;
  StreamSubscription<PaginatedMessagesResponse>? _paginatedMessagesSubscription;
  StreamSubscription<AgreeChatResponse>? _chatAgreeNotificationSubscription;
  StreamSubscription<AgreeChatResponse>? _chatAgreeResponseSubscription;
  StreamSubscription<AgreeChatResponse>? _chatPermanentCreatedSubscription;

  StreamSubscription<ContinueChatProposalResponseDto>?
  _continueChatProposalSubscription;
  StreamSubscription<ContinueChatResponseDto>?
  _continueChatResponseSubscription;

  final MessageInterface _messageInterface;
  final FriendInterface _friendInterface;
  final UploadImageInterface _uploadImageInterface;
  final SocketServiceInterface _socketInterface;
  final ChatInterface _chatInterface;
  final UserInterface _userInterface;
  final RsaEncryptionService _rsaEncryptionService;
  final RsaKeysInterface _rsaKeys;

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

  bool _friendRequestSent = false;

  final Map<String, String> _tempIdToRealId = {};
  final Map<String, String> _otherUserPublicKeys = {};

  final Map<String, SecretKey> _chatAesKeys = {};
  SecretKey? _currentChatAesKey;

  ChatMessageCubit({
    required UserInterface userInterface,
    required ChatInterface chatInterface,
    required UploadImageInterface uploadImageInterface,
    required SocketServiceInterface socketInterface,
    required FriendInterface friendInterface,
    required MessageInterface messageInterface,
    required RsaEncryptionService rsaEncryptionService,
    required RsaKeysInterface rsaKeys,
  }) : _rsaEncryptionService = rsaEncryptionService,
       _rsaKeys = rsaKeys,
       _userInterface = userInterface,
       _chatInterface = chatInterface,
       _socketInterface = socketInterface,
       _uploadImageInterface = uploadImageInterface,
       _friendInterface = friendInterface,
       _messageInterface = messageInterface,
       super(const ChatMessageState.initial()) {
    _setupChatSubscriptions();
  }

  Future<void> setChatEncryptedAesKey(String encryptedAesKey) async {
    if (encryptedAesKey.isEmpty) {
      return;
    }

    if (_currentChatId != null && _chatAesKeys.containsKey(_currentChatId)) {
      _currentChatAesKey = _chatAesKeys[_currentChatId];

      return;
    }

    try {
      final myPrivateKey = await _rsaKeys.getMyDecryptedPrivateKey();
      if (myPrivateKey == null) {
        return;
      }

      final decryptedBase64Key = await _rsaEncryptionService.rsaDecrypt(
        encryptedAesKey,
        myPrivateKey,
      );
      final keyBytes = base64Decode(decryptedBase64Key);
      final aesKey = SecretKey(keyBytes);

      if (_currentChatId != null) {
        _chatAesKeys[_currentChatId!] = aesKey;
        _currentChatAesKey = aesKey;
      }
    } catch (_) {}
  }

  Future<String> _encryptWithChatAes(String plainText) async {
    if (_currentChatAesKey == null) {
      throw Exception('AES-ключ чата не установлен');
    }
    final cryptoService = CryptoService();
    return await cryptoService.encrypt(plainText, _currentChatAesKey!);
  }

  Future<String> _decryptWithChatAes(String cipherText) async {
    if (_currentChatAesKey == null) {
      throw Exception('AES-ключ чата не установлен');
    }
    final cryptoService = CryptoService();
    return await cryptoService.decrypt(cipherText, _currentChatAesKey!);
  }

  void _setupChatSubscriptions() {
    _chatAgreeNotificationSubscription = _socketInterface
        .chatAgreeNotificationStream
        .listen(_handleChatAgreeNotification);
    _chatAgreeResponseSubscription = _socketInterface.chatAgreeResponseStream
        .listen(_handleChatAgreeResponse);
    _chatPermanentCreatedSubscription = _socketInterface
        .chatPermanentCreatedStream
        .listen(_handleChatPermanentCreated);
    _continueChatProposalSubscription = _socketInterface
        .continueChatProposalStream
        .listen(_handleContinueChatProposal);
    _continueChatResponseSubscription = _socketInterface
        .continueChatResponseStream
        .listen(_handleContinueChatResponse);
  }

  void _handleContinueChatProposal(ContinueChatProposalResponseDto proposal) {
    if (proposal.tempChatId == _currentChatId) {
      state.maybeMap(
        loaded: (state) {
          emit(
            state.copyWith(
              showContinueProposal: true,
              continueChatProposal: proposal,
              isWaitingForResponse: false,
            ),
          );
        },
        orElse: () {
          emit(
            ChatMessageState.loaded(
              messages: [],
              isTemporary: _isTemporary!,
              showContinueProposal: true,
              continueChatProposal: proposal,
              isWaitingForResponse: false,
            ),
          );
        },
      );
    }
  }

  void _handleContinueChatResponse(ContinueChatResponseDto response) {
    if (response.tempChatId == _currentChatId) {
      if (response.accepted && response.permanentChatCreated == true) {
        _handleSuccessfulAgreement(response);
      } else {
        state.maybeMap(
          loaded: (state) {
            emit(
              state.copyWith(
                showContinueProposal: false,
                isWaitingForResponse: false,
                continueChatProposal: null,
              ),
            );
          },
          orElse: () {},
        );
      }
    }
  }

  void initialize({
    required BuildContext context,
    required bool isTemporary,
    required String chatId,
    required String senderId,
    required String recipientId,
    String? encryptedAesKey,
  }) {
    if (_currentChatId == chatId &&
        _senderId == senderId &&
        _recipientId == recipientId &&
        _isTemporary == isTemporary) {
      return;
    }
    _friendRequestSent = false;
    _isTemporary = isTemporary;
    _currentChatId = chatId;
    _senderId = senderId;
    _recipientId = recipientId;
    _tempIdToRealId.clear();

    _currentChatAesKey = null;

    _resetPagination();
    _disposeSubscriptions();
    emit(const ChatMessageState.loading());

    try {
      if (encryptedAesKey != null && encryptedAesKey.isNotEmpty) {
        setChatEncryptedAesKey(encryptedAesKey);
      }

      _messagesSubscription = _messageInterface.messagesStream.listen(
        (messages) async => await _handleMessagesBatch(messages),
        onError: (e) {
          if (!isClosed) {
            emit(ChatMessageState.error('Failed to load messages: $e'));
          }
        },
        cancelOnError: false,
      );

      _paginatedMessagesSubscription = _messageInterface.paginatedMessagesStream
          .listen(
            (response) async => await _handlePaginatedMessages(response),
            onError: (e) {
              if (!isClosed) {
                emit(ChatMessageState.error('Failed to load messages: $e'));
              }
            },
            cancelOnError: false,
          );

      _singleMessageSubscription = _messageInterface.singleMessageStream.listen(
        (message) async => await _handleSingleMessage(message),
        onError: (e) {
          _reconnectMessageSubscriptions();
        },
        cancelOnError: false,
      );

      _setupChatSubscriptions();
      _loadInitialMessages();
      if (_currentChatId != null) {
        _messageInterface.requestMessages(_currentChatId!);
      }
      _startMarkAsReadTimer();
    } catch (e) {
      if (!isClosed) emit(ChatMessageState.error('Failed to initialize: $e'));
    }
  }

  Future<void> _handleMessagesBatch(List<Message> messages) async {
    if (messages.isEmpty) return;

    final firstMessage = messages.first;
    if (firstMessage.chatId != _currentChatId &&
        firstMessage.tempChatId != _currentChatId) {
      return;
    }

    final decryptedMessages = await Future.wait(
      messages.map(_decryptIncomingMessage),
    );

    if (!isClosed) {
      state.maybeMap(
        loaded: (state) {
          final existingIds =
              state.messages.map((m) => m.id).where((id) => id != null).toSet();
          final newMessages =
              decryptedMessages
                  .where((m) => !existingIds.contains(m.id))
                  .toList();

          if (newMessages.isNotEmpty) {
            final updatedMessages = [...state.messages, ...newMessages]..sort(
              (a, b) => (a.createdAt ?? DateTime.now()).compareTo(
                b.createdAt ?? DateTime.now(),
              ),
            );
            _collectUnreadMessagesIds(newMessages);
            emit(state.copyWith(messages: updatedMessages));
          }
        },
        orElse: () {
          _collectUnreadMessagesIds(decryptedMessages);
          emit(
            ChatMessageState.loaded(
              messages:
                  decryptedMessages..sort(
                    (a, b) => (a.createdAt ?? DateTime.now()).compareTo(
                      b.createdAt ?? DateTime.now(),
                    ),
                  ),
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

  Future<void> _handlePaginatedMessages(
    PaginatedMessagesResponse response,
  ) async {
    if (!isClosed) {
      final decryptedMessages = await Future.wait(
        response.messages.map(_decryptIncomingMessage),
      );

      state.maybeMap(
        loaded: (state) {
          List<Message> updatedMessages;
          if (response.currentPage == 0) {
            updatedMessages = decryptedMessages;
          } else {
            updatedMessages = [...decryptedMessages, ...state.messages];
          }
          updatedMessages.sort(
            (a, b) => (a.createdAt ?? DateTime.now()).compareTo(
              b.createdAt ?? DateTime.now(),
            ),
          );
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
          _collectUnreadMessagesIds(decryptedMessages);
          emit(
            ChatMessageState.loaded(
              messages: decryptedMessages,
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
    if (messages.isNotEmpty) markMessagesAsRead(messages);
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

  Future<void> _handleSingleMessage(Message newMessage) async {
    if (newMessage.chatId != _currentChatId &&
        newMessage.tempChatId != _currentChatId) {
      return;
    }

    final decryptedMessage = await _decryptIncomingMessage(newMessage);

    if (decryptedMessage.id != null) {
      _replaceTempMessageWithRealId(decryptedMessage);
    }

    if (decryptedMessage.senderId != _senderId && !decryptedMessage.read) {
      _messageInterface.markMessagesAsRead([decryptedMessage.id!]);
    }

    if (!isClosed) {
      state.maybeMap(
        loaded: (state) {
          final existingIndex = state.messages.indexWhere(
            (msg) =>
                msg.id == decryptedMessage.id ||
                (msg.tempId != null &&
                    _tempIdToRealId[msg.tempId] == decryptedMessage.id),
          );

          List<Message> updatedMessages;
          if (existingIndex != -1) {
            updatedMessages = List<Message>.from(state.messages);
            updatedMessages[existingIndex] = decryptedMessage;
          } else {
            updatedMessages = [...state.messages, decryptedMessage];
          }

          updatedMessages.sort(
            (a, b) => (a.createdAt ?? DateTime.now()).compareTo(
              b.createdAt ?? DateTime.now(),
            ),
          );

          if (decryptedMessage.senderId != _senderId &&
              !decryptedMessage.read) {
            if (decryptedMessage.id != null) {
              _unreadMessagesIds.add(decryptedMessage.id!);
            }
          }

          emit(state.copyWith(messages: updatedMessages));
        },
        orElse: () {
          emit(
            ChatMessageState.loaded(
              messages: [decryptedMessage],
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

  void _replaceTempMessageWithRealId(Message realMessage) {
    state.maybeMap(
      loaded: (state) {
        final tempIndex = state.messages.indexWhere(
          (msg) =>
              msg.tempId != null &&
              msg.senderId == realMessage.senderId &&
              msg.text == realMessage.text &&
              msg.createdAt != null &&
              realMessage.createdAt != null &&
              (realMessage.createdAt!.difference(msg.createdAt!).inSeconds)
                      .abs() <
                  5,
        );

        if (tempIndex != -1) {
          final tempMessage = state.messages[tempIndex];
          if (tempMessage.tempId != null) {
            _tempIdToRealId[tempMessage.tempId!] = realMessage.id!;
          }

          final updatedMessages = List<Message>.from(state.messages);
          updatedMessages[tempIndex] = realMessage;
          updatedMessages.sort(
            (a, b) => (a.createdAt ?? DateTime.now()).compareTo(
              b.createdAt ?? DateTime.now(),
            ),
          );
          emit(state.copyWith(messages: updatedMessages));
        }
      },
      orElse: () {},
    );
  }

  void _collectUnreadMessagesIds(List<Message> messages) {
    for (final message in messages) {
      if (message.senderId != _senderId &&
          !message.read &&
          message.id != null) {
        _unreadMessagesIds.add(message.id!);
      }
    }
  }

  void _startMarkAsReadTimer() {
    _markAsReadTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _sendMarkAsRead(),
    );
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
                  (message.id != null &&
                      _unreadMessagesIds.contains(message.id)),
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
      loaded: (state) => emit(state.copyWith(isLoadingMore: true)),
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
    return user.id.isNotEmpty ? user : null;
  }

  void _resetPagination() {
    _currentPage = 0;
    _hasMoreMessages = true;
    _isLoadingMore = false;
    _unreadMessagesIds.clear();
    _tempIdToRealId.clear();
    _markAsReadTimer?.cancel();
  }

  void _handleChatAgreeNotification(AgreeChatResponse response) {
    if (response.tempChatId == _currentChatId) {
      state.maybeMap(
        loaded:
            (state) => emit(
              state.copyWith(
                showContinueProposal: true,
                agreeChatResponse: response,
              ),
            ),
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

  void _handleSuccessfulAgreement(dynamic response) {
    _isTemporary = false;
    if (response is ContinueChatResponseDto) {
      _currentChatId = response.permanentChat.chatId;
    } else if (response is AgreeChatResponse &&
        response.permanentChat != null) {
      _currentChatId = response.permanentChat!.chatId;
    }

    if (!_friendRequestSent && _recipientId != null) {
      _sendFriendRequestSilently();
      _friendRequestSent = true;
    }

    state.maybeMap(
      loaded:
          (state) => emit(
            state.copyWith(
              showContinueProposal: false,
              isTemporary: false,
              isWaitingForResponse: false,
              continueChatProposal: null,
            ),
          ),
      orElse: () {},
    );
  }

  Future<void> _sendFriendRequestSilently() async {
    if (_recipientId == null || _recipientId!.isEmpty) return;
    try {
      await _friendInterface.sendFriendRequest(toUserId: _recipientId!);
    } catch (_) {}
  }

  void _handleAgreementError(AgreeChatResponse response) {
    state.maybeMap(
      loaded:
          (state) => emit(
            state.copyWith(
              showContinueProposal: false,
              isWaitingForResponse: false,
              agreeChatResponse: response,
            ),
          ),
      orElse: () {},
    );
  }

  void sendContinueProposal(String message) {
    if (_currentChatId == null || _isTemporary == false || _senderId == null) {
      return;
    }

    _socketInterface.proposeContinueChat(_currentChatId!, _senderId!, message);
    state.maybeMap(
      loaded:
          (state) => emit(
            state.copyWith(
              showContinueProposal: false,
              isWaitingForResponse: true,
              continueChatProposal: null,
            ),
          ),
      orElse: () {},
    );
  }

  void respondToContinueProposal(bool accepted) {
    if (_currentChatId == null || _senderId == null) return;

    _socketInterface.respondToContinueChat(
      _currentChatId!,
      _senderId!,
      accepted,
    );
    state.maybeMap(
      loaded:
          (state) => emit(
            state.copyWith(
              showContinueProposal: false,
              isWaitingForResponse: false,
              continueChatProposal: null,
            ),
          ),
      orElse: () {},
    );
  }

  void hideContinueProposal() {
    state.maybeMap(
      loaded:
          (state) => emit(
            state.copyWith(
              showContinueProposal: false,
              isWaitingForResponse: false,
              continueChatProposal: null,
            ),
          ),
      orElse: () {},
    );
  }

  void sendStickerMessage(Sticker sticker) {
    if (_senderId == null || _recipientId == null || _isTemporary == null) {
      return;
    }

    final tempId =
        'temp_sticker_${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().hashCode}';
    final message = Message(
      id: null,
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
          giftId: null,
          gift: null,
        ),
      ],
      tempId: tempId,
      isSending: true,
    );

    state.maybeMap(
      loaded: (state) {
        final updatedMessages = [...state.messages, message]..sort(
          (a, b) => (a.createdAt ?? DateTime.now()).compareTo(
            b.createdAt ?? DateTime.now(),
          ),
        );
        emit(state.copyWith(messages: updatedMessages));

        final sendMessage = message.toSendMessage();
        final cleanedMedia =
            sendMessage.media
                .map((media) => media.copyWith(giftId: null, gift: null))
                .toList();
        _messageInterface.sendMessage(
          sendMessage.copyWith(media: cleanedMedia),
        );
      },
      orElse: () {
        emit(
          ChatMessageState.loaded(
            messages: [message],
            isTemporary: _isTemporary!,
          ),
        );
        final sendMessage = message.toSendMessage();
        final cleanedMedia =
            sendMessage.media
                .map((media) => media.copyWith(giftId: null, gift: null))
                .toList();
        _messageInterface.sendMessage(
          sendMessage.copyWith(media: cleanedMedia),
        );
      },
    );
  }

  void sendTextMessage(String text) async {
    if (text.isEmpty) return;
    if (_senderId == null ||
        _recipientId == null ||
        _isTemporary == null ||
        _currentChatId == null) {
      return;
    }

    final tempId =
        'temp_text_${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().hashCode}';

    final localMessage = Message(
      id: null,
      senderId: _senderId!,
      recipientId: _recipientId!,
      text: text,
      createdAt: DateTime.now(),
      chatId: _isTemporary! ? null : _currentChatId,
      tempChatId: _isTemporary! ? _currentChatId : null,
      read: false,
      contentType: 'text',
      media: [],
      tempId: tempId,
      isSending: true,
    );

    state.maybeMap(
      loaded: (state) {
        final updatedMessages = [...state.messages, localMessage]..sort(
          (a, b) => (a.createdAt ?? DateTime.now()).compareTo(
            b.createdAt ?? DateTime.now(),
          ),
        );
        emit(state.copyWith(messages: updatedMessages));
      },
      orElse: () {
        emit(
          ChatMessageState.loaded(
            messages: [localMessage],
            isTemporary: _isTemporary!,
          ),
        );
      },
    );

    try {
      if (!_isTemporary! && _currentChatAesKey != null) {
        final encryptedText = await _encryptWithChatAes(text);
        final sendMessage = localMessage.toSendMessage().copyWith(
          text: encryptedText,
        );
        _messageInterface.sendMessage(sendMessage);
      } else {
        final recipientPublicKey = await _getRecipientPublicKey(_recipientId!);
        if (recipientPublicKey == null) {
          _updateMessageWithError(
            tempId,
            'Не удалось получить публичный ключ получателя',
          );
          return;
        }
        final encryptedText = await _rsaEncryptionService.encryptWithPublicKey(
          text,
          recipientPublicKey,
        );
        final sendMessage = localMessage.toSendMessage().copyWith(
          text: encryptedText,
        );
        _messageInterface.sendMessage(sendMessage);
      }
    } catch (e) {
      _updateMessageWithError(tempId, e.toString());
    }
  }

  void sendMediaMessage(List<MediaItem> mediaItems, {String text = ''}) {
    if (mediaItems.isEmpty) return;
    if (_senderId == null ||
        _senderId!.isEmpty ||
        _recipientId == null ||
        _recipientId!.isEmpty ||
        _isTemporary == null ||
        _currentChatId == null) {
      return;
    }

    final tempId =
        'temp_media_${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().hashCode}';

    final tempMessage = Message(
      id: null,
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
                  id: null,
                  contentType: _mapMediaTypeToContentType(mediaItem.type),
                  mimeType: mediaItem.type,
                  fileSize: mediaItem.size,
                  mediaUrl: null,
                  thumbnailUrl: null,
                  sortOrder: mediaItems.indexOf(mediaItem),
                ),
              )
              .toList(),
      tempId: tempId,
      isSending: true,
    );

    state.maybeMap(
      loaded:
          (state) =>
              emit(state.copyWith(messages: [...state.messages, tempMessage])),
      orElse:
          () => emit(
            ChatMessageState.loaded(
              messages: [tempMessage],
              isTemporary: _isTemporary!,
            ),
          ),
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
        _updateMessageWithError(
          tempMessage.tempId!,
          'Не удалось загрузить ${failedUploads.length} файлов',
        );
        return;
      }

      String finalText = text;
      if (text.isNotEmpty) {
        if (!_isTemporary! && _currentChatAesKey != null) {
          finalText = await _encryptWithChatAes(text);
        } else {
          final recipientPublicKey = await _getRecipientPublicKey(
            _recipientId!,
          );
          if (recipientPublicKey == null) {
            _updateMessageWithError(
              tempMessage.tempId!,
              'Не удалось получить публичный ключ получателя',
            );
            return;
          }
          try {
            finalText = await _rsaEncryptionService.encryptWithPublicKey(
              text,
              recipientPublicKey,
            );
          } catch (e) {
            _updateMessageWithError(
              tempMessage.tempId!,
              'Ошибка шифрования: $e',
            );
            return;
          }
        }
      }

      final finalMessage = Message(
        id: null,
        senderId: _senderId!,
        recipientId: _recipientId!,
        text: finalText,
        createdAt: DateTime.now(),
        chatId: _isTemporary! ? null : _currentChatId,
        tempChatId: _isTemporary! ? _currentChatId : null,
        read: false,
        contentType: _determineContentType(mediaItems),
        media: uploadedMedia,
      );

      _messageInterface.sendMessage(finalMessage.toSendMessage());
    } catch (e) {
      if (!isClosed) _updateMessageWithError(tempMessage.tempId!, e.toString());
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

  void _updateMessageWithError(String tempId, String error) {
    state.maybeMap(
      loaded: (state) {
        final updatedMessages =
            state.messages.map((message) {
              if (message.tempId == tempId) {
                return message.copyWith(error: error, isSending: false);
              }
              return message;
            }).toList();
        emit(state.copyWith(messages: updatedMessages));
      },
      orElse: () {},
    );
  }

  String _determineContentType(List<MediaItem> mediaItems) =>
      mediaItems.length == 1
          ? _mapMediaTypeToContentType(mediaItems.first.type)
          : 'file';

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
    } catch (_) {}
  }

  Future<String?> _generateVideoThumbnail(
    MediaItem videoItem,
    String videoUrl,
  ) async => null;

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

    _messagesSubscription = _messageInterface.messagesStream.listen(
      (messages) async => await _handleMessagesBatch(messages),
      onError: (e) {
        Future.delayed(const Duration(seconds: 3), () {
          if (!isClosed) _reconnectMessageSubscriptions();
        });
      },
      cancelOnError: false,
    );

    _paginatedMessagesSubscription = _messageInterface.paginatedMessagesStream
        .listen(
          (response) async => await _handlePaginatedMessages(response),
          onError: (e) {
            Future.delayed(const Duration(seconds: 3), () {
              if (!isClosed) _reconnectMessageSubscriptions();
            });
          },
          cancelOnError: false,
        );

    _singleMessageSubscription = _messageInterface.singleMessageStream.listen(
      (message) async => await _handleSingleMessage(message),
      onError: (e) {
        Future.delayed(const Duration(seconds: 3), () {
          if (!isClosed) _reconnectMessageSubscriptions();
        });
      },
      cancelOnError: false,
    );

    if (_currentChatId != null) {
      _loadInitialMessages();
      _messageInterface.requestMessages(_currentChatId!);
    }
  }

  void sendGiftMessage(Gift gift) {
    if (_senderId == null || _recipientId == null || _isTemporary == null) {
      return;
    }

    final tempId =
        'temp_gift_${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().hashCode}';
    final message = Message(
      id: null,
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
      tempId: tempId,
      isSending: true,
    );

    state.maybeMap(
      loaded: (state) {
        final updatedMessages = [...state.messages, message]..sort(
          (a, b) => (a.createdAt ?? DateTime.now()).compareTo(
            b.createdAt ?? DateTime.now(),
          ),
        );
        emit(state.copyWith(messages: updatedMessages));
        _messageInterface.sendMessage(message.toSendMessage());
      },
      orElse: () => _messageInterface.sendMessage(message.toSendMessage()),
    );
  }

  void _disposeMessageSubscriptions() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    _paginatedMessagesSubscription?.cancel();
    _paginatedMessagesSubscription = null;
    _singleMessageSubscription?.cancel();
    _singleMessageSubscription = null;
  }

  void _disposeSubscriptions() {
    _disposeMessageSubscriptions();
    _chatAgreeNotificationSubscription?.cancel();
    _chatAgreeNotificationSubscription = null;
    _chatAgreeResponseSubscription?.cancel();
    _chatAgreeResponseSubscription = null;
    _chatPermanentCreatedSubscription?.cancel();
    _chatPermanentCreatedSubscription = null;
    _continueChatProposalSubscription?.cancel();
    _continueChatProposalSubscription = null;
    _continueChatResponseSubscription?.cancel();
    _continueChatResponseSubscription = null;
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
    } catch (_) {}
  }

  void updateMessageSendingStatus(
    String tempId,
    bool isSending, {
    String? error,
  }) {
    state.maybeMap(
      loaded: (state) {
        final updatedMessages =
            state.messages.map((message) {
              if (message.tempId == tempId) {
                return message.copyWith(isSending: isSending, error: error);
              }
              return message;
            }).toList();
        emit(state.copyWith(messages: updatedMessages));
      },
      orElse: () {},
    );
  }

  Future<String?> _getRecipientPublicKey(String userId) async {
    if (_otherUserPublicKeys.containsKey(userId)) {
      return _otherUserPublicKeys[userId];
    }
    final user = await getOtherUser(otherUser: userId);
    if (user != null && user.publicKey != null && user.publicKey!.isNotEmpty) {
      _otherUserPublicKeys[userId] = user.publicKey!;
      return user.publicKey;
    }

    return null;
  }

  Future<Message> _decryptIncomingMessage(Message message) async {
    if (!_isTemporary! && _currentChatAesKey != null) {
      if (message.contentType == 'text' && message.text.isNotEmpty) {
        try {
          final decryptedText = await _decryptWithChatAes(message.text);

          return message.copyWith(text: decryptedText);
        } catch (e) {
          return message.copyWith(text: '[Ошибка расшифровки]');
        }
      }
      return message;
    }

    if (message.contentType != 'text') {
      return message;
    }

    if (message.recipientId != _senderId) {
      return message;
    }

    if (message.text.isEmpty) return message;

    final isEnc = _isEncrypted(message.text);

    if (!isEnc) return message;

    try {
      final myPrivateKey = await _rsaKeys.getMyDecryptedPrivateKey();
      if (myPrivateKey == null) {
        return message.copyWith(text: '[Зашифровано]');
      }
      final decryptedText = await _rsaEncryptionService.decryptWithPrivateKey(
        message.text,
        myPrivateKey,
      );

      return message.copyWith(text: decryptedText);
    } catch (e) {
      return message.copyWith(text: '[Ошибка расшифровки]');
    }
  }

  bool _isEncrypted(String text) {
    try {
      final json = jsonDecode(text) as Map;
      final hasEncKey = json.containsKey('encryptedAesKey');
      final hasEncData = json.containsKey('encryptedData');

      return hasEncKey && hasEncData;
    } catch (e) {
      return false;
    }
  }
}
