// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ModerationState {

 bool get isLoading; List<ReportedContent> get reportedContent; List<UserReport> get userReports; ModerationFilter get filter; String get searchQuery; int get currentPage; bool get hasMore; ReportStatisticsDto? get reportsStatistics; SupportStatisticsDto? get supportStatistics; String? get error;
/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModerationStateCopyWith<ModerationState> get copyWith => _$ModerationStateCopyWithImpl<ModerationState>(this as ModerationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModerationState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.reportedContent, reportedContent)&&const DeepCollectionEquality().equals(other.userReports, userReports)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.reportsStatistics, reportsStatistics) || other.reportsStatistics == reportsStatistics)&&(identical(other.supportStatistics, supportStatistics) || other.supportStatistics == supportStatistics)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(reportedContent),const DeepCollectionEquality().hash(userReports),filter,searchQuery,currentPage,hasMore,reportsStatistics,supportStatistics,error);

@override
String toString() {
  return 'ModerationState(isLoading: $isLoading, reportedContent: $reportedContent, userReports: $userReports, filter: $filter, searchQuery: $searchQuery, currentPage: $currentPage, hasMore: $hasMore, reportsStatistics: $reportsStatistics, supportStatistics: $supportStatistics, error: $error)';
}


}

/// @nodoc
abstract mixin class $ModerationStateCopyWith<$Res>  {
  factory $ModerationStateCopyWith(ModerationState value, $Res Function(ModerationState) _then) = _$ModerationStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<ReportedContent> reportedContent, List<UserReport> userReports, ModerationFilter filter, String searchQuery, int currentPage, bool hasMore, ReportStatisticsDto? reportsStatistics, SupportStatisticsDto? supportStatistics, String? error
});


$ReportStatisticsDtoCopyWith<$Res>? get reportsStatistics;$SupportStatisticsDtoCopyWith<$Res>? get supportStatistics;

}
/// @nodoc
class _$ModerationStateCopyWithImpl<$Res>
    implements $ModerationStateCopyWith<$Res> {
  _$ModerationStateCopyWithImpl(this._self, this._then);

  final ModerationState _self;
  final $Res Function(ModerationState) _then;

/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? reportedContent = null,Object? userReports = null,Object? filter = null,Object? searchQuery = null,Object? currentPage = null,Object? hasMore = null,Object? reportsStatistics = freezed,Object? supportStatistics = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,reportedContent: null == reportedContent ? _self.reportedContent : reportedContent // ignore: cast_nullable_to_non_nullable
as List<ReportedContent>,userReports: null == userReports ? _self.userReports : userReports // ignore: cast_nullable_to_non_nullable
as List<UserReport>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as ModerationFilter,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,reportsStatistics: freezed == reportsStatistics ? _self.reportsStatistics : reportsStatistics // ignore: cast_nullable_to_non_nullable
as ReportStatisticsDto?,supportStatistics: freezed == supportStatistics ? _self.supportStatistics : supportStatistics // ignore: cast_nullable_to_non_nullable
as SupportStatisticsDto?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportStatisticsDtoCopyWith<$Res>? get reportsStatistics {
    if (_self.reportsStatistics == null) {
    return null;
  }

  return $ReportStatisticsDtoCopyWith<$Res>(_self.reportsStatistics!, (value) {
    return _then(_self.copyWith(reportsStatistics: value));
  });
}/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupportStatisticsDtoCopyWith<$Res>? get supportStatistics {
    if (_self.supportStatistics == null) {
    return null;
  }

  return $SupportStatisticsDtoCopyWith<$Res>(_self.supportStatistics!, (value) {
    return _then(_self.copyWith(supportStatistics: value));
  });
}
}


