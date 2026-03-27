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
mixin _$UploadsAvatarsState implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UploadsAvatarsState'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadsAvatarsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _AvatarSelected value)?  avatarSelected,TResult Function( _AvatarLoading value)?  avatarLoading,TResult Function( _ImagesLoading value)?  imagesLoading,TResult Function( _AvatarUploadSuccess value)?  avatarUploadSuccess,TResult Function( _GallerySelected value)?  gallerySelected,TResult Function( _ImagesUploadSuccess value)?  imagesUploadSuccess,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _AvatarSelected() when avatarSelected != null:
return avatarSelected(_that);case _AvatarLoading() when avatarLoading != null:
return avatarLoading(_that);case _ImagesLoading() when imagesLoading != null:
return imagesLoading(_that);case _AvatarUploadSuccess() when avatarUploadSuccess != null:
return avatarUploadSuccess(_that);case _GallerySelected() when gallerySelected != null:
return gallerySelected(_that);case _ImagesUploadSuccess() when imagesUploadSuccess != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _AvatarSelected value)  avatarSelected,required TResult Function( _AvatarLoading value)  avatarLoading,required TResult Function( _ImagesLoading value)  imagesLoading,required TResult Function( _AvatarUploadSuccess value)  avatarUploadSuccess,required TResult Function( _GallerySelected value)  gallerySelected,required TResult Function( _ImagesUploadSuccess value)  imagesUploadSuccess,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _AvatarSelected():
return avatarSelected(_that);case _AvatarLoading():
return avatarLoading(_that);case _ImagesLoading():
return imagesLoading(_that);case _AvatarUploadSuccess():
return avatarUploadSuccess(_that);case _GallerySelected():
return gallerySelected(_that);case _ImagesUploadSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _AvatarSelected value)?  avatarSelected,TResult? Function( _AvatarLoading value)?  avatarLoading,TResult? Function( _ImagesLoading value)?  imagesLoading,TResult? Function( _AvatarUploadSuccess value)?  avatarUploadSuccess,TResult? Function( _GallerySelected value)?  gallerySelected,TResult? Function( _ImagesUploadSuccess value)?  imagesUploadSuccess,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _AvatarSelected() when avatarSelected != null:
return avatarSelected(_that);case _AvatarLoading() when avatarLoading != null:
return avatarLoading(_that);case _ImagesLoading() when imagesLoading != null:
return imagesLoading(_that);case _AvatarUploadSuccess() when avatarUploadSuccess != null:
return avatarUploadSuccess(_that);case _GallerySelected() when gallerySelected != null:
return gallerySelected(_that);case _ImagesUploadSuccess() when imagesUploadSuccess != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( String uri,  Uint8List bytes)?  avatarSelected,TResult Function()?  avatarLoading,TResult Function()?  imagesLoading,TResult Function( String url)?  avatarUploadSuccess,TResult Function( List<String> paths)?  gallerySelected,TResult Function( List<String> urls)?  imagesUploadSuccess,TResult Function( UploadAvatarsErrorKeys errorKey)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _AvatarSelected() when avatarSelected != null:
return avatarSelected(_that.uri,_that.bytes);case _AvatarLoading() when avatarLoading != null:
return avatarLoading();case _ImagesLoading() when imagesLoading != null:
return imagesLoading();case _AvatarUploadSuccess() when avatarUploadSuccess != null:
return avatarUploadSuccess(_that.url);case _GallerySelected() when gallerySelected != null:
return gallerySelected(_that.paths);case _ImagesUploadSuccess() when imagesUploadSuccess != null:
return imagesUploadSuccess(_that.urls);case _Error() when error != null:
return error(_that.errorKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( String uri,  Uint8List bytes)  avatarSelected,required TResult Function()  avatarLoading,required TResult Function()  imagesLoading,required TResult Function( String url)  avatarUploadSuccess,required TResult Function( List<String> paths)  gallerySelected,required TResult Function( List<String> urls)  imagesUploadSuccess,required TResult Function( UploadAvatarsErrorKeys errorKey)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _AvatarSelected():
return avatarSelected(_that.uri,_that.bytes);case _AvatarLoading():
return avatarLoading();case _ImagesLoading():
return imagesLoading();case _AvatarUploadSuccess():
return avatarUploadSuccess(_that.url);case _GallerySelected():
return gallerySelected(_that.paths);case _ImagesUploadSuccess():
return imagesUploadSuccess(_that.urls);case _Error():
return error(_that.errorKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( String uri,  Uint8List bytes)?  avatarSelected,TResult? Function()?  avatarLoading,TResult? Function()?  imagesLoading,TResult? Function( String url)?  avatarUploadSuccess,TResult? Function( List<String> paths)?  gallerySelected,TResult? Function( List<String> urls)?  imagesUploadSuccess,TResult? Function( UploadAvatarsErrorKeys errorKey)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _AvatarSelected() when avatarSelected != null:
return avatarSelected(_that.uri,_that.bytes);case _AvatarLoading() when avatarLoading != null:
return avatarLoading();case _ImagesLoading() when imagesLoading != null:
return imagesLoading();case _AvatarUploadSuccess() when avatarUploadSuccess != null:
return avatarUploadSuccess(_that.url);case _GallerySelected() when gallerySelected != null:
return gallerySelected(_that.paths);case _ImagesUploadSuccess() when imagesUploadSuccess != null:
return imagesUploadSuccess(_that.urls);case _Error() when error != null:
return error(_that.errorKey);case _:
  return null;

}
}

}

/// @nodoc


