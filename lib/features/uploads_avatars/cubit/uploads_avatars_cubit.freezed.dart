// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'uploads_avatars_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UploadsAvatarsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadsAvatarsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UploadsAvatarsState()';
}


}

/// @nodoc
class $UploadsAvatarsStateCopyWith<$Res>  {
$UploadsAvatarsStateCopyWith(UploadsAvatarsState _, $Res Function(UploadsAvatarsState) __);
}


/// Adds pattern-matching-related methods to [UploadsAvatarsState].
extension UploadsAvatarsStatePatterns on UploadsAvatarsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _AvatarUploadSuccess value)?  avatarUploadSuccess,TResult Function( _ImagesUploadSuccess value)?  imagesUploadSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _AvatarUploadSuccess() when avatarUploadSuccess != null:
return avatarUploadSuccess(_that);case _ImagesUploadSuccess() when imagesUploadSuccess != null:
return imagesUploadSuccess(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _AvatarUploadSuccess value)  avatarUploadSuccess,required TResult Function( _ImagesUploadSuccess value)  imagesUploadSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _AvatarUploadSuccess():
return avatarUploadSuccess(_that);case _ImagesUploadSuccess():
return imagesUploadSuccess(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _AvatarUploadSuccess value)?  avatarUploadSuccess,TResult? Function( _ImagesUploadSuccess value)?  imagesUploadSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _AvatarUploadSuccess() when avatarUploadSuccess != null:
return avatarUploadSuccess(_that);case _ImagesUploadSuccess() when imagesUploadSuccess != null:
return imagesUploadSuccess(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String url)?  avatarUploadSuccess,TResult Function( List<String> urls)?  imagesUploadSuccess,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _AvatarUploadSuccess() when avatarUploadSuccess != null:
return avatarUploadSuccess(_that.url);case _ImagesUploadSuccess() when imagesUploadSuccess != null:
return imagesUploadSuccess(_that.urls);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String url)  avatarUploadSuccess,required TResult Function( List<String> urls)  imagesUploadSuccess,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _AvatarUploadSuccess():
return avatarUploadSuccess(_that.url);case _ImagesUploadSuccess():
return imagesUploadSuccess(_that.urls);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String url)?  avatarUploadSuccess,TResult? Function( List<String> urls)?  imagesUploadSuccess,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _AvatarUploadSuccess() when avatarUploadSuccess != null:
return avatarUploadSuccess(_that.url);case _ImagesUploadSuccess() when imagesUploadSuccess != null:
return imagesUploadSuccess(_that.urls);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements UploadsAvatarsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UploadsAvatarsState.initial()';
}


}




/// @nodoc


class _Loading implements UploadsAvatarsState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UploadsAvatarsState.loading()';
}


}




/// @nodoc


class _AvatarUploadSuccess implements UploadsAvatarsState {
  const _AvatarUploadSuccess(this.url);
  

 final  String url;

/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarUploadSuccessCopyWith<_AvatarUploadSuccess> get copyWith => __$AvatarUploadSuccessCopyWithImpl<_AvatarUploadSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarUploadSuccess&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'UploadsAvatarsState.avatarUploadSuccess(url: $url)';
}


}

/// @nodoc
abstract mixin class _$AvatarUploadSuccessCopyWith<$Res> implements $UploadsAvatarsStateCopyWith<$Res> {
  factory _$AvatarUploadSuccessCopyWith(_AvatarUploadSuccess value, $Res Function(_AvatarUploadSuccess) _then) = __$AvatarUploadSuccessCopyWithImpl;
@useResult
$Res call({
 String url
});




}
/// @nodoc
class __$AvatarUploadSuccessCopyWithImpl<$Res>
    implements _$AvatarUploadSuccessCopyWith<$Res> {
  __$AvatarUploadSuccessCopyWithImpl(this._self, this._then);

  final _AvatarUploadSuccess _self;
  final $Res Function(_AvatarUploadSuccess) _then;

/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? url = null,}) {
  return _then(_AvatarUploadSuccess(
null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ImagesUploadSuccess implements UploadsAvatarsState {
  const _ImagesUploadSuccess(final  List<String> urls): _urls = urls;
  

 final  List<String> _urls;
 List<String> get urls {
  if (_urls is EqualUnmodifiableListView) return _urls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_urls);
}


/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImagesUploadSuccessCopyWith<_ImagesUploadSuccess> get copyWith => __$ImagesUploadSuccessCopyWithImpl<_ImagesUploadSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImagesUploadSuccess&&const DeepCollectionEquality().equals(other._urls, _urls));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_urls));

@override
String toString() {
  return 'UploadsAvatarsState.imagesUploadSuccess(urls: $urls)';
}


}

/// @nodoc
abstract mixin class _$ImagesUploadSuccessCopyWith<$Res> implements $UploadsAvatarsStateCopyWith<$Res> {
  factory _$ImagesUploadSuccessCopyWith(_ImagesUploadSuccess value, $Res Function(_ImagesUploadSuccess) _then) = __$ImagesUploadSuccessCopyWithImpl;
@useResult
$Res call({
 List<String> urls
});




}
/// @nodoc
class __$ImagesUploadSuccessCopyWithImpl<$Res>
    implements _$ImagesUploadSuccessCopyWith<$Res> {
  __$ImagesUploadSuccessCopyWithImpl(this._self, this._then);

  final _ImagesUploadSuccess _self;
  final $Res Function(_ImagesUploadSuccess) _then;

/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? urls = null,}) {
  return _then(_ImagesUploadSuccess(
null == urls ? _self._urls : urls // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class _Error implements UploadsAvatarsState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UploadsAvatarsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $UploadsAvatarsStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
