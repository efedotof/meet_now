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

 bool get isLoading; bool get isSending; NotificationCompose get composeData; List<NotificationHistoryDto> get notificationHistory; List<UserWithTokenDto> get usersWithTokens; NotificationStatisticsDto? get notificationStatistics; TokenCoverageDto? get tokenCoverage; NotificationHistoryStatsDto? get notificationHistoryStats; List<UserWithTokenDto>? get onlineUsersWithTokens; UserTokenStatusDto? get selectedUserTokenStatus; List<NotificationHistoryDto>? get filteredHistory; NotificationFilter? get currentFilter; String? get filterValue; String get searchQuery; int get currentPage; int get totalPages; int get pageSize; String? get errorMessage; String? get successMessage;
/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushNotificationsStateCopyWith<PushNotificationsState> get copyWith => _$PushNotificationsStateCopyWithImpl<PushNotificationsState>(this as PushNotificationsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushNotificationsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.composeData, composeData) || other.composeData == composeData)&&const DeepCollectionEquality().equals(other.notificationHistory, notificationHistory)&&const DeepCollectionEquality().equals(other.usersWithTokens, usersWithTokens)&&(identical(other.notificationStatistics, notificationStatistics) || other.notificationStatistics == notificationStatistics)&&(identical(other.tokenCoverage, tokenCoverage) || other.tokenCoverage == tokenCoverage)&&(identical(other.notificationHistoryStats, notificationHistoryStats) || other.notificationHistoryStats == notificationHistoryStats)&&const DeepCollectionEquality().equals(other.onlineUsersWithTokens, onlineUsersWithTokens)&&(identical(other.selectedUserTokenStatus, selectedUserTokenStatus) || other.selectedUserTokenStatus == selectedUserTokenStatus)&&const DeepCollectionEquality().equals(other.filteredHistory, filteredHistory)&&(identical(other.currentFilter, currentFilter) || other.currentFilter == currentFilter)&&(identical(other.filterValue, filterValue) || other.filterValue == filterValue)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hashAll([runtimeType,isLoading,isSending,composeData,const DeepCollectionEquality().hash(notificationHistory),const DeepCollectionEquality().hash(usersWithTokens),notificationStatistics,tokenCoverage,notificationHistoryStats,const DeepCollectionEquality().hash(onlineUsersWithTokens),selectedUserTokenStatus,const DeepCollectionEquality().hash(filteredHistory),currentFilter,filterValue,searchQuery,currentPage,totalPages,pageSize,errorMessage,successMessage]);

@override
String toString() {
  return 'PushNotificationsState(isLoading: $isLoading, isSending: $isSending, composeData: $composeData, notificationHistory: $notificationHistory, usersWithTokens: $usersWithTokens, notificationStatistics: $notificationStatistics, tokenCoverage: $tokenCoverage, notificationHistoryStats: $notificationHistoryStats, onlineUsersWithTokens: $onlineUsersWithTokens, selectedUserTokenStatus: $selectedUserTokenStatus, filteredHistory: $filteredHistory, currentFilter: $currentFilter, filterValue: $filterValue, searchQuery: $searchQuery, currentPage: $currentPage, totalPages: $totalPages, pageSize: $pageSize, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class $PushNotificationsStateCopyWith<$Res>  {
  factory $PushNotificationsStateCopyWith(PushNotificationsState value, $Res Function(PushNotificationsState) _then) = _$PushNotificationsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isSending, NotificationCompose composeData, List<NotificationHistoryDto> notificationHistory, List<UserWithTokenDto> usersWithTokens, NotificationStatisticsDto? notificationStatistics, TokenCoverageDto? tokenCoverage, NotificationHistoryStatsDto? notificationHistoryStats, List<UserWithTokenDto>? onlineUsersWithTokens, UserTokenStatusDto? selectedUserTokenStatus, List<NotificationHistoryDto>? filteredHistory, NotificationFilter? currentFilter, String? filterValue, String searchQuery, int currentPage, int totalPages, int pageSize, String? errorMessage, String? successMessage
});


