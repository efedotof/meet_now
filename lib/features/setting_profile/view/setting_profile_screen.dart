// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'package:meet_now_app/features/chat_message/cubit/media_selection/media_selection_cubit.dart';
import 'package:meet_now_app/features/setting_profile/cubit/setting_profile_cubit.dart';
import 'package:meet_now_app/features/setting_profile/widget/widget.dart';
import 'package:meet_now_app/features/settings/widget/widget.dart';
import 'package:meet_now_app/generated/l10n.dart';

@RoutePage()
class SettingProfileScreen extends StatefulWidget {
  final User user;

  const SettingProfileScreen({super.key, required this.user});

  @override
  State<SettingProfileScreen> createState() => _SettingProfileScreenState();
}

class _SettingProfileScreenState extends State<SettingProfileScreen> {
  final TextEditingController _interestController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  late final MediaSelectionCubit _mediaSelectionCubit;

  @override
  void initState() {
    super.initState();
    _mediaSelectionCubit = MediaSelectionCubit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingProfileCubit>().initialize(widget.user);
    });
  }

  void _showInterestsSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => InterestsSearchDialog(
            selectedInterests:
                context.read<SettingProfileCubit>().state.interests,
            onInterestsUpdated: (interests) {
              final cubit = context.read<SettingProfileCubit>();
              final currentInterests = cubit.state.interests.toList();

              for (final interest in currentInterests) {
                cubit.removeInterest(interest);
              }
              for (final interest in interests) {
                cubit.addInterest(interest);
              }
            },
          ),
    );
  }

  void _showPurposesSearchDialog() {
    showDialog(
      context: context,
      builder:
          (context) => PurposesSearchDialog(
            selectedPurposes:
                context.read<SettingProfileCubit>().state.purposes,
            onPurposesUpdated: (purposes) {
              final cubit = context.read<SettingProfileCubit>();
              final currentPurposes = cubit.state.purposes.toList();

              for (final purpose in currentPurposes) {
                cubit.removePurpose(purpose);
              }

              for (final purpose in purposes) {
                cubit.addPurpose(purpose);
              }
            },
          ),
    );
  }

  void _saveProfile() {
    context.read<SettingProfileCubit>().updateProfile();
  }

  void _changePassword() {
    context.read<SettingProfileCubit>()
      ..updateOldPassword(_oldPasswordController.text)
      ..updateNewPassword(_newPasswordController.text)
      ..changePassword();
  }

  void _showMediaPickerBottomSheet() {
    _mediaSelectionCubit.setPickerOpen(true);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => MediaPickerBottomSheet(
            initialSelection: _mediaSelectionCubit.state.selectedMedia,
            maxSelection: 1,
            allowMultiple: false,
            showVideos: false,
            initialChildSize: 0.7,
            minChildSize: 0.4,
            showSelectionIndicators: true,
            maxChildSize: 0.9,
            onSelectionChanged: (selectedItems) {
              _mediaSelectionCubit.clearMedia();
              _mediaSelectionCubit.addMedia(selectedItems);
            },
            onConfirmed: (selectedItems) {
              _mediaSelectionCubit.clearMedia();
              _mediaSelectionCubit.addMedia(selectedItems);
              _mediaSelectionCubit.setPickerOpen(false);

              if (selectedItems.isNotEmpty) {
                final selectedMedia = selectedItems.first;
                _handleAvatarSelection(selectedMedia);
              }

              debugPrint('Avatar selection: ${selectedItems.length} items');
            },
          ),
    ).whenComplete(() {
      _mediaSelectionCubit.setPickerOpen(false);
    });
  }

  void _handleAvatarSelection(MediaItem selectedMedia) {
    final cubit = context.read<SettingProfileCubit>();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const CircularProgressIndicator(strokeWidth: 2),
            const SizedBox(width: 16),
            Text(S.of(context).uploadingavatar),
          ],
        ),
        duration: const Duration(seconds: 5),
      ),
    );

    cubit
        .uploadAvatar(selectedMedia.uri)
        .then((_) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).avatarupdatedsuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${S.of(context).avataruploadfailed}: $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }

  @override
  void dispose() {
    _interestController.dispose();
    _purposeController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _mediaSelectionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider.value(
      value: _mediaSelectionCubit,
      child: BlocListener<SettingProfileCubit, SettingProfileState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).profileupdatedsuccessfully)),
            );
            context.read<SettingProfileCubit>().clearSuccess();
            context.maybePop();
          }

          if (state.isPasswordChanged) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).passwordchangedsuccessfully),
              ),
            );
            context.read<SettingProfileCubit>().clearSuccess();
            _oldPasswordController.clear();
            _newPasswordController.clear();
          }

          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
            context.read<SettingProfileCubit>().clearError();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).editProfile),
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.maybePop(),
            ),
            actions: [
              BlocBuilder<SettingProfileCubit, SettingProfileState>(
                builder: (context, state) {
                  return IconButton(
                    icon:
                        state.isLoading
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.check),
                    onPressed: state.isLoading ? null : _saveProfile,
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<SettingProfileCubit, SettingProfileState>(
            builder: (context, state) {
              if (state.isLoading && state.user == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          if (state.tempAvatarData != null)
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(
                                state.tempAvatarData!,
                              ),
                            )
                          else
                            UserAvatar(
                              radius: 60,
                              avatarKey:
                                  state.user?.avatar ??
                                  widget.user.avatar ??
                                  '',
                            ),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? Colors.black : Colors.white,
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed: _showMediaPickerBottomSheet,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: TextEditingController(
                                text: state.username,
                              ),
                              onChanged:
                                  (value) => context
                                      .read<SettingProfileCubit>()
                                      .updateUsername(value),
                              decoration: InputDecoration(
                                labelText: S.of(context).username,
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: TextEditingController(
                                text: state.firstname,
                              ),
                              onChanged:
                                  (value) => context
                                      .read<SettingProfileCubit>()
                                      .updateFirstname(value),
                              decoration: InputDecoration(
                                labelText: S.of(context).firstName,
                                prefixIcon: const Icon(Icons.badge_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: TextEditingController(
                                text: state.subname,
                              ),
                              onChanged:
                                  (value) => context
                                      .read<SettingProfileCubit>()
                                      .updateSubname(value),
                              decoration: InputDecoration(
                                labelText: S.of(context).lastName,
                                prefixIcon: const Icon(Icons.badge),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: TextEditingController(
                                text: state.city,
                              ),
                              onChanged:
                                  (value) => context
                                      .read<SettingProfileCubit>()
                                      .updateCity(value),
                              decoration: InputDecoration(
                                labelText: S.of(context).city,
                                prefixIcon: const Icon(
                                  Icons.location_on_outlined,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: TextEditingController(
                                text: state.age,
                              ),
                              onChanged:
                                  (value) => context
                                      .read<SettingProfileCubit>()
                                      .updateAge(value),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: S.of(context).age,
                                prefixIcon: const Icon(Icons.cake_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: TextEditingController(
                                text: state.description,
                              ),
                              onChanged:
                                  (value) => context
                                      .read<SettingProfileCubit>()
                                      .updateDescription(value),
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: S.of(context).aboutMe,
                                prefixIcon: const Icon(
                                  Icons.description_outlined,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: Text(S.of(context).visibleInSearch),
                              subtitle: Text(
                                S.of(context).visibleInSearchDescription,
                              ),
                              value: state.isSearchable,
                              onChanged:
                                  (value) => context
                                      .read<SettingProfileCubit>()
                                      .updateIsSearchable(value),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  S.of(context).myInterests,
                                  style: theme.textTheme.titleLarge,
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: _showInterestsSearchDialog,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  state.interests
                                      .map(
                                        (interest) => Chip(
                                          label: Text(interest),
                                          onDeleted:
                                              () => context
                                                  .read<SettingProfileCubit>()
                                                  .removeInterest(interest),
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            size: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            if (state.interests.isEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                S.of(context).nointerestsadded,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  S.of(context).datingGoals,
                                  style: theme.textTheme.titleLarge,
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: _showPurposesSearchDialog,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  state.purposes
                                      .map(
                                        (purpose) => Chip(
                                          label: Text(purpose),
                                          onDeleted:
                                              () => context
                                                  .read<SettingProfileCubit>()
                                                  .removePurpose(purpose),
                                          deleteIcon: const Icon(
                                            Icons.close,
                                            size: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                            if (state.purposes.isEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                S.of(context).nopurposesadded,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).changepassword,
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _oldPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: S.of(context).oldpassword,
                                prefixIcon: const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _newPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: S.of(context).newpassword,
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _changePassword,
                                child: Text(S.of(context).changepassword),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
