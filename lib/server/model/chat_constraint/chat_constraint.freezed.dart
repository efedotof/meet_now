// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_constraint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatConstraint {

 String get id; Chat get temporaryChat; int get waitSeconds; bool get canStart;
/// Create a copy of ChatConstraint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatConstraintCopyWith<ChatConstraint> get copyWith => _$ChatConstraintCopyWithImpl<ChatConstraint>(this as ChatConstraint, _$identity);

  /// Serializes this ChatConstraint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatConstraint&&(identical(other.id, id) || other.id == id)&&(identical(other.temporaryChat, temporaryChat) || other.temporaryChat == temporaryChat)&&(identical(other.waitSeconds, waitSeconds) || other.waitSeconds == waitSeconds)&&(identical(other.canStart, canStart) || other.canStart == canStart));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,temporaryChat,waitSeconds,canStart);

@override
String toString() {
  return 'ChatConstraint(id: $id, temporaryChat: $temporaryChat, waitSeconds: $waitSeconds, canStart: $canStart)';
}


}

/// @nodoc
abstract mixin class $ChatConstraintCopyWith<$Res>  {
  factory $ChatConstraintCopyWith(ChatConstraint value, $Res Function(ChatConstraint) _then) = _$ChatConstraintCopyWithImpl;
@useResult
$Res call({
 String id, Chat temporaryChat, int waitSeconds, bool canStart
});


$ChatCopyWith<$Res> get temporaryChat;

}
/// @nodoc
class _$ChatConstraintCopyWithImpl<$Res>
    implements $ChatConstraintCopyWith<$Res> {
  _$ChatConstraintCopyWithImpl(this._self, this._then);

  final ChatConstraint _self;
  final $Res Function(ChatConstraint) _then;

/// Create a copy of ChatConstraint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? temporaryChat = null,Object? waitSeconds = null,Object? canStart = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,temporaryChat: null == temporaryChat ? _self.temporaryChat : temporaryChat // ignore: cast_nullable_to_non_nullable
as Chat,waitSeconds: null == waitSeconds ? _self.waitSeconds : waitSeconds // ignore: cast_nullable_to_non_nullable
as int,canStart: null == canStart ? _self.canStart : canStart // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of ChatConstraint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCopyWith<$Res> get temporaryChat {
  
  return $ChatCopyWith<$Res>(_self.temporaryChat, (value) {
    return _then(_self.copyWith(temporaryChat: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatConstraint].
extension ChatConstraintPatterns on ChatConstraint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatConstraint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatConstraint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatConstraint value)  $default,){
final _that = this;
switch (_that) {
case _ChatConstraint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatConstraint value)?  $default,){
final _that = this;
switch (_that) {
case _ChatConstraint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Chat temporaryChat,  int waitSeconds,  bool canStart)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatConstraint() when $default != null:
return $default(_that.id,_that.temporaryChat,_that.waitSeconds,_that.canStart);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Chat temporaryChat,  int waitSeconds,  bool canStart)  $default,) {final _that = this;
switch (_that) {
case _ChatConstraint():
return $default(_that.id,_that.temporaryChat,_that.waitSeconds,_that.canStart);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Chat temporaryChat,  int waitSeconds,  bool canStart)?  $default,) {final _that = this;
switch (_that) {
case _ChatConstraint() when $default != null:
return $default(_that.id,_that.temporaryChat,_that.waitSeconds,_that.canStart);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatConstraint implements ChatConstraint {
  const _ChatConstraint({required this.id, required this.temporaryChat, this.waitSeconds = 30, this.canStart = false});
  factory _ChatConstraint.fromJson(Map<String, dynamic> json) => _$ChatConstraintFromJson(json);

@override final  String id;
@override final  Chat temporaryChat;
@override@JsonKey() final  int waitSeconds;
@override@JsonKey() final  bool canStart;

/// Create a copy of ChatConstraint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatConstraintCopyWith<_ChatConstraint> get copyWith => __$ChatConstraintCopyWithImpl<_ChatConstraint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatConstraintToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatConstraint&&(identical(other.id, id) || other.id == id)&&(identical(other.temporaryChat, temporaryChat) || other.temporaryChat == temporaryChat)&&(identical(other.waitSeconds, waitSeconds) || other.waitSeconds == waitSeconds)&&(identical(other.canStart, canStart) || other.canStart == canStart));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,temporaryChat,waitSeconds,canStart);

@override
String toString() {
  return 'ChatConstraint(id: $id, temporaryChat: $temporaryChat, waitSeconds: $waitSeconds, canStart: $canStart)';
}


}

/// @nodoc
abstract mixin class _$ChatConstraintCopyWith<$Res> implements $ChatConstraintCopyWith<$Res> {
  factory _$ChatConstraintCopyWith(_ChatConstraint value, $Res Function(_ChatConstraint) _then) = __$ChatConstraintCopyWithImpl;
@override @useResult
$Res call({
 String id, Chat temporaryChat, int waitSeconds, bool canStart
});


@override $ChatCopyWith<$Res> get temporaryChat;

}
/// @nodoc
class __$ChatConstraintCopyWithImpl<$Res>
    implements _$ChatConstraintCopyWith<$Res> {
  __$ChatConstraintCopyWithImpl(this._self, this._then);

  final _ChatConstraint _self;
  final $Res Function(_ChatConstraint) _then;

/// Create a copy of ChatConstraint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? temporaryChat = null,Object? waitSeconds = null,Object? canStart = null,}) {
  return _then(_ChatConstraint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,temporaryChat: null == temporaryChat ? _self.temporaryChat : temporaryChat // ignore: cast_nullable_to_non_nullable
as Chat,waitSeconds: null == waitSeconds ? _self.waitSeconds : waitSeconds // ignore: cast_nullable_to_non_nullable
as int,canStart: null == canStart ? _self.canStart : canStart // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of ChatConstraint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCopyWith<$Res> get temporaryChat {
  
  return $ChatCopyWith<$Res>(_self.temporaryChat, (value) {
    return _then(_self.copyWith(temporaryChat: value));
  });
}
}

// dart format on
