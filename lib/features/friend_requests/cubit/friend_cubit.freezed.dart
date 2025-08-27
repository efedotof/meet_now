// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FriendState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FriendState()';
}


}

/// @nodoc
class $FriendStateCopyWith<$Res>  {
$FriendStateCopyWith(FriendState _, $Res Function(FriendState) __);
}


/// Adds pattern-matching-related methods to [FriendState].
extension FriendStatePatterns on FriendState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _MyFriendRequest value)?  myFriendRequest,TResult Function( _EmptyFriendRequest value)?  emptyFriendRequest,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _MyFriendRequest() when myFriendRequest != null:
return myFriendRequest(_that);case _EmptyFriendRequest() when emptyFriendRequest != null:
return emptyFriendRequest(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _MyFriendRequest value)  myFriendRequest,required TResult Function( _EmptyFriendRequest value)  emptyFriendRequest,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _MyFriendRequest():
return myFriendRequest(_that);case _EmptyFriendRequest():
return emptyFriendRequest(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _MyFriendRequest value)?  myFriendRequest,TResult? Function( _EmptyFriendRequest value)?  emptyFriendRequest,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _MyFriendRequest() when myFriendRequest != null:
return myFriendRequest(_that);case _EmptyFriendRequest() when emptyFriendRequest != null:
return emptyFriendRequest(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( List<FriendRequest> friendRequest)?  myFriendRequest,TResult Function()?  emptyFriendRequest,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _MyFriendRequest() when myFriendRequest != null:
return myFriendRequest(_that.friendRequest);case _EmptyFriendRequest() when emptyFriendRequest != null:
return emptyFriendRequest();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( List<FriendRequest> friendRequest)  myFriendRequest,required TResult Function()  emptyFriendRequest,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _MyFriendRequest():
return myFriendRequest(_that.friendRequest);case _EmptyFriendRequest():
return emptyFriendRequest();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( List<FriendRequest> friendRequest)?  myFriendRequest,TResult? Function()?  emptyFriendRequest,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _MyFriendRequest() when myFriendRequest != null:
return myFriendRequest(_that.friendRequest);case _EmptyFriendRequest() when emptyFriendRequest != null:
return emptyFriendRequest();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements FriendState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FriendState.initial()';
}


}




/// @nodoc


class _MyFriendRequest implements FriendState {
  const _MyFriendRequest({required final  List<FriendRequest> friendRequest}): _friendRequest = friendRequest;
  

 final  List<FriendRequest> _friendRequest;
 List<FriendRequest> get friendRequest {
  if (_friendRequest is EqualUnmodifiableListView) return _friendRequest;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friendRequest);
}


/// Create a copy of FriendState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyFriendRequestCopyWith<_MyFriendRequest> get copyWith => __$MyFriendRequestCopyWithImpl<_MyFriendRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyFriendRequest&&const DeepCollectionEquality().equals(other._friendRequest, _friendRequest));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_friendRequest));

@override
String toString() {
  return 'FriendState.myFriendRequest(friendRequest: $friendRequest)';
}


}

/// @nodoc
abstract mixin class _$MyFriendRequestCopyWith<$Res> implements $FriendStateCopyWith<$Res> {
  factory _$MyFriendRequestCopyWith(_MyFriendRequest value, $Res Function(_MyFriendRequest) _then) = __$MyFriendRequestCopyWithImpl;
@useResult
$Res call({
 List<FriendRequest> friendRequest
});




}
/// @nodoc
class __$MyFriendRequestCopyWithImpl<$Res>
    implements _$MyFriendRequestCopyWith<$Res> {
  __$MyFriendRequestCopyWithImpl(this._self, this._then);

  final _MyFriendRequest _self;
  final $Res Function(_MyFriendRequest) _then;

/// Create a copy of FriendState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? friendRequest = null,}) {
  return _then(_MyFriendRequest(
friendRequest: null == friendRequest ? _self._friendRequest : friendRequest // ignore: cast_nullable_to_non_nullable
as List<FriendRequest>,
  ));
}


}

/// @nodoc


class _EmptyFriendRequest implements FriendState {
  const _EmptyFriendRequest();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmptyFriendRequest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FriendState.emptyFriendRequest()';
}


}




// dart format on
