// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 String get id; String get username; String get email; String? get firstname; String? get subname; String? get description; String? get avatar; List<String>? get friends; String? get city; int? get age; List<String> get purposes; List<String> get interests; DateTime get createdAt; bool get verified; bool get isSearchable; String? get token; Set<String> get roles; bool get isOnline; String get floor; int get gamePoints; List<String>? get images;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.subname, subname) || other.subname == subname)&&(identical(other.description, description) || other.description == description)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&const DeepCollectionEquality().equals(other.friends, friends)&&(identical(other.city, city) || other.city == city)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other.purposes, purposes)&&const DeepCollectionEquality().equals(other.interests, interests)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.isSearchable, isSearchable) || other.isSearchable == isSearchable)&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other.roles, roles)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.gamePoints, gamePoints) || other.gamePoints == gamePoints)&&const DeepCollectionEquality().equals(other.images, images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,email,firstname,subname,description,avatar,const DeepCollectionEquality().hash(friends),city,age,const DeepCollectionEquality().hash(purposes),const DeepCollectionEquality().hash(interests),createdAt,verified,isSearchable,token,const DeepCollectionEquality().hash(roles),isOnline,floor,gamePoints,const DeepCollectionEquality().hash(images)]);

@override
String toString() {
  return 'User(id: $id, username: $username, email: $email, firstname: $firstname, subname: $subname, description: $description, avatar: $avatar, friends: $friends, city: $city, age: $age, purposes: $purposes, interests: $interests, createdAt: $createdAt, verified: $verified, isSearchable: $isSearchable, token: $token, roles: $roles, isOnline: $isOnline, floor: $floor, gamePoints: $gamePoints, images: $images)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String username, String email, String? firstname, String? subname, String? description, String? avatar, List<String>? friends, String? city, int? age, List<String> purposes, List<String> interests, DateTime createdAt, bool verified, bool isSearchable, String? token, Set<String> roles, bool isOnline, String floor, int gamePoints, List<String>? images
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = null,Object? firstname = freezed,Object? subname = freezed,Object? description = freezed,Object? avatar = freezed,Object? friends = freezed,Object? city = freezed,Object? age = freezed,Object? purposes = null,Object? interests = null,Object? createdAt = null,Object? verified = null,Object? isSearchable = null,Object? token = freezed,Object? roles = null,Object? isOnline = null,Object? floor = null,Object? gamePoints = null,Object? images = freezed,}) {
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
as String,gamePoints: null == gamePoints ? _self.gamePoints : gamePoints // ignore: cast_nullable_to_non_nullable
as int,images: freezed == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String email,  String? firstname,  String? subname,  String? description,  String? avatar,  List<String>? friends,  String? city,  int? age,  List<String> purposes,  List<String> interests,  DateTime createdAt,  bool verified,  bool isSearchable,  String? token,  Set<String> roles,  bool isOnline,  String floor,  int gamePoints,  List<String>? images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.firstname,_that.subname,_that.description,_that.avatar,_that.friends,_that.city,_that.age,_that.purposes,_that.interests,_that.createdAt,_that.verified,_that.isSearchable,_that.token,_that.roles,_that.isOnline,_that.floor,_that.gamePoints,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String email,  String? firstname,  String? subname,  String? description,  String? avatar,  List<String>? friends,  String? city,  int? age,  List<String> purposes,  List<String> interests,  DateTime createdAt,  bool verified,  bool isSearchable,  String? token,  Set<String> roles,  bool isOnline,  String floor,  int gamePoints,  List<String>? images)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.username,_that.email,_that.firstname,_that.subname,_that.description,_that.avatar,_that.friends,_that.city,_that.age,_that.purposes,_that.interests,_that.createdAt,_that.verified,_that.isSearchable,_that.token,_that.roles,_that.isOnline,_that.floor,_that.gamePoints,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String email,  String? firstname,  String? subname,  String? description,  String? avatar,  List<String>? friends,  String? city,  int? age,  List<String> purposes,  List<String> interests,  DateTime createdAt,  bool verified,  bool isSearchable,  String? token,  Set<String> roles,  bool isOnline,  String floor,  int gamePoints,  List<String>? images)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.firstname,_that.subname,_that.description,_that.avatar,_that.friends,_that.city,_that.age,_that.purposes,_that.interests,_that.createdAt,_that.verified,_that.isSearchable,_that.token,_that.roles,_that.isOnline,_that.floor,_that.gamePoints,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.id, required this.username, required this.email, this.firstname, this.subname, this.description, this.avatar, required final  List<String>? friends, this.city, this.age, required final  List<String> purposes, required final  List<String> interests, required this.createdAt, required this.verified, required this.isSearchable, this.token, required final  Set<String> roles, required this.isOnline, required this.floor, required this.gamePoints, final  List<String>? images}): _friends = friends,_purposes = purposes,_interests = interests,_roles = roles,_images = images;
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String id;
@override final  String username;
@override final  String email;
@override final  String? firstname;
@override final  String? subname;
@override final  String? description;
@override final  String? avatar;
 final  List<String>? _friends;
