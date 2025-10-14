// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permanent_chat_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PermanentChatResponseDto {

@HiveField(0) String get chatId;@HiveField(1) String get user1Id;@HiveField(2) String get user1Username;@HiveField(3) String get user1Firstname;@HiveField(4) String get user1Subname;@HiveField(5) String? get user1Avatar;@HiveField(6) String get user2Id;@HiveField(7) String get user2Username;@HiveField(8) String get user2Firstname;@HiveField(9) String get user2Subname;@HiveField(10) String? get user2Avatar;@HiveField(11) DateTime get createdAt;@HiveField(12) bool get isOpened; String? get lastMessage;
/// Create a copy of PermanentChatResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermanentChatResponseDtoCopyWith<PermanentChatResponseDto> get copyWith => _$PermanentChatResponseDtoCopyWithImpl<PermanentChatResponseDto>(this as PermanentChatResponseDto, _$identity);

  /// Serializes this PermanentChatResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PermanentChatResponseDto&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.user1Id, user1Id) || other.user1Id == user1Id)&&(identical(other.user1Username, user1Username) || other.user1Username == user1Username)&&(identical(other.user1Firstname, user1Firstname) || other.user1Firstname == user1Firstname)&&(identical(other.user1Subname, user1Subname) || other.user1Subname == user1Subname)&&(identical(other.user1Avatar, user1Avatar) || other.user1Avatar == user1Avatar)&&(identical(other.user2Id, user2Id) || other.user2Id == user2Id)&&(identical(other.user2Username, user2Username) || other.user2Username == user2Username)&&(identical(other.user2Firstname, user2Firstname) || other.user2Firstname == user2Firstname)&&(identical(other.user2Subname, user2Subname) || other.user2Subname == user2Subname)&&(identical(other.user2Avatar, user2Avatar) || other.user2Avatar == user2Avatar)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isOpened, isOpened) || other.isOpened == isOpened)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatId,user1Id,user1Username,user1Firstname,user1Subname,user1Avatar,user2Id,user2Username,user2Firstname,user2Subname,user2Avatar,createdAt,isOpened,lastMessage);

