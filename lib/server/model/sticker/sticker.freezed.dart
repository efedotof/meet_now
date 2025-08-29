// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sticker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Sticker {

 String get id; StickerPack get pack; String get emoji; String get imageUrl;
/// Create a copy of Sticker
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StickerCopyWith<Sticker> get copyWith => _$StickerCopyWithImpl<Sticker>(this as Sticker, _$identity);

  /// Serializes this Sticker to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Sticker&&(identical(other.id, id) || other.id == id)&&(identical(other.pack, pack) || other.pack == pack)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pack,emoji,imageUrl);

@override
String toString() {
  return 'Sticker(id: $id, pack: $pack, emoji: $emoji, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $StickerCopyWith<$Res>  {
  factory $StickerCopyWith(Sticker value, $Res Function(Sticker) _then) = _$StickerCopyWithImpl;
@useResult
$Res call({
 String id, StickerPack pack, String emoji, String imageUrl
});


$StickerPackCopyWith<$Res> get pack;

}
/// @nodoc
class _$StickerCopyWithImpl<$Res>
    implements $StickerCopyWith<$Res> {
  _$StickerCopyWithImpl(this._self, this._then);

  final Sticker _self;
  final $Res Function(Sticker) _then;

/// Create a copy of Sticker
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pack = null,Object? emoji = null,Object? imageUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pack: null == pack ? _self.pack : pack // ignore: cast_nullable_to_non_nullable
as StickerPack,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Sticker
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StickerPackCopyWith<$Res> get pack {
  
  return $StickerPackCopyWith<$Res>(_self.pack, (value) {
    return _then(_self.copyWith(pack: value));
  });
}
}


/// Adds pattern-matching-related methods to [Sticker].
extension StickerPatterns on Sticker {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Sticker value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Sticker() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Sticker value)  $default,){
final _that = this;
switch (_that) {
case _Sticker():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Sticker value)?  $default,){
final _that = this;
switch (_that) {
case _Sticker() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  StickerPack pack,  String emoji,  String imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Sticker() when $default != null:
return $default(_that.id,_that.pack,_that.emoji,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  StickerPack pack,  String emoji,  String imageUrl)  $default,) {final _that = this;
switch (_that) {
case _Sticker():
return $default(_that.id,_that.pack,_that.emoji,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  StickerPack pack,  String emoji,  String imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _Sticker() when $default != null:
return $default(_that.id,_that.pack,_that.emoji,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Sticker implements Sticker {
  const _Sticker({required this.id, required this.pack, required this.emoji, required this.imageUrl});
  factory _Sticker.fromJson(Map<String, dynamic> json) => _$StickerFromJson(json);

@override final  String id;
@override final  StickerPack pack;
@override final  String emoji;
@override final  String imageUrl;

/// Create a copy of Sticker
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StickerCopyWith<_Sticker> get copyWith => __$StickerCopyWithImpl<_Sticker>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StickerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Sticker&&(identical(other.id, id) || other.id == id)&&(identical(other.pack, pack) || other.pack == pack)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pack,emoji,imageUrl);

@override
String toString() {
  return 'Sticker(id: $id, pack: $pack, emoji: $emoji, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$StickerCopyWith<$Res> implements $StickerCopyWith<$Res> {
  factory _$StickerCopyWith(_Sticker value, $Res Function(_Sticker) _then) = __$StickerCopyWithImpl;
@override @useResult
$Res call({
 String id, StickerPack pack, String emoji, String imageUrl
});


@override $StickerPackCopyWith<$Res> get pack;

}
/// @nodoc
class __$StickerCopyWithImpl<$Res>
    implements _$StickerCopyWith<$Res> {
  __$StickerCopyWithImpl(this._self, this._then);

  final _Sticker _self;
  final $Res Function(_Sticker) _then;

/// Create a copy of Sticker
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pack = null,Object? emoji = null,Object? imageUrl = null,}) {
  return _then(_Sticker(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pack: null == pack ? _self.pack : pack // ignore: cast_nullable_to_non_nullable
as StickerPack,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Sticker
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StickerPackCopyWith<$Res> get pack {
  
  return $StickerPackCopyWith<$Res>(_self.pack, (value) {
    return _then(_self.copyWith(pack: value));
  });
}
}

// dart format on
