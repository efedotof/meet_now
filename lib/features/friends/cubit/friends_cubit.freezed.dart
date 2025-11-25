// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friends_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FriendsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FriendsState()';
}


}

/// @nodoc
class $FriendsStateCopyWith<$Res>  {
$FriendsStateCopyWith(FriendsState _, $Res Function(FriendsState) __);
}


/// Adds pattern-matching-related methods to [FriendsState].
extension FriendsStatePatterns on FriendsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _FriendsList value)?  friendsList,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _FriendsList() when friendsList != null:
return friendsList(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _FriendsList value)  friendsList,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _FriendsList():
return friendsList(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _FriendsList value)?  friendsList,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _FriendsList() when friendsList != null:
return friendsList(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( List<FriendDto> friends)?  friendsList,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _FriendsList() when friendsList != null:
return friendsList(_that.friends);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( List<FriendDto> friends)  friendsList,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _FriendsList():
return friendsList(_that.friends);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( List<FriendDto> friends)?  friendsList,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _FriendsList() when friendsList != null:
return friendsList(_that.friends);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements FriendsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FriendsState.initial()';
}


}




/// @nodoc


class _FriendsList implements FriendsState {
  const _FriendsList({required final  List<FriendDto> friends}): _friends = friends;
  

 final  List<FriendDto> _friends;
 List<FriendDto> get friends {
  if (_friends is EqualUnmodifiableListView) return _friends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friends);
}


/// Create a copy of FriendsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendsListCopyWith<_FriendsList> get copyWith => __$FriendsListCopyWithImpl<_FriendsList>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendsList&&const DeepCollectionEquality().equals(other._friends, _friends));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_friends));

@override
String toString() {
  return 'FriendsState.friendsList(friends: $friends)';
}


}

/// @nodoc
abstract mixin class _$FriendsListCopyWith<$Res> implements $FriendsStateCopyWith<$Res> {
  factory _$FriendsListCopyWith(_FriendsList value, $Res Function(_FriendsList) _then) = __$FriendsListCopyWithImpl;
@useResult
$Res call({
 List<FriendDto> friends
});




}
/// @nodoc
class __$FriendsListCopyWithImpl<$Res>
    implements _$FriendsListCopyWith<$Res> {
  __$FriendsListCopyWithImpl(this._self, this._then);

  final _FriendsList _self;
  final $Res Function(_FriendsList) _then;

/// Create a copy of FriendsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? friends = null,}) {
  return _then(_FriendsList(
friends: null == friends ? _self._friends : friends // ignore: cast_nullable_to_non_nullable
as List<FriendDto>,
  ));
}


}

// dart format on
