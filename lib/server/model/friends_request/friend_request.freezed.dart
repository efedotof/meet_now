// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FriendRequest {

@HiveField(0) String get id;@HiveField(1) String get username;@HiveField(2) String get email;@HiveField(3) String? get firstname;@HiveField(4) String? get subname;@HiveField(5) String? get description;@HiveField(6) String? get avatar;@HiveField(7) List<String>? get friends;@HiveField(8) String? get city;@HiveField(9) int? get age;@HiveField(10) List<String> get purposes;@HiveField(11) List<String> get interests;@HiveField(12) DateTime get createdAt;@HiveField(13) bool get verified;@HiveField(14) bool get isSearchable;@HiveField(15) String? get token;@HiveField(16) Set<String> get roles;@HiveField(17) bool get isOnline;@HiveField(18) String get floor;
/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendRequestCopyWith<FriendRequest> get copyWith => _$FriendRequestCopyWithImpl<FriendRequest>(this as FriendRequest, _$identity);

  /// Serializes this FriendRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.subname, subname) || other.subname == subname)&&(identical(other.description, description) || other.description == description)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&const DeepCollectionEquality().equals(other.friends, friends)&&(identical(other.city, city) || other.city == city)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other.purposes, purposes)&&const DeepCollectionEquality().equals(other.interests, interests)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.isSearchable, isSearchable) || other.isSearchable == isSearchable)&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other.roles, roles)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.floor, floor) || other.floor == floor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,email,firstname,subname,description,avatar,const DeepCollectionEquality().hash(friends),city,age,const DeepCollectionEquality().hash(purposes),const DeepCollectionEquality().hash(interests),createdAt,verified,isSearchable,token,const DeepCollectionEquality().hash(roles),isOnline,floor]);

@override
String toString() {
  return 'FriendRequest(id: $id, username: $username, email: $email, firstname: $firstname, subname: $subname, description: $description, avatar: $avatar, friends: $friends, city: $city, age: $age, purposes: $purposes, interests: $interests, createdAt: $createdAt, verified: $verified, isSearchable: $isSearchable, token: $token, roles: $roles, isOnline: $isOnline, floor: $floor)';
}


}

