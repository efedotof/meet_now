// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FriendRequestAdapter extends TypeAdapter<FriendRequest> {
  @override
  final typeId = 2;

  @override
  FriendRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FriendRequest(
      id: fields[0] as String,
      username: fields[1] as String,
      email: fields[2] as String,
      firstname: fields[3] as String?,
      subname: fields[4] as String?,
      description: fields[5] as String?,
      avatar: fields[6] as String?,
      friends: (fields[7] as List?)?.cast<String>(),
      city: fields[8] as String?,
      age: (fields[9] as num?)?.toInt(),
      purposes: (fields[10] as List).cast<String>(),
      interests: (fields[11] as List).cast<String>(),
      createdAt: fields[12] as DateTime,
      verified: fields[13] as bool,
      isSearchable: fields[14] as bool,
      token: fields[15] as String?,
      roles: (fields[16] as Set).cast<String>(),
      isOnline: fields[17] as bool,
      floor: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FriendRequest obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.firstname)
      ..writeByte(4)
      ..write(obj.subname)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.avatar)
      ..writeByte(7)
      ..write(obj.friends)
      ..writeByte(8)
      ..write(obj.city)
      ..writeByte(9)
      ..write(obj.age)
      ..writeByte(10)
      ..write(obj.purposes)
      ..writeByte(11)
      ..write(obj.interests)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.verified)
      ..writeByte(14)
      ..write(obj.isSearchable)
      ..writeByte(15)
      ..write(obj.token)
      ..writeByte(16)
      ..write(obj.roles)
      ..writeByte(17)
      ..write(obj.isOnline)
      ..writeByte(18)
      ..write(obj.floor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    _FriendRequest(
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
    );

Map<String, dynamic> _$FriendRequestToJson(_FriendRequest instance) =>
    <String, dynamic>{
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
    };
