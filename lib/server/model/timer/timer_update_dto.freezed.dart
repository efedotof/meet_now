// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_update_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimerUpdateDto {

 String get tempChatId; int get remainingTime; bool get finished;
/// Create a copy of TimerUpdateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimerUpdateDtoCopyWith<TimerUpdateDto> get copyWith => _$TimerUpdateDtoCopyWithImpl<TimerUpdateDto>(this as TimerUpdateDto, _$identity);

  /// Serializes this TimerUpdateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimerUpdateDto&&(identical(other.tempChatId, tempChatId) || other.tempChatId == tempChatId)&&(identical(other.remainingTime, remainingTime) || other.remainingTime == remainingTime)&&(identical(other.finished, finished) || other.finished == finished));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tempChatId,remainingTime,finished);

@override
String toString() {
  return 'TimerUpdateDto(tempChatId: $tempChatId, remainingTime: $remainingTime, finished: $finished)';
}


}

/// @nodoc
abstract mixin class $TimerUpdateDtoCopyWith<$Res>  {
  factory $TimerUpdateDtoCopyWith(TimerUpdateDto value, $Res Function(TimerUpdateDto) _then) = _$TimerUpdateDtoCopyWithImpl;
@useResult
$Res call({
 String tempChatId, int remainingTime, bool finished
});




}
/// @nodoc
class _$TimerUpdateDtoCopyWithImpl<$Res>
    implements $TimerUpdateDtoCopyWith<$Res> {
  _$TimerUpdateDtoCopyWithImpl(this._self, this._then);

  final TimerUpdateDto _self;
  final $Res Function(TimerUpdateDto) _then;

/// Create a copy of TimerUpdateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tempChatId = null,Object? remainingTime = null,Object? finished = null,}) {
  return _then(_self.copyWith(
tempChatId: null == tempChatId ? _self.tempChatId : tempChatId // ignore: cast_nullable_to_non_nullable
as String,remainingTime: null == remainingTime ? _self.remainingTime : remainingTime // ignore: cast_nullable_to_non_nullable
as int,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TimerUpdateDto].
extension TimerUpdateDtoPatterns on TimerUpdateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimerUpdateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimerUpdateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimerUpdateDto value)  $default,){
final _that = this;
switch (_that) {
case _TimerUpdateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimerUpdateDto value)?  $default,){
final _that = this;
switch (_that) {
case _TimerUpdateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tempChatId,  int remainingTime,  bool finished)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimerUpdateDto() when $default != null:
return $default(_that.tempChatId,_that.remainingTime,_that.finished);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tempChatId,  int remainingTime,  bool finished)  $default,) {final _that = this;
switch (_that) {
case _TimerUpdateDto():
return $default(_that.tempChatId,_that.remainingTime,_that.finished);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tempChatId,  int remainingTime,  bool finished)?  $default,) {final _that = this;
switch (_that) {
case _TimerUpdateDto() when $default != null:
return $default(_that.tempChatId,_that.remainingTime,_that.finished);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimerUpdateDto implements TimerUpdateDto {
  const _TimerUpdateDto({required this.tempChatId, required this.remainingTime, required this.finished});
  factory _TimerUpdateDto.fromJson(Map<String, dynamic> json) => _$TimerUpdateDtoFromJson(json);

@override final  String tempChatId;
@override final  int remainingTime;
@override final  bool finished;

/// Create a copy of TimerUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimerUpdateDtoCopyWith<_TimerUpdateDto> get copyWith => __$TimerUpdateDtoCopyWithImpl<_TimerUpdateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimerUpdateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimerUpdateDto&&(identical(other.tempChatId, tempChatId) || other.tempChatId == tempChatId)&&(identical(other.remainingTime, remainingTime) || other.remainingTime == remainingTime)&&(identical(other.finished, finished) || other.finished == finished));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tempChatId,remainingTime,finished);

@override
String toString() {
  return 'TimerUpdateDto(tempChatId: $tempChatId, remainingTime: $remainingTime, finished: $finished)';
}


}

/// @nodoc
abstract mixin class _$TimerUpdateDtoCopyWith<$Res> implements $TimerUpdateDtoCopyWith<$Res> {
  factory _$TimerUpdateDtoCopyWith(_TimerUpdateDto value, $Res Function(_TimerUpdateDto) _then) = __$TimerUpdateDtoCopyWithImpl;
@override @useResult
$Res call({
 String tempChatId, int remainingTime, bool finished
});




}
/// @nodoc
class __$TimerUpdateDtoCopyWithImpl<$Res>
    implements _$TimerUpdateDtoCopyWith<$Res> {
  __$TimerUpdateDtoCopyWithImpl(this._self, this._then);

  final _TimerUpdateDto _self;
  final $Res Function(_TimerUpdateDto) _then;

/// Create a copy of TimerUpdateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tempChatId = null,Object? remainingTime = null,Object? finished = null,}) {
  return _then(_TimerUpdateDto(
tempChatId: null == tempChatId ? _self.tempChatId : tempChatId // ignore: cast_nullable_to_non_nullable
as String,remainingTime: null == remainingTime ? _self.remainingTime : remainingTime // ignore: cast_nullable_to_non_nullable
as int,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
