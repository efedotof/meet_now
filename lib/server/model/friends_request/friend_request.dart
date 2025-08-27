import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part "friend_request.freezed.dart";
part "friend_request.g.dart";

@HiveType(typeId: 2)
@freezed
abstract class FriendRequest with _$FriendRequest {
  factory FriendRequest({
    @HiveField(0) required String id,
    @HiveField(1) required String username,
    @HiveField(2) required String email,
    @HiveField(3) String? firstname,
    @HiveField(4) String? subname,
    @HiveField(5) String? description,
    @HiveField(6) String? avatar,
    @HiveField(7) required List<String>? friends,
    @HiveField(8) String? city,
    @HiveField(9) int? age,
    @HiveField(10) required List<String> purposes,
    @HiveField(11) required List<String> interests,
    @HiveField(12) required DateTime createdAt,
    @HiveField(13) required bool verified,
    @HiveField(14) required bool isSearchable,
    @HiveField(15) String? token,
    @HiveField(16) required Set<String> roles,
    @HiveField(17) required bool isOnline,
    @HiveField(18) required String floor,
  }) = _FriendRequest;

  factory FriendRequest.fromJson(Map<String, dynamic> json) => _$FriendRequestFromJson(json);
}
