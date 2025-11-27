import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/profile/widget/widget.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.read<UserModelAppInterface>().user;

    return SkeletonTheme(
      shimmerGradient: const LinearGradient(
        colors: [Color(0xFFD8E3E7), Color(0xFFC8D5DA), Color(0xFFD8E3E7)],
        stops: [0.1, 0.5, 0.9],
      ),
      darkShimmerGradient: const LinearGradient(
        colors: [
          Color(0xFF222222),
          Color(0xFF242424),
          Color(0xFF2B2B2B),
          Color(0xFF242424),
          Color(0xFF222222),
        ],
        stops: [0.0, 0.2, 0.5, 0.8, 1],
        begin: Alignment(-2.4, -0.2),
        end: Alignment(2.4, 0.2),
        tileMode: TileMode.clamp,
      ),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () => context.read<SettingsCubit>().getCurrentUser(),
              child: SafeArea(
                child: Stack(
                  children: [
                    user == null
                        ? const ProfileSkeleton()
                        : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 10),
                              ProfileHeader(user: user),
                              const SizedBox(height: 20),
                              if (user.images != null &&
                                  user.images!.isNotEmpty) ...[
                                UserPhotosSection(images: user.images!),
                                const SizedBox(height: 20),
                              ],
                              ProfileStats(user: user),
                              const SizedBox(height: 20),
                              PersonalInfo(theme: theme, user: user),
                              const SizedBox(height: 16),
                              InterestsSection(theme: theme, user: user),
                              const SizedBox(height: 16),
                              PurposesSection(theme: theme, user: user),
                              const SizedBox(height: 16),
                              AccountInfoSection(theme: theme, user: user),
                              const SizedBox(height: 20),
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
                          onTap: () => context.maybePop(),
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

                    Positioned(
                      right: 12,
                      top: 12,
                      child: Material(
                        color: Colors.black54,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap:
                              () => context.pushRoute(
                                SettingProfileRoute(
                                  user:
                                      context
                                          .read<UserModelAppInterface>()
                                          .user!,
                                ),
                              ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
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
