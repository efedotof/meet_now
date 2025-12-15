// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_notifications_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PushNotificationsState {

 bool get isLoading; bool get isSending; NotificationCompose get composeData; List<SentNotification> get sentNotifications; NotificationStats get stats; String get searchQuery;
/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushNotificationsStateCopyWith<PushNotificationsState> get copyWith => _$PushNotificationsStateCopyWithImpl<PushNotificationsState>(this as PushNotificationsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushNotificationsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.composeData, composeData) || other.composeData == composeData)&&const DeepCollectionEquality().equals(other.sentNotifications, sentNotifications)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isSending,composeData,const DeepCollectionEquality().hash(sentNotifications),stats,searchQuery);

@override
String toString() {
  return 'PushNotificationsState(isLoading: $isLoading, isSending: $isSending, composeData: $composeData, sentNotifications: $sentNotifications, stats: $stats, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $PushNotificationsStateCopyWith<$Res>  {
  factory $PushNotificationsStateCopyWith(PushNotificationsState value, $Res Function(PushNotificationsState) _then) = _$PushNotificationsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isSending, NotificationCompose composeData, List<SentNotification> sentNotifications, NotificationStats stats, String searchQuery
});




}
/// @nodoc
class _$PushNotificationsStateCopyWithImpl<$Res>
    implements $PushNotificationsStateCopyWith<$Res> {
  _$PushNotificationsStateCopyWithImpl(this._self, this._then);

  final PushNotificationsState _self;
  final $Res Function(PushNotificationsState) _then;

/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isSending = null,Object? composeData = null,Object? sentNotifications = null,Object? stats = null,Object? searchQuery = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,composeData: null == composeData ? _self.composeData : composeData // ignore: cast_nullable_to_non_nullable
as NotificationCompose,sentNotifications: null == sentNotifications ? _self.sentNotifications : sentNotifications // ignore: cast_nullable_to_non_nullable
as List<SentNotification>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as NotificationStats,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PushNotificationsState].
extension PushNotificationsStatePatterns on PushNotificationsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushNotificationsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushNotificationsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushNotificationsState value)  $default,){
final _that = this;
switch (_that) {
case _PushNotificationsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushNotificationsState value)?  $default,){
final _that = this;
switch (_that) {
case _PushNotificationsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isSending,  NotificationCompose composeData,  List<SentNotification> sentNotifications,  NotificationStats stats,  String searchQuery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushNotificationsState() when $default != null:
return $default(_that.isLoading,_that.isSending,_that.composeData,_that.sentNotifications,_that.stats,_that.searchQuery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isSending,  NotificationCompose composeData,  List<SentNotification> sentNotifications,  NotificationStats stats,  String searchQuery)  $default,) {final _that = this;
switch (_that) {
case _PushNotificationsState():
return $default(_that.isLoading,_that.isSending,_that.composeData,_that.sentNotifications,_that.stats,_that.searchQuery);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isSending,  NotificationCompose composeData,  List<SentNotification> sentNotifications,  NotificationStats stats,  String searchQuery)?  $default,) {final _that = this;
switch (_that) {
case _PushNotificationsState() when $default != null:
return $default(_that.isLoading,_that.isSending,_that.composeData,_that.sentNotifications,_that.stats,_that.searchQuery);case _:
  return null;

}
}

}

/// @nodoc


class _PushNotificationsState implements PushNotificationsState {
  const _PushNotificationsState({required this.isLoading, required this.isSending, required this.composeData, required final  List<SentNotification> sentNotifications, required this.stats, required this.searchQuery}): _sentNotifications = sentNotifications;
  

@override final  bool isLoading;
@override final  bool isSending;
@override final  NotificationCompose composeData;
 final  List<SentNotification> _sentNotifications;
@override List<SentNotification> get sentNotifications {
  if (_sentNotifications is EqualUnmodifiableListView) return _sentNotifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sentNotifications);
}

@override final  NotificationStats stats;
@override final  String searchQuery;

/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushNotificationsStateCopyWith<_PushNotificationsState> get copyWith => __$PushNotificationsStateCopyWithImpl<_PushNotificationsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushNotificationsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.composeData, composeData) || other.composeData == composeData)&&const DeepCollectionEquality().equals(other._sentNotifications, _sentNotifications)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isSending,composeData,const DeepCollectionEquality().hash(_sentNotifications),stats,searchQuery);

@override
String toString() {
  return 'PushNotificationsState(isLoading: $isLoading, isSending: $isSending, composeData: $composeData, sentNotifications: $sentNotifications, stats: $stats, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$PushNotificationsStateCopyWith<$Res> implements $PushNotificationsStateCopyWith<$Res> {
  factory _$PushNotificationsStateCopyWith(_PushNotificationsState value, $Res Function(_PushNotificationsState) _then) = __$PushNotificationsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isSending, NotificationCompose composeData, List<SentNotification> sentNotifications, NotificationStats stats, String searchQuery
});




}
/// @nodoc
class __$PushNotificationsStateCopyWithImpl<$Res>
    implements _$PushNotificationsStateCopyWith<$Res> {
  __$PushNotificationsStateCopyWithImpl(this._self, this._then);

  final _PushNotificationsState _self;
  final $Res Function(_PushNotificationsState) _then;

/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isSending = null,Object? composeData = null,Object? sentNotifications = null,Object? stats = null,Object? searchQuery = null,}) {
  return _then(_PushNotificationsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,composeData: null == composeData ? _self.composeData : composeData // ignore: cast_nullable_to_non_nullable
as NotificationCompose,sentNotifications: null == sentNotifications ? _self._sentNotifications : sentNotifications // ignore: cast_nullable_to_non_nullable
as List<SentNotification>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as NotificationStats,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
