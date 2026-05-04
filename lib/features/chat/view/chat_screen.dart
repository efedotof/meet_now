import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat/widget/desktop_layout.dart';
import 'package:meet_now_app/features/chat/widget/mobile_layout.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/model/chats/permanent_chat_response_dto/permanent_chat_response_dto.dart';
import 'package:meet_now_app_server/model/chats/temporary/temporary_chat.dart';
import 'package:meet_now_app_server/repository/chat/chat_interface.dart';
import 'package:meet_now_app_server/repository/socket/socket_service_interface.dart';
import 'package:meet_now_app_server/repository/user_model_app/user_model_app_interface.dart';
import 'package:skeletons_forked/skeletons_forked.dart';
import 'dart:io';
import 'package:meet_now_app_server/storage/rsa_keys/rsa_encryption_service.dart';
import 'package:meet_now_app_server/storage/rsa_keys/rsa_keys_interface.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  PermanentChatResponseDto? _selectedPermanentChat;
  TemporaryChat? _selectedTemporaryChat;
  bool _isMobileLayout = false;
  bool _wasDesktopLayout = false;
  bool _hasNavigatedForMobile = false;

  static const double mobileBreakpoint = 768;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayout(context);
      if (_refreshIndicatorKey.currentState?.mounted ?? false) {
        _refreshIndicatorKey.currentState?.show();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      _checkLayout(context);
    }
  }

  void _checkLayout(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool newIsMobileLayout = width < mobileBreakpoint;

    if (_isMobileLayout != newIsMobileLayout) {
      _hasNavigatedForMobile = false;
    }

    if (mounted) {
      setState(() {
        _wasDesktopLayout = !_isMobileLayout;
        _isMobileLayout = newIsMobileLayout;
      });
    }

    if (kIsWeb &&
        _wasDesktopLayout &&
        _isMobileLayout &&
        (_selectedPermanentChat != null || _selectedTemporaryChat != null) &&
        !_hasNavigatedForMobile) {
      _hasNavigatedForMobile = true;
      _navigateToChatMessage(context);
    }
  }

  void _navigateToChatMessage(BuildContext context) {
    if (_selectedPermanentChat != null) {
      context.read<ChatCubit>().openChat(
        chatId: _selectedPermanentChat!.chatId,
      );
      context.router.push(
        ChatMessageRoute(
          chatModel: _selectedPermanentChat,
          temporaryChatModel: null,
          chatKey: _selectedPermanentChat!.chatId,
        ),
      );
      _clearSelectedChat();
    } else if (_selectedTemporaryChat != null) {
      context.read<ChatCubit>().openTempChat(
        tempChatId: _selectedTemporaryChat!.tempChatId,
      );
      context.router.push(
        ChatMessageRoute(
          chatModel: null,
          temporaryChatModel: _selectedTemporaryChat,
          chatKey: _selectedTemporaryChat!.tempChatId,
        ),
      );
      _clearSelectedChat();
    }
  }

  void _selectChat({
    PermanentChatResponseDto? permanentChat,
    TemporaryChat? temporaryChat,
  }) {
    setState(() {
      _selectedPermanentChat = permanentChat;
      _selectedTemporaryChat = temporaryChat;
    });
  }

  void _clearSelectedChat() {
    setState(() {
      _selectedPermanentChat = null;
      _selectedTemporaryChat = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayout(context);
    });

    return BlocProvider(
      create:
          (_) => ChatCubit(
            socketServiceInterface: context.read<SocketServiceInterface>(),
            userModelAppInterface: context.read<UserModelAppInterface>(),
            chatInterface: context.read<ChatInterface>(),
            rsaEncryptionService: context.read<RsaEncryptionService>(),
            rsaKeys: context.read<RsaKeysInterface>(),
          )..refresh(),
      child: SkeletonTheme(
        shimmerGradient: const LinearGradient(
          colors: [Color(0xFFE0E0E0), Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
        ),
        darkShimmerGradient: const LinearGradient(
          colors: [Color(0xFF2A2A2A), Color(0xFF3A3A3A), Color(0xFF2A2A2A)],
        ),
        child: BlocConsumer<ChatCubit, ChatState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final chatCubit = context.read<ChatCubit>();

            bool isDesktopPlatform = false;
            if (!kIsWeb) {
              isDesktopPlatform =
                  Platform.isWindows || Platform.isMacOS || Platform.isLinux;
            }

            final bool showDesktopLayout =
                (kIsWeb || isDesktopPlatform) ? !_isMobileLayout : false;

            return showDesktopLayout
                ? DesktopLayout(
                  state: state,
                  selectedPermanentChat: _selectedPermanentChat,
                  selectedTemporaryChat: _selectedTemporaryChat,
                  selectChat: _selectChat,
                  clearSelectedChat: _clearSelectedChat,
                  searchController: _searchController,
                  refreshIndicatorKey: _refreshIndicatorKey,
                )
                : MobileLayout(
                  state: state,
                  isDark: isDark,
                  selectChat: ({permanentChat, temporaryChat}) {
                    if (permanentChat != null) {
                      chatCubit.openChat(chatId: permanentChat.chatId);
                      context.router.push(
                        ChatMessageRoute(
                          chatModel: permanentChat,
                          temporaryChatModel: null,
                          chatKey: permanentChat.chatId,
                        ),
                      );
                    } else if (temporaryChat != null) {
                      chatCubit.openTempChat(
                        tempChatId: temporaryChat.tempChatId,
                      );
                      context.router.push(
                        ChatMessageRoute(
                          chatModel: null,
                          temporaryChatModel: temporaryChat,
                          chatKey: temporaryChat.tempChatId,
                        ),
                      );
                    }
                  },
                  searchController: _searchController,
                  refreshIndicatorKey: _refreshIndicatorKey,
                );
          },
        ),
      ),
    );
  }
}
