// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatState()';
}


}

/// @nodoc
class $ChatStateCopyWith<$Res>  {
$ChatStateCopyWith(ChatState _, $Res Function(ChatState) __);
}


/// Adds pattern-matching-related methods to [ChatState].
extension ChatStatePatterns on ChatState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _GetChats value)?  getChats,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _GetChats() when getChats != null:
return getChats(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _GetChats value)  getChats,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _GetChats():
return getChats(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _GetChats value)?  getChats,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _GetChats() when getChats != null:
return getChats(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( List<TemporaryChat> temporaryChat,  List<Chat> permomentChat)?  getChats,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _GetChats() when getChats != null:
return getChats(_that.temporaryChat,_that.permomentChat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( List<TemporaryChat> temporaryChat,  List<Chat> permomentChat)  getChats,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _GetChats():
return getChats(_that.temporaryChat,_that.permomentChat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( List<TemporaryChat> temporaryChat,  List<Chat> permomentChat)?  getChats,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _GetChats() when getChats != null:
return getChats(_that.temporaryChat,_that.permomentChat);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ChatState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ChatState.initial()';
}


}




/// @nodoc


class _GetChats implements ChatState {
  const _GetChats({required final  List<TemporaryChat> temporaryChat, required final  List<Chat> permomentChat}): _temporaryChat = temporaryChat,_permomentChat = permomentChat;
  

 final  List<TemporaryChat> _temporaryChat;
 List<TemporaryChat> get temporaryChat {
  if (_temporaryChat is EqualUnmodifiableListView) return _temporaryChat;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_temporaryChat);
}

 final  List<Chat> _permomentChat;
 List<Chat> get permomentChat {
  if (_permomentChat is EqualUnmodifiableListView) return _permomentChat;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_permomentChat);
}


/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetChatsCopyWith<_GetChats> get copyWith => __$GetChatsCopyWithImpl<_GetChats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetChats&&const DeepCollectionEquality().equals(other._temporaryChat, _temporaryChat)&&const DeepCollectionEquality().equals(other._permomentChat, _permomentChat));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_temporaryChat),const DeepCollectionEquality().hash(_permomentChat));

@override
String toString() {
  return 'ChatState.getChats(temporaryChat: $temporaryChat, permomentChat: $permomentChat)';
}


}

/// @nodoc
abstract mixin class _$GetChatsCopyWith<$Res> implements $ChatStateCopyWith<$Res> {
  factory _$GetChatsCopyWith(_GetChats value, $Res Function(_GetChats) _then) = __$GetChatsCopyWithImpl;
@useResult
$Res call({
 List<TemporaryChat> temporaryChat, List<Chat> permomentChat
});




}
/// @nodoc
class __$GetChatsCopyWithImpl<$Res>
    implements _$GetChatsCopyWith<$Res> {
  __$GetChatsCopyWithImpl(this._self, this._then);

  final _GetChats _self;
  final $Res Function(_GetChats) _then;

/// Create a copy of ChatState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? temporaryChat = null,Object? permomentChat = null,}) {
  return _then(_GetChats(
temporaryChat: null == temporaryChat ? _self._temporaryChat : temporaryChat // ignore: cast_nullable_to_non_nullable
as List<TemporaryChat>,permomentChat: null == permomentChat ? _self._permomentChat : permomentChat // ignore: cast_nullable_to_non_nullable
as List<Chat>,
  ));
}


}

// dart format on