class _Initial with DiagnosticableTreeMixin implements UploadsAvatarsState {
  const _Initial();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UploadsAvatarsState.initial'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UploadsAvatarsState.initial()';
}


}




/// @nodoc


class _AvatarSelected with DiagnosticableTreeMixin implements UploadsAvatarsState {
  const _AvatarSelected(this.uri, this.bytes);
  

 final  String uri;
 final  Uint8List bytes;

/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarSelectedCopyWith<_AvatarSelected> get copyWith => __$AvatarSelectedCopyWithImpl<_AvatarSelected>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UploadsAvatarsState.avatarSelected'))
    ..add(DiagnosticsProperty('uri', uri))..add(DiagnosticsProperty('bytes', bytes));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarSelected&&(identical(other.uri, uri) || other.uri == uri)&&const DeepCollectionEquality().equals(other.bytes, bytes));
}


@override
int get hashCode => Object.hash(runtimeType,uri,const DeepCollectionEquality().hash(bytes));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UploadsAvatarsState.avatarSelected(uri: $uri, bytes: $bytes)';
}


}

/// @nodoc
abstract mixin class _$AvatarSelectedCopyWith<$Res> implements $UploadsAvatarsStateCopyWith<$Res> {
  factory _$AvatarSelectedCopyWith(_AvatarSelected value, $Res Function(_AvatarSelected) _then) = __$AvatarSelectedCopyWithImpl;
@useResult
$Res call({
 String uri, Uint8List bytes
});




}
/// @nodoc
class __$AvatarSelectedCopyWithImpl<$Res>
    implements _$AvatarSelectedCopyWith<$Res> {
  __$AvatarSelectedCopyWithImpl(this._self, this._then);

  final _AvatarSelected _self;
  final $Res Function(_AvatarSelected) _then;

/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uri = null,Object? bytes = null,}) {
  return _then(_AvatarSelected(
null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}


}

/// @nodoc


class _AvatarLoading with DiagnosticableTreeMixin implements UploadsAvatarsState {
  const _AvatarLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UploadsAvatarsState.avatarLoading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UploadsAvatarsState.avatarLoading()';
}


}




/// @nodoc


class _ImagesLoading with DiagnosticableTreeMixin implements UploadsAvatarsState {
  const _ImagesLoading();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UploadsAvatarsState.imagesLoading'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImagesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UploadsAvatarsState.imagesLoading()';
}


}




/// @nodoc


class _AvatarUploadSuccess with DiagnosticableTreeMixin implements UploadsAvatarsState {
  const _AvatarUploadSuccess(this.url);
  

 final  String url;

/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarUploadSuccessCopyWith<_AvatarUploadSuccess> get copyWith => __$AvatarUploadSuccessCopyWithImpl<_AvatarUploadSuccess>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UploadsAvatarsState.avatarUploadSuccess'))
    ..add(DiagnosticsProperty('url', url));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarUploadSuccess&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
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


class _GallerySelected with DiagnosticableTreeMixin implements UploadsAvatarsState {
  const _GallerySelected(final  List<String> paths): _paths = paths;
  

 final  List<String> _paths;
 List<String> get paths {
  if (_paths is EqualUnmodifiableListView) return _paths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paths);
}


/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GallerySelectedCopyWith<_GallerySelected> get copyWith => __$GallerySelectedCopyWithImpl<_GallerySelected>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UploadsAvatarsState.gallerySelected'))
    ..add(DiagnosticsProperty('paths', paths));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GallerySelected&&const DeepCollectionEquality().equals(other._paths, _paths));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_paths));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UploadsAvatarsState.gallerySelected(paths: $paths)';
}


}

/// @nodoc
abstract mixin class _$GallerySelectedCopyWith<$Res> implements $UploadsAvatarsStateCopyWith<$Res> {
  factory _$GallerySelectedCopyWith(_GallerySelected value, $Res Function(_GallerySelected) _then) = __$GallerySelectedCopyWithImpl;
@useResult
$Res call({
 List<String> paths
});




}
/// @nodoc
class __$GallerySelectedCopyWithImpl<$Res>
    implements _$GallerySelectedCopyWith<$Res> {
  __$GallerySelectedCopyWithImpl(this._self, this._then);

  final _GallerySelected _self;
  final $Res Function(_GallerySelected) _then;

/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? paths = null,}) {
  return _then(_GallerySelected(
null == paths ? _self._paths : paths // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class _ImagesUploadSuccess with DiagnosticableTreeMixin implements UploadsAvatarsState {
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
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UploadsAvatarsState.imagesUploadSuccess'))
    ..add(DiagnosticsProperty('urls', urls));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImagesUploadSuccess&&const DeepCollectionEquality().equals(other._urls, _urls));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_urls));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
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


class _Error with DiagnosticableTreeMixin implements UploadsAvatarsState {
  const _Error(this.errorKey);
  

 final  UploadAvatarsErrorKeys errorKey;

/// Create a copy of UploadsAvatarsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'UploadsAvatarsState.error'))
    ..add(DiagnosticsProperty('errorKey', errorKey));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.errorKey, errorKey) || other.errorKey == errorKey));
}


@override
int get hashCode => Object.hash(runtimeType,errorKey);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'UploadsAvatarsState.error(errorKey: $errorKey)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $UploadsAvatarsStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 UploadAvatarsErrorKeys errorKey
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
@pragma('vm:prefer-inline') $Res call({Object? errorKey = null,}) {
  return _then(_Error(
null == errorKey ? _self.errorKey : errorKey // ignore: cast_nullable_to_non_nullable
as UploadAvatarsErrorKeys,
  ));
}


}

// dart format on