$NotificationStatisticsDtoCopyWith<$Res>? get notificationStatistics;$TokenCoverageDtoCopyWith<$Res>? get tokenCoverage;$NotificationHistoryStatsDtoCopyWith<$Res>? get notificationHistoryStats;$UserTokenStatusDtoCopyWith<$Res>? get selectedUserTokenStatus;

}
/// @nodoc
class _$PushNotificationsStateCopyWithImpl<$Res>
    implements $PushNotificationsStateCopyWith<$Res> {
  _$PushNotificationsStateCopyWithImpl(this._self, this._then);

  final PushNotificationsState _self;
  final $Res Function(PushNotificationsState) _then;

/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isSending = null,Object? composeData = null,Object? notificationHistory = null,Object? usersWithTokens = null,Object? notificationStatistics = freezed,Object? tokenCoverage = freezed,Object? notificationHistoryStats = freezed,Object? onlineUsersWithTokens = freezed,Object? selectedUserTokenStatus = freezed,Object? filteredHistory = freezed,Object? currentFilter = freezed,Object? filterValue = freezed,Object? searchQuery = null,Object? currentPage = null,Object? totalPages = null,Object? pageSize = null,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,composeData: null == composeData ? _self.composeData : composeData // ignore: cast_nullable_to_non_nullable
as NotificationCompose,notificationHistory: null == notificationHistory ? _self.notificationHistory : notificationHistory // ignore: cast_nullable_to_non_nullable
as List<NotificationHistoryDto>,usersWithTokens: null == usersWithTokens ? _self.usersWithTokens : usersWithTokens // ignore: cast_nullable_to_non_nullable
as List<UserWithTokenDto>,notificationStatistics: freezed == notificationStatistics ? _self.notificationStatistics : notificationStatistics // ignore: cast_nullable_to_non_nullable
as NotificationStatisticsDto?,tokenCoverage: freezed == tokenCoverage ? _self.tokenCoverage : tokenCoverage // ignore: cast_nullable_to_non_nullable
as TokenCoverageDto?,notificationHistoryStats: freezed == notificationHistoryStats ? _self.notificationHistoryStats : notificationHistoryStats // ignore: cast_nullable_to_non_nullable
as NotificationHistoryStatsDto?,onlineUsersWithTokens: freezed == onlineUsersWithTokens ? _self.onlineUsersWithTokens : onlineUsersWithTokens // ignore: cast_nullable_to_non_nullable
as List<UserWithTokenDto>?,selectedUserTokenStatus: freezed == selectedUserTokenStatus ? _self.selectedUserTokenStatus : selectedUserTokenStatus // ignore: cast_nullable_to_non_nullable
as UserTokenStatusDto?,filteredHistory: freezed == filteredHistory ? _self.filteredHistory : filteredHistory // ignore: cast_nullable_to_non_nullable
as List<NotificationHistoryDto>?,currentFilter: freezed == currentFilter ? _self.currentFilter : currentFilter // ignore: cast_nullable_to_non_nullable
as NotificationFilter?,filterValue: freezed == filterValue ? _self.filterValue : filterValue // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationStatisticsDtoCopyWith<$Res>? get notificationStatistics {
    if (_self.notificationStatistics == null) {
    return null;
  }

  return $NotificationStatisticsDtoCopyWith<$Res>(_self.notificationStatistics!, (value) {
    return _then(_self.copyWith(notificationStatistics: value));
  });
}/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenCoverageDtoCopyWith<$Res>? get tokenCoverage {
    if (_self.tokenCoverage == null) {
    return null;
  }

  return $TokenCoverageDtoCopyWith<$Res>(_self.tokenCoverage!, (value) {
    return _then(_self.copyWith(tokenCoverage: value));
  });
}/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationHistoryStatsDtoCopyWith<$Res>? get notificationHistoryStats {
    if (_self.notificationHistoryStats == null) {
    return null;
  }

  return $NotificationHistoryStatsDtoCopyWith<$Res>(_self.notificationHistoryStats!, (value) {
    return _then(_self.copyWith(notificationHistoryStats: value));
  });
}/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserTokenStatusDtoCopyWith<$Res>? get selectedUserTokenStatus {
    if (_self.selectedUserTokenStatus == null) {
    return null;
  }

  return $UserTokenStatusDtoCopyWith<$Res>(_self.selectedUserTokenStatus!, (value) {
    return _then(_self.copyWith(selectedUserTokenStatus: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isSending,  NotificationCompose composeData,  List<NotificationHistoryDto> notificationHistory,  List<UserWithTokenDto> usersWithTokens,  NotificationStatisticsDto? notificationStatistics,  TokenCoverageDto? tokenCoverage,  NotificationHistoryStatsDto? notificationHistoryStats,  List<UserWithTokenDto>? onlineUsersWithTokens,  UserTokenStatusDto? selectedUserTokenStatus,  List<NotificationHistoryDto>? filteredHistory,  NotificationFilter? currentFilter,  String? filterValue,  String searchQuery,  int currentPage,  int totalPages,  int pageSize,  String? errorMessage,  String? successMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushNotificationsState() when $default != null:
return $default(_that.isLoading,_that.isSending,_that.composeData,_that.notificationHistory,_that.usersWithTokens,_that.notificationStatistics,_that.tokenCoverage,_that.notificationHistoryStats,_that.onlineUsersWithTokens,_that.selectedUserTokenStatus,_that.filteredHistory,_that.currentFilter,_that.filterValue,_that.searchQuery,_that.currentPage,_that.totalPages,_that.pageSize,_that.errorMessage,_that.successMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isSending,  NotificationCompose composeData,  List<NotificationHistoryDto> notificationHistory,  List<UserWithTokenDto> usersWithTokens,  NotificationStatisticsDto? notificationStatistics,  TokenCoverageDto? tokenCoverage,  NotificationHistoryStatsDto? notificationHistoryStats,  List<UserWithTokenDto>? onlineUsersWithTokens,  UserTokenStatusDto? selectedUserTokenStatus,  List<NotificationHistoryDto>? filteredHistory,  NotificationFilter? currentFilter,  String? filterValue,  String searchQuery,  int currentPage,  int totalPages,  int pageSize,  String? errorMessage,  String? successMessage)  $default,) {final _that = this;
switch (_that) {
case _PushNotificationsState():
return $default(_that.isLoading,_that.isSending,_that.composeData,_that.notificationHistory,_that.usersWithTokens,_that.notificationStatistics,_that.tokenCoverage,_that.notificationHistoryStats,_that.onlineUsersWithTokens,_that.selectedUserTokenStatus,_that.filteredHistory,_that.currentFilter,_that.filterValue,_that.searchQuery,_that.currentPage,_that.totalPages,_that.pageSize,_that.errorMessage,_that.successMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isSending,  NotificationCompose composeData,  List<NotificationHistoryDto> notificationHistory,  List<UserWithTokenDto> usersWithTokens,  NotificationStatisticsDto? notificationStatistics,  TokenCoverageDto? tokenCoverage,  NotificationHistoryStatsDto? notificationHistoryStats,  List<UserWithTokenDto>? onlineUsersWithTokens,  UserTokenStatusDto? selectedUserTokenStatus,  List<NotificationHistoryDto>? filteredHistory,  NotificationFilter? currentFilter,  String? filterValue,  String searchQuery,  int currentPage,  int totalPages,  int pageSize,  String? errorMessage,  String? successMessage)?  $default,) {final _that = this;
switch (_that) {
case _PushNotificationsState() when $default != null:
return $default(_that.isLoading,_that.isSending,_that.composeData,_that.notificationHistory,_that.usersWithTokens,_that.notificationStatistics,_that.tokenCoverage,_that.notificationHistoryStats,_that.onlineUsersWithTokens,_that.selectedUserTokenStatus,_that.filteredHistory,_that.currentFilter,_that.filterValue,_that.searchQuery,_that.currentPage,_that.totalPages,_that.pageSize,_that.errorMessage,_that.successMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PushNotificationsState implements PushNotificationsState {
  const _PushNotificationsState({required this.isLoading, required this.isSending, required this.composeData, required final  List<NotificationHistoryDto> notificationHistory, required final  List<UserWithTokenDto> usersWithTokens, this.notificationStatistics, this.tokenCoverage, this.notificationHistoryStats, final  List<UserWithTokenDto>? onlineUsersWithTokens, this.selectedUserTokenStatus, final  List<NotificationHistoryDto>? filteredHistory, this.currentFilter, this.filterValue, required this.searchQuery, required this.currentPage, required this.totalPages, required this.pageSize, this.errorMessage, this.successMessage}): _notificationHistory = notificationHistory,_usersWithTokens = usersWithTokens,_onlineUsersWithTokens = onlineUsersWithTokens,_filteredHistory = filteredHistory;
  

@override final  bool isLoading;
@override final  bool isSending;
@override final  NotificationCompose composeData;
 final  List<NotificationHistoryDto> _notificationHistory;
@override List<NotificationHistoryDto> get notificationHistory {
  if (_notificationHistory is EqualUnmodifiableListView) return _notificationHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notificationHistory);
}

 final  List<UserWithTokenDto> _usersWithTokens;
@override List<UserWithTokenDto> get usersWithTokens {
  if (_usersWithTokens is EqualUnmodifiableListView) return _usersWithTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_usersWithTokens);
}

@override final  NotificationStatisticsDto? notificationStatistics;
@override final  TokenCoverageDto? tokenCoverage;
@override final  NotificationHistoryStatsDto? notificationHistoryStats;
 final  List<UserWithTokenDto>? _onlineUsersWithTokens;
@override List<UserWithTokenDto>? get onlineUsersWithTokens {
  final value = _onlineUsersWithTokens;
  if (value == null) return null;
  if (_onlineUsersWithTokens is EqualUnmodifiableListView) return _onlineUsersWithTokens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  UserTokenStatusDto? selectedUserTokenStatus;
 final  List<NotificationHistoryDto>? _filteredHistory;
@override List<NotificationHistoryDto>? get filteredHistory {
  final value = _filteredHistory;
  if (value == null) return null;
  if (_filteredHistory is EqualUnmodifiableListView) return _filteredHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  NotificationFilter? currentFilter;
@override final  String? filterValue;
@override final  String searchQuery;
@override final  int currentPage;
@override final  int totalPages;
@override final  int pageSize;
@override final  String? errorMessage;
@override final  String? successMessage;

/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushNotificationsStateCopyWith<_PushNotificationsState> get copyWith => __$PushNotificationsStateCopyWithImpl<_PushNotificationsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushNotificationsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSending, isSending) || other.isSending == isSending)&&(identical(other.composeData, composeData) || other.composeData == composeData)&&const DeepCollectionEquality().equals(other._notificationHistory, _notificationHistory)&&const DeepCollectionEquality().equals(other._usersWithTokens, _usersWithTokens)&&(identical(other.notificationStatistics, notificationStatistics) || other.notificationStatistics == notificationStatistics)&&(identical(other.tokenCoverage, tokenCoverage) || other.tokenCoverage == tokenCoverage)&&(identical(other.notificationHistoryStats, notificationHistoryStats) || other.notificationHistoryStats == notificationHistoryStats)&&const DeepCollectionEquality().equals(other._onlineUsersWithTokens, _onlineUsersWithTokens)&&(identical(other.selectedUserTokenStatus, selectedUserTokenStatus) || other.selectedUserTokenStatus == selectedUserTokenStatus)&&const DeepCollectionEquality().equals(other._filteredHistory, _filteredHistory)&&(identical(other.currentFilter, currentFilter) || other.currentFilter == currentFilter)&&(identical(other.filterValue, filterValue) || other.filterValue == filterValue)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.successMessage, successMessage) || other.successMessage == successMessage));
}


@override
int get hashCode => Object.hashAll([runtimeType,isLoading,isSending,composeData,const DeepCollectionEquality().hash(_notificationHistory),const DeepCollectionEquality().hash(_usersWithTokens),notificationStatistics,tokenCoverage,notificationHistoryStats,const DeepCollectionEquality().hash(_onlineUsersWithTokens),selectedUserTokenStatus,const DeepCollectionEquality().hash(_filteredHistory),currentFilter,filterValue,searchQuery,currentPage,totalPages,pageSize,errorMessage,successMessage]);

@override
String toString() {
  return 'PushNotificationsState(isLoading: $isLoading, isSending: $isSending, composeData: $composeData, notificationHistory: $notificationHistory, usersWithTokens: $usersWithTokens, notificationStatistics: $notificationStatistics, tokenCoverage: $tokenCoverage, notificationHistoryStats: $notificationHistoryStats, onlineUsersWithTokens: $onlineUsersWithTokens, selectedUserTokenStatus: $selectedUserTokenStatus, filteredHistory: $filteredHistory, currentFilter: $currentFilter, filterValue: $filterValue, searchQuery: $searchQuery, currentPage: $currentPage, totalPages: $totalPages, pageSize: $pageSize, errorMessage: $errorMessage, successMessage: $successMessage)';
}


}

/// @nodoc
abstract mixin class _$PushNotificationsStateCopyWith<$Res> implements $PushNotificationsStateCopyWith<$Res> {
  factory _$PushNotificationsStateCopyWith(_PushNotificationsState value, $Res Function(_PushNotificationsState) _then) = __$PushNotificationsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isSending, NotificationCompose composeData, List<NotificationHistoryDto> notificationHistory, List<UserWithTokenDto> usersWithTokens, NotificationStatisticsDto? notificationStatistics, TokenCoverageDto? tokenCoverage, NotificationHistoryStatsDto? notificationHistoryStats, List<UserWithTokenDto>? onlineUsersWithTokens, UserTokenStatusDto? selectedUserTokenStatus, List<NotificationHistoryDto>? filteredHistory, NotificationFilter? currentFilter, String? filterValue, String searchQuery, int currentPage, int totalPages, int pageSize, String? errorMessage, String? successMessage
});


@override $NotificationStatisticsDtoCopyWith<$Res>? get notificationStatistics;@override $TokenCoverageDtoCopyWith<$Res>? get tokenCoverage;@override $NotificationHistoryStatsDtoCopyWith<$Res>? get notificationHistoryStats;@override $UserTokenStatusDtoCopyWith<$Res>? get selectedUserTokenStatus;

}
/// @nodoc
class __$PushNotificationsStateCopyWithImpl<$Res>
    implements _$PushNotificationsStateCopyWith<$Res> {
  __$PushNotificationsStateCopyWithImpl(this._self, this._then);

  final _PushNotificationsState _self;
  final $Res Function(_PushNotificationsState) _then;

/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isSending = null,Object? composeData = null,Object? notificationHistory = null,Object? usersWithTokens = null,Object? notificationStatistics = freezed,Object? tokenCoverage = freezed,Object? notificationHistoryStats = freezed,Object? onlineUsersWithTokens = freezed,Object? selectedUserTokenStatus = freezed,Object? filteredHistory = freezed,Object? currentFilter = freezed,Object? filterValue = freezed,Object? searchQuery = null,Object? currentPage = null,Object? totalPages = null,Object? pageSize = null,Object? errorMessage = freezed,Object? successMessage = freezed,}) {
  return _then(_PushNotificationsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSending: null == isSending ? _self.isSending : isSending // ignore: cast_nullable_to_non_nullable
as bool,composeData: null == composeData ? _self.composeData : composeData // ignore: cast_nullable_to_non_nullable
as NotificationCompose,notificationHistory: null == notificationHistory ? _self._notificationHistory : notificationHistory // ignore: cast_nullable_to_non_nullable
as List<NotificationHistoryDto>,usersWithTokens: null == usersWithTokens ? _self._usersWithTokens : usersWithTokens // ignore: cast_nullable_to_non_nullable
as List<UserWithTokenDto>,notificationStatistics: freezed == notificationStatistics ? _self.notificationStatistics : notificationStatistics // ignore: cast_nullable_to_non_nullable
as NotificationStatisticsDto?,tokenCoverage: freezed == tokenCoverage ? _self.tokenCoverage : tokenCoverage // ignore: cast_nullable_to_non_nullable
as TokenCoverageDto?,notificationHistoryStats: freezed == notificationHistoryStats ? _self.notificationHistoryStats : notificationHistoryStats // ignore: cast_nullable_to_non_nullable
as NotificationHistoryStatsDto?,onlineUsersWithTokens: freezed == onlineUsersWithTokens ? _self._onlineUsersWithTokens : onlineUsersWithTokens // ignore: cast_nullable_to_non_nullable
as List<UserWithTokenDto>?,selectedUserTokenStatus: freezed == selectedUserTokenStatus ? _self.selectedUserTokenStatus : selectedUserTokenStatus // ignore: cast_nullable_to_non_nullable
as UserTokenStatusDto?,filteredHistory: freezed == filteredHistory ? _self._filteredHistory : filteredHistory // ignore: cast_nullable_to_non_nullable
as List<NotificationHistoryDto>?,currentFilter: freezed == currentFilter ? _self.currentFilter : currentFilter // ignore: cast_nullable_to_non_nullable
as NotificationFilter?,filterValue: freezed == filterValue ? _self.filterValue : filterValue // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,successMessage: freezed == successMessage ? _self.successMessage : successMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationStatisticsDtoCopyWith<$Res>? get notificationStatistics {
    if (_self.notificationStatistics == null) {
    return null;
  }

  return $NotificationStatisticsDtoCopyWith<$Res>(_self.notificationStatistics!, (value) {
    return _then(_self.copyWith(notificationStatistics: value));
  });
}/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenCoverageDtoCopyWith<$Res>? get tokenCoverage {
    if (_self.tokenCoverage == null) {
    return null;
  }

  return $TokenCoverageDtoCopyWith<$Res>(_self.tokenCoverage!, (value) {
    return _then(_self.copyWith(tokenCoverage: value));
  });
}/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationHistoryStatsDtoCopyWith<$Res>? get notificationHistoryStats {
    if (_self.notificationHistoryStats == null) {
    return null;
  }

  return $NotificationHistoryStatsDtoCopyWith<$Res>(_self.notificationHistoryStats!, (value) {
    return _then(_self.copyWith(notificationHistoryStats: value));
  });
}/// Create a copy of PushNotificationsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserTokenStatusDtoCopyWith<$Res>? get selectedUserTokenStatus {
    if (_self.selectedUserTokenStatus == null) {
    return null;
  }

  return $UserTokenStatusDtoCopyWith<$Res>(_self.selectedUserTokenStatus!, (value) {
    return _then(_self.copyWith(selectedUserTokenStatus: value));
  });
}
}

// dart format on
