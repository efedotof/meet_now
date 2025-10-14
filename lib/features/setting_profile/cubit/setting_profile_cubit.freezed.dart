// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'setting_profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingProfileState {

 User? get user; String get username; String get firstname; String get subname; String get description; String get city; String get age; List<String> get interests; List<String> get purposes; bool get isSearchable; String? get oldPassword; String? get newPassword; bool get isLoading; String? get errorMessage; bool get isSuccess; bool get isPasswordChanged;
/// Create a copy of SettingProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingProfileStateCopyWith<SettingProfileState> get copyWith => _$SettingProfileStateCopyWithImpl<SettingProfileState>(this as SettingProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingProfileState&&(identical(other.user, user) || other.user == user)&&(identical(other.username, username) || other.username == username)&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.subname, subname) || other.subname == subname)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other.interests, interests)&&const DeepCollectionEquality().equals(other.purposes, purposes)&&(identical(other.isSearchable, isSearchable) || other.isSearchable == isSearchable)&&(identical(other.oldPassword, oldPassword) || other.oldPassword == oldPassword)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.isPasswordChanged, isPasswordChanged) || other.isPasswordChanged == isPasswordChanged));
}


@override
int get hashCode => Object.hash(runtimeType,user,username,firstname,subname,description,city,age,const DeepCollectionEquality().hash(interests),const DeepCollectionEquality().hash(purposes),isSearchable,oldPassword,newPassword,isLoading,errorMessage,isSuccess,isPasswordChanged);

@override
String toString() {
  return 'SettingProfileState(user: $user, username: $username, firstname: $firstname, subname: $subname, description: $description, city: $city, age: $age, interests: $interests, purposes: $purposes, isSearchable: $isSearchable, oldPassword: $oldPassword, newPassword: $newPassword, isLoading: $isLoading, errorMessage: $errorMessage, isSuccess: $isSuccess, isPasswordChanged: $isPasswordChanged)';
}


}