/// @nodoc
abstract mixin class $FriendRequestCopyWith<$Res>  {
  factory $FriendRequestCopyWith(FriendRequest value, $Res Function(FriendRequest) _then) = _$FriendRequestCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String username,@HiveField(2) String email,@HiveField(3) String? firstname,@HiveField(4) String? subname,@HiveField(5) String? description,@HiveField(6) String? avatar,@HiveField(7) List<String>? friends,@HiveField(8) String? city,@HiveField(9) int? age,@HiveField(10) List<String> purposes,@HiveField(11) List<String> interests,@HiveField(12) DateTime createdAt,@HiveField(13) bool verified,@HiveField(14) bool isSearchable,@HiveField(15) String? token,@HiveField(16) Set<String> roles,@HiveField(17) bool isOnline,@HiveField(18) String floor
});




}
/// @nodoc
class _$FriendRequestCopyWithImpl<$Res>
    implements $FriendRequestCopyWith<$Res> {
  _$FriendRequestCopyWithImpl(this._self, this._then);

  final FriendRequest _self;
  final $Res Function(FriendRequest) _then;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = null,Object? firstname = freezed,Object? subname = freezed,Object? description = freezed,Object? avatar = freezed,Object? friends = freezed,Object? city = freezed,Object? age = freezed,Object? purposes = null,Object? interests = null,Object? createdAt = null,Object? verified = null,Object? isSearchable = null,Object? token = freezed,Object? roles = null,Object? isOnline = null,Object? floor = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstname: freezed == firstname ? _self.firstname : firstname // ignore: cast_nullable_to_non_nullable
as String?,subname: freezed == subname ? _self.subname : subname // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,friends: freezed == friends ? _self.friends : friends // ignore: cast_nullable_to_non_nullable
as List<String>?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,purposes: null == purposes ? _self.purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,isSearchable: null == isSearchable ? _self.isSearchable : isSearchable // ignore: cast_nullable_to_non_nullable
as bool,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as Set<String>,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,floor: null == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FriendRequest].
extension FriendRequestPatterns on FriendRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendRequest value)  $default,){
final _that = this;
switch (_that) {
case _FriendRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String username, @HiveField(2)  String email, @HiveField(3)  String? firstname, @HiveField(4)  String? subname, @HiveField(5)  String? description, @HiveField(6)  String? avatar, @HiveField(7)  List<String>? friends, @HiveField(8)  String? city, @HiveField(9)  int? age, @HiveField(10)  List<String> purposes, @HiveField(11)  List<String> interests, @HiveField(12)  DateTime createdAt, @HiveField(13)  bool verified, @HiveField(14)  bool isSearchable, @HiveField(15)  String? token, @HiveField(16)  Set<String> roles, @HiveField(17)  bool isOnline, @HiveField(18)  String floor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.firstname,_that.subname,_that.description,_that.avatar,_that.friends,_that.city,_that.age,_that.purposes,_that.interests,_that.createdAt,_that.verified,_that.isSearchable,_that.token,_that.roles,_that.isOnline,_that.floor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String username, @HiveField(2)  String email, @HiveField(3)  String? firstname, @HiveField(4)  String? subname, @HiveField(5)  String? description, @HiveField(6)  String? avatar, @HiveField(7)  List<String>? friends, @HiveField(8)  String? city, @HiveField(9)  int? age, @HiveField(10)  List<String> purposes, @HiveField(11)  List<String> interests, @HiveField(12)  DateTime createdAt, @HiveField(13)  bool verified, @HiveField(14)  bool isSearchable, @HiveField(15)  String? token, @HiveField(16)  Set<String> roles, @HiveField(17)  bool isOnline, @HiveField(18)  String floor)  $default,) {final _that = this;
switch (_that) {
case _FriendRequest():
return $default(_that.id,_that.username,_that.email,_that.firstname,_that.subname,_that.description,_that.avatar,_that.friends,_that.city,_that.age,_that.purposes,_that.interests,_that.createdAt,_that.verified,_that.isSearchable,_that.token,_that.roles,_that.isOnline,_that.floor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String username, @HiveField(2)  String email, @HiveField(3)  String? firstname, @HiveField(4)  String? subname, @HiveField(5)  String? description, @HiveField(6)  String? avatar, @HiveField(7)  List<String>? friends, @HiveField(8)  String? city, @HiveField(9)  int? age, @HiveField(10)  List<String> purposes, @HiveField(11)  List<String> interests, @HiveField(12)  DateTime createdAt, @HiveField(13)  bool verified, @HiveField(14)  bool isSearchable, @HiveField(15)  String? token, @HiveField(16)  Set<String> roles, @HiveField(17)  bool isOnline, @HiveField(18)  String floor)?  $default,) {final _that = this;
switch (_that) {
case _FriendRequest() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.firstname,_that.subname,_that.description,_that.avatar,_that.friends,_that.city,_that.age,_that.purposes,_that.interests,_that.createdAt,_that.verified,_that.isSearchable,_that.token,_that.roles,_that.isOnline,_that.floor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendRequest implements FriendRequest {
   _FriendRequest({@HiveField(0) required this.id, @HiveField(1) required this.username, @HiveField(2) required this.email, @HiveField(3) this.firstname, @HiveField(4) this.subname, @HiveField(5) this.description, @HiveField(6) this.avatar, @HiveField(7) required final  List<String>? friends, @HiveField(8) this.city, @HiveField(9) this.age, @HiveField(10) required final  List<String> purposes, @HiveField(11) required final  List<String> interests, @HiveField(12) required this.createdAt, @HiveField(13) required this.verified, @HiveField(14) required this.isSearchable, @HiveField(15) this.token, @HiveField(16) required final  Set<String> roles, @HiveField(17) required this.isOnline, @HiveField(18) required this.floor}): _friends = friends,_purposes = purposes,_interests = interests,_roles = roles;
  factory _FriendRequest.fromJson(Map<String, dynamic> json) => _$FriendRequestFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String username;
@override@HiveField(2) final  String email;
@override@HiveField(3) final  String? firstname;
@override@HiveField(4) final  String? subname;
@override@HiveField(5) final  String? description;
@override@HiveField(6) final  String? avatar;
 final  List<String>? _friends;
@override@HiveField(7) List<String>? get friends {
  final value = _friends;
  if (value == null) return null;
  if (_friends is EqualUnmodifiableListView) return _friends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@HiveField(8) final  String? city;
@override@HiveField(9) final  int? age;
 final  List<String> _purposes;
@override@HiveField(10) List<String> get purposes {
  if (_purposes is EqualUnmodifiableListView) return _purposes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_purposes);
}

 final  List<String> _interests;
@override@HiveField(11) List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

@override@HiveField(12) final  DateTime createdAt;
@override@HiveField(13) final  bool verified;
@override@HiveField(14) final  bool isSearchable;
@override@HiveField(15) final  String? token;
 final  Set<String> _roles;
@override@HiveField(16) Set<String> get roles {
  if (_roles is EqualUnmodifiableSetView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_roles);
}

@override@HiveField(17) final  bool isOnline;
@override@HiveField(18) final  String floor;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendRequestCopyWith<_FriendRequest> get copyWith => __$FriendRequestCopyWithImpl<_FriendRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.subname, subname) || other.subname == subname)&&(identical(other.description, description) || other.description == description)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&const DeepCollectionEquality().equals(other._friends, _friends)&&(identical(other.city, city) || other.city == city)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other._purposes, _purposes)&&const DeepCollectionEquality().equals(other._interests, _interests)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.isSearchable, isSearchable) || other.isSearchable == isSearchable)&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other._roles, _roles)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.floor, floor) || other.floor == floor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,email,firstname,subname,description,avatar,const DeepCollectionEquality().hash(_friends),city,age,const DeepCollectionEquality().hash(_purposes),const DeepCollectionEquality().hash(_interests),createdAt,verified,isSearchable,token,const DeepCollectionEquality().hash(_roles),isOnline,floor]);