@override
String toString() {
  return 'PermanentChatResponseDto(chatId: $chatId, user1Id: $user1Id, user1Username: $user1Username, user1Firstname: $user1Firstname, user1Subname: $user1Subname, user1Avatar: $user1Avatar, user2Id: $user2Id, user2Username: $user2Username, user2Firstname: $user2Firstname, user2Subname: $user2Subname, user2Avatar: $user2Avatar, createdAt: $createdAt, isOpened: $isOpened, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class $PermanentChatResponseDtoCopyWith<$Res>  {
  factory $PermanentChatResponseDtoCopyWith(PermanentChatResponseDto value, $Res Function(PermanentChatResponseDto) _then) = _$PermanentChatResponseDtoCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String chatId,@HiveField(1) String user1Id,@HiveField(2) String user1Username,@HiveField(3) String user1Firstname,@HiveField(4) String user1Subname,@HiveField(5) String? user1Avatar,@HiveField(6) String user2Id,@HiveField(7) String user2Username,@HiveField(8) String user2Firstname,@HiveField(9) String user2Subname,@HiveField(10) String? user2Avatar,@HiveField(11) DateTime createdAt,@HiveField(12) bool isOpened, String? lastMessage
});




}
/// @nodoc
class _$PermanentChatResponseDtoCopyWithImpl<$Res>
    implements $PermanentChatResponseDtoCopyWith<$Res> {
  _$PermanentChatResponseDtoCopyWithImpl(this._self, this._then);

  final PermanentChatResponseDto _self;
  final $Res Function(PermanentChatResponseDto) _then;

/// Create a copy of PermanentChatResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chatId = null,Object? user1Id = null,Object? user1Username = null,Object? user1Firstname = null,Object? user1Subname = null,Object? user1Avatar = freezed,Object? user2Id = null,Object? user2Username = null,Object? user2Firstname = null,Object? user2Subname = null,Object? user2Avatar = freezed,Object? createdAt = null,Object? isOpened = null,Object? lastMessage = freezed,}) {
  return _then(_self.copyWith(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,user1Id: null == user1Id ? _self.user1Id : user1Id // ignore: cast_nullable_to_non_nullable
as String,user1Username: null == user1Username ? _self.user1Username : user1Username // ignore: cast_nullable_to_non_nullable
as String,user1Firstname: null == user1Firstname ? _self.user1Firstname : user1Firstname // ignore: cast_nullable_to_non_nullable
as String,user1Subname: null == user1Subname ? _self.user1Subname : user1Subname // ignore: cast_nullable_to_non_nullable
as String,user1Avatar: freezed == user1Avatar ? _self.user1Avatar : user1Avatar // ignore: cast_nullable_to_non_nullable
as String?,user2Id: null == user2Id ? _self.user2Id : user2Id // ignore: cast_nullable_to_non_nullable
as String,user2Username: null == user2Username ? _self.user2Username : user2Username // ignore: cast_nullable_to_non_nullable
as String,user2Firstname: null == user2Firstname ? _self.user2Firstname : user2Firstname // ignore: cast_nullable_to_non_nullable
as String,user2Subname: null == user2Subname ? _self.user2Subname : user2Subname // ignore: cast_nullable_to_non_nullable
as String,user2Avatar: freezed == user2Avatar ? _self.user2Avatar : user2Avatar // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isOpened: null == isOpened ? _self.isOpened : isOpened // ignore: cast_nullable_to_non_nullable
as bool,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PermanentChatResponseDto].
extension PermanentChatResponseDtoPatterns on PermanentChatResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PermanentChatResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PermanentChatResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PermanentChatResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _PermanentChatResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PermanentChatResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _PermanentChatResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String chatId, @HiveField(1)  String user1Id, @HiveField(2)  String user1Username, @HiveField(3)  String user1Firstname, @HiveField(4)  String user1Subname, @HiveField(5)  String? user1Avatar, @HiveField(6)  String user2Id, @HiveField(7)  String user2Username, @HiveField(8)  String user2Firstname, @HiveField(9)  String user2Subname, @HiveField(10)  String? user2Avatar, @HiveField(11)  DateTime createdAt, @HiveField(12)  bool isOpened,  String? lastMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PermanentChatResponseDto() when $default != null:
return $default(_that.chatId,_that.user1Id,_that.user1Username,_that.user1Firstname,_that.user1Subname,_that.user1Avatar,_that.user2Id,_that.user2Username,_that.user2Firstname,_that.user2Subname,_that.user2Avatar,_that.createdAt,_that.isOpened,_that.lastMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String chatId, @HiveField(1)  String user1Id, @HiveField(2)  String user1Username, @HiveField(3)  String user1Firstname, @HiveField(4)  String user1Subname, @HiveField(5)  String? user1Avatar, @HiveField(6)  String user2Id, @HiveField(7)  String user2Username, @HiveField(8)  String user2Firstname, @HiveField(9)  String user2Subname, @HiveField(10)  String? user2Avatar, @HiveField(11)  DateTime createdAt, @HiveField(12)  bool isOpened,  String? lastMessage)  $default,) {final _that = this;
switch (_that) {
case _PermanentChatResponseDto():
return $default(_that.chatId,_that.user1Id,_that.user1Username,_that.user1Firstname,_that.user1Subname,_that.user1Avatar,_that.user2Id,_that.user2Username,_that.user2Firstname,_that.user2Subname,_that.user2Avatar,_that.createdAt,_that.isOpened,_that.lastMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String chatId, @HiveField(1)  String user1Id, @HiveField(2)  String user1Username, @HiveField(3)  String user1Firstname, @HiveField(4)  String user1Subname, @HiveField(5)  String? user1Avatar, @HiveField(6)  String user2Id, @HiveField(7)  String user2Username, @HiveField(8)  String user2Firstname, @HiveField(9)  String user2Subname, @HiveField(10)  String? user2Avatar, @HiveField(11)  DateTime createdAt, @HiveField(12)  bool isOpened,  String? lastMessage)?  $default,) {final _that = this;
switch (_that) {
case _PermanentChatResponseDto() when $default != null:
return $default(_that.chatId,_that.user1Id,_that.user1Username,_that.user1Firstname,_that.user1Subname,_that.user1Avatar,_that.user2Id,_that.user2Username,_that.user2Firstname,_that.user2Subname,_that.user2Avatar,_that.createdAt,_that.isOpened,_that.lastMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PermanentChatResponseDto implements PermanentChatResponseDto {
  const _PermanentChatResponseDto({@HiveField(0) required this.chatId, @HiveField(1) required this.user1Id, @HiveField(2) required this.user1Username, @HiveField(3) required this.user1Firstname, @HiveField(4) required this.user1Subname, @HiveField(5) required this.user1Avatar, @HiveField(6) required this.user2Id, @HiveField(7) required this.user2Username, @HiveField(8) required this.user2Firstname, @HiveField(9) required this.user2Subname, @HiveField(10) required this.user2Avatar, @HiveField(11) required this.createdAt, @HiveField(12) required this.isOpened, this.lastMessage});
  factory _PermanentChatResponseDto.fromJson(Map<String, dynamic> json) => _$PermanentChatResponseDtoFromJson(json);

@override@HiveField(0) final  String chatId;
@override@HiveField(1) final  String user1Id;
@override@HiveField(2) final  String user1Username;
@override@HiveField(3) final  String user1Firstname;
@override@HiveField(4) final  String user1Subname;
@override@HiveField(5) final  String? user1Avatar;
@override@HiveField(6) final  String user2Id;
@override@HiveField(7) final  String user2Username;
@override@HiveField(8) final  String user2Firstname;
@override@HiveField(9) final  String user2Subname;
@override@HiveField(10) final  String? user2Avatar;
@override@HiveField(11) final  DateTime createdAt;
@override@HiveField(12) final  bool isOpened;
@override final  String? lastMessage;

/// Create a copy of PermanentChatResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermanentChatResponseDtoCopyWith<_PermanentChatResponseDto> get copyWith => __$PermanentChatResponseDtoCopyWithImpl<_PermanentChatResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermanentChatResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PermanentChatResponseDto&&(identical(other.chatId, chatId) || other.chatId == chatId)&&(identical(other.user1Id, user1Id) || other.user1Id == user1Id)&&(identical(other.user1Username, user1Username) || other.user1Username == user1Username)&&(identical(other.user1Firstname, user1Firstname) || other.user1Firstname == user1Firstname)&&(identical(other.user1Subname, user1Subname) || other.user1Subname == user1Subname)&&(identical(other.user1Avatar, user1Avatar) || other.user1Avatar == user1Avatar)&&(identical(other.user2Id, user2Id) || other.user2Id == user2Id)&&(identical(other.user2Username, user2Username) || other.user2Username == user2Username)&&(identical(other.user2Firstname, user2Firstname) || other.user2Firstname == user2Firstname)&&(identical(other.user2Subname, user2Subname) || other.user2Subname == user2Subname)&&(identical(other.user2Avatar, user2Avatar) || other.user2Avatar == user2Avatar)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isOpened, isOpened) || other.isOpened == isOpened)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chatId,user1Id,user1Username,user1Firstname,user1Subname,user1Avatar,user2Id,user2Username,user2Firstname,user2Subname,user2Avatar,createdAt,isOpened,lastMessage);

@override
String toString() {
  return 'PermanentChatResponseDto(chatId: $chatId, user1Id: $user1Id, user1Username: $user1Username, user1Firstname: $user1Firstname, user1Subname: $user1Subname, user1Avatar: $user1Avatar, user2Id: $user2Id, user2Username: $user2Username, user2Firstname: $user2Firstname, user2Subname: $user2Subname, user2Avatar: $user2Avatar, createdAt: $createdAt, isOpened: $isOpened, lastMessage: $lastMessage)';
}


}

/// @nodoc
abstract mixin class _$PermanentChatResponseDtoCopyWith<$Res> implements $PermanentChatResponseDtoCopyWith<$Res> {
  factory _$PermanentChatResponseDtoCopyWith(_PermanentChatResponseDto value, $Res Function(_PermanentChatResponseDto) _then) = __$PermanentChatResponseDtoCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String chatId,@HiveField(1) String user1Id,@HiveField(2) String user1Username,@HiveField(3) String user1Firstname,@HiveField(4) String user1Subname,@HiveField(5) String? user1Avatar,@HiveField(6) String user2Id,@HiveField(7) String user2Username,@HiveField(8) String user2Firstname,@HiveField(9) String user2Subname,@HiveField(10) String? user2Avatar,@HiveField(11) DateTime createdAt,@HiveField(12) bool isOpened, String? lastMessage
});




}
/// @nodoc
class __$PermanentChatResponseDtoCopyWithImpl<$Res>
    implements _$PermanentChatResponseDtoCopyWith<$Res> {
  __$PermanentChatResponseDtoCopyWithImpl(this._self, this._then);

  final _PermanentChatResponseDto _self;
  final $Res Function(_PermanentChatResponseDto) _then;

/// Create a copy of PermanentChatResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chatId = null,Object? user1Id = null,Object? user1Username = null,Object? user1Firstname = null,Object? user1Subname = null,Object? user1Avatar = freezed,Object? user2Id = null,Object? user2Username = null,Object? user2Firstname = null,Object? user2Subname = null,Object? user2Avatar = freezed,Object? createdAt = null,Object? isOpened = null,Object? lastMessage = freezed,}) {
  return _then(_PermanentChatResponseDto(
chatId: null == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String,user1Id: null == user1Id ? _self.user1Id : user1Id // ignore: cast_nullable_to_non_nullable
as String,user1Username: null == user1Username ? _self.user1Username : user1Username // ignore: cast_nullable_to_non_nullable
as String,user1Firstname: null == user1Firstname ? _self.user1Firstname : user1Firstname // ignore: cast_nullable_to_non_nullable
as String,user1Subname: null == user1Subname ? _self.user1Subname : user1Subname // ignore: cast_nullable_to_non_nullable
as String,user1Avatar: freezed == user1Avatar ? _self.user1Avatar : user1Avatar // ignore: cast_nullable_to_non_nullable
as String?,user2Id: null == user2Id ? _self.user2Id : user2Id // ignore: cast_nullable_to_non_nullable
as String,user2Username: null == user2Username ? _self.user2Username : user2Username // ignore: cast_nullable_to_non_nullable
as String,user2Firstname: null == user2Firstname ? _self.user2Firstname : user2Firstname // ignore: cast_nullable_to_non_nullable
as String,user2Subname: null == user2Subname ? _self.user2Subname : user2Subname // ignore: cast_nullable_to_non_nullable
as String,user2Avatar: freezed == user2Avatar ? _self.user2Avatar : user2Avatar // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isOpened: null == isOpened ? _self.isOpened : isOpened // ignore: cast_nullable_to_non_nullable
as bool,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
