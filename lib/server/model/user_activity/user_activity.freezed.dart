// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserActivity {

 String get userId; String get username; String get chatId; ActivityType get activityType; DateTime get timestamp;
/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserActivityCopyWith<UserActivity> get copyWith => _$UserActivityCopyWithImpl<UserActivity>(this as UserActivity, _$identity);

  /// Serializes this UserActivity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserActivity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.activityType, activityType) || other.activityType == activityType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,chatId,activityType,timestamp);

@override
String toString() {
  return 'UserActivity(userId: $userId, username: $username, chatId: $chatId, activityType: $activityType, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $UserActivityCopyWith<$Res>  {
  factory $UserActivityCopyWith(UserActivity value, $Res Function(UserActivity) _then) = _$UserActivityCopyWithImpl;
@useResult
$Res call({
 String userId, String username, String chatId, ActivityType activityType, DateTime timestamp
});




}
/// @nodoc
class _$UserActivityCopyWithImpl<$Res>
    implements $UserActivityCopyWith<$Res> {
  _$UserActivityCopyWithImpl(this._self, this._then);

  final UserActivity _self;
  final $Res Function(UserActivity) _then;

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = null,Object? chatId = null,Object? activityType = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,activityType: null == activityType ? _self.activityType : activityType // ignore: cast_nullable_to_non_nullable
as ActivityType,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserActivity].
extension UserActivityPatterns on UserActivity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserActivity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserActivity value)  $default,){
final _that = this;
switch (_that) {
case _UserActivity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserActivity value)?  $default,){
final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String username,  String chatId,  ActivityType activityType,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that.userId,_that.username,_that.chatId,_that.activityType,_that.timestamp);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String username,  String chatId,  ActivityType activityType,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _UserActivity():
return $default(_that.userId,_that.username,_that.chatId,_that.activityType,_that.timestamp);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String username,  String chatId,  ActivityType activityType,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _UserActivity() when $default != null:
return $default(_that.userId,_that.username,_that.chatId,_that.activityType,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserActivity implements UserActivity {
  const _UserActivity({required this.userId, required this.username, required this.chatId, required this.activityType, required this.timestamp});
  factory _UserActivity.fromJson(Map<String, dynamic> json) => _$UserActivityFromJson(json);

@override final  String userId;
@override final  String username;
@override final  String chatId;
@override final  ActivityType activityType;
@override final  DateTime timestamp;

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserActivityCopyWith<_UserActivity> get copyWith => __$UserActivityCopyWithImpl<_UserActivity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserActivityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserActivity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.activityType, activityType) || other.activityType == activityType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,chatId,activityType,timestamp);

@override
String toString() {
  return 'UserActivity(userId: $userId, username: $username, chatId: $chatId, activityType: $activityType, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$UserActivityCopyWith<$Res> implements $UserActivityCopyWith<$Res> {
  factory _$UserActivityCopyWith(_UserActivity value, $Res Function(_UserActivity) _then) = __$UserActivityCopyWithImpl;
@override @useResult
$Res call({
 String userId, String username, String chatId, ActivityType activityType, DateTime timestamp
});




}
/// @nodoc
class __$UserActivityCopyWithImpl<$Res>
    implements _$UserActivityCopyWith<$Res> {
  __$UserActivityCopyWithImpl(this._self, this._then);

  final _UserActivity _self;
  final $Res Function(_UserActivity) _then;

/// Create a copy of UserActivity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = null,Object? chatId = null,Object? activityType = null,Object? timestamp = null,}) {
  return _then(_UserActivity(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,activityType: null == activityType ? _self.activityType : activityType // ignore: cast_nullable_to_non_nullable
as ActivityType,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
