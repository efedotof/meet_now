// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Registration {

 String get username; String get email; String get firstname; String get subname; String get description; String get avatar; String get city; int get age; List<String> get purposes; List<String> get interests; bool get isSearchable; String get password;
/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegistrationCopyWith<Registration> get copyWith => _$RegistrationCopyWithImpl<Registration>(this as Registration, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Registration&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.subname, subname) || other.subname == subname)&&(identical(other.description, description) || other.description == description)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.city, city) || other.city == city)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other.purposes, purposes)&&const DeepCollectionEquality().equals(other.interests, interests)&&(identical(other.isSearchable, isSearchable) || other.isSearchable == isSearchable)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,username,email,firstname,subname,description,avatar,city,age,const DeepCollectionEquality().hash(purposes),const DeepCollectionEquality().hash(interests),isSearchable,password);

@override
String toString() {
  return 'Registration(username: $username, email: $email, firstname: $firstname, subname: $subname, description: $description, avatar: $avatar, city: $city, age: $age, purposes: $purposes, interests: $interests, isSearchable: $isSearchable, password: $password)';
}


}

/// @nodoc
abstract mixin class $RegistrationCopyWith<$Res>  {
  factory $RegistrationCopyWith(Registration value, $Res Function(Registration) _then) = _$RegistrationCopyWithImpl;
@useResult
$Res call({
 String username, String email, String firstname, String subname, String description, String avatar, String city, int age, List<String> purposes, List<String> interests, bool isSearchable, String password
});




}
/// @nodoc
class _$RegistrationCopyWithImpl<$Res>
    implements $RegistrationCopyWith<$Res> {
  _$RegistrationCopyWithImpl(this._self, this._then);

  final Registration _self;
  final $Res Function(Registration) _then;

/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? email = null,Object? firstname = null,Object? subname = null,Object? description = null,Object? avatar = null,Object? city = null,Object? age = null,Object? purposes = null,Object? interests = null,Object? isSearchable = null,Object? password = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstname: null == firstname ? _self.firstname : firstname // ignore: cast_nullable_to_non_nullable
as String,subname: null == subname ? _self.subname : subname // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,purposes: null == purposes ? _self.purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,isSearchable: null == isSearchable ? _self.isSearchable : isSearchable // ignore: cast_nullable_to_non_nullable
as bool,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Registration].
extension RegistrationPatterns on Registration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Registration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Registration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Registration value)  $default,){
final _that = this;
switch (_that) {
case _Registration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Registration value)?  $default,){
final _that = this;
switch (_that) {
case _Registration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String email,  String firstname,  String subname,  String description,  String avatar,  String city,  int age,  List<String> purposes,  List<String> interests,  bool isSearchable,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Registration() when $default != null:
return $default(_that.username,_that.email,_that.firstname,_that.subname,_that.description,_that.avatar,_that.city,_that.age,_that.purposes,_that.interests,_that.isSearchable,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String email,  String firstname,  String subname,  String description,  String avatar,  String city,  int age,  List<String> purposes,  List<String> interests,  bool isSearchable,  String password)  $default,) {final _that = this;
switch (_that) {
case _Registration():
return $default(_that.username,_that.email,_that.firstname,_that.subname,_that.description,_that.avatar,_that.city,_that.age,_that.purposes,_that.interests,_that.isSearchable,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String email,  String firstname,  String subname,  String description,  String avatar,  String city,  int age,  List<String> purposes,  List<String> interests,  bool isSearchable,  String password)?  $default,) {final _that = this;
switch (_that) {
case _Registration() when $default != null:
return $default(_that.username,_that.email,_that.firstname,_that.subname,_that.description,_that.avatar,_that.city,_that.age,_that.purposes,_that.interests,_that.isSearchable,_that.password);case _:
  return null;

}
}

}

/// @nodoc


class _Registration implements Registration {
   _Registration({required this.username, required this.email, required this.firstname, required this.subname, required this.description, required this.avatar, required this.city, required this.age, required final  List<String> purposes, required final  List<String> interests, required this.isSearchable, required this.password}): _purposes = purposes,_interests = interests;
  

@override final  String username;
@override final  String email;
@override final  String firstname;
@override final  String subname;
@override final  String description;
@override final  String avatar;
@override final  String city;
@override final  int age;
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

@override final  bool isSearchable;
@override final  String password;

/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegistrationCopyWith<_Registration> get copyWith => __$RegistrationCopyWithImpl<_Registration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Registration&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstname, firstname) || other.firstname == firstname)&&(identical(other.subname, subname) || other.subname == subname)&&(identical(other.description, description) || other.description == description)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.city, city) || other.city == city)&&(identical(other.age, age) || other.age == age)&&const DeepCollectionEquality().equals(other._purposes, _purposes)&&const DeepCollectionEquality().equals(other._interests, _interests)&&(identical(other.isSearchable, isSearchable) || other.isSearchable == isSearchable)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,username,email,firstname,subname,description,avatar,city,age,const DeepCollectionEquality().hash(_purposes),const DeepCollectionEquality().hash(_interests),isSearchable,password);

@override
String toString() {
  return 'Registration(username: $username, email: $email, firstname: $firstname, subname: $subname, description: $description, avatar: $avatar, city: $city, age: $age, purposes: $purposes, interests: $interests, isSearchable: $isSearchable, password: $password)';
}


}

/// @nodoc
abstract mixin class _$RegistrationCopyWith<$Res> implements $RegistrationCopyWith<$Res> {
  factory _$RegistrationCopyWith(_Registration value, $Res Function(_Registration) _then) = __$RegistrationCopyWithImpl;
@override @useResult
$Res call({
 String username, String email, String firstname, String subname, String description, String avatar, String city, int age, List<String> purposes, List<String> interests, bool isSearchable, String password
});




}
/// @nodoc
class __$RegistrationCopyWithImpl<$Res>
    implements _$RegistrationCopyWith<$Res> {
  __$RegistrationCopyWithImpl(this._self, this._then);

  final _Registration _self;
  final $Res Function(_Registration) _then;

/// Create a copy of Registration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? email = null,Object? firstname = null,Object? subname = null,Object? description = null,Object? avatar = null,Object? city = null,Object? age = null,Object? purposes = null,Object? interests = null,Object? isSearchable = null,Object? password = null,}) {
  return _then(_Registration(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstname: null == firstname ? _self.firstname : firstname // ignore: cast_nullable_to_non_nullable
as String,subname: null == subname ? _self.subname : subname // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,purposes: null == purposes ? _self._purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<String>,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,isSearchable: null == isSearchable ? _self.isSearchable : isSearchable // ignore: cast_nullable_to_non_nullable
as bool,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
