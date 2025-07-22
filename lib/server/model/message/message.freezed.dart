// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Message {

 String? get id; String? get chatId; String? get tempChatId; String get senderId; String get recipientId; String get text; DateTime? get createdAt; bool? get isRead;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.id, id) || other.id == id)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.tempChatId, tempChatId) || other.tempChatId == tempChatId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chatId,tempChatId,senderId,recipientId,text,createdAt,isRead);

@override
String toString() {
  return 'Message(id: $id, chatId: $chatId, tempChatId: $tempChatId, senderId: $senderId, recipientId: $recipientId, text: $text, createdAt: $createdAt, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 String? id, String? chatId, String? tempChatId, String senderId, String recipientId, String text, DateTime? createdAt, bool? isRead
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? chatId = freezed,Object? tempChatId = freezed,Object? senderId = null,Object? recipientId = null,Object? text = null,Object? createdAt = freezed,Object? isRead = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,chatId: freezed == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String?,tempChatId: freezed == tempChatId ? _self.tempChatId : tempChatId // ignore: cast_nullable_to_non_nullable
as String?,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,recipientId: null == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isRead: freezed == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? chatId,  String? tempChatId,  String senderId,  String recipientId,  String text,  DateTime? createdAt,  bool? isRead)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.chatId,_that.tempChatId,_that.senderId,_that.recipientId,_that.text,_that.createdAt,_that.isRead);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? chatId,  String? tempChatId,  String senderId,  String recipientId,  String text,  DateTime? createdAt,  bool? isRead)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.id,_that.chatId,_that.tempChatId,_that.senderId,_that.recipientId,_that.text,_that.createdAt,_that.isRead);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? chatId,  String? tempChatId,  String senderId,  String recipientId,  String text,  DateTime? createdAt,  bool? isRead)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.chatId,_that.tempChatId,_that.senderId,_that.recipientId,_that.text,_that.createdAt,_that.isRead);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message implements Message {
  const _Message({this.id, this.chatId, this.tempChatId, required this.senderId, required this.recipientId, required this.text, this.createdAt, this.isRead});
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override final  String? id;
@override final  String? chatId;
@override final  String? tempChatId;
@override final  String senderId;
@override final  String recipientId;
@override final  String text;
@override final  DateTime? createdAt;
@override final  bool? isRead;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.id, id) || other.id == id)&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.tempChatId, tempChatId) || other.tempChatId == tempChatId)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.recipientId, recipientId) || other.recipientId == recipientId)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,chatId,tempChatId,senderId,recipientId,text,createdAt,isRead);

@override
String toString() {
  return 'Message(id: $id, chatId: $chatId, tempChatId: $tempChatId, senderId: $senderId, recipientId: $recipientId, text: $text, createdAt: $createdAt, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? chatId, String? tempChatId, String senderId, String recipientId, String text, DateTime? createdAt, bool? isRead
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? chatId = freezed,Object? tempChatId = freezed,Object? senderId = null,Object? recipientId = null,Object? text = null,Object? createdAt = freezed,Object? isRead = freezed,}) {
  return _then(_Message(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,chatId: freezed == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String?,tempChatId: freezed == tempChatId ? _self.tempChatId : tempChatId // ignore: cast_nullable_to_non_nullable
as String?,senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,recipientId: null == recipientId ? _self.recipientId : recipientId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isRead: freezed == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
