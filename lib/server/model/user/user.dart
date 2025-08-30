import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String username,
    required String email,
    String? firstname,
    String? subname,
    String? description,
    String? avatar,
    required List<String>? friends,
    String? city,
    int? age,
    required List<String> purposes,
    required List<String> interests,
    required DateTime createdAt,
    required bool verified,
    required bool isSearchable,
    String? token,
    required Set<String> roles,
    required bool isOnline,
    required String floor,
    List<String>? images,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
