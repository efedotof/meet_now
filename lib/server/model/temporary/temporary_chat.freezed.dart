// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'temporary_chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TemporaryChat {

@HiveField(0) String get tempChatId;@HiveField(1) String get senderId;@HiveField(2) String get recipientId;@HiveField(3) DateTime get createdAt;@HiveField(4) int get durationMinutes;@HiveField(5) bool get isFinished;@HiveField(6) bool get bothAgreed;
/// Create a copy of TemporaryChat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemporaryChatCopyWith<TemporaryChat> get copyWith => _$TemporaryChatCopyWithImpl<TemporaryChat>(this as TemporaryChat, _$identity);

  /// Serializes this TemporaryChat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemporaryChat&&(identical(other.tempChatId, tempChatId) || other.tempChatId == tempChatId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.bothAgreed, bothAgreed) || other.bothAgreed == bothAgreed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tempChatId,senderId,recipientId,createdAt,durationMinutes,isFinished,bothAgreed);

@override
String toString() {
  return 'TemporaryChat(tempChatId: $tempChatId, senderId: $senderId, recipientId: $recipientId, createdAt: $createdAt, durationMinutes: $durationMinutes, isFinished: $isFinished, bothAgreed: $bothAgreed)';
}


}

/// @nodoc
abstract mixin class $TemporaryChatCopyWith<$Res>  {
  factory $TemporaryChatCopyWith(TemporaryChat value, $Res Function(TemporaryChat) _then) = _$TemporaryChatCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String tempChatId,@HiveField(1) String senderId,@HiveField(2) String recipientId,@HiveField(3) DateTime createdAt,@HiveField(4) int durationMinutes,@HiveField(5) bool isFinished,@HiveField(6) bool bothAgreed
});




}
/// @nodoc
class _$TemporaryChatCopyWithImpl<$Res>
    implements $TemporaryChatCopyWith<$Res> {
  _$TemporaryChatCopyWithImpl(this._self, this._then);

  final TemporaryChat _self;
  final $Res Function(TemporaryChat) _then;

/// Create a copy of TemporaryChat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tempChatId = null,Object? senderId = null,Object? recipientId = null,Object? createdAt = null,Object? durationMinutes = null,Object? isFinished = null,Object? bothAgreed = null,}) {
  return _then(_self.copyWith(
tempChatId: null == tempChatId ? _self.tempChatId : tempChatId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,recipientId: null == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,bothAgreed: null == bothAgreed ? _self.bothAgreed : bothAgreed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TemporaryChat].
extension TemporaryChatPatterns on TemporaryChat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemporaryChat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemporaryChat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemporaryChat value)  $default,){
final _that = this;
switch (_that) {
case _TemporaryChat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemporaryChat value)?  $default,){
final _that = this;
switch (_that) {
case _TemporaryChat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String tempChatId, @HiveField(1)  String senderId, @HiveField(2)  String recipientId, @HiveField(3)  DateTime createdAt, @HiveField(4)  int durationMinutes, @HiveField(5)  bool isFinished, @HiveField(6)  bool bothAgreed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemporaryChat() when $default != null:
return $default(_that.tempChatId,_that.senderId,_that.recipientId,_that.createdAt,_that.durationMinutes,_that.isFinished,_that.bothAgreed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String tempChatId, @HiveField(1)  String senderId, @HiveField(2)  String recipientId, @HiveField(3)  DateTime createdAt, @HiveField(4)  int durationMinutes, @HiveField(5)  bool isFinished, @HiveField(6)  bool bothAgreed)  $default,) {final _that = this;
switch (_that) {
case _TemporaryChat():
return $default(_that.tempChatId,_that.senderId,_that.recipientId,_that.createdAt,_that.durationMinutes,_that.isFinished,_that.bothAgreed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String tempChatId, @HiveField(1)  String senderId, @HiveField(2)  String recipientId, @HiveField(3)  DateTime createdAt, @HiveField(4)  int durationMinutes, @HiveField(5)  bool isFinished, @HiveField(6)  bool bothAgreed)?  $default,) {final _that = this;
switch (_that) {
case _TemporaryChat() when $default != null:
return $default(_that.tempChatId,_that.senderId,_that.recipientId,_that.createdAt,_that.durationMinutes,_that.isFinished,_that.bothAgreed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemporaryChat implements TemporaryChat {
  const _TemporaryChat({@HiveField(0) required this.tempChatId, @HiveField(1) required this.senderId, @HiveField(2) required this.recipientId, @HiveField(3) required this.createdAt, @HiveField(4) required this.durationMinutes, @HiveField(5) required this.isFinished, @HiveField(6) required this.bothAgreed});
  factory _TemporaryChat.fromJson(Map<String, dynamic> json) => _$TemporaryChatFromJson(json);

@override@HiveField(0) final  String tempChatId;
@override@HiveField(1) final  String senderId;
@override@HiveField(2) final  String recipientId;
@override@HiveField(3) final  DateTime createdAt;
@override@HiveField(4) final  int durationMinutes;
@override@HiveField(5) final  bool isFinished;
@override@HiveField(6) final  bool bothAgreed;

/// Create a copy of TemporaryChat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemporaryChatCopyWith<_TemporaryChat> get copyWith => __$TemporaryChatCopyWithImpl<_TemporaryChat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemporaryChatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemporaryChat&&(identical(other.tempChatId, tempChatId) || other.tempChatId == tempChatId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.bothAgreed, bothAgreed) || other.bothAgreed == bothAgreed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tempChatId,senderId,recipientId,createdAt,durationMinutes,isFinished,bothAgreed);

@override
String toString() {
  return 'TemporaryChat(tempChatId: $tempChatId, senderId: $senderId, recipientId: $recipientId, createdAt: $createdAt, durationMinutes: $durationMinutes, isFinished: $isFinished, bothAgreed: $bothAgreed)';
}


}

/// @nodoc
abstract mixin class _$TemporaryChatCopyWith<$Res> implements $TemporaryChatCopyWith<$Res> {
  factory _$TemporaryChatCopyWith(_TemporaryChat value, $Res Function(_TemporaryChat) _then) = __$TemporaryChatCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String tempChatId,@HiveField(1) String senderId,@HiveField(2) String recipientId,@HiveField(3) DateTime createdAt,@HiveField(4) int durationMinutes,@HiveField(5) bool isFinished,@HiveField(6) bool bothAgreed
});




}
/// @nodoc
class __$TemporaryChatCopyWithImpl<$Res>
    implements _$TemporaryChatCopyWith<$Res> {
  __$TemporaryChatCopyWithImpl(this._self, this._then);

  final _TemporaryChat _self;
  final $Res Function(_TemporaryChat) _then;

/// Create a copy of TemporaryChat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tempChatId = null,Object? senderId = null,Object? recipientId = null,Object? createdAt = null,Object? durationMinutes = null,Object? isFinished = null,Object? bothAgreed = null,}) {
  return _then(_TemporaryChat(
tempChatId: null == tempChatId ? _self.tempChatId : tempChatId // ignore: cast_nullable_to_non_nullable
as String,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,recipientId: null == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,bothAgreed: null == bothAgreed ? _self.bothAgreed : bothAgreed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
