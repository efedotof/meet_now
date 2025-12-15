// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SystemState {

 bool get isLoading; SystemHealth get systemHealth; ServerStatus get serverStatus; List<SystemLog> get systemLogs; SystemConfig get config; List<BackupRecord> get backups; SystemPerformance get performance; String get searchQuery;
/// Create a copy of SystemState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SystemStateCopyWith<SystemState> get copyWith => _$SystemStateCopyWithImpl<SystemState>(this as SystemState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.systemHealth, systemHealth) || other.systemHealth == systemHealth)&&(identical(other.serverStatus, serverStatus) || other.serverStatus == serverStatus)&&const DeepCollectionEquality().equals(other.systemLogs, systemLogs)&&(identical(other.config, config) || other.config == config)&&const DeepCollectionEquality().equals(other.backups, backups)&&(identical(other.performance, performance) || other.performance == performance)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,systemHealth,serverStatus,const DeepCollectionEquality().hash(systemLogs),config,const DeepCollectionEquality().hash(backups),performance,searchQuery);

@override
String toString() {
  return 'SystemState(isLoading: $isLoading, systemHealth: $systemHealth, serverStatus: $serverStatus, systemLogs: $systemLogs, config: $config, backups: $backups, performance: $performance, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $SystemStateCopyWith<$Res>  {
  factory $SystemStateCopyWith(SystemState value, $Res Function(SystemState) _then) = _$SystemStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, SystemHealth systemHealth, ServerStatus serverStatus, List<SystemLog> systemLogs, SystemConfig config, List<BackupRecord> backups, SystemPerformance performance, String searchQuery
});




}
/// @nodoc
class _$SystemStateCopyWithImpl<$Res>
    implements $SystemStateCopyWith<$Res> {
  _$SystemStateCopyWithImpl(this._self, this._then);

  final SystemState _self;
  final $Res Function(SystemState) _then;

/// Create a copy of SystemState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? systemHealth = null,Object? serverStatus = null,Object? systemLogs = null,Object? config = null,Object? backups = null,Object? performance = null,Object? searchQuery = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,systemHealth: null == systemHealth ? _self.systemHealth : systemHealth // ignore: cast_nullable_to_non_nullable
as SystemHealth,serverStatus: null == serverStatus ? _self.serverStatus : serverStatus // ignore: cast_nullable_to_non_nullable
as ServerStatus,systemLogs: null == systemLogs ? _self.systemLogs : systemLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLog>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as SystemConfig,backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as List<BackupRecord>,performance: null == performance ? _self.performance : performance // ignore: cast_nullable_to_non_nullable
as SystemPerformance,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SystemState].
extension SystemStatePatterns on SystemState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SystemState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SystemState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SystemState value)  $default,){
final _that = this;
switch (_that) {
case _SystemState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SystemState value)?  $default,){
final _that = this;
switch (_that) {
case _SystemState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  SystemHealth systemHealth,  ServerStatus serverStatus,  List<SystemLog> systemLogs,  SystemConfig config,  List<BackupRecord> backups,  SystemPerformance performance,  String searchQuery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SystemState() when $default != null:
return $default(_that.isLoading,_that.systemHealth,_that.serverStatus,_that.systemLogs,_that.config,_that.backups,_that.performance,_that.searchQuery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  SystemHealth systemHealth,  ServerStatus serverStatus,  List<SystemLog> systemLogs,  SystemConfig config,  List<BackupRecord> backups,  SystemPerformance performance,  String searchQuery)  $default,) {final _that = this;
switch (_that) {
case _SystemState():
return $default(_that.isLoading,_that.systemHealth,_that.serverStatus,_that.systemLogs,_that.config,_that.backups,_that.performance,_that.searchQuery);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  SystemHealth systemHealth,  ServerStatus serverStatus,  List<SystemLog> systemLogs,  SystemConfig config,  List<BackupRecord> backups,  SystemPerformance performance,  String searchQuery)?  $default,) {final _that = this;
switch (_that) {
case _SystemState() when $default != null:
return $default(_that.isLoading,_that.systemHealth,_that.serverStatus,_that.systemLogs,_that.config,_that.backups,_that.performance,_that.searchQuery);case _:
  return null;

}
}

}

/// @nodoc


class _SystemState implements SystemState {
  const _SystemState({required this.isLoading, required this.systemHealth, required this.serverStatus, required final  List<SystemLog> systemLogs, required this.config, required final  List<BackupRecord> backups, required this.performance, required this.searchQuery}): _systemLogs = systemLogs,_backups = backups;
  

@override final  bool isLoading;
@override final  SystemHealth systemHealth;
@override final  ServerStatus serverStatus;
 final  List<SystemLog> _systemLogs;
@override List<SystemLog> get systemLogs {
  if (_systemLogs is EqualUnmodifiableListView) return _systemLogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_systemLogs);
}

@override final  SystemConfig config;
 final  List<BackupRecord> _backups;
@override List<BackupRecord> get backups {
  if (_backups is EqualUnmodifiableListView) return _backups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_backups);
}

@override final  SystemPerformance performance;
@override final  String searchQuery;

/// Create a copy of SystemState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SystemStateCopyWith<_SystemState> get copyWith => __$SystemStateCopyWithImpl<_SystemState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SystemState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.systemHealth, systemHealth) || other.systemHealth == systemHealth)&&(identical(other.serverStatus, serverStatus) || other.serverStatus == serverStatus)&&const DeepCollectionEquality().equals(other._systemLogs, _systemLogs)&&(identical(other.config, config) || other.config == config)&&const DeepCollectionEquality().equals(other._backups, _backups)&&(identical(other.performance, performance) || other.performance == performance)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,systemHealth,serverStatus,const DeepCollectionEquality().hash(_systemLogs),config,const DeepCollectionEquality().hash(_backups),performance,searchQuery);

@override
String toString() {
  return 'SystemState(isLoading: $isLoading, systemHealth: $systemHealth, serverStatus: $serverStatus, systemLogs: $systemLogs, config: $config, backups: $backups, performance: $performance, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$SystemStateCopyWith<$Res> implements $SystemStateCopyWith<$Res> {
  factory _$SystemStateCopyWith(_SystemState value, $Res Function(_SystemState) _then) = __$SystemStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, SystemHealth systemHealth, ServerStatus serverStatus, List<SystemLog> systemLogs, SystemConfig config, List<BackupRecord> backups, SystemPerformance performance, String searchQuery
});




}
/// @nodoc
class __$SystemStateCopyWithImpl<$Res>
    implements _$SystemStateCopyWith<$Res> {
  __$SystemStateCopyWithImpl(this._self, this._then);

  final _SystemState _self;
  final $Res Function(_SystemState) _then;

/// Create a copy of SystemState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? systemHealth = null,Object? serverStatus = null,Object? systemLogs = null,Object? config = null,Object? backups = null,Object? performance = null,Object? searchQuery = null,}) {
  return _then(_SystemState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,systemHealth: null == systemHealth ? _self.systemHealth : systemHealth // ignore: cast_nullable_to_non_nullable
as SystemHealth,serverStatus: null == serverStatus ? _self.serverStatus : serverStatus // ignore: cast_nullable_to_non_nullable
as ServerStatus,systemLogs: null == systemLogs ? _self._systemLogs : systemLogs // ignore: cast_nullable_to_non_nullable
as List<SystemLog>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as SystemConfig,backups: null == backups ? _self._backups : backups // ignore: cast_nullable_to_non_nullable
as List<BackupRecord>,performance: null == performance ? _self.performance : performance // ignore: cast_nullable_to_non_nullable
as SystemPerformance,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
