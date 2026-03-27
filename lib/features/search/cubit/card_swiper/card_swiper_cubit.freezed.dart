// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_swiper_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CardSwiperState {

 SwipeCandidateResponse? get currentCandidate; bool get isLoading; String? get errorMessage; String? get gender; int? get minAge; int? get maxAge; bool? get verified; List<String> get interests; List<String> get purposes; bool get isLoadingMatches; List<MatchResponse> get matches; String? get matchesErrorMessage; bool get isLoadingLikes; List<UserLikeResponse> get userLikes; String? get likesErrorMessage;
/// Create a copy of CardSwiperState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardSwiperStateCopyWith<CardSwiperState> get copyWith => _$CardSwiperStateCopyWithImpl<CardSwiperState>(this as CardSwiperState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardSwiperState&&(identical(other.currentCandidate, currentCandidate) || other.currentCandidate == currentCandidate)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.minAge, minAge) || other.minAge == minAge)&&(identical(other.maxAge, maxAge) || other.maxAge == maxAge)&&(identical(other.verified, verified) || other.verified == verified)&&const DeepCollectionEquality().equals(other.interests, interests)&&const DeepCollectionEquality().equals(other.purposes, purposes)&&(identical(other.isLoadingMatches, isLoadingMatches) || other.isLoadingMatches == isLoadingMatches)&&const DeepCollectionEquality().equals(other.matches, matches)&&(identical(other.matchesErrorMessage, matchesErrorMessage) || other.matchesErrorMessage == matchesErrorMessage)&&(identical(other.isLoadingLikes, isLoadingLikes) || other.isLoadingLikes == isLoadingLikes)&&const DeepCollectionEquality().equals(other.userLikes, userLikes)&&(identical(other.likesErrorMessage, likesErrorMessage) || other.likesErrorMessage == likesErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,currentCandidate,isLoading,errorMessage,gender,minAge,maxAge,verified,const DeepCollectionEquality().hash(interests),const DeepCollectionEquality().hash(purposes),isLoadingMatches,const DeepCollectionEquality().hash(matches),matchesErrorMessage,isLoadingLikes,const DeepCollectionEquality().hash(userLikes),likesErrorMessage);

@override
String toString() {
  return 'CardSwiperState(currentCandidate: $currentCandidate, isLoading: $isLoading, errorMessage: $errorMessage, gender: $gender, minAge: $minAge, maxAge: $maxAge, verified: $verified, interests: $interests, purposes: $purposes, isLoadingMatches: $isLoadingMatches, matches: $matches, matchesErrorMessage: $matchesErrorMessage, isLoadingLikes: $isLoadingLikes, userLikes: $userLikes, likesErrorMessage: $likesErrorMessage)';
}


}

