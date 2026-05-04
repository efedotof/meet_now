// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'matchmaking_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MatchmakingState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchmakingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MatchmakingState()';
}


}

/// @nodoc
class $MatchmakingStateCopyWith<$Res>  {
$MatchmakingStateCopyWith(MatchmakingState _, $Res Function(MatchmakingState) __);
}


/// Adds pattern-matching-related methods to [MatchmakingState].
extension MatchmakingStatePatterns on MatchmakingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Found value)?  found,TResult Function( _Error value)?  error,TResult Function( _NoResults value)?  noResults,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Found() when found != null:
return found(_that);case _Error() when error != null:
return error(_that);case _NoResults() when noResults != null:
return noResults(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Found value)  found,required TResult Function( _Error value)  error,required TResult Function( _NoResults value)  noResults,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Found():
return found(_that);case _Error():
return error(_that);case _NoResults():
return noResults(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Found value)?  found,TResult? Function( _Error value)?  error,TResult? Function( _NoResults value)?  noResults,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Found() when found != null:
return found(_that);case _Error() when error != null:
return error(_that);case _NoResults() when noResults != null:
return noResults(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( PermanentChatResponseDto permanentChat)?  found,TResult Function( String error)?  error,TResult Function( String message)?  noResults,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Found() when found != null:
return found(_that.permanentChat);case _Error() when error != null:
return error(_that.error);case _NoResults() when noResults != null:
return noResults(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( PermanentChatResponseDto permanentChat)  found,required TResult Function( String error)  error,required TResult Function( String message)  noResults,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Found():
return found(_that.permanentChat);case _Error():
return error(_that.error);case _NoResults():
return noResults(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( PermanentChatResponseDto permanentChat)?  found,TResult? Function( String error)?  error,TResult? Function( String message)?  noResults,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Found() when found != null:
return found(_that.permanentChat);case _Error() when error != null:
return error(_that.error);case _NoResults() when noResults != null:
return noResults(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements MatchmakingState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MatchmakingState.initial()';
}


}




/// @nodoc


class _Loading implements MatchmakingState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MatchmakingState.loading()';
}


}




/// @nodoc


class _Found implements MatchmakingState {
  const _Found({required this.permanentChat});
  

 final  PermanentChatResponseDto permanentChat;

/// Create a copy of MatchmakingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoundCopyWith<_Found> get copyWith => __$FoundCopyWithImpl<_Found>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Found&&(identical(other.permanentChat, permanentChat) || other.permanentChat == permanentChat));
}


@override
int get hashCode => Object.hash(runtimeType,permanentChat);

@override
String toString() {
  return 'MatchmakingState.found(permanentChat: $permanentChat)';
}


}

/// @nodoc
abstract mixin class _$FoundCopyWith<$Res> implements $MatchmakingStateCopyWith<$Res> {
  factory _$FoundCopyWith(_Found value, $Res Function(_Found) _then) = __$FoundCopyWithImpl;
@useResult
$Res call({
 PermanentChatResponseDto permanentChat
});


$PermanentChatResponseDtoCopyWith<$Res> get permanentChat;

}
/// @nodoc
class __$FoundCopyWithImpl<$Res>
    implements _$FoundCopyWith<$Res> {
  __$FoundCopyWithImpl(this._self, this._then);

  final _Found _self;
  final $Res Function(_Found) _then;

/// Create a copy of MatchmakingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? permanentChat = null,}) {
  return _then(_Found(
permanentChat: null == permanentChat ? _self.permanentChat : permanentChat // ignore: cast_nullable_to_non_nullable
as PermanentChatResponseDto,
  ));
}

/// Create a copy of MatchmakingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermanentChatResponseDtoCopyWith<$Res> get permanentChat {
  
  return $PermanentChatResponseDtoCopyWith<$Res>(_self.permanentChat, (value) {
    return _then(_self.copyWith(permanentChat: value));
  });
}
}

/// @nodoc


class _Error implements MatchmakingState {
  const _Error({required this.error});
  

 final  String error;

/// Create a copy of MatchmakingState
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
  return 'MatchmakingState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $MatchmakingStateCopyWith<$Res> {
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

/// Create a copy of MatchmakingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(_Error(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _NoResults implements MatchmakingState {
  const _NoResults({required this.message});
  

 final  String message;

/// Create a copy of MatchmakingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NoResultsCopyWith<_NoResults> get copyWith => __$NoResultsCopyWithImpl<_NoResults>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NoResults&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'MatchmakingState.noResults(message: $message)';
}


}

/// @nodoc
abstract mixin class _$NoResultsCopyWith<$Res> implements $MatchmakingStateCopyWith<$Res> {
  factory _$NoResultsCopyWith(_NoResults value, $Res Function(_NoResults) _then) = __$NoResultsCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$NoResultsCopyWithImpl<$Res>
    implements _$NoResultsCopyWith<$Res> {
  __$NoResultsCopyWithImpl(this._self, this._then);

  final _NoResults _self;
  final $Res Function(_NoResults) _then;

/// Create a copy of MatchmakingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_NoResults(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
