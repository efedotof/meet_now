// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameResponse {

 String get gameType; String get gameUrl; String get gameName; String get gameDescription; String get thumbnailUrl;
/// Create a copy of GameResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameResponseCopyWith<GameResponse> get copyWith => _$GameResponseCopyWithImpl<GameResponse>(this as GameResponse, _$identity);

  /// Serializes this GameResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameResponse&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.gameUrl, gameUrl) || other.gameUrl == gameUrl)&&(identical(other.gameName, gameName) || other.gameName == gameName)&&(identical(other.gameDescription, gameDescription) || other.gameDescription == gameDescription)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameType,gameUrl,gameName,gameDescription,thumbnailUrl);

@override
String toString() {
  return 'GameResponse(gameType: $gameType, gameUrl: $gameUrl, gameName: $gameName, gameDescription: $gameDescription, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class $GameResponseCopyWith<$Res>  {
  factory $GameResponseCopyWith(GameResponse value, $Res Function(GameResponse) _then) = _$GameResponseCopyWithImpl;
@useResult
$Res call({
 String gameType, String gameUrl, String gameName, String gameDescription, String thumbnailUrl
});




}
/// @nodoc
class _$GameResponseCopyWithImpl<$Res>
    implements $GameResponseCopyWith<$Res> {
  _$GameResponseCopyWithImpl(this._self, this._then);

  final GameResponse _self;
  final $Res Function(GameResponse) _then;

/// Create a copy of GameResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameType = null,Object? gameUrl = null,Object? gameName = null,Object? gameDescription = null,Object? thumbnailUrl = null,}) {
  return _then(_self.copyWith(
gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,gameUrl: null == gameUrl ? _self.gameUrl : gameUrl // ignore: cast_nullable_to_non_nullable
as String,gameName: null == gameName ? _self.gameName : gameName // ignore: cast_nullable_to_non_nullable
as String,gameDescription: null == gameDescription ? _self.gameDescription : gameDescription // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GameResponse].
extension GameResponsePatterns on GameResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameResponse value)  $default,){
final _that = this;
switch (_that) {
case _GameResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GameResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String gameType,  String gameUrl,  String gameName,  String gameDescription,  String thumbnailUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameResponse() when $default != null:
return $default(_that.gameType,_that.gameUrl,_that.gameName,_that.gameDescription,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String gameType,  String gameUrl,  String gameName,  String gameDescription,  String thumbnailUrl)  $default,) {final _that = this;
switch (_that) {
case _GameResponse():
return $default(_that.gameType,_that.gameUrl,_that.gameName,_that.gameDescription,_that.thumbnailUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String gameType,  String gameUrl,  String gameName,  String gameDescription,  String thumbnailUrl)?  $default,) {final _that = this;
switch (_that) {
case _GameResponse() when $default != null:
return $default(_that.gameType,_that.gameUrl,_that.gameName,_that.gameDescription,_that.thumbnailUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameResponse implements GameResponse {
  const _GameResponse({required this.gameType, required this.gameUrl, required this.gameName, required this.gameDescription, required this.thumbnailUrl});
  factory _GameResponse.fromJson(Map<String, dynamic> json) => _$GameResponseFromJson(json);

@override final  String gameType;
@override final  String gameUrl;
@override final  String gameName;
@override final  String gameDescription;
@override final  String thumbnailUrl;

/// Create a copy of GameResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameResponseCopyWith<_GameResponse> get copyWith => __$GameResponseCopyWithImpl<_GameResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameResponse&&(identical(other.gameType, gameType) || other.gameType == gameType)&&(identical(other.gameUrl, gameUrl) || other.gameUrl == gameUrl)&&(identical(other.gameName, gameName) || other.gameName == gameName)&&(identical(other.gameDescription, gameDescription) || other.gameDescription == gameDescription)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameType,gameUrl,gameName,gameDescription,thumbnailUrl);

@override
String toString() {
  return 'GameResponse(gameType: $gameType, gameUrl: $gameUrl, gameName: $gameName, gameDescription: $gameDescription, thumbnailUrl: $thumbnailUrl)';
}


}

/// @nodoc
abstract mixin class _$GameResponseCopyWith<$Res> implements $GameResponseCopyWith<$Res> {
  factory _$GameResponseCopyWith(_GameResponse value, $Res Function(_GameResponse) _then) = __$GameResponseCopyWithImpl;
@override @useResult
$Res call({
 String gameType, String gameUrl, String gameName, String gameDescription, String thumbnailUrl
});




}
/// @nodoc
class __$GameResponseCopyWithImpl<$Res>
    implements _$GameResponseCopyWith<$Res> {
  __$GameResponseCopyWithImpl(this._self, this._then);

  final _GameResponse _self;
  final $Res Function(_GameResponse) _then;

/// Create a copy of GameResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameType = null,Object? gameUrl = null,Object? gameName = null,Object? gameDescription = null,Object? thumbnailUrl = null,}) {
  return _then(_GameResponse(
gameType: null == gameType ? _self.gameType : gameType // ignore: cast_nullable_to_non_nullable
as String,gameUrl: null == gameUrl ? _self.gameUrl : gameUrl // ignore: cast_nullable_to_non_nullable
as String,gameName: null == gameName ? _self.gameName : gameName // ignore: cast_nullable_to_non_nullable
as String,gameDescription: null == gameDescription ? _self.gameDescription : gameDescription // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
