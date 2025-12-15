// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UsersState {

 bool get isLoading; List<User> get users; List<User> get filteredUsers; String get searchQuery; UsersTab get activeTab; List<FriendConnectionDto> get friendConnections; List<FriendRequestDto> get friendRequests; List<UserWithFriendCountDto> get usersWithFriendCount; List<UserWithFriendCountDto> get popularUsers; bool get isLoadingFriends; String? get error; String? get blockReason;
/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsersStateCopyWith<UsersState> get copyWith => _$UsersStateCopyWithImpl<UsersState>(this as UsersState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsersState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.users, users)&&const DeepCollectionEquality().equals(other.filteredUsers, filteredUsers)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.activeTab, activeTab) || other.activeTab == activeTab)&&const DeepCollectionEquality().equals(other.friendConnections, friendConnections)&&const DeepCollectionEquality().equals(other.friendRequests, friendRequests)&&const DeepCollectionEquality().equals(other.usersWithFriendCount, usersWithFriendCount)&&const DeepCollectionEquality().equals(other.popularUsers, popularUsers)&&(identical(other.isLoadingFriends, isLoadingFriends) || other.isLoadingFriends == isLoadingFriends)&&(identical(other.error, error) || other.error == error)&&(identical(other.blockReason, blockReason) || other.blockReason == blockReason));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(users),const DeepCollectionEquality().hash(filteredUsers),searchQuery,activeTab,const DeepCollectionEquality().hash(friendConnections),const DeepCollectionEquality().hash(friendRequests),const DeepCollectionEquality().hash(usersWithFriendCount),const DeepCollectionEquality().hash(popularUsers),isLoadingFriends,error,blockReason);

@override
String toString() {
  return 'UsersState(isLoading: $isLoading, users: $users, filteredUsers: $filteredUsers, searchQuery: $searchQuery, activeTab: $activeTab, friendConnections: $friendConnections, friendRequests: $friendRequests, usersWithFriendCount: $usersWithFriendCount, popularUsers: $popularUsers, isLoadingFriends: $isLoadingFriends, error: $error, blockReason: $blockReason)';
}


}

