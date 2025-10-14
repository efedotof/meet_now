// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageMedia {

 String? get id; String get contentType; String? get mediaUrl; int? get fileSize; String? get mimeType; String? get thumbnailUrl; String? get stickerId; Sticker? get sticker; int? get sortOrder;
/// Create a copy of MessageMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageMediaCopyWith<MessageMedia> get copyWith => _$MessageMediaCopyWithImpl<MessageMedia>(this as MessageMedia, _$identity);

  /// Serializes this MessageMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.stickerId, stickerId) || other.stickerId == stickerId)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,contentType,mediaUrl,fileSize,mimeType,thumbnailUrl,stickerId,sticker,sortOrder);

@override
String toString() {
  return 'MessageMedia(id: $id, contentType: $contentType, mediaUrl: $mediaUrl, fileSize: $fileSize, mimeType: $mimeType, thumbnailUrl: $thumbnailUrl, stickerId: $stickerId, sticker: $sticker, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $MessageMediaCopyWith<$Res>  {
  factory $MessageMediaCopyWith(MessageMedia value, $Res Function(MessageMedia) _then) = _$MessageMediaCopyWithImpl;
@useResult
$Res call({
 String? id, String contentType, String? mediaUrl, int? fileSize, String? mimeType, String? thumbnailUrl, String? stickerId, Sticker? sticker, int? sortOrder
});


$StickerCopyWith<$Res>? get sticker;

}
/// @nodoc
class _$MessageMediaCopyWithImpl<$Res>
    implements $MessageMediaCopyWith<$Res> {
  _$MessageMediaCopyWithImpl(this._self, this._then);

  final MessageMedia _self;
  final $Res Function(MessageMedia) _then;

/// Create a copy of MessageMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? contentType = null,Object? mediaUrl = freezed,Object? fileSize = freezed,Object? mimeType = freezed,Object? thumbnailUrl = freezed,Object? stickerId = freezed,Object? sticker = freezed,Object? sortOrder = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,stickerId: freezed == stickerId ? _self.stickerId : stickerId // ignore: cast_nullable_to_non_nullable
as String?,sticker: freezed == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as Sticker?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of MessageMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StickerCopyWith<$Res>? get sticker {
    if (_self.sticker == null) {
    return null;
  }

  return $StickerCopyWith<$Res>(_self.sticker!, (value) {
    return _then(_self.copyWith(sticker: value));
  });
}
}


/// Adds pattern-matching-related methods to [MessageMedia].
extension MessageMediaPatterns on MessageMedia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageMedia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageMedia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageMedia value)  $default,){
final _that = this;
switch (_that) {
case _MessageMedia():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageMedia value)?  $default,){
final _that = this;
switch (_that) {
case _MessageMedia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String contentType,  String? mediaUrl,  int? fileSize,  String? mimeType,  String? thumbnailUrl,  String? stickerId,  Sticker? sticker,  int? sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageMedia() when $default != null:
return $default(_that.id,_that.contentType,_that.mediaUrl,_that.fileSize,_that.mimeType,_that.thumbnailUrl,_that.stickerId,_that.sticker,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String contentType,  String? mediaUrl,  int? fileSize,  String? mimeType,  String? thumbnailUrl,  String? stickerId,  Sticker? sticker,  int? sortOrder)  $default,) {final _that = this;
switch (_that) {
case _MessageMedia():
return $default(_that.id,_that.contentType,_that.mediaUrl,_that.fileSize,_that.mimeType,_that.thumbnailUrl,_that.stickerId,_that.sticker,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String contentType,  String? mediaUrl,  int? fileSize,  String? mimeType,  String? thumbnailUrl,  String? stickerId,  Sticker? sticker,  int? sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _MessageMedia() when $default != null:
return $default(_that.id,_that.contentType,_that.mediaUrl,_that.fileSize,_that.mimeType,_that.thumbnailUrl,_that.stickerId,_that.sticker,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageMedia implements MessageMedia {
  const _MessageMedia({this.id, required this.contentType, this.mediaUrl, this.fileSize, this.mimeType, this.thumbnailUrl, this.stickerId, this.sticker, this.sortOrder});
  factory _MessageMedia.fromJson(Map<String, dynamic> json) => _$MessageMediaFromJson(json);

@override final  String? id;
@override final  String contentType;
@override final  String? mediaUrl;
@override final  int? fileSize;
@override final  String? mimeType;
@override final  String? thumbnailUrl;
@override final  String? stickerId;
@override final  Sticker? sticker;
@override final  int? sortOrder;

/// Create a copy of MessageMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageMediaCopyWith<_MessageMedia> get copyWith => __$MessageMediaCopyWithImpl<_MessageMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.stickerId, stickerId) || other.stickerId == stickerId)&&(identical(other.sticker, sticker) || other.sticker == sticker)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,contentType,mediaUrl,fileSize,mimeType,thumbnailUrl,stickerId,sticker,sortOrder);

@override
String toString() {
  return 'MessageMedia(id: $id, contentType: $contentType, mediaUrl: $mediaUrl, fileSize: $fileSize, mimeType: $mimeType, thumbnailUrl: $thumbnailUrl, stickerId: $stickerId, sticker: $sticker, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$MessageMediaCopyWith<$Res> implements $MessageMediaCopyWith<$Res> {
  factory _$MessageMediaCopyWith(_MessageMedia value, $Res Function(_MessageMedia) _then) = __$MessageMediaCopyWithImpl;
@override @useResult
$Res call({
 String? id, String contentType, String? mediaUrl, int? fileSize, String? mimeType, String? thumbnailUrl, String? stickerId, Sticker? sticker, int? sortOrder
});


@override $StickerCopyWith<$Res>? get sticker;

}
/// @nodoc
class __$MessageMediaCopyWithImpl<$Res>
    implements _$MessageMediaCopyWith<$Res> {
  __$MessageMediaCopyWithImpl(this._self, this._then);

  final _MessageMedia _self;
  final $Res Function(_MessageMedia) _then;

/// Create a copy of MessageMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? contentType = null,Object? mediaUrl = freezed,Object? fileSize = freezed,Object? mimeType = freezed,Object? thumbnailUrl = freezed,Object? stickerId = freezed,Object? sticker = freezed,Object? sortOrder = freezed,}) {
  return _then(_MessageMedia(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: freezed == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,stickerId: freezed == stickerId ? _self.stickerId : stickerId // ignore: cast_nullable_to_non_nullable
as String?,sticker: freezed == sticker ? _self.sticker : sticker // ignore: cast_nullable_to_non_nullable
as Sticker?,sortOrder: freezed == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of MessageMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StickerCopyWith<$Res>? get sticker {
    if (_self.sticker == null) {
    return null;
  }

  return $StickerCopyWith<$Res>(_self.sticker!, (value) {
    return _then(_self.copyWith(sticker: value));
  });
}
}

// dart format on
