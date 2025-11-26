import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/profile/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/repository/user_model_app/user_model_app_interface.dart';
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
        appBar: AppBar(
          title: Text(S.of(context).myProfile),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed:
                  () => context.pushRoute(SettingProfileRoute(user: user!)),
            ),
          ],
        ),
        body:
            user == null
                ? const ProfileSkeleton()
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileHeader(user: user),
                      const SizedBox(height: 24),
                      if (user.images != null && user.images!.isNotEmpty) ...[
                        UserPhotosSection(images: user.images!),
                        const SizedBox(height: 24),
                      ],
                      ProfileStats(user: user),
                      const SizedBox(height: 24),
                      PersonalInfo(theme: theme, user: user),
                      const SizedBox(height: 24),
                      InterestsSection(theme: theme, user: user),
                      const SizedBox(height: 24),
                      PurposesSection(theme: theme, user: user),
                      const SizedBox(height: 24),
                      FriendsSection(theme: theme, user: user),
                      const SizedBox(height: 24),
                      AccountInfoSection(theme: theme, user: user),
                    ],
                  ),
                ),
      ),
    );
  }
}
