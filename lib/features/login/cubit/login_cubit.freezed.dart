// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {

 String get username; String get password; bool get isLoading; bool get obscurePassword; bool get rememberMe; bool get loginSuccess; String? get usernameError; String? get passwordError; String? get generalError; User? get user;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.loginSuccess, loginSuccess) || other.loginSuccess == loginSuccess)&&(identical(other.usernameError, usernameError) || other.usernameError == usernameError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.generalError, generalError) || other.generalError == generalError)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,username,password,isLoading,obscurePassword,rememberMe,loginSuccess,usernameError,passwordError,generalError,user);

@override
String toString() {
  return 'LoginState(username: $username, password: $password, isLoading: $isLoading, obscurePassword: $obscurePassword, rememberMe: $rememberMe, loginSuccess: $loginSuccess, usernameError: $usernameError, passwordError: $passwordError, generalError: $generalError, user: $user)';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 String username, String password, bool isLoading, bool obscurePassword, bool rememberMe, bool loginSuccess, String? usernameError, String? passwordError, String? generalError, User? user
});


$UserCopyWith<$Res>? get user;

}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? password = null,Object? isLoading = null,Object? obscurePassword = null,Object? rememberMe = null,Object? loginSuccess = null,Object? usernameError = freezed,Object? passwordError = freezed,Object? generalError = freezed,Object? user = freezed,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,loginSuccess: null == loginSuccess ? _self.loginSuccess : loginSuccess // ignore: cast_nullable_to_non_nullable
as bool,usernameError: freezed == usernameError ? _self.usernameError : usernameError // ignore: cast_nullable_to_non_nullable
as String?,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String?,generalError: freezed == generalError ? _self.generalError : generalError // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,
  ));
}
/// Create a copy of LoginState
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


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String username,  String password,  bool isLoading,  bool obscurePassword,  bool rememberMe,  bool loginSuccess,  String? usernameError,  String? passwordError,  String? generalError,  User? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.username,_that.password,_that.isLoading,_that.obscurePassword,_that.rememberMe,_that.loginSuccess,_that.usernameError,_that.passwordError,_that.generalError,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String username,  String password,  bool isLoading,  bool obscurePassword,  bool rememberMe,  bool loginSuccess,  String? usernameError,  String? passwordError,  String? generalError,  User? user)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.username,_that.password,_that.isLoading,_that.obscurePassword,_that.rememberMe,_that.loginSuccess,_that.usernameError,_that.passwordError,_that.generalError,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String username,  String password,  bool isLoading,  bool obscurePassword,  bool rememberMe,  bool loginSuccess,  String? usernameError,  String? passwordError,  String? generalError,  User? user)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.username,_that.password,_that.isLoading,_that.obscurePassword,_that.rememberMe,_that.loginSuccess,_that.usernameError,_that.passwordError,_that.generalError,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState implements LoginState {
  const _LoginState({required this.username, required this.password, required this.isLoading, required this.obscurePassword, required this.rememberMe, required this.loginSuccess, this.usernameError, this.passwordError, this.generalError, this.user});
  

@override final  String username;
@override final  String password;
@override final  bool isLoading;
@override final  bool obscurePassword;
@override final  bool rememberMe;
@override final  bool loginSuccess;
@override final  String? usernameError;
@override final  String? passwordError;
@override final  String? generalError;
@override final  User? user;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.rememberMe, rememberMe) || other.rememberMe == rememberMe)&&(identical(other.loginSuccess, loginSuccess) || other.loginSuccess == loginSuccess)&&(identical(other.usernameError, usernameError) || other.usernameError == usernameError)&&(identical(other.passwordError, passwordError) || other.passwordError == passwordError)&&(identical(other.generalError, generalError) || other.generalError == generalError)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,username,password,isLoading,obscurePassword,rememberMe,loginSuccess,usernameError,passwordError,generalError,user);

@override
String toString() {
  return 'LoginState(username: $username, password: $password, isLoading: $isLoading, obscurePassword: $obscurePassword, rememberMe: $rememberMe, loginSuccess: $loginSuccess, usernameError: $usernameError, passwordError: $passwordError, generalError: $generalError, user: $user)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 String username, String password, bool isLoading, bool obscurePassword, bool rememberMe, bool loginSuccess, String? usernameError, String? passwordError, String? generalError, User? user
});


@override $UserCopyWith<$Res>? get user;

}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = null,Object? isLoading = null,Object? obscurePassword = null,Object? rememberMe = null,Object? loginSuccess = null,Object? usernameError = freezed,Object? passwordError = freezed,Object? generalError = freezed,Object? user = freezed,}) {
  return _then(_LoginState(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,rememberMe: null == rememberMe ? _self.rememberMe : rememberMe // ignore: cast_nullable_to_non_nullable
as bool,loginSuccess: null == loginSuccess ? _self.loginSuccess : loginSuccess // ignore: cast_nullable_to_non_nullable
as bool,usernameError: freezed == usernameError ? _self.usernameError : usernameError // ignore: cast_nullable_to_non_nullable
as String?,passwordError: freezed == passwordError ? _self.passwordError : passwordError // ignore: cast_nullable_to_non_nullable
as String?,generalError: freezed == generalError ? _self.generalError : generalError // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User?,
  ));
}

/// Create a copy of LoginState
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
