// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState()';
}


}

/// @nodoc
class $NotificationStateCopyWith<$Res>  {
$NotificationStateCopyWith(NotificationState _, $Res Function(NotificationState) __);
}


/// Adds pattern-matching-related methods to [NotificationState].
extension NotificationStatePatterns on NotificationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( bool enableNotifications,  bool enableSound,  bool enableVibration,  bool enableBadge,  bool enablePreviews,  bool quietHoursEnabled,  bool silentMode,  bool messageNotifications,  bool friendRequestNotifications,  bool systemNotifications)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.enableNotifications,_that.enableSound,_that.enableVibration,_that.enableBadge,_that.enablePreviews,_that.quietHoursEnabled,_that.silentMode,_that.messageNotifications,_that.friendRequestNotifications,_that.systemNotifications);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( bool enableNotifications,  bool enableSound,  bool enableVibration,  bool enableBadge,  bool enablePreviews,  bool quietHoursEnabled,  bool silentMode,  bool messageNotifications,  bool friendRequestNotifications,  bool systemNotifications)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.enableNotifications,_that.enableSound,_that.enableVibration,_that.enableBadge,_that.enablePreviews,_that.quietHoursEnabled,_that.silentMode,_that.messageNotifications,_that.friendRequestNotifications,_that.systemNotifications);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( bool enableNotifications,  bool enableSound,  bool enableVibration,  bool enableBadge,  bool enablePreviews,  bool quietHoursEnabled,  bool silentMode,  bool messageNotifications,  bool friendRequestNotifications,  bool systemNotifications)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.enableNotifications,_that.enableSound,_that.enableVibration,_that.enableBadge,_that.enablePreviews,_that.quietHoursEnabled,_that.silentMode,_that.messageNotifications,_that.friendRequestNotifications,_that.systemNotifications);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements NotificationState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.initial()';
}


}




/// @nodoc


class _Loading implements NotificationState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationState.loading()';
}


}




/// @nodoc


class _Loaded implements NotificationState {
  const _Loaded({required this.enableNotifications, required this.enableSound, required this.enableVibration, required this.enableBadge, required this.enablePreviews, required this.quietHoursEnabled, required this.silentMode, required this.messageNotifications, required this.friendRequestNotifications, required this.systemNotifications});
  

 final  bool enableNotifications;
 final  bool enableSound;
 final  bool enableVibration;
 final  bool enableBadge;
 final  bool enablePreviews;
 final  bool quietHoursEnabled;
 final  bool silentMode;
 final  bool messageNotifications;
 final  bool friendRequestNotifications;
 final  bool systemNotifications;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.enableNotifications, enableNotifications) || other.enableNotifications == enableNotifications)&&(identical(other.enableSound, enableSound) || other.enableSound == enableSound)&&(identical(other.enableVibration, enableVibration) || other.enableVibration == enableVibration)&&(identical(other.enableBadge, enableBadge) || other.enableBadge == enableBadge)&&(identical(other.enablePreviews, enablePreviews) || other.enablePreviews == enablePreviews)&&(identical(other.quietHoursEnabled, quietHoursEnabled) || other.quietHoursEnabled == quietHoursEnabled)&&(identical(other.silentMode, silentMode) || other.silentMode == silentMode)&&(identical(other.messageNotifications, messageNotifications) || other.messageNotifications == messageNotifications)&&(identical(other.friendRequestNotifications, friendRequestNotifications) || other.friendRequestNotifications == friendRequestNotifications)&&(identical(other.systemNotifications, systemNotifications) || other.systemNotifications == systemNotifications));
}


@override
int get hashCode => Object.hash(runtimeType,enableNotifications,enableSound,enableVibration,enableBadge,enablePreviews,quietHoursEnabled,silentMode,messageNotifications,friendRequestNotifications,systemNotifications);

@override
String toString() {
  return 'NotificationState.loaded(enableNotifications: $enableNotifications, enableSound: $enableSound, enableVibration: $enableVibration, enableBadge: $enableBadge, enablePreviews: $enablePreviews, quietHoursEnabled: $quietHoursEnabled, silentMode: $silentMode, messageNotifications: $messageNotifications, friendRequestNotifications: $friendRequestNotifications, systemNotifications: $systemNotifications)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $NotificationStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 bool enableNotifications, bool enableSound, bool enableVibration, bool enableBadge, bool enablePreviews, bool quietHoursEnabled, bool silentMode, bool messageNotifications, bool friendRequestNotifications, bool systemNotifications
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enableNotifications = null,Object? enableSound = null,Object? enableVibration = null,Object? enableBadge = null,Object? enablePreviews = null,Object? quietHoursEnabled = null,Object? silentMode = null,Object? messageNotifications = null,Object? friendRequestNotifications = null,Object? systemNotifications = null,}) {
  return _then(_Loaded(
enableNotifications: null == enableNotifications ? _self.enableNotifications : enableNotifications // ignore: cast_nullable_to_non_nullable
as bool,enableSound: null == enableSound ? _self.enableSound : enableSound // ignore: cast_nullable_to_non_nullable
as bool,enableVibration: null == enableVibration ? _self.enableVibration : enableVibration // ignore: cast_nullable_to_non_nullable
as bool,enableBadge: null == enableBadge ? _self.enableBadge : enableBadge // ignore: cast_nullable_to_non_nullable
as bool,enablePreviews: null == enablePreviews ? _self.enablePreviews : enablePreviews // ignore: cast_nullable_to_non_nullable
as bool,quietHoursEnabled: null == quietHoursEnabled ? _self.quietHoursEnabled : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
as bool,silentMode: null == silentMode ? _self.silentMode : silentMode // ignore: cast_nullable_to_non_nullable
as bool,messageNotifications: null == messageNotifications ? _self.messageNotifications : messageNotifications // ignore: cast_nullable_to_non_nullable
as bool,friendRequestNotifications: null == friendRequestNotifications ? _self.friendRequestNotifications : friendRequestNotifications // ignore: cast_nullable_to_non_nullable
as bool,systemNotifications: null == systemNotifications ? _self.systemNotifications : systemNotifications // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Error implements NotificationState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NotificationState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $NotificationStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of NotificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
