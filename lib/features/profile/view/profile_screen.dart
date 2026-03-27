import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_now_app/features/profile/widget/widget.dart';
import 'package:meet_now_app/features/settings/cubit/settings_cubit.dart';
import 'package:meet_now_app/features/settings/cubit/user_date_cubit.dart';
import 'package:meet_now_app/generated/l10n.dart';
import 'package:meet_now_app/route/app_route.dart';
import 'package:meet_now_app_server/meet_now_app_server.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    this.friendRequest,
    this.otherUser,
    this.userId,
  });
  final FriendRequest? friendRequest;
  final User? otherUser;
  final String? userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with WidgetsBindingObserver {
  bool _isMobileLayout = false;
  static const double mobileBreakpoint = 768;

  User? _loadedUser;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayout();
    });

    if (widget.userId != null &&
        widget.otherUser == null &&
        widget.friendRequest == null) {
      _loadUser();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (mounted) {
      _checkLayout();
    }
  }

  void _checkLayout() {
    final double width = MediaQuery.of(context).size.width;
    final bool newIsMobileLayout = width < mobileBreakpoint;

    if (mounted && _isMobileLayout != newIsMobileLayout) {
      setState(() {
        _isMobileLayout = newIsMobileLayout;
      });
    }
  }

  Future<void> _loadUser() async {
    if (widget.userId == null) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = await context.read<UserInterface>().getOtherUser(
        userId: widget.userId!,
      );
      if (mounted) {
        setState(() {
          _loadedUser = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = S.of(context).userUploadError;
          _isLoading = false;
        });
      }
    }
  }

  User? getUser(BuildContext context) {
    if (_loadedUser != null) return _loadedUser;
    if (widget.friendRequest != null) return widget.friendRequest!.toUser();
    if (widget.otherUser != null) return widget.otherUser!;
    return context.read<UserModelAppInterface>().user;
  }

  bool _isCurrentUser(BuildContext context) {
    final displayedUser = getUser(context);
    final currentUser = context.read<UserModelAppInterface>().user;
    if (displayedUser == null || currentUser == null) return false;
    return displayedUser.id == currentUser.id;
  }

  Future<void> _refreshData() async {
    if (widget.userId != null &&
        widget.otherUser == null &&
        widget.friendRequest == null &&
        _loadedUser != null) {
      await _loadUser();
    } else {
      await context.read<UserDateCubit>().refreshUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLayout();
    });

    bool isDesktopPlatform = false;
    if (!kIsWeb) {
      isDesktopPlatform =
          Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    }

    final bool useDesktopLayout =
        (kIsWeb || isDesktopPlatform) && !_isMobileLayout;

    final theme = Theme.of(context);
    final userModel = getUser(context);

    final bool showSkeleton = _isLoading || userModel == null;

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
              onRefresh: _refreshData,
              child: SafeArea(
                child: Stack(
                  children: [
                    if (_error != null)
                      Center(
                        child: Text(
                          _error!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else if (showSkeleton)
                      const ProfileSkeleton()
                    else
                      SingleChildScrollView(
                        padding:
                            useDesktopLayout
                                ? const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 12,
                                )
                                : const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                        child:
                            useDesktopLayout
                                ? Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 500,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(height: 30),
                                        ProfileHeader(user: userModel),
                                        const SizedBox(height: 10),
                                        PersonalInfo(
                                          theme: theme,
                                          user: userModel,
                                        ),
                                        const SizedBox(height: 16),
                                        InterestsSection(
                                          theme: theme,
                                          user: userModel,
                                        ),
                                        const SizedBox(height: 16),
                                        PurposesSection(
                                          theme: theme,
                                          user: userModel,
                                        ),
                                        const SizedBox(height: 16),
                                        if (userModel.images != null &&
                                            userModel.images!.isNotEmpty &&
                                            !_isCurrentUser(context)) ...[
                                          UserPhotosSection(
                                            images: userModel.images!,
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ],
                                    ),
                                  ),
                                )
                                : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 30),
                                    ProfileHeader(user: userModel),
                                    const SizedBox(height: 10),
                                    PersonalInfo(theme: theme, user: userModel),
                                    const SizedBox(height: 16),
                                    InterestsSection(
                                      theme: theme,
                                      user: userModel,
                                    ),
                                    const SizedBox(height: 16),
                                    PurposesSection(
                                      theme: theme,
                                      user: userModel,
                                    ),
                                    const SizedBox(height: 16),

                                    UserPhotosSection(
                                      images: userModel.images ?? [],
                                      showAddButton: _isCurrentUser(context),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                      ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Material(
                        color: Colors.black87,
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

                    if (_isCurrentUser(context))
                      Positioned(
                        right: 12,
                        top: 12,
                        child: Material(
                          color: Colors.black87,
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

extension FriendRequestToUser on FriendRequest {
  User toUser() {
    return User(
      id: id,
      username: username,
      firstname: firstname,
      subname: subname,
      description: description,
      avatar: avatar,
      city: city,
      age: age,
      purposes: purposes,
      interests: interests,
      verified: verified,
      roles: roles,
      isOnline: isOnline,
      floor: floor,
      friends: friends,
      createdAt: createdAt,
      isSearchable: isSearchable,
      email: '',
      gamePoints: 0,
      isBlocked: false,
      blockReason: null,
    );
  }
}
