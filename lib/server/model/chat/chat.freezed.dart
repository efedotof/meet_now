// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Chat {

 String get chatId; User get user1; User get user2; DateTime get createdAt; bool get isOpened;
/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCopyWith<Chat> get copyWith => _$ChatCopyWithImpl<Chat>(this as Chat, _$identity);

  /// Serializes this Chat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Chat&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.user1, user1) || other.user1 == user1)&&(identical(other.user2, user2) || other.user2 == user2)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isOpened, isOpened) || other.isOpened == isOpened));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatId,user1,user2,createdAt,isOpened);

@override
String toString() {
  return 'Chat(chatId: $chatId, user1: $user1, user2: $user2, createdAt: $createdAt, isOpened: $isOpened)';
}


}

/// @nodoc
abstract mixin class $ChatCopyWith<$Res>  {
  factory $ChatCopyWith(Chat value, $Res Function(Chat) _then) = _$ChatCopyWithImpl;
@useResult
$Res call({
 String chatId, User user1, User user2, DateTime createdAt, bool isOpened
});


$UserCopyWith<$Res> get user1;$UserCopyWith<$Res> get user2;

}
/// @nodoc
class _$ChatCopyWithImpl<$Res>
    implements $ChatCopyWith<$Res> {
  _$ChatCopyWithImpl(this._self, this._then);

  final Chat _self;
  final $Res Function(Chat) _then;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatId = null,Object? user1 = null,Object? user2 = null,Object? createdAt = null,Object? isOpened = null,}) {
  return _then(_self.copyWith(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,user1: null == user1 ? _self.user1 : user1 // ignore: cast_nullable_to_non_nullable
as User,user2: null == user2 ? _self.user2 : user2 // ignore: cast_nullable_to_non_nullable
as User,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isOpened: null == isOpened ? _self.isOpened : isOpened // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user1 {
  
  return $UserCopyWith<$Res>(_self.user1, (value) {
    return _then(_self.copyWith(user1: value));
  });
}/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user2 {
  
  return $UserCopyWith<$Res>(_self.user2, (value) {
    return _then(_self.copyWith(user2: value));
  });
}
}


/// Adds pattern-matching-related methods to [Chat].
extension ChatPatterns on Chat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Chat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Chat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Chat value)  $default,){
final _that = this;
switch (_that) {
case _Chat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Chat value)?  $default,){
final _that = this;
switch (_that) {
case _Chat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String chatId,  User user1,  User user2,  DateTime createdAt,  bool isOpened)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that.chatId,_that.user1,_that.user2,_that.createdAt,_that.isOpened);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String chatId,  User user1,  User user2,  DateTime createdAt,  bool isOpened)  $default,) {final _that = this;
switch (_that) {
case _Chat():
return $default(_that.chatId,_that.user1,_that.user2,_that.createdAt,_that.isOpened);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String chatId,  User user1,  User user2,  DateTime createdAt,  bool isOpened)?  $default,) {final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that.chatId,_that.user1,_that.user2,_that.createdAt,_that.isOpened);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Chat implements Chat {
  const _Chat({required this.chatId, required this.user1, required this.user2, required this.createdAt, required this.isOpened});
  factory _Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

@override final  String chatId;
@override final  User user1;
@override final  User user2;
@override final  DateTime createdAt;
@override final  bool isOpened;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCopyWith<_Chat> get copyWith => __$ChatCopyWithImpl<_Chat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chat&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.user1, user1) || other.user1 == user1)&&(identical(other.user2, user2) || other.user2 == user2)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isOpened, isOpened) || other.isOpened == isOpened));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatId,user1,user2,createdAt,isOpened);

@override
String toString() {
  return 'Chat(chatId: $chatId, user1: $user1, user2: $user2, createdAt: $createdAt, isOpened: $isOpened)';
}


}

/// @nodoc
abstract mixin class _$ChatCopyWith<$Res> implements $ChatCopyWith<$Res> {
  factory _$ChatCopyWith(_Chat value, $Res Function(_Chat) _then) = __$ChatCopyWithImpl;
@override @useResult
$Res call({
 String chatId, User user1, User user2, DateTime createdAt, bool isOpened
});


@override $UserCopyWith<$Res> get user1;@override $UserCopyWith<$Res> get user2;

}
/// @nodoc
class __$ChatCopyWithImpl<$Res>
    implements _$ChatCopyWith<$Res> {
  __$ChatCopyWithImpl(this._self, this._then);

  final _Chat _self;
  final $Res Function(_Chat) _then;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,Object? user1 = null,Object? user2 = null,Object? createdAt = null,Object? isOpened = null,}) {
  return _then(_Chat(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,user1: null == user1 ? _self.user1 : user1 // ignore: cast_nullable_to_non_nullable
as User,user2: null == user2 ? _self.user2 : user2 // ignore: cast_nullable_to_non_nullable
as User,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isOpened: null == isOpened ? _self.isOpened : isOpened // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user1 {
  
  return $UserCopyWith<$Res>(_self.user1, (value) {
    return _then(_self.copyWith(user1: value));
  });
}/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user2 {
  
  return $UserCopyWith<$Res>(_self.user2, (value) {
    return _then(_self.copyWith(user2: value));
  });
}
}

// dart format on
