// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SplashState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SplashState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState()';
}


}

/// @nodoc
class $SplashStateCopyWith<$Res>  {
$SplashStateCopyWith(SplashState _, $Res Function(SplashState) __);
}


/// Adds pattern-matching-related methods to [SplashState].
extension SplashStatePatterns on SplashState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _NavigateToAuth value)?  navigateToAuth,TResult Function( _NavigateToLocked value)?  navigateToLocked,TResult Function( _NavigateToUploadAvatar value)?  navigateToUploadAvatar,TResult Function( _NavigateToPinCode value)?  navigateToPinCode,TResult Function( _NavigateToMainHome value)?  navigateToMainHome,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _NavigateToAuth() when navigateToAuth != null:
return navigateToAuth(_that);case _NavigateToLocked() when navigateToLocked != null:
return navigateToLocked(_that);case _NavigateToUploadAvatar() when navigateToUploadAvatar != null:
return navigateToUploadAvatar(_that);case _NavigateToPinCode() when navigateToPinCode != null:
return navigateToPinCode(_that);case _NavigateToMainHome() when navigateToMainHome != null:
return navigateToMainHome(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _NavigateToAuth value)  navigateToAuth,required TResult Function( _NavigateToLocked value)  navigateToLocked,required TResult Function( _NavigateToUploadAvatar value)  navigateToUploadAvatar,required TResult Function( _NavigateToPinCode value)  navigateToPinCode,required TResult Function( _NavigateToMainHome value)  navigateToMainHome,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _NavigateToAuth():
return navigateToAuth(_that);case _NavigateToLocked():
return navigateToLocked(_that);case _NavigateToUploadAvatar():
return navigateToUploadAvatar(_that);case _NavigateToPinCode():
return navigateToPinCode(_that);case _NavigateToMainHome():
return navigateToMainHome(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _NavigateToAuth value)?  navigateToAuth,TResult? Function( _NavigateToLocked value)?  navigateToLocked,TResult? Function( _NavigateToUploadAvatar value)?  navigateToUploadAvatar,TResult? Function( _NavigateToPinCode value)?  navigateToPinCode,TResult? Function( _NavigateToMainHome value)?  navigateToMainHome,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _NavigateToAuth() when navigateToAuth != null:
return navigateToAuth(_that);case _NavigateToLocked() when navigateToLocked != null:
return navigateToLocked(_that);case _NavigateToUploadAvatar() when navigateToUploadAvatar != null:
return navigateToUploadAvatar(_that);case _NavigateToPinCode() when navigateToPinCode != null:
return navigateToPinCode(_that);case _NavigateToMainHome() when navigateToMainHome != null:
return navigateToMainHome(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  navigateToAuth,TResult Function()?  navigateToLocked,TResult Function()?  navigateToUploadAvatar,TResult Function()?  navigateToPinCode,TResult Function()?  navigateToMainHome,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _NavigateToAuth() when navigateToAuth != null:
return navigateToAuth();case _NavigateToLocked() when navigateToLocked != null:
return navigateToLocked();case _NavigateToUploadAvatar() when navigateToUploadAvatar != null:
return navigateToUploadAvatar();case _NavigateToPinCode() when navigateToPinCode != null:
return navigateToPinCode();case _NavigateToMainHome() when navigateToMainHome != null:
return navigateToMainHome();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  navigateToAuth,required TResult Function()  navigateToLocked,required TResult Function()  navigateToUploadAvatar,required TResult Function()  navigateToPinCode,required TResult Function()  navigateToMainHome,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _NavigateToAuth():
return navigateToAuth();case _NavigateToLocked():
return navigateToLocked();case _NavigateToUploadAvatar():
return navigateToUploadAvatar();case _NavigateToPinCode():
return navigateToPinCode();case _NavigateToMainHome():
return navigateToMainHome();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  navigateToAuth,TResult? Function()?  navigateToLocked,TResult? Function()?  navigateToUploadAvatar,TResult? Function()?  navigateToPinCode,TResult? Function()?  navigateToMainHome,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _NavigateToAuth() when navigateToAuth != null:
return navigateToAuth();case _NavigateToLocked() when navigateToLocked != null:
return navigateToLocked();case _NavigateToUploadAvatar() when navigateToUploadAvatar != null:
return navigateToUploadAvatar();case _NavigateToPinCode() when navigateToPinCode != null:
return navigateToPinCode();case _NavigateToMainHome() when navigateToMainHome != null:
return navigateToMainHome();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements SplashState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState.initial()';
}


}




/// @nodoc


class _NavigateToAuth implements SplashState {
  const _NavigateToAuth();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToAuth);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState.navigateToAuth()';
}


}




/// @nodoc


class _NavigateToLocked implements SplashState {
  const _NavigateToLocked();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToLocked);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState.navigateToLocked()';
}


}




/// @nodoc


class _NavigateToUploadAvatar implements SplashState {
  const _NavigateToUploadAvatar();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToUploadAvatar);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState.navigateToUploadAvatar()';
}


}




/// @nodoc


class _NavigateToPinCode implements SplashState {
  const _NavigateToPinCode();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToPinCode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState.navigateToPinCode()';
}


}




/// @nodoc


class _NavigateToMainHome implements SplashState {
  const _NavigateToMainHome();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToMainHome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SplashState.navigateToMainHome()';
}


}




// dart format on
