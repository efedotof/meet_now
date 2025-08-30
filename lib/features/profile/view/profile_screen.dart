import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/profile/widget/widget.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.read<SettingsCubit>().userModelAppInterface.user!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myProfile),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.pushRoute(SettingProfileRoute(user: user)),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
    );
  }
}