@override
String toString() {
  return 'FriendRequest(id: $id, username: $username, email: $email, firstname: $firstname, subname: $subname, description: $description, avatar: $avatar, friends: $friends, city: $city, age: $age, purposes: $purposes, interests: $interests, createdAt: $createdAt, verified: $verified, isSearchable: $isSearchable, token: $token, roles: $roles, isOnline: $isOnline, floor: $floor)';
}


}

/// @nodoc
abstract mixin class _$FriendRequestCopyWith<$Res> implements $FriendRequestCopyWith<$Res> {
  factory _$FriendRequestCopyWith(_FriendRequest value, $Res Function(_FriendRequest) _then) = __$FriendRequestCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String username,@HiveField(2) String email,@HiveField(3) String? firstname,@HiveField(4) String? subname,@HiveField(5) String? description,@HiveField(6) String? avatar,@HiveField(7) List<String>? friends,@HiveField(8) String? city,@HiveField(9) int? age,@HiveField(10) List<String> purposes,@HiveField(11) List<String> interests,@HiveField(12) DateTime createdAt,@HiveField(13) bool verified,@HiveField(14) bool isSearchable,@HiveField(15) String? token,@HiveField(16) Set<String> roles,@HiveField(17) bool isOnline,@HiveField(18) String floor
});




}
/// @nodoc
class __$FriendRequestCopyWithImpl<$Res>
    implements _$FriendRequestCopyWith<$Res> {
  __$FriendRequestCopyWithImpl(this._self, this._then);

  final _FriendRequest _self;
  final $Res Function(_FriendRequest) _then;

/// Create a copy of FriendRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = null,Object? firstname = freezed,Object? subname = freezed,Object? description = freezed,Object? avatar = freezed,Object? friends = freezed,Object? city = freezed,Object? age = freezed,Object? purposes = null,Object? interests = null,Object? createdAt = null,Object? verified = null,Object? isSearchable = null,Object? token = freezed,Object? roles = null,Object? isOnline = null,Object? floor = null,}) {
  return _then(_FriendRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstname: freezed == firstname ? _self.firstname : firstname // ignore: cast_nullable_to_non_nullable
as String?,subname: freezed == subname ? _self.subname : subname // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,friends: freezed == friends ? _self._friends : friends // ignore: cast_nullable_to_non_nullable
as List<String>?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,purposes: null == purposes ? _self._purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,isSearchable: null == isSearchable ? _self.isSearchable : isSearchable // ignore: cast_nullable_to_non_nullable
as bool,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as Set<String>,isOnline: null == isOnline ? _self.isOnline : isOnline // ignore: cast_nullable_to_non_nullable
as bool,floor: null == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