@override List<String>? get friends {
  final value = _friends;
  if (value == null) return null;
  if (_friends is EqualUnmodifiableListView) return _friends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? city;
@override final  int? age;
 final  List<String> _purposes;
@override List<String> get purposes {
  if (_purposes is EqualUnmodifiableListView) return _purposes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_purposes);
}

 final  List<String> _interests;
@override List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

@override final  DateTime createdAt;
@override final  bool verified;
@override final  bool isSearchable;
@override final  String? token;
 final  Set<String> _roles;
@override Set<String> get roles {
  if (_roles is EqualUnmodifiableSetView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_roles);
}

@override final  bool isOnline;
@override final  String floor;
@override final  int gamePoints;
 final  List<String>? _images;
@override List<String>? get images {
  final value = _images;
  if (value == null) return null;
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.subname, subname) || other.subname == subname)&&(identical(other.description, description) || other.description == description)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&const DeepCollectionEquality().equals(other._friends, _friends)&&(identical(other.city, city) || other.city == city)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other._purposes, _purposes)&&const DeepCollectionEquality().equals(other._interests, _interests)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.verified, verified) || other.verified == verified)&&(identical(other.isSearchable, isSearchable) || other.isSearchable == isSearchable)&&(identical(other.token, token) || other.token == token)&&const DeepCollectionEquality().equals(other._roles, _roles)&&(identical(other.isOnline, isOnline) || other.isOnline == isOnline)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.gamePoints, gamePoints) || other.gamePoints == gamePoints)&&const DeepCollectionEquality().equals(other._images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,username,email,firstname,subname,description,avatar,const DeepCollectionEquality().hash(_friends),city,age,const DeepCollectionEquality().hash(_purposes),const DeepCollectionEquality().hash(_interests),createdAt,verified,isSearchable,token,const DeepCollectionEquality().hash(_roles),isOnline,floor,gamePoints,const DeepCollectionEquality().hash(_images)]);

@override
String toString() {
  return 'User(id: $id, username: $username, email: $email, firstname: $firstname, subname: $subname, description: $description, avatar: $avatar, friends: $friends, city: $city, age: $age, purposes: $purposes, interests: $interests, createdAt: $createdAt, verified: $verified, isSearchable: $isSearchable, token: $token, roles: $roles, isOnline: $isOnline, floor: $floor, gamePoints: $gamePoints, images: $images)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String email, String? firstname, String? subname, String? description, String? avatar, List<String>? friends, String? city, int? age, List<String> purposes, List<String> interests, DateTime createdAt, bool verified, bool isSearchable, String? token, Set<String> roles, bool isOnline, String floor, int gamePoints, List<String>? images
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = null,Object? firstname = freezed,Object? subname = freezed,Object? description = freezed,Object? avatar = freezed,Object? friends = freezed,Object? city = freezed,Object? age = freezed,Object? purposes = null,Object? interests = null,Object? createdAt = null,Object? verified = null,Object? isSearchable = null,Object? token = freezed,Object? roles = null,Object? isOnline = null,Object? floor = null,Object? gamePoints = null,Object? images = freezed,}) {
  return _then(_User(
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
as String,gamePoints: null == gamePoints ? _self.gamePoints : gamePoints // ignore: cast_nullable_to_non_nullable
as int,images: freezed == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
