// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardState {

 bool get isLoading; int get totalUsers; int get activeSessions; int get totalMeetings; double get systemHealth; List<MeetingStats> get meetingStats; List<SystemAlert> get alerts; DateTime? get lastUpdated; String? get error; int get onlineUsers; int get newUsers; RealtimeStatisticsDto get realtimeStats;
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardStateCopyWith<DashboardState> get copyWith => _$DashboardStateCopyWithImpl<DashboardState>(this as DashboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.activeSessions, activeSessions) || other.activeSessions == activeSessions)&&(identical(other.totalMeetings, totalMeetings) || other.totalMeetings == totalMeetings)&&(identical(other.systemHealth, systemHealth) || other.systemHealth == systemHealth)&&const DeepCollectionEquality().equals(other.meetingStats, meetingStats)&&const DeepCollectionEquality().equals(other.alerts, alerts)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.error, error) || other.error == error)&&(identical(other.onlineUsers, onlineUsers) || other.onlineUsers == onlineUsers)&&(identical(other.newUsers, newUsers) || other.newUsers == newUsers)&&(identical(other.realtimeStats, realtimeStats) || other.realtimeStats == realtimeStats));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,totalUsers,activeSessions,totalMeetings,systemHealth,const DeepCollectionEquality().hash(meetingStats),const DeepCollectionEquality().hash(alerts),lastUpdated,error,onlineUsers,newUsers,realtimeStats);

@override
String toString() {
  return 'DashboardState(isLoading: $isLoading, totalUsers: $totalUsers, activeSessions: $activeSessions, totalMeetings: $totalMeetings, systemHealth: $systemHealth, meetingStats: $meetingStats, alerts: $alerts, lastUpdated: $lastUpdated, error: $error, onlineUsers: $onlineUsers, newUsers: $newUsers, realtimeStats: $realtimeStats)';
}


}

/// @nodoc
abstract mixin class $DashboardStateCopyWith<$Res>  {
  factory $DashboardStateCopyWith(DashboardState value, $Res Function(DashboardState) _then) = _$DashboardStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, int totalUsers, int activeSessions, int totalMeetings, double systemHealth, List<MeetingStats> meetingStats, List<SystemAlert> alerts, DateTime? lastUpdated, String? error, int onlineUsers, int newUsers, RealtimeStatisticsDto realtimeStats
});


$RealtimeStatisticsDtoCopyWith<$Res> get realtimeStats;

}
/// @nodoc
class _$DashboardStateCopyWithImpl<$Res>
    implements $DashboardStateCopyWith<$Res> {
  _$DashboardStateCopyWithImpl(this._self, this._then);

  final DashboardState _self;
  final $Res Function(DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? totalUsers = null,Object? activeSessions = null,Object? totalMeetings = null,Object? systemHealth = null,Object? meetingStats = null,Object? alerts = null,Object? lastUpdated = freezed,Object? error = freezed,Object? onlineUsers = null,Object? newUsers = null,Object? realtimeStats = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,activeSessions: null == activeSessions ? _self.activeSessions : activeSessions // ignore: cast_nullable_to_non_nullable
as int,totalMeetings: null == totalMeetings ? _self.totalMeetings : totalMeetings // ignore: cast_nullable_to_non_nullable
as int,systemHealth: null == systemHealth ? _self.systemHealth : systemHealth // ignore: cast_nullable_to_non_nullable
as double,meetingStats: null == meetingStats ? _self.meetingStats : meetingStats // ignore: cast_nullable_to_non_nullable
as List<MeetingStats>,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<SystemAlert>,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,onlineUsers: null == onlineUsers ? _self.onlineUsers : onlineUsers // ignore: cast_nullable_to_non_nullable
as int,newUsers: null == newUsers ? _self.newUsers : newUsers // ignore: cast_nullable_to_non_nullable
as int,realtimeStats: null == realtimeStats ? _self.realtimeStats : realtimeStats // ignore: cast_nullable_to_non_nullable
as RealtimeStatisticsDto,
  ));
}
/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RealtimeStatisticsDtoCopyWith<$Res> get realtimeStats {
  
  return $RealtimeStatisticsDtoCopyWith<$Res>(_self.realtimeStats, (value) {
    return _then(_self.copyWith(realtimeStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardState].
extension DashboardStatePatterns on DashboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  int totalUsers,  int activeSessions,  int totalMeetings,  double systemHealth,  List<MeetingStats> meetingStats,  List<SystemAlert> alerts,  DateTime? lastUpdated,  String? error,  int onlineUsers,  int newUsers,  RealtimeStatisticsDto realtimeStats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.isLoading,_that.totalUsers,_that.activeSessions,_that.totalMeetings,_that.systemHealth,_that.meetingStats,_that.alerts,_that.lastUpdated,_that.error,_that.onlineUsers,_that.newUsers,_that.realtimeStats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  int totalUsers,  int activeSessions,  int totalMeetings,  double systemHealth,  List<MeetingStats> meetingStats,  List<SystemAlert> alerts,  DateTime? lastUpdated,  String? error,  int onlineUsers,  int newUsers,  RealtimeStatisticsDto realtimeStats)  $default,) {final _that = this;
switch (_that) {
case _DashboardState():
return $default(_that.isLoading,_that.totalUsers,_that.activeSessions,_that.totalMeetings,_that.systemHealth,_that.meetingStats,_that.alerts,_that.lastUpdated,_that.error,_that.onlineUsers,_that.newUsers,_that.realtimeStats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  int totalUsers,  int activeSessions,  int totalMeetings,  double systemHealth,  List<MeetingStats> meetingStats,  List<SystemAlert> alerts,  DateTime? lastUpdated,  String? error,  int onlineUsers,  int newUsers,  RealtimeStatisticsDto realtimeStats)?  $default,) {final _that = this;
switch (_that) {
case _DashboardState() when $default != null:
return $default(_that.isLoading,_that.totalUsers,_that.activeSessions,_that.totalMeetings,_that.systemHealth,_that.meetingStats,_that.alerts,_that.lastUpdated,_that.error,_that.onlineUsers,_that.newUsers,_that.realtimeStats);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardState implements DashboardState {
  const _DashboardState({required this.isLoading, required this.totalUsers, required this.activeSessions, required this.totalMeetings, required this.systemHealth, required final  List<MeetingStats> meetingStats, required final  List<SystemAlert> alerts, this.lastUpdated, this.error, required this.onlineUsers, required this.newUsers, required this.realtimeStats}): _meetingStats = meetingStats,_alerts = alerts;
  

@override final  bool isLoading;
@override final  int totalUsers;
@override final  int activeSessions;
@override final  int totalMeetings;
@override final  double systemHealth;
 final  List<MeetingStats> _meetingStats;
@override List<MeetingStats> get meetingStats {
  if (_meetingStats is EqualUnmodifiableListView) return _meetingStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_meetingStats);
}

 final  List<SystemAlert> _alerts;
@override List<SystemAlert> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}

@override final  DateTime? lastUpdated;
@override final  String? error;
@override final  int onlineUsers;
@override final  int newUsers;
@override final  RealtimeStatisticsDto realtimeStats;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardStateCopyWith<_DashboardState> get copyWith => __$DashboardStateCopyWithImpl<_DashboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.activeSessions, activeSessions) || other.activeSessions == activeSessions)&&(identical(other.totalMeetings, totalMeetings) || other.totalMeetings == totalMeetings)&&(identical(other.systemHealth, systemHealth) || other.systemHealth == systemHealth)&&const DeepCollectionEquality().equals(other._meetingStats, _meetingStats)&&const DeepCollectionEquality().equals(other._alerts, _alerts)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.error, error) || other.error == error)&&(identical(other.onlineUsers, onlineUsers) || other.onlineUsers == onlineUsers)&&(identical(other.newUsers, newUsers) || other.newUsers == newUsers)&&(identical(other.realtimeStats, realtimeStats) || other.realtimeStats == realtimeStats));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,totalUsers,activeSessions,totalMeetings,systemHealth,const DeepCollectionEquality().hash(_meetingStats),const DeepCollectionEquality().hash(_alerts),lastUpdated,error,onlineUsers,newUsers,realtimeStats);

