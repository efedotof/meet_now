// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {

 String get gender; int? get ageFrom; bool get isLoading; bool get isSearching; List<String> get interests; List<String> get purposes; String get city; bool get verified;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.ageFrom, ageFrom) || other.ageFrom == ageFrom)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&const DeepCollectionEquality().equals(other.interests, interests)&&const DeepCollectionEquality().equals(other.purposes, purposes)&&(identical(other.city, city) || other.city == city)&&(identical(other.verified, verified) || other.verified == verified));
}


@override
int get hashCode => Object.hash(runtimeType,gender,ageFrom,isLoading,isSearching,const DeepCollectionEquality().hash(interests),const DeepCollectionEquality().hash(purposes),city,verified);

@override
String toString() {
  return 'SearchState(gender: $gender, ageFrom: $ageFrom, isLoading: $isLoading, isSearching: $isSearching, interests: $interests, purposes: $purposes, city: $city, verified: $verified)';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 String gender, int? ageFrom, bool isLoading, bool isSearching, List<String> interests, List<String> purposes, String city, bool verified
});




}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gender = null,Object? ageFrom = freezed,Object? isLoading = null,Object? isSearching = null,Object? interests = null,Object? purposes = null,Object? city = null,Object? verified = null,}) {
  return _then(_self.copyWith(
gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,ageFrom: freezed == ageFrom ? _self.ageFrom : ageFrom // ignore: cast_nullable_to_non_nullable
as int?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,purposes: null == purposes ? _self.purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<String>,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchState value)  $default,){
final _that = this;
switch (_that) {
case _SearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gender,  int? ageFrom,  bool isLoading,  bool isSearching,  List<String> interests,  List<String> purposes,  String city,  bool verified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.gender,_that.ageFrom,_that.isLoading,_that.isSearching,_that.interests,_that.purposes,_that.city,_that.verified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gender,  int? ageFrom,  bool isLoading,  bool isSearching,  List<String> interests,  List<String> purposes,  String city,  bool verified)  $default,) {final _that = this;
switch (_that) {
case _SearchState():
return $default(_that.gender,_that.ageFrom,_that.isLoading,_that.isSearching,_that.interests,_that.purposes,_that.city,_that.verified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gender,  int? ageFrom,  bool isLoading,  bool isSearching,  List<String> interests,  List<String> purposes,  String city,  bool verified)?  $default,) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.gender,_that.ageFrom,_that.isLoading,_that.isSearching,_that.interests,_that.purposes,_that.city,_that.verified);case _:
  return null;

}
}

}

/// @nodoc


class _SearchState implements SearchState {
  const _SearchState({this.gender = '', this.ageFrom, this.isLoading = false, this.isSearching = false, final  List<String> interests = const [], final  List<String> purposes = const [], this.city = '', this.verified = false}): _interests = interests,_purposes = purposes;
  

@override@JsonKey() final  String gender;
@override final  int? ageFrom;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSearching;
 final  List<String> _interests;
@override@JsonKey() List<String> get interests {
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_interests);
}

 final  List<String> _purposes;
@override@JsonKey() List<String> get purposes {
  if (_purposes is EqualUnmodifiableListView) return _purposes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_purposes);
}

@override@JsonKey() final  String city;
@override@JsonKey() final  bool verified;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStateCopyWith<_SearchState> get copyWith => __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchState&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.ageFrom, ageFrom) || other.ageFrom == ageFrom)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching)&&const DeepCollectionEquality().equals(other._interests, _interests)&&const DeepCollectionEquality().equals(other._purposes, _purposes)&&(identical(other.city, city) || other.city == city)&&(identical(other.verified, verified) || other.verified == verified));
}


@override
int get hashCode => Object.hash(runtimeType,gender,ageFrom,isLoading,isSearching,const DeepCollectionEquality().hash(_interests),const DeepCollectionEquality().hash(_purposes),city,verified);

@override
String toString() {
  return 'SearchState(gender: $gender, ageFrom: $ageFrom, isLoading: $isLoading, isSearching: $isSearching, interests: $interests, purposes: $purposes, city: $city, verified: $verified)';
}


}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(_SearchState value, $Res Function(_SearchState) _then) = __$SearchStateCopyWithImpl;
@override @useResult
$Res call({
 String gender, int? ageFrom, bool isLoading, bool isSearching, List<String> interests, List<String> purposes, String city, bool verified
});




}
/// @nodoc
class __$SearchStateCopyWithImpl<$Res>
    implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gender = null,Object? ageFrom = freezed,Object? isLoading = null,Object? isSearching = null,Object? interests = null,Object? purposes = null,Object? city = null,Object? verified = null,}) {
  return _then(_SearchState(
gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,ageFrom: freezed == ageFrom ? _self.ageFrom : ageFrom // ignore: cast_nullable_to_non_nullable
as int?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,purposes: null == purposes ? _self._purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<String>,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,verified: null == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
