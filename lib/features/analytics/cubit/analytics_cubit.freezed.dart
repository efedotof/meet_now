// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalyticsState {

 bool get isLoading; AnalyticsData get data; CustomDateTimeRange get dateRange; ChartType get selectedChart; String? get error;
/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsStateCopyWith<AnalyticsState> get copyWith => _$AnalyticsStateCopyWithImpl<AnalyticsState>(this as AnalyticsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data)&&(identical(other.dateRange, dateRange) || other.dateRange == dateRange)&&(identical(other.selectedChart, selectedChart) || other.selectedChart == selectedChart)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data,dateRange,selectedChart,error);

@override
String toString() {
  return 'AnalyticsState(isLoading: $isLoading, data: $data, dateRange: $dateRange, selectedChart: $selectedChart, error: $error)';
}


}

/// @nodoc
abstract mixin class $AnalyticsStateCopyWith<$Res>  {
  factory $AnalyticsStateCopyWith(AnalyticsState value, $Res Function(AnalyticsState) _then) = _$AnalyticsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, AnalyticsData data, CustomDateTimeRange dateRange, ChartType selectedChart, String? error
});




}
/// @nodoc
class _$AnalyticsStateCopyWithImpl<$Res>
    implements $AnalyticsStateCopyWith<$Res> {
  _$AnalyticsStateCopyWithImpl(this._self, this._then);

  final AnalyticsState _self;
  final $Res Function(AnalyticsState) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? data = null,Object? dateRange = null,Object? selectedChart = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AnalyticsData,dateRange: null == dateRange ? _self.dateRange : dateRange // ignore: cast_nullable_to_non_nullable
as CustomDateTimeRange,selectedChart: null == selectedChart ? _self.selectedChart : selectedChart // ignore: cast_nullable_to_non_nullable
as ChartType,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsState].
extension AnalyticsStatePatterns on AnalyticsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsState value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsState value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  AnalyticsData data,  CustomDateTimeRange dateRange,  ChartType selectedChart,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
return $default(_that.isLoading,_that.data,_that.dateRange,_that.selectedChart,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  AnalyticsData data,  CustomDateTimeRange dateRange,  ChartType selectedChart,  String? error)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsState():
return $default(_that.isLoading,_that.data,_that.dateRange,_that.selectedChart,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  AnalyticsData data,  CustomDateTimeRange dateRange,  ChartType selectedChart,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
return $default(_that.isLoading,_that.data,_that.dateRange,_that.selectedChart,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _AnalyticsState implements AnalyticsState {
  const _AnalyticsState({required this.isLoading, required this.data, required this.dateRange, required this.selectedChart, this.error});
  

@override final  bool isLoading;
@override final  AnalyticsData data;
@override final  CustomDateTimeRange dateRange;
@override final  ChartType selectedChart;
@override final  String? error;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsStateCopyWith<_AnalyticsState> get copyWith => __$AnalyticsStateCopyWithImpl<_AnalyticsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.data, data) || other.data == data)&&(identical(other.dateRange, dateRange) || other.dateRange == dateRange)&&(identical(other.selectedChart, selectedChart) || other.selectedChart == selectedChart)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,data,dateRange,selectedChart,error);

@override
String toString() {
  return 'AnalyticsState(isLoading: $isLoading, data: $data, dateRange: $dateRange, selectedChart: $selectedChart, error: $error)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsStateCopyWith<$Res> implements $AnalyticsStateCopyWith<$Res> {
  factory _$AnalyticsStateCopyWith(_AnalyticsState value, $Res Function(_AnalyticsState) _then) = __$AnalyticsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, AnalyticsData data, CustomDateTimeRange dateRange, ChartType selectedChart, String? error
});




}
/// @nodoc
class __$AnalyticsStateCopyWithImpl<$Res>
    implements _$AnalyticsStateCopyWith<$Res> {
  __$AnalyticsStateCopyWithImpl(this._self, this._then);

  final _AnalyticsState _self;
  final $Res Function(_AnalyticsState) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? data = null,Object? dateRange = null,Object? selectedChart = null,Object? error = freezed,}) {
  return _then(_AnalyticsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as AnalyticsData,dateRange: null == dateRange ? _self.dateRange : dateRange // ignore: cast_nullable_to_non_nullable
as CustomDateTimeRange,selectedChart: null == selectedChart ? _self.selectedChart : selectedChart // ignore: cast_nullable_to_non_nullable
as ChartType,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
