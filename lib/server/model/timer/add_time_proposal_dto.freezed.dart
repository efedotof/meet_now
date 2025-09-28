// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_time_proposal_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddTimeProposalDto {

 String get tempChatId; String get fromUserId; int get additionalMinutes;
/// Create a copy of AddTimeProposalDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddTimeProposalDtoCopyWith<AddTimeProposalDto> get copyWith => _$AddTimeProposalDtoCopyWithImpl<AddTimeProposalDto>(this as AddTimeProposalDto, _$identity);

  /// Serializes this AddTimeProposalDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddTimeProposalDto&&(identical(other.tempChatId, tempChatId) || other.tempChatId == tempChatId)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.additionalMinutes, additionalMinutes) || other.additionalMinutes == additionalMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tempChatId,fromUserId,additionalMinutes);

@override
String toString() {
  return 'AddTimeProposalDto(tempChatId: $tempChatId, fromUserId: $fromUserId, additionalMinutes: $additionalMinutes)';
}


}

/// @nodoc
abstract mixin class $AddTimeProposalDtoCopyWith<$Res>  {
  factory $AddTimeProposalDtoCopyWith(AddTimeProposalDto value, $Res Function(AddTimeProposalDto) _then) = _$AddTimeProposalDtoCopyWithImpl;
@useResult
$Res call({
 String tempChatId, String fromUserId, int additionalMinutes
});




}
/// @nodoc
class _$AddTimeProposalDtoCopyWithImpl<$Res>
    implements $AddTimeProposalDtoCopyWith<$Res> {
  _$AddTimeProposalDtoCopyWithImpl(this._self, this._then);

  final AddTimeProposalDto _self;
  final $Res Function(AddTimeProposalDto) _then;

/// Create a copy of AddTimeProposalDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tempChatId = null,Object? fromUserId = null,Object? additionalMinutes = null,}) {
  return _then(_self.copyWith(
tempChatId: null == tempChatId ? _self.tempChatId : tempChatId // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,additionalMinutes: null == additionalMinutes ? _self.additionalMinutes : additionalMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AddTimeProposalDto].
extension AddTimeProposalDtoPatterns on AddTimeProposalDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddTimeProposalDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddTimeProposalDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddTimeProposalDto value)  $default,){
final _that = this;
switch (_that) {
case _AddTimeProposalDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddTimeProposalDto value)?  $default,){
final _that = this;
switch (_that) {
case _AddTimeProposalDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tempChatId,  String fromUserId,  int additionalMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddTimeProposalDto() when $default != null:
return $default(_that.tempChatId,_that.fromUserId,_that.additionalMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tempChatId,  String fromUserId,  int additionalMinutes)  $default,) {final _that = this;
switch (_that) {
case _AddTimeProposalDto():
return $default(_that.tempChatId,_that.fromUserId,_that.additionalMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tempChatId,  String fromUserId,  int additionalMinutes)?  $default,) {final _that = this;
switch (_that) {
case _AddTimeProposalDto() when $default != null:
return $default(_that.tempChatId,_that.fromUserId,_that.additionalMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddTimeProposalDto implements AddTimeProposalDto {
  const _AddTimeProposalDto({required this.tempChatId, required this.fromUserId, required this.additionalMinutes});
  factory _AddTimeProposalDto.fromJson(Map<String, dynamic> json) => _$AddTimeProposalDtoFromJson(json);

@override final  String tempChatId;
@override final  String fromUserId;
@override final  int additionalMinutes;

/// Create a copy of AddTimeProposalDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddTimeProposalDtoCopyWith<_AddTimeProposalDto> get copyWith => __$AddTimeProposalDtoCopyWithImpl<_AddTimeProposalDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddTimeProposalDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddTimeProposalDto&&(identical(other.tempChatId, tempChatId) || other.tempChatId == tempChatId)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.additionalMinutes, additionalMinutes) || other.additionalMinutes == additionalMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tempChatId,fromUserId,additionalMinutes);

@override
String toString() {
  return 'AddTimeProposalDto(tempChatId: $tempChatId, fromUserId: $fromUserId, additionalMinutes: $additionalMinutes)';
}


}

/// @nodoc
abstract mixin class _$AddTimeProposalDtoCopyWith<$Res> implements $AddTimeProposalDtoCopyWith<$Res> {
  factory _$AddTimeProposalDtoCopyWith(_AddTimeProposalDto value, $Res Function(_AddTimeProposalDto) _then) = __$AddTimeProposalDtoCopyWithImpl;
@override @useResult
$Res call({
 String tempChatId, String fromUserId, int additionalMinutes
});




}
/// @nodoc
class __$AddTimeProposalDtoCopyWithImpl<$Res>
    implements _$AddTimeProposalDtoCopyWith<$Res> {
  __$AddTimeProposalDtoCopyWithImpl(this._self, this._then);

  final _AddTimeProposalDto _self;
  final $Res Function(_AddTimeProposalDto) _then;

/// Create a copy of AddTimeProposalDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tempChatId = null,Object? fromUserId = null,Object? additionalMinutes = null,}) {
  return _then(_AddTimeProposalDto(
tempChatId: null == tempChatId ? _self.tempChatId : tempChatId // ignore: cast_nullable_to_non_nullable
as String,fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,additionalMinutes: null == additionalMinutes ? _self.additionalMinutes : additionalMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
