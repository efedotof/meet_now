import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app_server/repository/chat/chat_interface.dart';
import 'package:meet_now_app_server/repository/socket/socket_service_interface.dart';
import 'package:meet_now_app_server/repository/user_model_app/user_model_app_interface.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return BlocProvider(
      create:
          (context) => ChatCubit(
            socketServiceInterface: context.read<SocketServiceInterface>(),
            userModelAppInterface: context.read<UserModelAppInterface>(),
            chatInterface: context.read<ChatInterface>(),
          )..refresh(),
      child: SkeletonTheme(
        shimmerGradient: const LinearGradient(
          colors: [Color(0xFFE0E0E0), Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
        ),
        darkShimmerGradient: const LinearGradient(
          colors: [Color(0xFF2A2A2A), Color(0xFF3A3A3A), Color(0xFF2A2A2A)],
        ),
        child: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(l10n.chats),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: MyBody(state: state),
            );
          },
        ),
      ),
    );
  }
}