/// @nodoc
abstract mixin class $UsersStateCopyWith<$Res>  {
  factory $UsersStateCopyWith(UsersState value, $Res Function(UsersState) _then) = _$UsersStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<User> users, List<User> filteredUsers, String searchQuery, UsersTab activeTab, List<FriendConnectionDto> friendConnections, List<FriendRequestDto> friendRequests, List<UserWithFriendCountDto> usersWithFriendCount, List<UserWithFriendCountDto> popularUsers, bool isLoadingFriends, String? error, String? blockReason
});




}
/// @nodoc
class _$UsersStateCopyWithImpl<$Res>
    implements $UsersStateCopyWith<$Res> {
  _$UsersStateCopyWithImpl(this._self, this._then);

  final UsersState _self;
  final $Res Function(UsersState) _then;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? users = null,Object? filteredUsers = null,Object? searchQuery = null,Object? activeTab = null,Object? friendConnections = null,Object? friendRequests = null,Object? usersWithFriendCount = null,Object? popularUsers = null,Object? isLoadingFriends = null,Object? error = freezed,Object? blockReason = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<User>,filteredUsers: null == filteredUsers ? _self.filteredUsers : filteredUsers // ignore: cast_nullable_to_non_nullable
as List<User>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,activeTab: null == activeTab ? _self.activeTab : activeTab // ignore: cast_nullable_to_non_nullable
as UsersTab,friendConnections: null == friendConnections ? _self.friendConnections : friendConnections // ignore: cast_nullable_to_non_nullable
as List<FriendConnectionDto>,friendRequests: null == friendRequests ? _self.friendRequests : friendRequests // ignore: cast_nullable_to_non_nullable
as List<FriendRequestDto>,usersWithFriendCount: null == usersWithFriendCount ? _self.usersWithFriendCount : usersWithFriendCount // ignore: cast_nullable_to_non_nullable
as List<UserWithFriendCountDto>,popularUsers: null == popularUsers ? _self.popularUsers : popularUsers // ignore: cast_nullable_to_non_nullable
as List<UserWithFriendCountDto>,isLoadingFriends: null == isLoadingFriends ? _self.isLoadingFriends : isLoadingFriends // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,blockReason: freezed == blockReason ? _self.blockReason : blockReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UsersState].
extension UsersStatePatterns on UsersState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsersState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsersState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsersState value)  $default,){
final _that = this;
switch (_that) {
case _UsersState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsersState value)?  $default,){
final _that = this;
switch (_that) {
case _UsersState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<User> users,  List<User> filteredUsers,  String searchQuery,  UsersTab activeTab,  List<FriendConnectionDto> friendConnections,  List<FriendRequestDto> friendRequests,  List<UserWithFriendCountDto> usersWithFriendCount,  List<UserWithFriendCountDto> popularUsers,  bool isLoadingFriends,  String? error,  String? blockReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsersState() when $default != null:
return $default(_that.isLoading,_that.users,_that.filteredUsers,_that.searchQuery,_that.activeTab,_that.friendConnections,_that.friendRequests,_that.usersWithFriendCount,_that.popularUsers,_that.isLoadingFriends,_that.error,_that.blockReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<User> users,  List<User> filteredUsers,  String searchQuery,  UsersTab activeTab,  List<FriendConnectionDto> friendConnections,  List<FriendRequestDto> friendRequests,  List<UserWithFriendCountDto> usersWithFriendCount,  List<UserWithFriendCountDto> popularUsers,  bool isLoadingFriends,  String? error,  String? blockReason)  $default,) {final _that = this;
switch (_that) {
case _UsersState():
return $default(_that.isLoading,_that.users,_that.filteredUsers,_that.searchQuery,_that.activeTab,_that.friendConnections,_that.friendRequests,_that.usersWithFriendCount,_that.popularUsers,_that.isLoadingFriends,_that.error,_that.blockReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<User> users,  List<User> filteredUsers,  String searchQuery,  UsersTab activeTab,  List<FriendConnectionDto> friendConnections,  List<FriendRequestDto> friendRequests,  List<UserWithFriendCountDto> usersWithFriendCount,  List<UserWithFriendCountDto> popularUsers,  bool isLoadingFriends,  String? error,  String? blockReason)?  $default,) {final _that = this;
switch (_that) {
case _UsersState() when $default != null:
return $default(_that.isLoading,_that.users,_that.filteredUsers,_that.searchQuery,_that.activeTab,_that.friendConnections,_that.friendRequests,_that.usersWithFriendCount,_that.popularUsers,_that.isLoadingFriends,_that.error,_that.blockReason);case _:
  return null;

}
}

}

/// @nodoc


class _UsersState implements UsersState {
  const _UsersState({required this.isLoading, required final  List<User> users, required final  List<User> filteredUsers, required this.searchQuery, required this.activeTab, required final  List<FriendConnectionDto> friendConnections, required final  List<FriendRequestDto> friendRequests, required final  List<UserWithFriendCountDto> usersWithFriendCount, required final  List<UserWithFriendCountDto> popularUsers, required this.isLoadingFriends, this.error, this.blockReason}): _users = users,_filteredUsers = filteredUsers,_friendConnections = friendConnections,_friendRequests = friendRequests,_usersWithFriendCount = usersWithFriendCount,_popularUsers = popularUsers;
  

@override final  bool isLoading;
 final  List<User> _users;
@override List<User> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}

 final  List<User> _filteredUsers;
@override List<User> get filteredUsers {
  if (_filteredUsers is EqualUnmodifiableListView) return _filteredUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredUsers);
}

@override final  String searchQuery;
@override final  UsersTab activeTab;
 final  List<FriendConnectionDto> _friendConnections;
@override List<FriendConnectionDto> get friendConnections {
  if (_friendConnections is EqualUnmodifiableListView) return _friendConnections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friendConnections);
}

 final  List<FriendRequestDto> _friendRequests;
@override List<FriendRequestDto> get friendRequests {
  if (_friendRequests is EqualUnmodifiableListView) return _friendRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_friendRequests);
}

 final  List<UserWithFriendCountDto> _usersWithFriendCount;
@override List<UserWithFriendCountDto> get usersWithFriendCount {
  if (_usersWithFriendCount is EqualUnmodifiableListView) return _usersWithFriendCount;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_usersWithFriendCount);
}

 final  List<UserWithFriendCountDto> _popularUsers;
