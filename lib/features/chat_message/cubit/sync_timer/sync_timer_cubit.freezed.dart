// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_timer_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SyncTimerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncTimerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncTimerState()';
}


}

/// @nodoc
class $SyncTimerStateCopyWith<$Res>  {
$SyncTimerStateCopyWith(SyncTimerState _, $Res Function(SyncTimerState) __);
}


/// Adds pattern-matching-related methods to [SyncTimerState].
extension SyncTimerStatePatterns on SyncTimerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Running value)?  running,TResult Function( _Finished value)?  finished,TResult Function( _AddTimeProposed value)?  addTimeProposed,TResult Function( _WaitingForResponse value)?  waitingForResponse,TResult Function( _TimeAdded value)?  timeAdded,TResult Function( _TimeRejected value)?  timeRejected,TResult Function( _TimeOptions value)?  timeOptions,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Running() when running != null:
return running(_that);case _Finished() when finished != null:
return finished(_that);case _AddTimeProposed() when addTimeProposed != null:
return addTimeProposed(_that);case _WaitingForResponse() when waitingForResponse != null:
return waitingForResponse(_that);case _TimeAdded() when timeAdded != null:
return timeAdded(_that);case _TimeRejected() when timeRejected != null:
return timeRejected(_that);case _TimeOptions() when timeOptions != null:
return timeOptions(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Running value)  running,required TResult Function( _Finished value)  finished,required TResult Function( _AddTimeProposed value)  addTimeProposed,required TResult Function( _WaitingForResponse value)  waitingForResponse,required TResult Function( _TimeAdded value)  timeAdded,required TResult Function( _TimeRejected value)  timeRejected,required TResult Function( _TimeOptions value)  timeOptions,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Running():
return running(_that);case _Finished():
return finished(_that);case _AddTimeProposed():
return addTimeProposed(_that);case _WaitingForResponse():
return waitingForResponse(_that);case _TimeAdded():
return timeAdded(_that);case _TimeRejected():
return timeRejected(_that);case _TimeOptions():
return timeOptions(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Running value)?  running,TResult? Function( _Finished value)?  finished,TResult? Function( _AddTimeProposed value)?  addTimeProposed,TResult? Function( _WaitingForResponse value)?  waitingForResponse,TResult? Function( _TimeAdded value)?  timeAdded,TResult? Function( _TimeRejected value)?  timeRejected,TResult? Function( _TimeOptions value)?  timeOptions,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Running() when running != null:
return running(_that);case _Finished() when finished != null:
return finished(_that);case _AddTimeProposed() when addTimeProposed != null:
return addTimeProposed(_that);case _WaitingForResponse() when waitingForResponse != null:
return waitingForResponse(_that);case _TimeAdded() when timeAdded != null:
return timeAdded(_that);case _TimeRejected() when timeRejected != null:
return timeRejected(_that);case _TimeOptions() when timeOptions != null:
return timeOptions(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( int remainingTime,  String formattedTime)?  running,TResult Function()?  finished,TResult Function( int remainingTime,  String formattedTime,  int additionalMinutes,  String fromUserId)?  addTimeProposed,TResult Function( int remainingTime,  String formattedTime,  int additionalMinutes)?  waitingForResponse,TResult Function( int additionalMinutes)?  timeAdded,TResult Function()?  timeRejected,TResult Function( int remainingTime,  String formattedTime)?  timeOptions,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Running() when running != null:
return running(_that.remainingTime,_that.formattedTime);case _Finished() when finished != null:
return finished();case _AddTimeProposed() when addTimeProposed != null:
return addTimeProposed(_that.remainingTime,_that.formattedTime,_that.additionalMinutes,_that.fromUserId);case _WaitingForResponse() when waitingForResponse != null:
return waitingForResponse(_that.remainingTime,_that.formattedTime,_that.additionalMinutes);case _TimeAdded() when timeAdded != null:
return timeAdded(_that.additionalMinutes);case _TimeRejected() when timeRejected != null:
return timeRejected();case _TimeOptions() when timeOptions != null:
return timeOptions(_that.remainingTime,_that.formattedTime);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( int remainingTime,  String formattedTime)  running,required TResult Function()  finished,required TResult Function( int remainingTime,  String formattedTime,  int additionalMinutes,  String fromUserId)  addTimeProposed,required TResult Function( int remainingTime,  String formattedTime,  int additionalMinutes)  waitingForResponse,required TResult Function( int additionalMinutes)  timeAdded,required TResult Function()  timeRejected,required TResult Function( int remainingTime,  String formattedTime)  timeOptions,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Running():
return running(_that.remainingTime,_that.formattedTime);case _Finished():
return finished();case _AddTimeProposed():
return addTimeProposed(_that.remainingTime,_that.formattedTime,_that.additionalMinutes,_that.fromUserId);case _WaitingForResponse():
return waitingForResponse(_that.remainingTime,_that.formattedTime,_that.additionalMinutes);case _TimeAdded():
return timeAdded(_that.additionalMinutes);case _TimeRejected():
return timeRejected();case _TimeOptions():
return timeOptions(_that.remainingTime,_that.formattedTime);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( int remainingTime,  String formattedTime)?  running,TResult? Function()?  finished,TResult? Function( int remainingTime,  String formattedTime,  int additionalMinutes,  String fromUserId)?  addTimeProposed,TResult? Function( int remainingTime,  String formattedTime,  int additionalMinutes)?  waitingForResponse,TResult? Function( int additionalMinutes)?  timeAdded,TResult? Function()?  timeRejected,TResult? Function( int remainingTime,  String formattedTime)?  timeOptions,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Running() when running != null:
return running(_that.remainingTime,_that.formattedTime);case _Finished() when finished != null:
return finished();case _AddTimeProposed() when addTimeProposed != null:
return addTimeProposed(_that.remainingTime,_that.formattedTime,_that.additionalMinutes,_that.fromUserId);case _WaitingForResponse() when waitingForResponse != null:
return waitingForResponse(_that.remainingTime,_that.formattedTime,_that.additionalMinutes);case _TimeAdded() when timeAdded != null:
return timeAdded(_that.additionalMinutes);case _TimeRejected() when timeRejected != null:
return timeRejected();case _TimeOptions() when timeOptions != null:
return timeOptions(_that.remainingTime,_that.formattedTime);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends SyncTimerState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncTimerState.initial()';
}


}




