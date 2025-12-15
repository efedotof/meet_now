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

 bool get isLoading; List<ReportedContent> get reportedContent; List<Question> get questions; List<UserQuestionStatisticDto> get activeSupportUsers; ModerationCategory get selectedCategory; ReportStatus? get selectedReportStatus; String get searchQuery; int get totalReports; int get totalQuestions; ReportStatisticsDto? get reportsStatistics; SupportStatisticsDto? get supportStatistics; List<Question>? get unansweredQuestions; List<Question>? get userQuestions; String? get selectedUserId; String? get error;
/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModerationStateCopyWith<ModerationState> get copyWith => _$ModerationStateCopyWithImpl<ModerationState>(this as ModerationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModerationState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.reportedContent, reportedContent)&&const DeepCollectionEquality().equals(other.questions, questions)&&const DeepCollectionEquality().equals(other.activeSupportUsers, activeSupportUsers)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.selectedReportStatus, selectedReportStatus) || other.selectedReportStatus == selectedReportStatus)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.totalReports, totalReports) || other.totalReports == totalReports)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.reportsStatistics, reportsStatistics) || other.reportsStatistics == reportsStatistics)&&(identical(other.supportStatistics, supportStatistics) || other.supportStatistics == supportStatistics)&&const DeepCollectionEquality().equals(other.unansweredQuestions, unansweredQuestions)&&const DeepCollectionEquality().equals(other.userQuestions, userQuestions)&&(identical(other.selectedUserId, selectedUserId) || other.selectedUserId == selectedUserId)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(reportedContent),const DeepCollectionEquality().hash(questions),const DeepCollectionEquality().hash(activeSupportUsers),selectedCategory,selectedReportStatus,searchQuery,totalReports,totalQuestions,reportsStatistics,supportStatistics,const DeepCollectionEquality().hash(unansweredQuestions),const DeepCollectionEquality().hash(userQuestions),selectedUserId,error);

@override
String toString() {
  return 'ModerationState(isLoading: $isLoading, reportedContent: $reportedContent, questions: $questions, activeSupportUsers: $activeSupportUsers, selectedCategory: $selectedCategory, selectedReportStatus: $selectedReportStatus, searchQuery: $searchQuery, totalReports: $totalReports, totalQuestions: $totalQuestions, reportsStatistics: $reportsStatistics, supportStatistics: $supportStatistics, unansweredQuestions: $unansweredQuestions, userQuestions: $userQuestions, selectedUserId: $selectedUserId, error: $error)';
}


}