@override List<UserWithFriendCountDto> get popularUsers {
  if (_popularUsers is EqualUnmodifiableListView) return _popularUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_popularUsers);
}

@override final  bool isLoadingFriends;
@override final  String? error;
@override final  String? blockReason;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsersStateCopyWith<_UsersState> get copyWith => __$UsersStateCopyWithImpl<_UsersState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsersState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._users, _users)&&const DeepCollectionEquality().equals(other._filteredUsers, _filteredUsers)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.activeTab, activeTab) || other.activeTab == activeTab)&&const DeepCollectionEquality().equals(other._friendConnections, _friendConnections)&&const DeepCollectionEquality().equals(other._friendRequests, _friendRequests)&&const DeepCollectionEquality().equals(other._usersWithFriendCount, _usersWithFriendCount)&&const DeepCollectionEquality().equals(other._popularUsers, _popularUsers)&&(identical(other.isLoadingFriends, isLoadingFriends) || other.isLoadingFriends == isLoadingFriends)&&(identical(other.error, error) || other.error == error)&&(identical(other.blockReason, blockReason) || other.blockReason == blockReason));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_users),const DeepCollectionEquality().hash(_filteredUsers),searchQuery,activeTab,const DeepCollectionEquality().hash(_friendConnections),const DeepCollectionEquality().hash(_friendRequests),const DeepCollectionEquality().hash(_usersWithFriendCount),const DeepCollectionEquality().hash(_popularUsers),isLoadingFriends,error,blockReason);

@override
String toString() {
  return 'UsersState(isLoading: $isLoading, users: $users, filteredUsers: $filteredUsers, searchQuery: $searchQuery, activeTab: $activeTab, friendConnections: $friendConnections, friendRequests: $friendRequests, usersWithFriendCount: $usersWithFriendCount, popularUsers: $popularUsers, isLoadingFriends: $isLoadingFriends, error: $error, blockReason: $blockReason)';
}


}

/// @nodoc
abstract mixin class _$UsersStateCopyWith<$Res> implements $UsersStateCopyWith<$Res> {
  factory _$UsersStateCopyWith(_UsersState value, $Res Function(_UsersState) _then) = __$UsersStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<User> users, List<User> filteredUsers, String searchQuery, UsersTab activeTab, List<FriendConnectionDto> friendConnections, List<FriendRequestDto> friendRequests, List<UserWithFriendCountDto> usersWithFriendCount, List<UserWithFriendCountDto> popularUsers, bool isLoadingFriends, String? error, String? blockReason
});




}
/// @nodoc
class __$UsersStateCopyWithImpl<$Res>
    implements _$UsersStateCopyWith<$Res> {
  __$UsersStateCopyWithImpl(this._self, this._then);

  final _UsersState _self;
  final $Res Function(_UsersState) _then;

/// Create a copy of UsersState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? users = null,Object? filteredUsers = null,Object? searchQuery = null,Object? activeTab = null,Object? friendConnections = null,Object? friendRequests = null,Object? usersWithFriendCount = null,Object? popularUsers = null,Object? isLoadingFriends = null,Object? error = freezed,Object? blockReason = freezed,}) {
  return _then(_UsersState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<User>,filteredUsers: null == filteredUsers ? _self._filteredUsers : filteredUsers // ignore: cast_nullable_to_non_nullable
as List<User>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,activeTab: null == activeTab ? _self.activeTab : activeTab // ignore: cast_nullable_to_non_nullable
as UsersTab,friendConnections: null == friendConnections ? _self._friendConnections : friendConnections // ignore: cast_nullable_to_non_nullable
as List<FriendConnectionDto>,friendRequests: null == friendRequests ? _self._friendRequests : friendRequests // ignore: cast_nullable_to_non_nullable
as List<FriendRequestDto>,usersWithFriendCount: null == usersWithFriendCount ? _self._usersWithFriendCount : usersWithFriendCount // ignore: cast_nullable_to_non_nullable
as List<UserWithFriendCountDto>,popularUsers: null == popularUsers ? _self._popularUsers : popularUsers // ignore: cast_nullable_to_non_nullable
as List<UserWithFriendCountDto>,isLoadingFriends: null == isLoadingFriends ? _self.isLoadingFriends : isLoadingFriends // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,blockReason: freezed == blockReason ? _self.blockReason : blockReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