/// @nodoc
abstract mixin class $CardSwiperStateCopyWith<$Res>  {
  factory $CardSwiperStateCopyWith(CardSwiperState value, $Res Function(CardSwiperState) _then) = _$CardSwiperStateCopyWithImpl;
@useResult
$Res call({
 SwipeCandidateResponse? currentCandidate, bool isLoading, String? errorMessage, String? gender, int? minAge, int? maxAge, bool? verified, List<String> interests, List<String> purposes, bool isLoadingMatches, List<MatchResponse> matches, String? matchesErrorMessage, bool isLoadingLikes, List<UserLikeResponse> userLikes, String? likesErrorMessage
});


$SwipeCandidateResponseCopyWith<$Res>? get currentCandidate;

}
/// @nodoc
class _$CardSwiperStateCopyWithImpl<$Res>
    implements $CardSwiperStateCopyWith<$Res> {
  _$CardSwiperStateCopyWithImpl(this._self, this._then);

  final CardSwiperState _self;
  final $Res Function(CardSwiperState) _then;

/// Create a copy of CardSwiperState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentCandidate = freezed,Object? isLoading = null,Object? errorMessage = freezed,Object? gender = freezed,Object? minAge = freezed,Object? maxAge = freezed,Object? verified = freezed,Object? interests = null,Object? purposes = null,Object? isLoadingMatches = null,Object? matches = null,Object? matchesErrorMessage = freezed,Object? isLoadingLikes = null,Object? userLikes = null,Object? likesErrorMessage = freezed,}) {
  return _then(_self.copyWith(
currentCandidate: freezed == currentCandidate ? _self.currentCandidate : currentCandidate // ignore: cast_nullable_to_non_nullable
as SwipeCandidateResponse?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,minAge: freezed == minAge ? _self.minAge : minAge // ignore: cast_nullable_to_non_nullable
as int?,maxAge: freezed == maxAge ? _self.maxAge : maxAge // ignore: cast_nullable_to_non_nullable
as int?,verified: freezed == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool?,interests: null == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,purposes: null == purposes ? _self.purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<String>,isLoadingMatches: null == isLoadingMatches ? _self.isLoadingMatches : isLoadingMatches // ignore: cast_nullable_to_non_nullable
as bool,matches: null == matches ? _self.matches : matches // ignore: cast_nullable_to_non_nullable
as List<MatchResponse>,matchesErrorMessage: freezed == matchesErrorMessage ? _self.matchesErrorMessage : matchesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLoadingLikes: null == isLoadingLikes ? _self.isLoadingLikes : isLoadingLikes // ignore: cast_nullable_to_non_nullable
as bool,userLikes: null == userLikes ? _self.userLikes : userLikes // ignore: cast_nullable_to_non_nullable
as List<UserLikeResponse>,likesErrorMessage: freezed == likesErrorMessage ? _self.likesErrorMessage : likesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CardSwiperState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SwipeCandidateResponseCopyWith<$Res>? get currentCandidate {
    if (_self.currentCandidate == null) {
    return null;
  }

  return $SwipeCandidateResponseCopyWith<$Res>(_self.currentCandidate!, (value) {
    return _then(_self.copyWith(currentCandidate: value));
  });
}
}


/// Adds pattern-matching-related methods to [CardSwiperState].
extension CardSwiperStatePatterns on CardSwiperState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CardSwiperState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CardSwiperState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CardSwiperState value)  $default,){
final _that = this;
switch (_that) {
case _CardSwiperState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CardSwiperState value)?  $default,){
final _that = this;
switch (_that) {
case _CardSwiperState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SwipeCandidateResponse? currentCandidate,  bool isLoading,  String? errorMessage,  String? gender,  int? minAge,  int? maxAge,  bool? verified,  List<String> interests,  List<String> purposes,  bool isLoadingMatches,  List<MatchResponse> matches,  String? matchesErrorMessage,  bool isLoadingLikes,  List<UserLikeResponse> userLikes,  String? likesErrorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CardSwiperState() when $default != null:
return $default(_that.currentCandidate,_that.isLoading,_that.errorMessage,_that.gender,_that.minAge,_that.maxAge,_that.verified,_that.interests,_that.purposes,_that.isLoadingMatches,_that.matches,_that.matchesErrorMessage,_that.isLoadingLikes,_that.userLikes,_that.likesErrorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SwipeCandidateResponse? currentCandidate,  bool isLoading,  String? errorMessage,  String? gender,  int? minAge,  int? maxAge,  bool? verified,  List<String> interests,  List<String> purposes,  bool isLoadingMatches,  List<MatchResponse> matches,  String? matchesErrorMessage,  bool isLoadingLikes,  List<UserLikeResponse> userLikes,  String? likesErrorMessage)  $default,) {final _that = this;
switch (_that) {
case _CardSwiperState():
return $default(_that.currentCandidate,_that.isLoading,_that.errorMessage,_that.gender,_that.minAge,_that.maxAge,_that.verified,_that.interests,_that.purposes,_that.isLoadingMatches,_that.matches,_that.matchesErrorMessage,_that.isLoadingLikes,_that.userLikes,_that.likesErrorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SwipeCandidateResponse? currentCandidate,  bool isLoading,  String? errorMessage,  String? gender,  int? minAge,  int? maxAge,  bool? verified,  List<String> interests,  List<String> purposes,  bool isLoadingMatches,  List<MatchResponse> matches,  String? matchesErrorMessage,  bool isLoadingLikes,  List<UserLikeResponse> userLikes,  String? likesErrorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CardSwiperState() when $default != null:
return $default(_that.currentCandidate,_that.isLoading,_that.errorMessage,_that.gender,_that.minAge,_that.maxAge,_that.verified,_that.interests,_that.purposes,_that.isLoadingMatches,_that.matches,_that.matchesErrorMessage,_that.isLoadingLikes,_that.userLikes,_that.likesErrorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CardSwiperState implements CardSwiperState {
  const _CardSwiperState({this.currentCandidate, this.isLoading = false, this.errorMessage, this.gender, this.minAge, this.maxAge, this.verified = false, final  List<String> interests = const [], final  List<String> purposes = const [], this.isLoadingMatches = false, final  List<MatchResponse> matches = const [], this.matchesErrorMessage, this.isLoadingLikes = false, final  List<UserLikeResponse> userLikes = const [], this.likesErrorMessage}): _interests = interests,_purposes = purposes,_matches = matches,_userLikes = userLikes;
  

@override final  SwipeCandidateResponse? currentCandidate;
@override@JsonKey() final  bool isLoading;
@override final  String? errorMessage;
@override final  String? gender;
@override final  int? minAge;
@override final  int? maxAge;
@override@JsonKey() final  bool? verified;
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

@override@JsonKey() final  bool isLoadingMatches;
 final  List<MatchResponse> _matches;
@override@JsonKey() List<MatchResponse> get matches {
  if (_matches is EqualUnmodifiableListView) return _matches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matches);
}

@override final  String? matchesErrorMessage;
@override@JsonKey() final  bool isLoadingLikes;
 final  List<UserLikeResponse> _userLikes;
@override@JsonKey() List<UserLikeResponse> get userLikes {
  if (_userLikes is EqualUnmodifiableListView) return _userLikes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_userLikes);
}

@override final  String? likesErrorMessage;

/// Create a copy of CardSwiperState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardSwiperStateCopyWith<_CardSwiperState> get copyWith => __$CardSwiperStateCopyWithImpl<_CardSwiperState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardSwiperState&&(identical(other.currentCandidate, currentCandidate) || other.currentCandidate == currentCandidate)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.minAge, minAge) || other.minAge == minAge)&&(identical(other.maxAge, maxAge) || other.maxAge == maxAge)&&(identical(other.verified, verified) || other.verified == verified)&&const DeepCollectionEquality().equals(other._interests, _interests)&&const DeepCollectionEquality().equals(other._purposes, _purposes)&&(identical(other.isLoadingMatches, isLoadingMatches) || other.isLoadingMatches == isLoadingMatches)&&const DeepCollectionEquality().equals(other._matches, _matches)&&(identical(other.matchesErrorMessage, matchesErrorMessage) || other.matchesErrorMessage == matchesErrorMessage)&&(identical(other.isLoadingLikes, isLoadingLikes) || other.isLoadingLikes == isLoadingLikes)&&const DeepCollectionEquality().equals(other._userLikes, _userLikes)&&(identical(other.likesErrorMessage, likesErrorMessage) || other.likesErrorMessage == likesErrorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,currentCandidate,isLoading,errorMessage,gender,minAge,maxAge,verified,const DeepCollectionEquality().hash(_interests),const DeepCollectionEquality().hash(_purposes),isLoadingMatches,const DeepCollectionEquality().hash(_matches),matchesErrorMessage,isLoadingLikes,const DeepCollectionEquality().hash(_userLikes),likesErrorMessage);

@override
String toString() {
  return 'CardSwiperState(currentCandidate: $currentCandidate, isLoading: $isLoading, errorMessage: $errorMessage, gender: $gender, minAge: $minAge, maxAge: $maxAge, verified: $verified, interests: $interests, purposes: $purposes, isLoadingMatches: $isLoadingMatches, matches: $matches, matchesErrorMessage: $matchesErrorMessage, isLoadingLikes: $isLoadingLikes, userLikes: $userLikes, likesErrorMessage: $likesErrorMessage)';
}


}

/// @nodoc
abstract mixin class _$CardSwiperStateCopyWith<$Res> implements $CardSwiperStateCopyWith<$Res> {
  factory _$CardSwiperStateCopyWith(_CardSwiperState value, $Res Function(_CardSwiperState) _then) = __$CardSwiperStateCopyWithImpl;
@override @useResult
$Res call({
 SwipeCandidateResponse? currentCandidate, bool isLoading, String? errorMessage, String? gender, int? minAge, int? maxAge, bool? verified, List<String> interests, List<String> purposes, bool isLoadingMatches, List<MatchResponse> matches, String? matchesErrorMessage, bool isLoadingLikes, List<UserLikeResponse> userLikes, String? likesErrorMessage
});


@override $SwipeCandidateResponseCopyWith<$Res>? get currentCandidate;

}
/// @nodoc
class __$CardSwiperStateCopyWithImpl<$Res>
    implements _$CardSwiperStateCopyWith<$Res> {
  __$CardSwiperStateCopyWithImpl(this._self, this._then);

  final _CardSwiperState _self;
  final $Res Function(_CardSwiperState) _then;

/// Create a copy of CardSwiperState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentCandidate = freezed,Object? isLoading = null,Object? errorMessage = freezed,Object? gender = freezed,Object? minAge = freezed,Object? maxAge = freezed,Object? verified = freezed,Object? interests = null,Object? purposes = null,Object? isLoadingMatches = null,Object? matches = null,Object? matchesErrorMessage = freezed,Object? isLoadingLikes = null,Object? userLikes = null,Object? likesErrorMessage = freezed,}) {
  return _then(_CardSwiperState(
currentCandidate: freezed == currentCandidate ? _self.currentCandidate : currentCandidate // ignore: cast_nullable_to_non_nullable
as SwipeCandidateResponse?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,minAge: freezed == minAge ? _self.minAge : minAge // ignore: cast_nullable_to_non_nullable
as int?,maxAge: freezed == maxAge ? _self.maxAge : maxAge // ignore: cast_nullable_to_non_nullable
as int?,verified: freezed == verified ? _self.verified : verified // ignore: cast_nullable_to_non_nullable
as bool?,interests: null == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<String>,purposes: null == purposes ? _self._purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<String>,isLoadingMatches: null == isLoadingMatches ? _self.isLoadingMatches : isLoadingMatches // ignore: cast_nullable_to_non_nullable
as bool,matches: null == matches ? _self._matches : matches // ignore: cast_nullable_to_non_nullable
as List<MatchResponse>,matchesErrorMessage: freezed == matchesErrorMessage ? _self.matchesErrorMessage : matchesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,isLoadingLikes: null == isLoadingLikes ? _self.isLoadingLikes : isLoadingLikes // ignore: cast_nullable_to_non_nullable
as bool,userLikes: null == userLikes ? _self._userLikes : userLikes // ignore: cast_nullable_to_non_nullable
as List<UserLikeResponse>,likesErrorMessage: freezed == likesErrorMessage ? _self.likesErrorMessage : likesErrorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CardSwiperState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SwipeCandidateResponseCopyWith<$Res>? get currentCandidate {
    if (_self.currentCandidate == null) {
    return null;
  }

  return $SwipeCandidateResponseCopyWith<$Res>(_self.currentCandidate!, (value) {
    return _then(_self.copyWith(currentCandidate: value));
  });
}
}

// dart format on
