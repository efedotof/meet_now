// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_time_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddTimeResponseDto {

 String get tempChatId; String get userId; bool get accepted; int get additionalMinutes;
/// Create a copy of AddTimeResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddTimeResponseDtoCopyWith<AddTimeResponseDto> get copyWith => _$AddTimeResponseDtoCopyWithImpl<AddTimeResponseDto>(this as AddTimeResponseDto, _$identity);

  /// Serializes this AddTimeResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddTimeResponseDto&&(identical(other.tempChatId, tempChatId) || other.tempChatId == tempChatId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.accepted, accepted) || other.accepted == accepted)&&(identical(other.additionalMinutes, additionalMinutes) || other.additionalMinutes == additionalMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tempChatId,userId,accepted,additionalMinutes);

@override
String toString() {
  return 'AddTimeResponseDto(tempChatId: $tempChatId, userId: $userId, accepted: $accepted, additionalMinutes: $additionalMinutes)';
}


}

/// @nodoc
abstract mixin class $AddTimeResponseDtoCopyWith<$Res>  {
  factory $AddTimeResponseDtoCopyWith(AddTimeResponseDto value, $Res Function(AddTimeResponseDto) _then) = _$AddTimeResponseDtoCopyWithImpl;
@useResult
$Res call({
 String tempChatId, String userId, bool accepted, int additionalMinutes
});




}
/// @nodoc
class _$AddTimeResponseDtoCopyWithImpl<$Res>
    implements $AddTimeResponseDtoCopyWith<$Res> {
  _$AddTimeResponseDtoCopyWithImpl(this._self, this._then);

  final AddTimeResponseDto _self;
  final $Res Function(AddTimeResponseDto) _then;

/// Create a copy of AddTimeResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tempChatId = null,Object? userId = null,Object? accepted = null,Object? additionalMinutes = null,}) {
  return _then(_self.copyWith(
tempChatId: null == tempChatId ? _self.tempChatId : tempChatId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,additionalMinutes: null == additionalMinutes ? _self.additionalMinutes : additionalMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AddTimeResponseDto].
extension AddTimeResponseDtoPatterns on AddTimeResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddTimeResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddTimeResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddTimeResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _AddTimeResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddTimeResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _AddTimeResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tempChatId,  String userId,  bool accepted,  int additionalMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddTimeResponseDto() when $default != null:
return $default(_that.tempChatId,_that.userId,_that.accepted,_that.additionalMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tempChatId,  String userId,  bool accepted,  int additionalMinutes)  $default,) {final _that = this;
switch (_that) {
case _AddTimeResponseDto():
return $default(_that.tempChatId,_that.userId,_that.accepted,_that.additionalMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tempChatId,  String userId,  bool accepted,  int additionalMinutes)?  $default,) {final _that = this;
switch (_that) {
case _AddTimeResponseDto() when $default != null:
return $default(_that.tempChatId,_that.userId,_that.accepted,_that.additionalMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddTimeResponseDto implements AddTimeResponseDto {
  const _AddTimeResponseDto({required this.tempChatId, required this.userId, required this.accepted, required this.additionalMinutes});
  factory _AddTimeResponseDto.fromJson(Map<String, dynamic> json) => _$AddTimeResponseDtoFromJson(json);

@override final  String tempChatId;
@override final  String userId;
@override final  bool accepted;
@override final  int additionalMinutes;

/// Create a copy of AddTimeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddTimeResponseDtoCopyWith<_AddTimeResponseDto> get copyWith => __$AddTimeResponseDtoCopyWithImpl<_AddTimeResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddTimeResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddTimeResponseDto&&(identical(other.tempChatId, tempChatId) || other.tempChatId == tempChatId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.accepted, accepted) || other.accepted == accepted)&&(identical(other.additionalMinutes, additionalMinutes) || other.additionalMinutes == additionalMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tempChatId,userId,accepted,additionalMinutes);

@override
String toString() {
  return 'AddTimeResponseDto(tempChatId: $tempChatId, userId: $userId, accepted: $accepted, additionalMinutes: $additionalMinutes)';
}


}

/// @nodoc
abstract mixin class _$AddTimeResponseDtoCopyWith<$Res> implements $AddTimeResponseDtoCopyWith<$Res> {
  factory _$AddTimeResponseDtoCopyWith(_AddTimeResponseDto value, $Res Function(_AddTimeResponseDto) _then) = __$AddTimeResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String tempChatId, String userId, bool accepted, int additionalMinutes
});




}
/// @nodoc
class __$AddTimeResponseDtoCopyWithImpl<$Res>
    implements _$AddTimeResponseDtoCopyWith<$Res> {
  __$AddTimeResponseDtoCopyWithImpl(this._self, this._then);

  final _AddTimeResponseDto _self;
  final $Res Function(_AddTimeResponseDto) _then;

/// Create a copy of AddTimeResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tempChatId = null,Object? userId = null,Object? accepted = null,Object? additionalMinutes = null,}) {
  return _then(_AddTimeResponseDto(
tempChatId: null == tempChatId ? _self.tempChatId : tempChatId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,accepted: null == accepted ? _self.accepted : accepted // ignore: cast_nullable_to_non_nullable
as bool,additionalMinutes: null == additionalMinutes ? _self.additionalMinutes : additionalMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