/// @nodoc
abstract mixin class $SettingProfileStateCopyWith<$Res>  {
  factory $SettingProfileStateCopyWith(SettingProfileState value, $Res Function(SettingProfileState) _then) = _$SettingProfileStateCopyWithImpl;
@useResult
$Res call({
 User? user, String username, String firstname, String subname, String description, String city, String age, List<String> interests, List<String> purposes, bool isSearchable, String? oldPassword, String? newPassword, bool isLoading, String? errorMessage, bool isSuccess, bool isPasswordChanged
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$SettingProfileStateCopyWithImpl<$Res>
    implements $SettingProfileStateCopyWith<$Res> {
  _$SettingProfileStateCopyWithImpl(this._self, this._then);

  final SettingProfileState _self;
  final $Res Function(SettingProfileState) _then;

/// Create a copy of SettingProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? username = null,Object? firstname = null,Object? subname = null,Object? description = null,Object? city = null,Object? age = null,Object? interests = null,Object? purposes = null,Object? isSearchable = null,Object? oldPassword = freezed,Object? newPassword = freezed,Object? isLoading = null,Object? errorMessage = freezed,Object? isSuccess = null,Object? isPasswordChanged = null,}) {
  return _then(_self.copyWith(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,firstname: null == firstname ? _self.firstname : firstname // ignore: cast_nullable_to_non_nullable
as String,subname: null == subname ? _self.subname : subname // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,purposes: null == purposes ? _self.purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<String>,isSearchable: null == isSearchable ? _self.isSearchable : isSearchable // ignore: cast_nullable_to_non_nullable
as bool,oldPassword: freezed == oldPassword ? _self.oldPassword : oldPassword // ignore: cast_nullable_to_non_nullable
as String?,newPassword: freezed == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,isPasswordChanged: null == isPasswordChanged ? _self.isPasswordChanged : isPasswordChanged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SettingProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingProfileState].
extension SettingProfileStatePatterns on SettingProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingProfileState value)  $default,){
final _that = this;
switch (_that) {
case _SettingProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( User? user,  String username,  String firstname,  String subname,  String description,  String city,  String age,  List<String> interests,  List<String> purposes,  bool isSearchable,  String? oldPassword,  String? newPassword,  bool isLoading,  String? errorMessage,  bool isSuccess,  bool isPasswordChanged)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingProfileState() when $default != null:
return $default(_that.user,_that.username,_that.firstname,_that.subname,_that.description,_that.city,_that.age,_that.interests,_that.purposes,_that.isSearchable,_that.oldPassword,_that.newPassword,_that.isLoading,_that.errorMessage,_that.isSuccess,_that.isPasswordChanged);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( User? user,  String username,  String firstname,  String subname,  String description,  String city,  String age,  List<String> interests,  List<String> purposes,  bool isSearchable,  String? oldPassword,  String? newPassword,  bool isLoading,  String? errorMessage,  bool isSuccess,  bool isPasswordChanged)  $default,) {final _that = this;
switch (_that) {
case _SettingProfileState():
return $default(_that.user,_that.username,_that.firstname,_that.subname,_that.description,_that.city,_that.age,_that.interests,_that.purposes,_that.isSearchable,_that.oldPassword,_that.newPassword,_that.isLoading,_that.errorMessage,_that.isSuccess,_that.isPasswordChanged);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( User? user,  String username,  String firstname,  String subname,  String description,  String city,  String age,  List<String> interests,  List<String> purposes,  bool isSearchable,  String? oldPassword,  String? newPassword,  bool isLoading,  String? errorMessage,  bool isSuccess,  bool isPasswordChanged)?  $default,) {final _that = this;
switch (_that) {
case _SettingProfileState() when $default != null:
return $default(_that.user,_that.username,_that.firstname,_that.subname,_that.description,_that.city,_that.age,_that.interests,_that.purposes,_that.isSearchable,_that.oldPassword,_that.newPassword,_that.isLoading,_that.errorMessage,_that.isSuccess,_that.isPasswordChanged);case _:
  return null;

}
}

}

/// @nodoc


class _SettingProfileState implements SettingProfileState {
  const _SettingProfileState({this.user, required this.username, required this.firstname, required this.subname, required this.description, required this.city, required this.age, required final  List<String> interests, required final  List<String> purposes, required this.isSearchable, this.oldPassword, this.newPassword, required this.isLoading, this.errorMessage, required this.isSuccess, required this.isPasswordChanged}): _interests = interests,_purposes = purposes;
  

@override final  User? user;
@override final  String username;
@override final  String firstname;
@override final  String subname;
@override final  String description;
@override final  String city;
@override final  String age;
 final  List<String> _interests;
@override List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

 final  List<String> _purposes;
@override List<String> get purposes {
  if (_purposes is EqualUnmodifiableListView) return _purposes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_purposes);
}

@override final  bool isSearchable;
@override final  String? oldPassword;
@override final  String? newPassword;
@override final  bool isLoading;
@override final  String? errorMessage;
@override final  bool isSuccess;
@override final  bool isPasswordChanged;

/// Create a copy of SettingProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingProfileStateCopyWith<_SettingProfileState> get copyWith => __$SettingProfileStateCopyWithImpl<_SettingProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingProfileState&&(identical(other.user, user) || other.user == user)&&(identical(other.username, username) || other.username == username)&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.subname, subname) || other.subname == subname)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other._interests, _interests)&&const DeepCollectionEquality().equals(other._purposes, _purposes)&&(identical(other.isSearchable, isSearchable) || other.isSearchable == isSearchable)&&(identical(other.oldPassword, oldPassword) || other.oldPassword == oldPassword)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.isPasswordChanged, isPasswordChanged) || other.isPasswordChanged == isPasswordChanged));
}


@override
int get hashCode => Object.hash(runtimeType,user,username,firstname,subname,description,city,age,const DeepCollectionEquality().hash(_interests),const DeepCollectionEquality().hash(_purposes),isSearchable,oldPassword,newPassword,isLoading,errorMessage,isSuccess,isPasswordChanged);

@override
String toString() {
  return 'SettingProfileState(user: $user, username: $username, firstname: $firstname, subname: $subname, description: $description, city: $city, age: $age, interests: $interests, purposes: $purposes, isSearchable: $isSearchable, oldPassword: $oldPassword, newPassword: $newPassword, isLoading: $isLoading, errorMessage: $errorMessage, isSuccess: $isSuccess, isPasswordChanged: $isPasswordChanged)';
}


}

/// @nodoc
abstract mixin class _$SettingProfileStateCopyWith<$Res> implements $SettingProfileStateCopyWith<$Res> {
  factory _$SettingProfileStateCopyWith(_SettingProfileState value, $Res Function(_SettingProfileState) _then) = __$SettingProfileStateCopyWithImpl;
@override @useResult
$Res call({
 User? user, String username, String firstname, String subname, String description, String city, String age, List<String> interests, List<String> purposes, bool isSearchable, String? oldPassword, String? newPassword, bool isLoading, String? errorMessage, bool isSuccess, bool isPasswordChanged
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$SettingProfileStateCopyWithImpl<$Res>
    implements _$SettingProfileStateCopyWith<$Res> {
  __$SettingProfileStateCopyWithImpl(this._self, this._then);

  final _SettingProfileState _self;
  final $Res Function(_SettingProfileState) _then;

/// Create a copy of SettingProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? username = null,Object? firstname = null,Object? subname = null,Object? description = null,Object? city = null,Object? age = null,Object? interests = null,Object? purposes = null,Object? isSearchable = null,Object? oldPassword = freezed,Object? newPassword = freezed,Object? isLoading = null,Object? errorMessage = freezed,Object? isSuccess = null,Object? isPasswordChanged = null,}) {
  return _then(_SettingProfileState(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,firstname: null == firstname ? _self.firstname : firstname // ignore: cast_nullable_to_non_nullable
as String,subname: null == subname ? _self.subname : subname // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as String,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,purposes: null == purposes ? _self._purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<String>,isSearchable: null == isSearchable ? _self.isSearchable : isSearchable // ignore: cast_nullable_to_non_nullable
as bool,oldPassword: freezed == oldPassword ? _self.oldPassword : oldPassword // ignore: cast_nullable_to_non_nullable
as String?,newPassword: freezed == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,isPasswordChanged: null == isPasswordChanged ? _self.isPasswordChanged : isPasswordChanged // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SettingProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $UserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
