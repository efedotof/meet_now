// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  firstname: json['firstname'] as String?,
  subname: json['subname'] as String?,
  description: json['description'] as String?,
  avatar: json['avatar'] as String?,
  friends:
      (json['friends'] as List<dynamic>?)?.map((e) => e as String).toList(),
  city: json['city'] as String?,
  age: (json['age'] as num?)?.toInt(),
  purposes:
      (json['purposes'] as List<dynamic>).map((e) => e as String).toList(),
  interests:
      (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  verified: json['verified'] as bool,
  isSearchable: json['isSearchable'] as bool,
  token: json['token'] as String?,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toSet(),
  isOnline: json['isOnline'] as bool,
  floor: json['floor'] as String,
  images: (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'firstname': instance.firstname,
  'subname': instance.subname,
  'description': instance.description,
  'avatar': instance.avatar,
  'friends': instance.friends,
  'city': instance.city,
  'age': instance.age,
  'purposes': instance.purposes,
  'interests': instance.interests,
  'createdAt': instance.createdAt.toIso8601String(),
  'verified': instance.verified,
  'isSearchable': instance.isSearchable,
  'token': instance.token,
  'roles': instance.roles.toList(),
  'isOnline': instance.isOnline,
  'floor': instance.floor,
  'images': instance.images,
};
