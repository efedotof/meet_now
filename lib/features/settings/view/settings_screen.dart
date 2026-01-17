import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/game_chat/cubit/game_points_cubit.dart';
import 'package:meet_now_app/features/settings/cubit/user_date_cubit.dart';
import 'package:meet_now_app/features/settings/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserDateCubit>().loadUser();
      context.read<GamePointsCubit>().loadPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocConsumer<UserDateCubit, UserDateState>(
            listener: (context, state) {
              state.whenOrNull(
                error: (message, _) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.when(
                initial: () => Loading(),
                loading: () => Loading(),
                loaded:
                    (user) => SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<UserDateCubit>().refreshUser();
                          context.read<GamePointsCubit>().refreshPoints();
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              ProfileCard(user: user),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AccountSettingsSection(),
                                    const SizedBox(height: 24),

                                    AppSettingsSection(),
                                    const SizedBox(height: 24),

                                    AboutAppSection(),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Center(
                                  child: Text(
                                    S.of(context).version('1.0.0'),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                refreshing:
                    (previousUser) => Center(
                      child: Container(
                        color: Colors.black87,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                S.of(context).updating,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                error: (message, user) {
                  if (user != null) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).download_error,
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      message.length > 100
                                          ? '${message.substring(0, 100)}...'
                                          : message,
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  context.read<UserDateCubit>().refreshUser();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            S.of(context).profile_upload_error,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(color: Colors.red),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              context.read<UserDateCubit>().loadUser();
                            },
                            child: Text(S.of(context).try_again),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
          ),

          const AppBarWidget(),
        ],
      ),
    );
  }
}