@override
String toString() {
  return 'DashboardState(isLoading: $isLoading, totalUsers: $totalUsers, activeSessions: $activeSessions, totalMeetings: $totalMeetings, systemHealth: $systemHealth, meetingStats: $meetingStats, alerts: $alerts, lastUpdated: $lastUpdated, error: $error, onlineUsers: $onlineUsers, newUsers: $newUsers, realtimeStats: $realtimeStats)';
}


}

/// @nodoc
abstract mixin class _$DashboardStateCopyWith<$Res> implements $DashboardStateCopyWith<$Res> {
  factory _$DashboardStateCopyWith(_DashboardState value, $Res Function(_DashboardState) _then) = __$DashboardStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, int totalUsers, int activeSessions, int totalMeetings, double systemHealth, List<MeetingStats> meetingStats, List<SystemAlert> alerts, DateTime? lastUpdated, String? error, int onlineUsers, int newUsers, RealtimeStatisticsDto realtimeStats
});


@override $RealtimeStatisticsDtoCopyWith<$Res> get realtimeStats;

}
/// @nodoc
class __$DashboardStateCopyWithImpl<$Res>
    implements _$DashboardStateCopyWith<$Res> {
  __$DashboardStateCopyWithImpl(this._self, this._then);

  final _DashboardState _self;
  final $Res Function(_DashboardState) _then;

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? totalUsers = null,Object? activeSessions = null,Object? totalMeetings = null,Object? systemHealth = null,Object? meetingStats = null,Object? alerts = null,Object? lastUpdated = freezed,Object? error = freezed,Object? onlineUsers = null,Object? newUsers = null,Object? realtimeStats = null,}) {
  return _then(_DashboardState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,activeSessions: null == activeSessions ? _self.activeSessions : activeSessions // ignore: cast_nullable_to_non_nullable
as int,totalMeetings: null == totalMeetings ? _self.totalMeetings : totalMeetings // ignore: cast_nullable_to_non_nullable
as int,systemHealth: null == systemHealth ? _self.systemHealth : systemHealth // ignore: cast_nullable_to_non_nullable
as double,meetingStats: null == meetingStats ? _self._meetingStats : meetingStats // ignore: cast_nullable_to_non_nullable
as List<MeetingStats>,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<SystemAlert>,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,onlineUsers: null == onlineUsers ? _self.onlineUsers : onlineUsers // ignore: cast_nullable_to_non_nullable
as int,newUsers: null == newUsers ? _self.newUsers : newUsers // ignore: cast_nullable_to_non_nullable
as int,realtimeStats: null == realtimeStats ? _self.realtimeStats : realtimeStats // ignore: cast_nullable_to_non_nullable
as RealtimeStatisticsDto,
  ));
}

/// Create a copy of DashboardState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RealtimeStatisticsDtoCopyWith<$Res> get realtimeStats {
  
  return $RealtimeStatisticsDtoCopyWith<$Res>(_self.realtimeStats, (value) {
    return _then(_self.copyWith(realtimeStats: value));
  });
}
}

// dart format on
