// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatGame {

 String get id; Chat get chat; String get gameType; String get state;
/// Create a copy of ChatGame
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatGameCopyWith<ChatGame> get copyWith => _$ChatGameCopyWithImpl<ChatGame>(this as ChatGame, _$identity);

  /// Serializes this ChatGame to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatGame&&(identical(other.id, id) || other.id == id)&&(identical(other.chat, chat) || other.chat == chat)&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.state, state) || other.state == state));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chat,gameType,state);

@override
String toString() {
  return 'ChatGame(id: $id, chat: $chat, gameType: $gameType, state: $state)';
}


}

/// @nodoc
abstract mixin class $ChatGameCopyWith<$Res>  {
  factory $ChatGameCopyWith(ChatGame value, $Res Function(ChatGame) _then) = _$ChatGameCopyWithImpl;
@useResult
$Res call({
 String id, Chat chat, String gameType, String state
});


$ChatCopyWith<$Res> get chat;

}
/// @nodoc
class _$ChatGameCopyWithImpl<$Res>
    implements $ChatGameCopyWith<$Res> {
  _$ChatGameCopyWithImpl(this._self, this._then);

  final ChatGame _self;
  final $Res Function(ChatGame) _then;

/// Create a copy of ChatGame
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? chat = null,Object? gameType = null,Object? state = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chat: null == chat ? _self.chat : chat // ignore: cast_nullable_to_non_nullable
as Chat,gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of ChatGame
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCopyWith<$Res> get chat {
  
  return $ChatCopyWith<$Res>(_self.chat, (value) {
    return _then(_self.copyWith(chat: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatGame].
extension ChatGamePatterns on ChatGame {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatGame value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatGame() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatGame value)  $default,){
final _that = this;
switch (_that) {
case _ChatGame():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatGame value)?  $default,){
final _that = this;
switch (_that) {
case _ChatGame() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Chat chat,  String gameType,  String state)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatGame() when $default != null:
return $default(_that.id,_that.chat,_that.gameType,_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Chat chat,  String gameType,  String state)  $default,) {final _that = this;
switch (_that) {
case _ChatGame():
return $default(_that.id,_that.chat,_that.gameType,_that.state);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Chat chat,  String gameType,  String state)?  $default,) {final _that = this;
switch (_that) {
case _ChatGame() when $default != null:
return $default(_that.id,_that.chat,_that.gameType,_that.state);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatGame implements ChatGame {
  const _ChatGame({required this.id, required this.chat, required this.gameType, required this.state});
  factory _ChatGame.fromJson(Map<String, dynamic> json) => _$ChatGameFromJson(json);

@override final  String id;
@override final  Chat chat;
@override final  String gameType;
@override final  String state;

/// Create a copy of ChatGame
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatGameCopyWith<_ChatGame> get copyWith => __$ChatGameCopyWithImpl<_ChatGame>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatGameToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatGame&&(identical(other.id, id) || other.id == id)&&(identical(other.chat, chat) || other.chat == chat)&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.state, state) || other.state == state));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chat,gameType,state);

@override
String toString() {
  return 'ChatGame(id: $id, chat: $chat, gameType: $gameType, state: $state)';
}


}

/// @nodoc
abstract mixin class _$ChatGameCopyWith<$Res> implements $ChatGameCopyWith<$Res> {
  factory _$ChatGameCopyWith(_ChatGame value, $Res Function(_ChatGame) _then) = __$ChatGameCopyWithImpl;
@override @useResult
$Res call({
 String id, Chat chat, String gameType, String state
});


@override $ChatCopyWith<$Res> get chat;

}
/// @nodoc
class __$ChatGameCopyWithImpl<$Res>
    implements _$ChatGameCopyWith<$Res> {
  __$ChatGameCopyWithImpl(this._self, this._then);

  final _ChatGame _self;
  final $Res Function(_ChatGame) _then;

/// Create a copy of ChatGame
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? chat = null,Object? gameType = null,Object? state = null,}) {
  return _then(_ChatGame(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,chat: null == chat ? _self.chat : chat // ignore: cast_nullable_to_non_nullable
as Chat,gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ChatGame
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCopyWith<$Res> get chat {
  
  return $ChatCopyWith<$Res>(_self.chat, (value) {
    return _then(_self.copyWith(chat: value));
  });
}
}

// dart format on
