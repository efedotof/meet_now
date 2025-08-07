// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SecurityState {

 bool get pinEnabled; bool get biometricEnabled; bool get privacyMode; bool get autoLock; bool get pinSetInProgress;
/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecurityStateCopyWith<SecurityState> get copyWith => _$SecurityStateCopyWithImpl<SecurityState>(this as SecurityState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecurityState&&(identical(other.pinEnabled, pinEnabled) || other.pinEnabled == pinEnabled)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.privacyMode, privacyMode) || other.privacyMode == privacyMode)&&(identical(other.autoLock, autoLock) || other.autoLock == autoLock)&&(identical(other.pinSetInProgress, pinSetInProgress) || other.pinSetInProgress == pinSetInProgress));
}


@override
int get hashCode => Object.hash(runtimeType,pinEnabled,biometricEnabled,privacyMode,autoLock,pinSetInProgress);

@override
String toString() {
  return 'SecurityState(pinEnabled: $pinEnabled, biometricEnabled: $biometricEnabled, privacyMode: $privacyMode, autoLock: $autoLock, pinSetInProgress: $pinSetInProgress)';
}


}

/// @nodoc
abstract mixin class $SecurityStateCopyWith<$Res>  {
  factory $SecurityStateCopyWith(SecurityState value, $Res Function(SecurityState) _then) = _$SecurityStateCopyWithImpl;
@useResult
$Res call({
 bool pinEnabled, bool biometricEnabled, bool privacyMode, bool autoLock, bool pinSetInProgress
});




}
/// @nodoc
class _$SecurityStateCopyWithImpl<$Res>
    implements $SecurityStateCopyWith<$Res> {
  _$SecurityStateCopyWithImpl(this._self, this._then);

  final SecurityState _self;
  final $Res Function(SecurityState) _then;

/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pinEnabled = null,Object? biometricEnabled = null,Object? privacyMode = null,Object? autoLock = null,Object? pinSetInProgress = null,}) {
  return _then(_self.copyWith(
pinEnabled: null == pinEnabled ? _self.pinEnabled : pinEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,privacyMode: null == privacyMode ? _self.privacyMode : privacyMode // ignore: cast_nullable_to_non_nullable
as bool,autoLock: null == autoLock ? _self.autoLock : autoLock // ignore: cast_nullable_to_non_nullable
as bool,pinSetInProgress: null == pinSetInProgress ? _self.pinSetInProgress : pinSetInProgress // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SecurityState].
extension SecurityStatePatterns on SecurityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecurityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecurityState value)  $default,){
final _that = this;
switch (_that) {
case _SecurityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecurityState value)?  $default,){
final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool pinEnabled,  bool biometricEnabled,  bool privacyMode,  bool autoLock,  bool pinSetInProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
return $default(_that.pinEnabled,_that.biometricEnabled,_that.privacyMode,_that.autoLock,_that.pinSetInProgress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool pinEnabled,  bool biometricEnabled,  bool privacyMode,  bool autoLock,  bool pinSetInProgress)  $default,) {final _that = this;
switch (_that) {
case _SecurityState():
return $default(_that.pinEnabled,_that.biometricEnabled,_that.privacyMode,_that.autoLock,_that.pinSetInProgress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool pinEnabled,  bool biometricEnabled,  bool privacyMode,  bool autoLock,  bool pinSetInProgress)?  $default,) {final _that = this;
switch (_that) {
case _SecurityState() when $default != null:
return $default(_that.pinEnabled,_that.biometricEnabled,_that.privacyMode,_that.autoLock,_that.pinSetInProgress);case _:
  return null;

}
}

}

/// @nodoc


class _SecurityState implements SecurityState {
  const _SecurityState({required this.pinEnabled, required this.biometricEnabled, required this.privacyMode, required this.autoLock, this.pinSetInProgress = false});
  

@override final  bool pinEnabled;
@override final  bool biometricEnabled;
@override final  bool privacyMode;
@override final  bool autoLock;
@override@JsonKey() final  bool pinSetInProgress;

/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecurityStateCopyWith<_SecurityState> get copyWith => __$SecurityStateCopyWithImpl<_SecurityState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecurityState&&(identical(other.pinEnabled, pinEnabled) || other.pinEnabled == pinEnabled)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.privacyMode, privacyMode) || other.privacyMode == privacyMode)&&(identical(other.autoLock, autoLock) || other.autoLock == autoLock)&&(identical(other.pinSetInProgress, pinSetInProgress) || other.pinSetInProgress == pinSetInProgress));
}


@override
int get hashCode => Object.hash(runtimeType,pinEnabled,biometricEnabled,privacyMode,autoLock,pinSetInProgress);

@override
String toString() {
  return 'SecurityState(pinEnabled: $pinEnabled, biometricEnabled: $biometricEnabled, privacyMode: $privacyMode, autoLock: $autoLock, pinSetInProgress: $pinSetInProgress)';
}


}

/// @nodoc
abstract mixin class _$SecurityStateCopyWith<$Res> implements $SecurityStateCopyWith<$Res> {
  factory _$SecurityStateCopyWith(_SecurityState value, $Res Function(_SecurityState) _then) = __$SecurityStateCopyWithImpl;
@override @useResult
$Res call({
 bool pinEnabled, bool biometricEnabled, bool privacyMode, bool autoLock, bool pinSetInProgress
});




}
/// @nodoc
class __$SecurityStateCopyWithImpl<$Res>
    implements _$SecurityStateCopyWith<$Res> {
  __$SecurityStateCopyWithImpl(this._self, this._then);

  final _SecurityState _self;
  final $Res Function(_SecurityState) _then;

/// Create a copy of SecurityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pinEnabled = null,Object? biometricEnabled = null,Object? privacyMode = null,Object? autoLock = null,Object? pinSetInProgress = null,}) {
  return _then(_SecurityState(
pinEnabled: null == pinEnabled ? _self.pinEnabled : pinEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,privacyMode: null == privacyMode ? _self.privacyMode : privacyMode // ignore: cast_nullable_to_non_nullable
as bool,autoLock: null == autoLock ? _self.autoLock : autoLock // ignore: cast_nullable_to_non_nullable
as bool,pinSetInProgress: null == pinSetInProgress ? _self.pinSetInProgress : pinSetInProgress // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