/// @nodoc
abstract mixin class $ModerationStateCopyWith<$Res>  {
  factory $ModerationStateCopyWith(ModerationState value, $Res Function(ModerationState) _then) = _$ModerationStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<ReportedContent> reportedContent, List<Question> questions, List<UserQuestionStatisticDto> activeSupportUsers, ModerationCategory selectedCategory, ReportStatus? selectedReportStatus, String searchQuery, int totalReports, int totalQuestions, ReportStatisticsDto? reportsStatistics, SupportStatisticsDto? supportStatistics, List<Question>? unansweredQuestions, List<Question>? userQuestions, String? selectedUserId, String? error
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
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? reportedContent = null,Object? questions = null,Object? activeSupportUsers = null,Object? selectedCategory = null,Object? selectedReportStatus = freezed,Object? searchQuery = null,Object? totalReports = null,Object? totalQuestions = null,Object? reportsStatistics = freezed,Object? supportStatistics = freezed,Object? unansweredQuestions = freezed,Object? userQuestions = freezed,Object? selectedUserId = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,reportedContent: null == reportedContent ? _self.reportedContent : reportedContent // ignore: cast_nullable_to_non_nullable
as List<ReportedContent>,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,activeSupportUsers: null == activeSupportUsers ? _self.activeSupportUsers : activeSupportUsers // ignore: cast_nullable_to_non_nullable
as List<UserQuestionStatisticDto>,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as ModerationCategory,selectedReportStatus: freezed == selectedReportStatus ? _self.selectedReportStatus : selectedReportStatus // ignore: cast_nullable_to_non_nullable
as ReportStatus?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,totalReports: null == totalReports ? _self.totalReports : totalReports // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,reportsStatistics: freezed == reportsStatistics ? _self.reportsStatistics : reportsStatistics // ignore: cast_nullable_to_non_nullable
as ReportStatisticsDto?,supportStatistics: freezed == supportStatistics ? _self.supportStatistics : supportStatistics // ignore: cast_nullable_to_non_nullable
as SupportStatisticsDto?,unansweredQuestions: freezed == unansweredQuestions ? _self.unansweredQuestions : unansweredQuestions // ignore: cast_nullable_to_non_nullable
as List<Question>?,userQuestions: freezed == userQuestions ? _self.userQuestions : userQuestions // ignore: cast_nullable_to_non_nullable
as List<Question>?,selectedUserId: freezed == selectedUserId ? _self.selectedUserId : selectedUserId // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<ReportedContent> reportedContent,  List<Question> questions,  List<UserQuestionStatisticDto> activeSupportUsers,  ModerationCategory selectedCategory,  ReportStatus? selectedReportStatus,  String searchQuery,  int totalReports,  int totalQuestions,  ReportStatisticsDto? reportsStatistics,  SupportStatisticsDto? supportStatistics,  List<Question>? unansweredQuestions,  List<Question>? userQuestions,  String? selectedUserId,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModerationState() when $default != null:
return $default(_that.isLoading,_that.reportedContent,_that.questions,_that.activeSupportUsers,_that.selectedCategory,_that.selectedReportStatus,_that.searchQuery,_that.totalReports,_that.totalQuestions,_that.reportsStatistics,_that.supportStatistics,_that.unansweredQuestions,_that.userQuestions,_that.selectedUserId,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<ReportedContent> reportedContent,  List<Question> questions,  List<UserQuestionStatisticDto> activeSupportUsers,  ModerationCategory selectedCategory,  ReportStatus? selectedReportStatus,  String searchQuery,  int totalReports,  int totalQuestions,  ReportStatisticsDto? reportsStatistics,  SupportStatisticsDto? supportStatistics,  List<Question>? unansweredQuestions,  List<Question>? userQuestions,  String? selectedUserId,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ModerationState():
return $default(_that.isLoading,_that.reportedContent,_that.questions,_that.activeSupportUsers,_that.selectedCategory,_that.selectedReportStatus,_that.searchQuery,_that.totalReports,_that.totalQuestions,_that.reportsStatistics,_that.supportStatistics,_that.unansweredQuestions,_that.userQuestions,_that.selectedUserId,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<ReportedContent> reportedContent,  List<Question> questions,  List<UserQuestionStatisticDto> activeSupportUsers,  ModerationCategory selectedCategory,  ReportStatus? selectedReportStatus,  String searchQuery,  int totalReports,  int totalQuestions,  ReportStatisticsDto? reportsStatistics,  SupportStatisticsDto? supportStatistics,  List<Question>? unansweredQuestions,  List<Question>? userQuestions,  String? selectedUserId,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ModerationState() when $default != null:
return $default(_that.isLoading,_that.reportedContent,_that.questions,_that.activeSupportUsers,_that.selectedCategory,_that.selectedReportStatus,_that.searchQuery,_that.totalReports,_that.totalQuestions,_that.reportsStatistics,_that.supportStatistics,_that.unansweredQuestions,_that.userQuestions,_that.selectedUserId,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ModerationState implements ModerationState {
  const _ModerationState({required this.isLoading, required final  List<ReportedContent> reportedContent, required final  List<Question> questions, required final  List<UserQuestionStatisticDto> activeSupportUsers, required this.selectedCategory, required this.selectedReportStatus, required this.searchQuery, required this.totalReports, required this.totalQuestions, this.reportsStatistics, this.supportStatistics, final  List<Question>? unansweredQuestions, final  List<Question>? userQuestions, this.selectedUserId, this.error}): _reportedContent = reportedContent,_questions = questions,_activeSupportUsers = activeSupportUsers,_unansweredQuestions = unansweredQuestions,_userQuestions = userQuestions;
  

@override final  bool isLoading;
 final  List<ReportedContent> _reportedContent;
@override List<ReportedContent> get reportedContent {
  if (_reportedContent is EqualUnmodifiableListView) return _reportedContent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reportedContent);
}

 final  List<Question> _questions;
@override List<Question> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

 final  List<UserQuestionStatisticDto> _activeSupportUsers;
@override List<UserQuestionStatisticDto> get activeSupportUsers {
  if (_activeSupportUsers is EqualUnmodifiableListView) return _activeSupportUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeSupportUsers);
}

@override final  ModerationCategory selectedCategory;
@override final  ReportStatus? selectedReportStatus;
@override final  String searchQuery;
@override final  int totalReports;
@override final  int totalQuestions;
@override final  ReportStatisticsDto? reportsStatistics;
@override final  SupportStatisticsDto? supportStatistics;
 final  List<Question>? _unansweredQuestions;
@override List<Question>? get unansweredQuestions {
  final value = _unansweredQuestions;
  if (value == null) return null;
  if (_unansweredQuestions is EqualUnmodifiableListView) return _unansweredQuestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Question>? _userQuestions;
@override List<Question>? get userQuestions {
  final value = _userQuestions;
  if (value == null) return null;
  if (_userQuestions is EqualUnmodifiableListView) return _userQuestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? selectedUserId;
@override final  String? error;

/// Create a copy of ModerationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModerationStateCopyWith<_ModerationState> get copyWith => __$ModerationStateCopyWithImpl<_ModerationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModerationState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._reportedContent, _reportedContent)&&const DeepCollectionEquality().equals(other._questions, _questions)&&const DeepCollectionEquality().equals(other._activeSupportUsers, _activeSupportUsers)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.selectedReportStatus, selectedReportStatus) || other.selectedReportStatus == selectedReportStatus)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.totalReports, totalReports) || other.totalReports == totalReports)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.reportsStatistics, reportsStatistics) || other.reportsStatistics == reportsStatistics)&&(identical(other.supportStatistics, supportStatistics) || other.supportStatistics == supportStatistics)&&const DeepCollectionEquality().equals(other._unansweredQuestions, _unansweredQuestions)&&const DeepCollectionEquality().equals(other._userQuestions, _userQuestions)&&(identical(other.selectedUserId, selectedUserId) || other.selectedUserId == selectedUserId)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_reportedContent),const DeepCollectionEquality().hash(_questions),const DeepCollectionEquality().hash(_activeSupportUsers),selectedCategory,selectedReportStatus,searchQuery,totalReports,totalQuestions,reportsStatistics,supportStatistics,const DeepCollectionEquality().hash(_unansweredQuestions),const DeepCollectionEquality().hash(_userQuestions),selectedUserId,error);

@override
String toString() {
  return 'ModerationState(isLoading: $isLoading, reportedContent: $reportedContent, questions: $questions, activeSupportUsers: $activeSupportUsers, selectedCategory: $selectedCategory, selectedReportStatus: $selectedReportStatus, searchQuery: $searchQuery, totalReports: $totalReports, totalQuestions: $totalQuestions, reportsStatistics: $reportsStatistics, supportStatistics: $supportStatistics, unansweredQuestions: $unansweredQuestions, userQuestions: $userQuestions, selectedUserId: $selectedUserId, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ModerationStateCopyWith<$Res> implements $ModerationStateCopyWith<$Res> {
  factory _$ModerationStateCopyWith(_ModerationState value, $Res Function(_ModerationState) _then) = __$ModerationStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<ReportedContent> reportedContent, List<Question> questions, List<UserQuestionStatisticDto> activeSupportUsers, ModerationCategory selectedCategory, ReportStatus? selectedReportStatus, String searchQuery, int totalReports, int totalQuestions, ReportStatisticsDto? reportsStatistics, SupportStatisticsDto? supportStatistics, List<Question>? unansweredQuestions, List<Question>? userQuestions, String? selectedUserId, String? error
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
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? reportedContent = null,Object? questions = null,Object? activeSupportUsers = null,Object? selectedCategory = null,Object? selectedReportStatus = freezed,Object? searchQuery = null,Object? totalReports = null,Object? totalQuestions = null,Object? reportsStatistics = freezed,Object? supportStatistics = freezed,Object? unansweredQuestions = freezed,Object? userQuestions = freezed,Object? selectedUserId = freezed,Object? error = freezed,}) {
  return _then(_ModerationState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,reportedContent: null == reportedContent ? _self._reportedContent : reportedContent // ignore: cast_nullable_to_non_nullable
as List<ReportedContent>,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,activeSupportUsers: null == activeSupportUsers ? _self._activeSupportUsers : activeSupportUsers // ignore: cast_nullable_to_non_nullable
as List<UserQuestionStatisticDto>,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as ModerationCategory,selectedReportStatus: freezed == selectedReportStatus ? _self.selectedReportStatus : selectedReportStatus // ignore: cast_nullable_to_non_nullable
as ReportStatus?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,totalReports: null == totalReports ? _self.totalReports : totalReports // ignore: cast_nullable_to_non_nullable
as int,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,reportsStatistics: freezed == reportsStatistics ? _self.reportsStatistics : reportsStatistics // ignore: cast_nullable_to_non_nullable
as ReportStatisticsDto?,supportStatistics: freezed == supportStatistics ? _self.supportStatistics : supportStatistics // ignore: cast_nullable_to_non_nullable
as SupportStatisticsDto?,unansweredQuestions: freezed == unansweredQuestions ? _self._unansweredQuestions : unansweredQuestions // ignore: cast_nullable_to_non_nullable
as List<Question>?,userQuestions: freezed == userQuestions ? _self._userQuestions : userQuestions // ignore: cast_nullable_to_non_nullable
as List<Question>?,selectedUserId: freezed == selectedUserId ? _self.selectedUserId : selectedUserId // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
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
