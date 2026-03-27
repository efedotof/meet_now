import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_ui_package/media_ui_package.dart';
import 'package:meet_now_app/features/settings/cubit/user_date_cubit.dart';
import 'package:meet_now_app/features/settings/widget/user_avatar.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'package:meet_now_app/features/chat_message/cubit/media_selection/media_selection_cubit.dart';
import 'package:meet_now_app/features/setting_profile/cubit/setting_profile_cubit.dart';
import 'package:meet_now_app/features/setting_profile/widget/widget.dart';
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
  late TextEditingController _usernameController;
  late TextEditingController _firstnameController;
  late TextEditingController _subnameController;
  late TextEditingController _cityController;
  late TextEditingController _ageController;
  late TextEditingController _descriptionController;

  late final MediaSelectionCubit _mediaSelectionCubit;
  final DeviceMediaLibrary mediaLibrary = DeviceMediaLibrary();

  bool _controllersInitialized = false;
  bool _shouldUpdateUserData = false;

  bool get isWeb => kIsWeb;
  bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  bool get isWebOrDesktop => isWeb || isDesktop;

  @override
  void initState() {
    super.initState();
    _mediaSelectionCubit = MediaSelectionCubit();

    _usernameController = TextEditingController();
    _firstnameController = TextEditingController();
    _subnameController = TextEditingController();
    _cityController = TextEditingController();
    _ageController = TextEditingController();
    _descriptionController = TextEditingController();

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

  Future<void> _showMediaPickerBottomSheet() async {
    if (isWebOrDesktop) {
      final List<MapEntry<MediaItem, Uint8List?>>? filesWithBytes =
          await showDialog<List<MapEntry<MediaItem, Uint8List?>>>(
            context: context,
            builder:
                (context) => Dialog(
                  insetPadding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: min(500, MediaQuery.of(context).size.width * 0.9),
                    height: min(500, MediaQuery.of(context).size.height * 0.9),
                    child: MediaPickerWidget(
                      initialSelection: const [],
                      maxSelection: 1,
                      allowMultiple: false,
                      showVideos: false,
                      onConfirmed: (
                        List<MapEntry<MediaItem, Uint8List?>> selectedFiles,
                      ) {
                        Navigator.of(context).pop(selectedFiles);
                      },
                      enableDragDrop: true,
                      config: const MediaPickerConfig(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload, size: 64),
                              const SizedBox(height: 16),
                              Text(
                                S.of(context).choose_an_avatar,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(S.of(context).dragAndDropTheFilesHere),
                              Text(S.of(context).orClickTheButton),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  final pickerState =
                                      context
                                          .findAncestorStateOfType<
                                            MediaPickerWidgetState
                                          >();
                                  pickerState?.pickFiles();
                                },
                                child: Text(S.of(context).selectAFile),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          );

      if (filesWithBytes != null && filesWithBytes.isNotEmpty) {
        final firstEntry = filesWithBytes.first;
        final firstItem = firstEntry.key;
        var bytes = firstEntry.value;

        if (bytes == null || bytes.isEmpty) {
          bytes = await _readFileBytes(firstItem.uri);
        }

        if (bytes != null && bytes.isNotEmpty) {
          final mediaItems = filesWithBytes.map((e) => e.key).toList();
          _mediaSelectionCubit.clearMedia();
          _mediaSelectionCubit.addMedia(mediaItems);

          await _handleAvatarSelection(firstItem.uri, bytes);
        } else {
          if (!mounted) return;
          _showErrorSnackBar(S.of(context).couldntGetFileData);
        }
      }
    } else {
      await MediaPickerBottomSheet.open(
        context: context,
        initialSelection: _mediaSelectionCubit.state.selectedMedia,
        maxSelection: 1,
        allowMultiple: false,
        showVideos: false,
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        showSelectionIndicators: true,
        config: const MediaPickerConfig(),
        mediaLibrary: mediaLibrary,
        onConfirmed: (medias) {
          Navigator.pop(context);
        },
        onSelectionChanged: (selectedItems) {
          _mediaSelectionCubit.clearMedia();
          _mediaSelectionCubit.addMedia(selectedItems);
        },
        onConfirmedWithBytes: (selectedItemsWithBytes) async {
          if (selectedItemsWithBytes.isEmpty) {
            return;
          }

          final firstEntry = selectedItemsWithBytes.first;
          final firstItem = firstEntry.key;
          final bytes = firstEntry.value;

          final mediaItems = selectedItemsWithBytes.map((e) => e.key).toList();
          _mediaSelectionCubit.clearMedia();
          _mediaSelectionCubit.addMedia(mediaItems);

          if (bytes != null && bytes.isNotEmpty) {
            await _handleAvatarSelection(firstItem.uri, bytes);
          } else {
            _showErrorSnackBar(S.of(context).couldntGetFileData);
          }
        },
      );
    }
  }

  Future<Uint8List?> _readFileBytes(String uri) async {
    try {
      if (uri.startsWith('data:')) {
        final base64Data = uri.split(',').last;

        return Uint8List.fromList(base64Decode(base64Data));
      }

      if (uri.startsWith('file://')) {
        final filePath = Uri.parse(uri).toFilePath(windows: Platform.isWindows);
        final file = File(filePath);
        if (await file.exists()) {
          return await file.readAsBytes();
        }
      }

      if (!uri.startsWith('http')) {
        final file = File(uri);
        if (await file.exists()) {
          return await file.readAsBytes();
        }
      }
    } catch (_) {}

    return null;
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleAvatarSelection(String uri, Uint8List bytes) async {
    if (!mounted) return;

    final cubit = context.read<SettingProfileCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    scaffoldMessenger.showSnackBar(
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

    try {
      await cubit.uploadAvatar(bytes);

      if (!mounted) return;

      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(S.of(context).avatarupdatedsuccessfully),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      scaffoldMessenger.hideCurrentSnackBar();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('${S.of(context).avataruploadfailed}: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateUserData() async {
    if (!mounted) return;

    try {
      await context.read<UserDateCubit>().refreshUser();
      _shouldUpdateUserData = false;
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${S.of(context).userDataUpdateFailed}: $e'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _handlePostFrameUpdate() {
    if (_shouldUpdateUserData && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateUserData();
        }
      });
    }
  }

  @override
  void dispose() {
    _interestController.dispose();
    _purposeController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _usernameController.dispose();
    _firstnameController.dispose();
    _subnameController.dispose();
    _cityController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    _mediaSelectionCubit.close();

    _handlePostFrameUpdate();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider.value(
      value: _mediaSelectionCubit,
      child: BlocListener<SettingProfileCubit, SettingProfileState>(
        listener: (context, state) {
          if (!_controllersInitialized && state.user != null) {
            _usernameController.text = state.username;
            _firstnameController.text = state.firstname;
            _subnameController.text = state.subname;
            _cityController.text = state.city;
            _ageController.text = state.age;
            _descriptionController.text = state.description;
            _controllersInitialized = true;
          }

          if (_controllersInitialized) {
            if (_usernameController.text != state.username &&
                !_usernameController.selection.isValid) {
              _usernameController.text = state.username;
            }
            if (_firstnameController.text != state.firstname &&
                !_firstnameController.selection.isValid) {
              _firstnameController.text = state.firstname;
            }
            if (_subnameController.text != state.subname &&
                !_subnameController.selection.isValid) {
              _subnameController.text = state.subname;
            }
            if (_cityController.text != state.city &&
                !_cityController.selection.isValid) {
              _cityController.text = state.city;
            }
            if (_ageController.text != state.age &&
                !_ageController.selection.isValid) {
              _ageController.text = state.age;
            }
            if (_descriptionController.text != state.description &&
                !_descriptionController.selection.isValid) {
              _descriptionController.text = state.description;
            }
          }

          if (state.isSuccess) {
            _shouldUpdateUserData = true;
            _handlePostFrameUpdate();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).profileupdatedsuccessfully),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<SettingProfileCubit>().clearSuccess();
              context.maybePop();
            }
          }

          if (state.isPasswordChanged) {
            _shouldUpdateUserData = true;
            _handlePostFrameUpdate();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(S.of(context).passwordchangedsuccessfully),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<SettingProfileCubit>().clearSuccess();
              _oldPasswordController.clear();
              _newPasswordController.clear();
            }
          }

          if (state.errorMessage != null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
              context.read<SettingProfileCubit>().clearError();
            }
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
              final isMobile = screenWidth < 600;

              return SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 16 : 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isMobile ? double.infinity : 600,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              if (state.tempAvatarData != null)
                                CircleAvatar(
                                  radius: isMobile ? 60 : 70,
                                  backgroundImage: MemoryImage(
                                    state.tempAvatarData!,
                                  ),
                                )
                              else
                                UserAvatar(
                                  radius: isMobile ? 60 : 70,
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
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: isMobile ? 20 : 24,
                                    color:
                                        Theme.brightnessOf(context) ==
                                                Brightness.dark
                                            ? Colors.black
                                            : Colors.white,
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
                            borderRadius: BorderRadius.circular(
                              isMobile ? 16 : 20,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 16 : 20),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _usernameController,
                                  onChanged:
                                      (value) => context
                                          .read<SettingProfileCubit>()
                                          .updateUsername(value),
                                  decoration: InputDecoration(
                                    labelText: S.of(context).username,
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        isMobile ? 12 : 16,
                                      ),
                                    ),
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _firstnameController,
                                  onChanged:
                                      (value) => context
                                          .read<SettingProfileCubit>()
                                          .updateFirstname(value),
                                  decoration: InputDecoration(
                                    labelText: S.of(context).firstName,
                                    prefixIcon: const Icon(
                                      Icons.badge_outlined,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        isMobile ? 12 : 16,
                                      ),
                                    ),
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _subnameController,
                                  onChanged:
                                      (value) => context
                                          .read<SettingProfileCubit>()
                                          .updateSubname(value),
                                  decoration: InputDecoration(
                                    labelText: S.of(context).lastName,
                                    prefixIcon: const Icon(Icons.badge),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        isMobile ? 12 : 16,
                                      ),
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
                            borderRadius: BorderRadius.circular(
                              isMobile ? 16 : 20,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 16 : 20),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _cityController,
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
                                      borderRadius: BorderRadius.circular(
                                        isMobile ? 12 : 16,
                                      ),
                                    ),
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _ageController,
                                  onChanged:
                                      (value) => context
                                          .read<SettingProfileCubit>()
                                          .updateAge(value),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).age,
                                    prefixIcon: const Icon(Icons.cake_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        isMobile ? 12 : 16,
                                      ),
                                    ),
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _descriptionController,
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
                                      borderRadius: BorderRadius.circular(
                                        isMobile ? 12 : 16,
                                      ),
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
                            borderRadius: BorderRadius.circular(
                              isMobile ? 16 : 20,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 16 : 20),
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
                            borderRadius: BorderRadius.circular(
                              isMobile ? 16 : 20,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 16 : 20),
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
                                                      .read<
                                                        SettingProfileCubit
                                                      >()
                                                      .removeInterest(interest),
                                              deleteIcon: const Icon(
                                                Icons.close,
                                                size: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                            borderRadius: BorderRadius.circular(
                              isMobile ? 16 : 20,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 16 : 20),
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
                                                      .read<
                                                        SettingProfileCubit
                                                      >()
                                                      .removePurpose(purpose),
                                              deleteIcon: const Icon(
                                                Icons.close,
                                                size: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
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
                            borderRadius: BorderRadius.circular(
                              isMobile ? 16 : 20,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 16 : 20),
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
                                      borderRadius: BorderRadius.circular(
                                        isMobile ? 12 : 16,
                                      ),
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
                                      borderRadius: BorderRadius.circular(
                                        isMobile ? 12 : 16,
                                      ),
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
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