/// @nodoc


class _Running extends SyncTimerState {
  const _Running({required this.remainingTime, required this.formattedTime}): super._();
  

 final  int remainingTime;
 final  String formattedTime;

/// Create a copy of SyncTimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunningCopyWith<_Running> get copyWith => __$RunningCopyWithImpl<_Running>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Running&&(identical(other.remainingTime, remainingTime) || other.remainingTime == remainingTime)&&(identical(other.formattedTime, formattedTime) || other.formattedTime == formattedTime));
}


@override
int get hashCode => Object.hash(runtimeType,remainingTime,formattedTime);

@override
String toString() {
  return 'SyncTimerState.running(remainingTime: $remainingTime, formattedTime: $formattedTime)';
}


}

/// @nodoc
abstract mixin class _$RunningCopyWith<$Res> implements $SyncTimerStateCopyWith<$Res> {
  factory _$RunningCopyWith(_Running value, $Res Function(_Running) _then) = __$RunningCopyWithImpl;
@useResult
$Res call({
 int remainingTime, String formattedTime
});




}
/// @nodoc
class __$RunningCopyWithImpl<$Res>
    implements _$RunningCopyWith<$Res> {
  __$RunningCopyWithImpl(this._self, this._then);

  final _Running _self;
  final $Res Function(_Running) _then;

/// Create a copy of SyncTimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? remainingTime = null,Object? formattedTime = null,}) {
  return _then(_Running(
remainingTime: null == remainingTime ? _self.remainingTime : remainingTime // ignore: cast_nullable_to_non_nullable
as int,formattedTime: null == formattedTime ? _self.formattedTime : formattedTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Finished extends SyncTimerState {
  const _Finished(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Finished);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncTimerState.finished()';
}


}




/// @nodoc


class _AddTimeProposed extends SyncTimerState {
  const _AddTimeProposed({required this.remainingTime, required this.formattedTime, required this.additionalMinutes, required this.fromUserId}): super._();
  

 final  int remainingTime;
 final  String formattedTime;
 final  int additionalMinutes;
 final  String fromUserId;

/// Create a copy of SyncTimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddTimeProposedCopyWith<_AddTimeProposed> get copyWith => __$AddTimeProposedCopyWithImpl<_AddTimeProposed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddTimeProposed&&(identical(other.remainingTime, remainingTime) || other.remainingTime == remainingTime)&&(identical(other.formattedTime, formattedTime) || other.formattedTime == formattedTime)&&(identical(other.additionalMinutes, additionalMinutes) || other.additionalMinutes == additionalMinutes)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId));
}


@override
int get hashCode => Object.hash(runtimeType,remainingTime,formattedTime,additionalMinutes,fromUserId);

@override
String toString() {
  return 'SyncTimerState.addTimeProposed(remainingTime: $remainingTime, formattedTime: $formattedTime, additionalMinutes: $additionalMinutes, fromUserId: $fromUserId)';
}


}

/// @nodoc
abstract mixin class _$AddTimeProposedCopyWith<$Res> implements $SyncTimerStateCopyWith<$Res> {
  factory _$AddTimeProposedCopyWith(_AddTimeProposed value, $Res Function(_AddTimeProposed) _then) = __$AddTimeProposedCopyWithImpl;
@useResult
$Res call({
 int remainingTime, String formattedTime, int additionalMinutes, String fromUserId
});




}
/// @nodoc
class __$AddTimeProposedCopyWithImpl<$Res>
    implements _$AddTimeProposedCopyWith<$Res> {
  __$AddTimeProposedCopyWithImpl(this._self, this._then);

  final _AddTimeProposed _self;
  final $Res Function(_AddTimeProposed) _then;

/// Create a copy of SyncTimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? remainingTime = null,Object? formattedTime = null,Object? additionalMinutes = null,Object? fromUserId = null,}) {
  return _then(_AddTimeProposed(
remainingTime: null == remainingTime ? _self.remainingTime : remainingTime // ignore: cast_nullable_to_non_nullable
as int,formattedTime: null == formattedTime ? _self.formattedTime : formattedTime // ignore: cast_nullable_to_non_nullable
as String,additionalMinutes: null == additionalMinutes ? _self.additionalMinutes : additionalMinutes // ignore: cast_nullable_to_non_nullable
as int,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _WaitingForResponse extends SyncTimerState {
  const _WaitingForResponse({required this.remainingTime, required this.formattedTime, required this.additionalMinutes}): super._();
  

 final  int remainingTime;
 final  String formattedTime;
 final  int additionalMinutes;

/// Create a copy of SyncTimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaitingForResponseCopyWith<_WaitingForResponse> get copyWith => __$WaitingForResponseCopyWithImpl<_WaitingForResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaitingForResponse&&(identical(other.remainingTime, remainingTime) || other.remainingTime == remainingTime)&&(identical(other.formattedTime, formattedTime) || other.formattedTime == formattedTime)&&(identical(other.additionalMinutes, additionalMinutes) || other.additionalMinutes == additionalMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,remainingTime,formattedTime,additionalMinutes);

@override
String toString() {
  return 'SyncTimerState.waitingForResponse(remainingTime: $remainingTime, formattedTime: $formattedTime, additionalMinutes: $additionalMinutes)';
}


}

/// @nodoc
abstract mixin class _$WaitingForResponseCopyWith<$Res> implements $SyncTimerStateCopyWith<$Res> {
  factory _$WaitingForResponseCopyWith(_WaitingForResponse value, $Res Function(_WaitingForResponse) _then) = __$WaitingForResponseCopyWithImpl;
@useResult
$Res call({
 int remainingTime, String formattedTime, int additionalMinutes
});




}
/// @nodoc
class __$WaitingForResponseCopyWithImpl<$Res>
    implements _$WaitingForResponseCopyWith<$Res> {
  __$WaitingForResponseCopyWithImpl(this._self, this._then);

  final _WaitingForResponse _self;
  final $Res Function(_WaitingForResponse) _then;

/// Create a copy of SyncTimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? remainingTime = null,Object? formattedTime = null,Object? additionalMinutes = null,}) {
  return _then(_WaitingForResponse(
remainingTime: null == remainingTime ? _self.remainingTime : remainingTime // ignore: cast_nullable_to_non_nullable
as int,formattedTime: null == formattedTime ? _self.formattedTime : formattedTime // ignore: cast_nullable_to_non_nullable
as String,additionalMinutes: null == additionalMinutes ? _self.additionalMinutes : additionalMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _TimeAdded extends SyncTimerState {
  const _TimeAdded({required this.additionalMinutes}): super._();
  

 final  int additionalMinutes;

/// Create a copy of SyncTimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeAddedCopyWith<_TimeAdded> get copyWith => __$TimeAddedCopyWithImpl<_TimeAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeAdded&&(identical(other.additionalMinutes, additionalMinutes) || other.additionalMinutes == additionalMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,additionalMinutes);

@override
String toString() {
  return 'SyncTimerState.timeAdded(additionalMinutes: $additionalMinutes)';
}


}

/// @nodoc
abstract mixin class _$TimeAddedCopyWith<$Res> implements $SyncTimerStateCopyWith<$Res> {
  factory _$TimeAddedCopyWith(_TimeAdded value, $Res Function(_TimeAdded) _then) = __$TimeAddedCopyWithImpl;
@useResult
$Res call({
 int additionalMinutes
});




}
/// @nodoc
class __$TimeAddedCopyWithImpl<$Res>
    implements _$TimeAddedCopyWith<$Res> {
  __$TimeAddedCopyWithImpl(this._self, this._then);

  final _TimeAdded _self;
  final $Res Function(_TimeAdded) _then;

/// Create a copy of SyncTimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? additionalMinutes = null,}) {
  return _then(_TimeAdded(
additionalMinutes: null == additionalMinutes ? _self.additionalMinutes : additionalMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _TimeRejected extends SyncTimerState {
  const _TimeRejected(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeRejected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SyncTimerState.timeRejected()';
}


}




/// @nodoc


class _TimeOptions extends SyncTimerState {
  const _TimeOptions({required this.remainingTime, required this.formattedTime}): super._();
  

 final  int remainingTime;
 final  String formattedTime;

/// Create a copy of SyncTimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeOptionsCopyWith<_TimeOptions> get copyWith => __$TimeOptionsCopyWithImpl<_TimeOptions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeOptions&&(identical(other.remainingTime, remainingTime) || other.remainingTime == remainingTime)&&(identical(other.formattedTime, formattedTime) || other.formattedTime == formattedTime));
}


@override
int get hashCode => Object.hash(runtimeType,remainingTime,formattedTime);

@override
String toString() {
  return 'SyncTimerState.timeOptions(remainingTime: $remainingTime, formattedTime: $formattedTime)';
}


}

/// @nodoc
abstract mixin class _$TimeOptionsCopyWith<$Res> implements $SyncTimerStateCopyWith<$Res> {
  factory _$TimeOptionsCopyWith(_TimeOptions value, $Res Function(_TimeOptions) _then) = __$TimeOptionsCopyWithImpl;
@useResult
$Res call({
 int remainingTime, String formattedTime
});




}
/// @nodoc
class __$TimeOptionsCopyWithImpl<$Res>
    implements _$TimeOptionsCopyWith<$Res> {
  __$TimeOptionsCopyWithImpl(this._self, this._then);

  final _TimeOptions _self;
  final $Res Function(_TimeOptions) _then;

/// Create a copy of SyncTimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? remainingTime = null,Object? formattedTime = null,}) {
  return _then(_TimeOptions(
remainingTime: null == remainingTime ? _self.remainingTime : remainingTime // ignore: cast_nullable_to_non_nullable
as int,formattedTime: null == formattedTime ? _self.formattedTime : formattedTime // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error extends SyncTimerState {
  const _Error(this.message): super._();
  

 final  String message;

/// Create a copy of SyncTimerState
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
  return 'SyncTimerState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $SyncTimerStateCopyWith<$Res> {
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

/// Create a copy of SyncTimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