/// Adds pattern-matching-related methods to [ModerationState].
extension ModerationStatePatterns on ModerationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModerationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModerationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModerationState value)  $default,){
final _that = this;
switch (_that) {
case _ModerationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModerationState value)?  $default,){
final _that = this;
switch (_that) {
case _ModerationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<ReportedContent> reportedContent,  List<UserReport> userReports,  ModerationFilter filter,  String searchQuery,  int currentPage,  bool hasMore,  ReportStatisticsDto? reportsStatistics,  SupportStatisticsDto? supportStatistics,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModerationState() when $default != null:
return $default(_that.isLoading,_that.reportedContent,_that.userReports,_that.filter,_that.searchQuery,_that.currentPage,_that.hasMore,_that.reportsStatistics,_that.supportStatistics,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<ReportedContent> reportedContent,  List<UserReport> userReports,  ModerationFilter filter,  String searchQuery,  int currentPage,  bool hasMore,  ReportStatisticsDto? reportsStatistics,  SupportStatisticsDto? supportStatistics,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ModerationState():
return $default(_that.isLoading,_that.reportedContent,_that.userReports,_that.filter,_that.searchQuery,_that.currentPage,_that.hasMore,_that.reportsStatistics,_that.supportStatistics,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<ReportedContent> reportedContent,  List<UserReport> userReports,  ModerationFilter filter,  String searchQuery,  int currentPage,  bool hasMore,  ReportStatisticsDto? reportsStatistics,  SupportStatisticsDto? supportStatistics,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ModerationState() when $default != null:
return $default(_that.isLoading,_that.reportedContent,_that.userReports,_that.filter,_that.searchQuery,_that.currentPage,_that.hasMore,_that.reportsStatistics,_that.supportStatistics,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ModerationState implements ModerationState {
  const _ModerationState({required this.isLoading, required final  List<ReportedContent> reportedContent, required final  List<UserReport> userReports, required this.filter, required this.searchQuery, required this.currentPage, required this.hasMore, this.reportsStatistics, this.supportStatistics, this.error}): _reportedContent = reportedContent,_userReports = userReports;
  

@override final  bool isLoading;
 final  List<ReportedContent> _reportedContent;
@override List<ReportedContent> get reportedContent {
  if (_reportedContent is EqualUnmodifiableListView) return _reportedContent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reportedContent);
}

 final  List<UserReport> _userReports;
@override List<UserReport> get userReports {
  if (_userReports is EqualUnmodifiableListView) return _userReports;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userReports);
}

@override final  ModerationFilter filter;
@override final  String searchQuery;
@override final  int currentPage;
@override final  bool hasMore;
@override final  ReportStatisticsDto? reportsStatistics;
@override final  SupportStatisticsDto? supportStatistics;
@override final  String? error;

/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModerationStateCopyWith<_ModerationState> get copyWith => __$ModerationStateCopyWithImpl<_ModerationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModerationState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._reportedContent, _reportedContent)&&const DeepCollectionEquality().equals(other._userReports, _userReports)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.reportsStatistics, reportsStatistics) || other.reportsStatistics == reportsStatistics)&&(identical(other.supportStatistics, supportStatistics) || other.supportStatistics == supportStatistics)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_reportedContent),const DeepCollectionEquality().hash(_userReports),filter,searchQuery,currentPage,hasMore,reportsStatistics,supportStatistics,error);

@override
String toString() {
  return 'ModerationState(isLoading: $isLoading, reportedContent: $reportedContent, userReports: $userReports, filter: $filter, searchQuery: $searchQuery, currentPage: $currentPage, hasMore: $hasMore, reportsStatistics: $reportsStatistics, supportStatistics: $supportStatistics, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ModerationStateCopyWith<$Res> implements $ModerationStateCopyWith<$Res> {
  factory _$ModerationStateCopyWith(_ModerationState value, $Res Function(_ModerationState) _then) = __$ModerationStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<ReportedContent> reportedContent, List<UserReport> userReports, ModerationFilter filter, String searchQuery, int currentPage, bool hasMore, ReportStatisticsDto? reportsStatistics, SupportStatisticsDto? supportStatistics, String? error
});


@override $ReportStatisticsDtoCopyWith<$Res>? get reportsStatistics;@override $SupportStatisticsDtoCopyWith<$Res>? get supportStatistics;

}
/// @nodoc
class __$ModerationStateCopyWithImpl<$Res>
    implements _$ModerationStateCopyWith<$Res> {
  __$ModerationStateCopyWithImpl(this._self, this._then);

  final _ModerationState _self;
  final $Res Function(_ModerationState) _then;

/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? reportedContent = null,Object? userReports = null,Object? filter = null,Object? searchQuery = null,Object? currentPage = null,Object? hasMore = null,Object? reportsStatistics = freezed,Object? supportStatistics = freezed,Object? error = freezed,}) {
  return _then(_ModerationState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,reportedContent: null == reportedContent ? _self._reportedContent : reportedContent // ignore: cast_nullable_to_non_nullable
as List<ReportedContent>,userReports: null == userReports ? _self._userReports : userReports // ignore: cast_nullable_to_non_nullable
as List<UserReport>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as ModerationFilter,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,reportsStatistics: freezed == reportsStatistics ? _self.reportsStatistics : reportsStatistics // ignore: cast_nullable_to_non_nullable
as ReportStatisticsDto?,supportStatistics: freezed == supportStatistics ? _self.supportStatistics : supportStatistics // ignore: cast_nullable_to_non_nullable
as SupportStatisticsDto?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReportStatisticsDtoCopyWith<$Res>? get reportsStatistics {
    if (_self.reportsStatistics == null) {
    return null;
  }

  return $ReportStatisticsDtoCopyWith<$Res>(_self.reportsStatistics!, (value) {
    return _then(_self.copyWith(reportsStatistics: value));
  });
}/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SupportStatisticsDtoCopyWith<$Res>? get supportStatistics {
    if (_self.supportStatistics == null) {
    return null;
  }

  return $SupportStatisticsDtoCopyWith<$Res>(_self.supportStatistics!, (value) {
    return _then(_self.copyWith(supportStatistics: value));
  });
}
}

// dart format on
