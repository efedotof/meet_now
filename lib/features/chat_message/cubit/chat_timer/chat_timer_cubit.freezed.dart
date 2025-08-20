// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_timer_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatTimerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatTimerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatTimerState()';
}


}

/// @nodoc
class $ChatTimerStateCopyWith<$Res>  {
$ChatTimerStateCopyWith(ChatTimerState _, $Res Function(ChatTimerState) __);
}


/// Adds pattern-matching-related methods to [ChatTimerState].
extension ChatTimerStatePatterns on ChatTimerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Running value)?  running,TResult Function( _OneThirdReached value)?  oneThirdReached,TResult Function( _Finished value)?  finished,TResult Function( _ModalRunning value)?  modalRunning,TResult Function( _ModalFinished value)?  modalFinished,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Running() when running != null:
return running(_that);case _OneThirdReached() when oneThirdReached != null:
return oneThirdReached(_that);case _Finished() when finished != null:
return finished(_that);case _ModalRunning() when modalRunning != null:
return modalRunning(_that);case _ModalFinished() when modalFinished != null:
return modalFinished(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Running value)  running,required TResult Function( _OneThirdReached value)  oneThirdReached,required TResult Function( _Finished value)  finished,required TResult Function( _ModalRunning value)  modalRunning,required TResult Function( _ModalFinished value)  modalFinished,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Running():
return running(_that);case _OneThirdReached():
return oneThirdReached(_that);case _Finished():
return finished(_that);case _ModalRunning():
return modalRunning(_that);case _ModalFinished():
return modalFinished(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Running value)?  running,TResult? Function( _OneThirdReached value)?  oneThirdReached,TResult? Function( _Finished value)?  finished,TResult? Function( _ModalRunning value)?  modalRunning,TResult? Function( _ModalFinished value)?  modalFinished,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Running() when running != null:
return running(_that);case _OneThirdReached() when oneThirdReached != null:
return oneThirdReached(_that);case _Finished() when finished != null:
return finished(_that);case _ModalRunning() when modalRunning != null:
return modalRunning(_that);case _ModalFinished() when modalFinished != null:
return modalFinished(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( int totalSeconds,  int remainingSeconds,  bool isOneThirdModalShown)?  running,TResult Function()?  oneThirdReached,TResult Function()?  finished,TResult Function( int secondsRemaining)?  modalRunning,TResult Function()?  modalFinished,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Running() when running != null:
return running(_that.totalSeconds,_that.remainingSeconds,_that.isOneThirdModalShown);case _OneThirdReached() when oneThirdReached != null:
return oneThirdReached();case _Finished() when finished != null:
return finished();case _ModalRunning() when modalRunning != null:
return modalRunning(_that.secondsRemaining);case _ModalFinished() when modalFinished != null:
return modalFinished();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( int totalSeconds,  int remainingSeconds,  bool isOneThirdModalShown)  running,required TResult Function()  oneThirdReached,required TResult Function()  finished,required TResult Function( int secondsRemaining)  modalRunning,required TResult Function()  modalFinished,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Running():
return running(_that.totalSeconds,_that.remainingSeconds,_that.isOneThirdModalShown);case _OneThirdReached():
return oneThirdReached();case _Finished():
return finished();case _ModalRunning():
return modalRunning(_that.secondsRemaining);case _ModalFinished():
return modalFinished();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( int totalSeconds,  int remainingSeconds,  bool isOneThirdModalShown)?  running,TResult? Function()?  oneThirdReached,TResult? Function()?  finished,TResult? Function( int secondsRemaining)?  modalRunning,TResult? Function()?  modalFinished,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Running() when running != null:
return running(_that.totalSeconds,_that.remainingSeconds,_that.isOneThirdModalShown);case _OneThirdReached() when oneThirdReached != null:
return oneThirdReached();case _Finished() when finished != null:
return finished();case _ModalRunning() when modalRunning != null:
return modalRunning(_that.secondsRemaining);case _ModalFinished() when modalFinished != null:
return modalFinished();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ChatTimerState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatTimerState.initial()';
}


}




