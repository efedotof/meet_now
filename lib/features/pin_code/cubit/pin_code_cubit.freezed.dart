// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_code_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinCodeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinCodeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinCodeState()';
}


}

/// @nodoc
class $PinCodeStateCopyWith<$Res>  {
$PinCodeStateCopyWith(PinCodeState _, $Res Function(PinCodeState) __);
}


/// Adds pattern-matching-related methods to [PinCodeState].
extension PinCodeStatePatterns on PinCodeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Entering value)?  entering,TResult Function( _Success value)?  success,TResult Function( _Failure value)?  failure,TResult Function( _Reset value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Entering() when entering != null:
return entering(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Entering value)  entering,required TResult Function( _Success value)  success,required TResult Function( _Failure value)  failure,required TResult Function( _Reset value)  reset,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Entering():
return entering(_that);case _Success():
return success(_that);case _Failure():
return failure(_that);case _Reset():
return reset(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Entering value)?  entering,TResult? Function( _Success value)?  success,TResult? Function( _Failure value)?  failure,TResult? Function( _Reset value)?  reset,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Entering() when entering != null:
return entering(_that);case _Success() when success != null:
return success(_that);case _Failure() when failure != null:
return failure(_that);case _Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String currentPin)?  entering,TResult Function()?  success,TResult Function( String error)?  failure,TResult Function()?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Entering() when entering != null:
return entering(_that.currentPin);case _Success() when success != null:
return success();case _Failure() when failure != null:
return failure(_that.error);case _Reset() when reset != null:
return reset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String currentPin)  entering,required TResult Function()  success,required TResult Function( String error)  failure,required TResult Function()  reset,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Entering():
return entering(_that.currentPin);case _Success():
return success();case _Failure():
return failure(_that.error);case _Reset():
return reset();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String currentPin)?  entering,TResult? Function()?  success,TResult? Function( String error)?  failure,TResult? Function()?  reset,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Entering() when entering != null:
return entering(_that.currentPin);case _Success() when success != null:
return success();case _Failure() when failure != null:
return failure(_that.error);case _Reset() when reset != null:
return reset();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements PinCodeState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinCodeState.initial()';
}


}




/// @nodoc


class _Entering implements PinCodeState {
  const _Entering(this.currentPin);
  

 final  String currentPin;

/// Create a copy of PinCodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnteringCopyWith<_Entering> get copyWith => __$EnteringCopyWithImpl<_Entering>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Entering&&(identical(other.currentPin, currentPin) || other.currentPin == currentPin));
}


@override
int get hashCode => Object.hash(runtimeType,currentPin);

@override
String toString() {
  return 'PinCodeState.entering(currentPin: $currentPin)';
}


}

/// @nodoc
abstract mixin class _$EnteringCopyWith<$Res> implements $PinCodeStateCopyWith<$Res> {
  factory _$EnteringCopyWith(_Entering value, $Res Function(_Entering) _then) = __$EnteringCopyWithImpl;
@useResult
$Res call({
 String currentPin
});




}
/// @nodoc
class __$EnteringCopyWithImpl<$Res>
    implements _$EnteringCopyWith<$Res> {
  __$EnteringCopyWithImpl(this._self, this._then);

  final _Entering _self;
  final $Res Function(_Entering) _then;

/// Create a copy of PinCodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? currentPin = null,}) {
  return _then(_Entering(
null == currentPin ? _self.currentPin : currentPin // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Success implements PinCodeState {
  const _Success();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinCodeState.success()';
}


}




/// @nodoc


class _Failure implements PinCodeState {
  const _Failure(this.error);
  

 final  String error;

/// Create a copy of PinCodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'PinCodeState.failure(error: $error)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $PinCodeStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of PinCodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_Failure(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Reset implements PinCodeState {
  const _Reset();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinCodeState.reset()';
}


}




// dart format on
