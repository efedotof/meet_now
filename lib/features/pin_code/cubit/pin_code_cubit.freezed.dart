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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Entering value)?  entering,TResult Function( _Processing value)?  processing,TResult Function( _Failure value)?  failure,TResult Function( _AuthRequired value)?  authRequired,TResult Function( _MainHomeRequired value)?  mainHomeRequired,TResult Function( _Locked value)?  locked,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Entering() when entering != null:
return entering(_that);case _Processing() when processing != null:
return processing(_that);case _Failure() when failure != null:
return failure(_that);case _AuthRequired() when authRequired != null:
return authRequired(_that);case _MainHomeRequired() when mainHomeRequired != null:
return mainHomeRequired(_that);case _Locked() when locked != null:
return locked(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Entering value)  entering,required TResult Function( _Processing value)  processing,required TResult Function( _Failure value)  failure,required TResult Function( _AuthRequired value)  authRequired,required TResult Function( _MainHomeRequired value)  mainHomeRequired,required TResult Function( _Locked value)  locked,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Entering():
return entering(_that);case _Processing():
return processing(_that);case _Failure():
return failure(_that);case _AuthRequired():
return authRequired(_that);case _MainHomeRequired():
return mainHomeRequired(_that);case _Locked():
return locked(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Entering value)?  entering,TResult? Function( _Processing value)?  processing,TResult? Function( _Failure value)?  failure,TResult? Function( _AuthRequired value)?  authRequired,TResult? Function( _MainHomeRequired value)?  mainHomeRequired,TResult? Function( _Locked value)?  locked,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Entering() when entering != null:
return entering(_that);case _Processing() when processing != null:
return processing(_that);case _Failure() when failure != null:
return failure(_that);case _AuthRequired() when authRequired != null:
return authRequired(_that);case _MainHomeRequired() when mainHomeRequired != null:
return mainHomeRequired(_that);case _Locked() when locked != null:
return locked(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String currentPin)?  entering,TResult Function()?  processing,TResult Function()?  failure,TResult Function()?  authRequired,TResult Function()?  mainHomeRequired,TResult Function( String blockReason)?  locked,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Entering() when entering != null:
return entering(_that.currentPin);case _Processing() when processing != null:
return processing();case _Failure() when failure != null:
return failure();case _AuthRequired() when authRequired != null:
return authRequired();case _MainHomeRequired() when mainHomeRequired != null:
return mainHomeRequired();case _Locked() when locked != null:
return locked(_that.blockReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String currentPin)  entering,required TResult Function()  processing,required TResult Function()  failure,required TResult Function()  authRequired,required TResult Function()  mainHomeRequired,required TResult Function( String blockReason)  locked,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Entering():
return entering(_that.currentPin);case _Processing():
return processing();case _Failure():
return failure();case _AuthRequired():
return authRequired();case _MainHomeRequired():
return mainHomeRequired();case _Locked():
return locked(_that.blockReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String currentPin)?  entering,TResult? Function()?  processing,TResult? Function()?  failure,TResult? Function()?  authRequired,TResult? Function()?  mainHomeRequired,TResult? Function( String blockReason)?  locked,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Entering() when entering != null:
return entering(_that.currentPin);case _Processing() when processing != null:
return processing();case _Failure() when failure != null:
return failure();case _AuthRequired() when authRequired != null:
return authRequired();case _MainHomeRequired() when mainHomeRequired != null:
return mainHomeRequired();case _Locked() when locked != null:
return locked(_that.blockReason);case _:
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


class _Processing implements PinCodeState {
  const _Processing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Processing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinCodeState.processing()';
}


}




/// @nodoc


class _Failure implements PinCodeState {
  const _Failure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinCodeState.failure()';
}


}




/// @nodoc


class _AuthRequired implements PinCodeState {
  const _AuthRequired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthRequired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinCodeState.authRequired()';
}


}




/// @nodoc


class _MainHomeRequired implements PinCodeState {
  const _MainHomeRequired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainHomeRequired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PinCodeState.mainHomeRequired()';
}


}




/// @nodoc


class _Locked implements PinCodeState {
  const _Locked(this.blockReason);
  

 final  String blockReason;

/// Create a copy of PinCodeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LockedCopyWith<_Locked> get copyWith => __$LockedCopyWithImpl<_Locked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Locked&&(identical(other.blockReason, blockReason) || other.blockReason == blockReason));
}


@override
int get hashCode => Object.hash(runtimeType,blockReason);

@override
String toString() {
  return 'PinCodeState.locked(blockReason: $blockReason)';
}


}

/// @nodoc
abstract mixin class _$LockedCopyWith<$Res> implements $PinCodeStateCopyWith<$Res> {
  factory _$LockedCopyWith(_Locked value, $Res Function(_Locked) _then) = __$LockedCopyWithImpl;
@useResult
$Res call({
 String blockReason
});




}
/// @nodoc
class __$LockedCopyWithImpl<$Res>
    implements _$LockedCopyWith<$Res> {
  __$LockedCopyWithImpl(this._self, this._then);

  final _Locked _self;
  final $Res Function(_Locked) _then;

/// Create a copy of PinCodeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? blockReason = null,}) {
  return _then(_Locked(
null == blockReason ? _self.blockReason : blockReason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
