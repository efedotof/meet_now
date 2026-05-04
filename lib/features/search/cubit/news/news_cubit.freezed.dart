// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsState()';
}


}

/// @nodoc
class $NewsStateCopyWith<$Res>  {
$NewsStateCopyWith(NewsState _, $Res Function(NewsState) __);
}


/// Adds pattern-matching-related methods to [NewsState].
extension NewsStatePatterns on NewsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _News value)?  news,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _News() when news != null:
return news(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _News value)  news,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _News():
return news(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _News value)?  news,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _News() when news != null:
return news(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<NewsResponse> news)?  news,TResult Function( String error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _News() when news != null:
return news(_that.news);case _Error() when error != null:
return error(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<NewsResponse> news)  news,required TResult Function( String error)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _News():
return news(_that.news);case _Error():
return error(_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<NewsResponse> news)?  news,TResult? Function( String error)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _News() when news != null:
return news(_that.news);case _Error() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements NewsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsState.initial()';
}


}




/// @nodoc


class _Loading implements NewsState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewsState.loading()';
}


}




/// @nodoc


class _News implements NewsState {
  const _News({required final  List<NewsResponse> news}): _news = news;
  

 final  List<NewsResponse> _news;
 List<NewsResponse> get news {
  if (_news is EqualUnmodifiableListView) return _news;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_news);
}


/// Create a copy of NewsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsCopyWith<_News> get copyWith => __$NewsCopyWithImpl<_News>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _News&&const DeepCollectionEquality().equals(other._news, _news));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_news));

@override
String toString() {
  return 'NewsState.news(news: $news)';
}


}

/// @nodoc
abstract mixin class _$NewsCopyWith<$Res> implements $NewsStateCopyWith<$Res> {
  factory _$NewsCopyWith(_News value, $Res Function(_News) _then) = __$NewsCopyWithImpl;
@useResult
$Res call({
 List<NewsResponse> news
});




}
/// @nodoc
class __$NewsCopyWithImpl<$Res>
    implements _$NewsCopyWith<$Res> {
  __$NewsCopyWithImpl(this._self, this._then);

  final _News _self;
  final $Res Function(_News) _then;

/// Create a copy of NewsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? news = null,}) {
  return _then(_News(
news: null == news ? _self._news : news // ignore: cast_nullable_to_non_nullable
as List<NewsResponse>,
  ));
}


}

/// @nodoc


class _Error implements NewsState {
  const _Error({required this.error});
  

 final  String error;

/// Create a copy of NewsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'NewsState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $NewsStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of NewsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_Error(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
