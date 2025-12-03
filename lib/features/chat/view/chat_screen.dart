import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/chat/cubit/chat_cubit.dart';
import 'package:meet_now_app/features/chat/widget/chat_type.dart';
import 'package:meet_now_app/features/chat/widget/widget.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/repository/chat/chat_interface.dart';
import 'package:meet_now_app_server/repository/socket/socket_service_interface.dart';
import 'package:meet_now_app_server/repository/user_model_app/user_model_app_interface.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create:
          (_) => ChatCubit(
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
            final chatTypes = [
              (ChatType.all, "Все"),
              (ChatType.permanent, "Постоянные"),
              (ChatType.temporary, "Временные"),
            ];
            return Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 0,
                surfaceTintColor: Colors.transparent,
                actions: [
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 12,
                  //     vertical: 6,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: isDark ? Colors.white : Colors.black,
                  //     borderRadius: BorderRadius.circular(30),
                  //   ),
                  //   child: Text(
                  //     'Select',
                  //     style: TextStyle(
                  //       color: isDark ? Colors.black : Colors.white,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500,
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 15),
                  RawMaterialButton(
                    fillColor: isDark ? Colors.white : Colors.black,
                    onPressed: () => context.pushRoute(FriendsRoute()),
                    elevation: 2.0,
                    shape: const CircleBorder(),
                    constraints: const BoxConstraints(minWidth: 0.0),
                    child: Icon(
                      Icons.add,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),

              body: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchField(controller: _searchController),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      children:
                          chatTypes.map((type) {
                            return ChoiceChip(
                              label: Text(type.$2),
                              selected: state.selectedChatType == type.$1,
                              onSelected: (selected) {
                                if (selected) {
                                  context.read<ChatCubit>().changeChatType(
                                    type.$1,
                                  );
                                }
                              },
                            );
                          }).toList(),
                    ),

                    const SizedBox(height: 10),

                    MyBody(state: state),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