/// @nodoc


class _Running implements ChatTimerState {
  const _Running({required this.totalSeconds, required this.remainingSeconds, required this.isOneThirdModalShown});
  

 final  int totalSeconds;
 final  int remainingSeconds;
 final  bool isOneThirdModalShown;

/// Create a copy of ChatTimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunningCopyWith<_Running> get copyWith => __$RunningCopyWithImpl<_Running>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Running&&(identical(other.totalSeconds, totalSeconds) || other.totalSeconds == totalSeconds)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.isOneThirdModalShown, isOneThirdModalShown) || other.isOneThirdModalShown == isOneThirdModalShown));
}


@override
int get hashCode => Object.hash(runtimeType,totalSeconds,remainingSeconds,isOneThirdModalShown);

@override
String toString() {
  return 'ChatTimerState.running(totalSeconds: $totalSeconds, remainingSeconds: $remainingSeconds, isOneThirdModalShown: $isOneThirdModalShown)';
}


}

/// @nodoc
abstract mixin class _$RunningCopyWith<$Res> implements $ChatTimerStateCopyWith<$Res> {
  factory _$RunningCopyWith(_Running value, $Res Function(_Running) _then) = __$RunningCopyWithImpl;
@useResult
$Res call({
 int totalSeconds, int remainingSeconds, bool isOneThirdModalShown
});




}
/// @nodoc
class __$RunningCopyWithImpl<$Res>
    implements _$RunningCopyWith<$Res> {
  __$RunningCopyWithImpl(this._self, this._then);

  final _Running _self;
  final $Res Function(_Running) _then;

/// Create a copy of ChatTimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? totalSeconds = null,Object? remainingSeconds = null,Object? isOneThirdModalShown = null,}) {
  return _then(_Running(
totalSeconds: null == totalSeconds ? _self.totalSeconds : totalSeconds // ignore: cast_nullable_to_non_nullable
as int,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,isOneThirdModalShown: null == isOneThirdModalShown ? _self.isOneThirdModalShown : isOneThirdModalShown // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _OneThirdReached implements ChatTimerState {
  const _OneThirdReached();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OneThirdReached);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatTimerState.oneThirdReached()';
}


}




/// @nodoc


class _Finished implements ChatTimerState {
  const _Finished();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Finished);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatTimerState.finished()';
}


}




/// @nodoc


class _ModalRunning implements ChatTimerState {
  const _ModalRunning(this.secondsRemaining);
  

 final  int secondsRemaining;

/// Create a copy of ChatTimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModalRunningCopyWith<_ModalRunning> get copyWith => __$ModalRunningCopyWithImpl<_ModalRunning>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModalRunning&&(identical(other.secondsRemaining, secondsRemaining) || other.secondsRemaining == secondsRemaining));
}


@override
int get hashCode => Object.hash(runtimeType,secondsRemaining);

@override
String toString() {
  return 'ChatTimerState.modalRunning(secondsRemaining: $secondsRemaining)';
}


}

/// @nodoc
abstract mixin class _$ModalRunningCopyWith<$Res> implements $ChatTimerStateCopyWith<$Res> {
  factory _$ModalRunningCopyWith(_ModalRunning value, $Res Function(_ModalRunning) _then) = __$ModalRunningCopyWithImpl;
@useResult
$Res call({
 int secondsRemaining
});




}
/// @nodoc
class __$ModalRunningCopyWithImpl<$Res>
    implements _$ModalRunningCopyWith<$Res> {
  __$ModalRunningCopyWithImpl(this._self, this._then);

  final _ModalRunning _self;
  final $Res Function(_ModalRunning) _then;

/// Create a copy of ChatTimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? secondsRemaining = null,}) {
  return _then(_ModalRunning(
null == secondsRemaining ? _self.secondsRemaining : secondsRemaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ModalFinished implements ChatTimerState {
  const _ModalFinished();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModalFinished);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatTimerState.modalFinished()';
}


}




// dart format on
