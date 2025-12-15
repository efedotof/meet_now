// user_ui_models.dart
import 'package:meet_now_app_server/model/auth/user/user.dart';

enum UsersFilter { all, active, inactive, premium, blocked }

enum UserSort { newest, oldest, mostActive, leastActive, nameAZ, nameZA }

class UsersStats {
  final int totalUsers;
  final int activeUsers;
  final int newUsers;
  final int premiumUsers;
  final int blockedUsers;

  const UsersStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.newUsers,
    required this.premiumUsers,
    required this.blockedUsers,
  });

  factory UsersStats.empty() => const UsersStats(
    totalUsers: 0,
    activeUsers: 0,
    newUsers: 0,
    premiumUsers: 0,
    blockedUsers: 0,
  );

  factory UsersStats.fromUsers(List<User> users) {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    return UsersStats(
      totalUsers: users.length,
      activeUsers: users.where((user) => user.isOnline).length,
      newUsers: users
          .where((user) => user.createdAt.isAfter(thirtyDaysAgo))
          .length,
      premiumUsers: users.where((user) => user.isPremium).length,
      blockedUsers: users.where((user) => user.isBlocked == true).length,
    );
  }
}

extension UserExtensions on User {
  String get displayName {
    if (firstname != null && subname != null) {
      return '$firstname $subname';
    } else if (firstname != null) {
      return firstname!;
    } else if (subname != null) {
      return subname!;
    } else {
      return username;
    }
  }

  bool get isPremium => roles.contains('premium');
  bool get isAdmin => roles.contains('admin');
  bool get isModerator => roles.contains('moderator');

  String get status {
    if (isBlocked == true) return 'Blocked';
    if (!isOnline) return 'Offline';
    return 'Online';
  }
}
