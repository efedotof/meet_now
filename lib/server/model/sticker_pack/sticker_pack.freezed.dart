// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sticker_pack.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StickerPack {

 String get id; String get title; List<Sticker> get stickers;
/// Create a copy of StickerPack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StickerPackCopyWith<StickerPack> get copyWith => _$StickerPackCopyWithImpl<StickerPack>(this as StickerPack, _$identity);

  /// Serializes this StickerPack to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StickerPack&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.stickers, stickers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(stickers));

@override
String toString() {
  return 'StickerPack(id: $id, title: $title, stickers: $stickers)';
}


}

/// @nodoc
abstract mixin class $StickerPackCopyWith<$Res>  {
  factory $StickerPackCopyWith(StickerPack value, $Res Function(StickerPack) _then) = _$StickerPackCopyWithImpl;
@useResult
$Res call({
 String id, String title, List<Sticker> stickers
});




}
/// @nodoc
class _$StickerPackCopyWithImpl<$Res>
    implements $StickerPackCopyWith<$Res> {
  _$StickerPackCopyWithImpl(this._self, this._then);

  final StickerPack _self;
  final $Res Function(StickerPack) _then;

/// Create a copy of StickerPack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? stickers = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,stickers: null == stickers ? _self.stickers : stickers // ignore: cast_nullable_to_non_nullable
as List<Sticker>,
  ));
}

}


/// Adds pattern-matching-related methods to [StickerPack].
extension StickerPackPatterns on StickerPack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StickerPack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StickerPack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StickerPack value)  $default,){
final _that = this;
switch (_that) {
case _StickerPack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StickerPack value)?  $default,){
final _that = this;
switch (_that) {
case _StickerPack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  List<Sticker> stickers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StickerPack() when $default != null:
return $default(_that.id,_that.title,_that.stickers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  List<Sticker> stickers)  $default,) {final _that = this;
switch (_that) {
case _StickerPack():
return $default(_that.id,_that.title,_that.stickers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  List<Sticker> stickers)?  $default,) {final _that = this;
switch (_that) {
case _StickerPack() when $default != null:
return $default(_that.id,_that.title,_that.stickers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StickerPack implements StickerPack {
  const _StickerPack({required this.id, required this.title, required final  List<Sticker> stickers}): _stickers = stickers;
  factory _StickerPack.fromJson(Map<String, dynamic> json) => _$StickerPackFromJson(json);

@override final  String id;
@override final  String title;
 final  List<Sticker> _stickers;
@override List<Sticker> get stickers {
  if (_stickers is EqualUnmodifiableListView) return _stickers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stickers);
}


/// Create a copy of StickerPack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StickerPackCopyWith<_StickerPack> get copyWith => __$StickerPackCopyWithImpl<_StickerPack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StickerPackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StickerPack&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._stickers, _stickers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(_stickers));

@override
String toString() {
  return 'StickerPack(id: $id, title: $title, stickers: $stickers)';
}


}

/// @nodoc
abstract mixin class _$StickerPackCopyWith<$Res> implements $StickerPackCopyWith<$Res> {
  factory _$StickerPackCopyWith(_StickerPack value, $Res Function(_StickerPack) _then) = __$StickerPackCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, List<Sticker> stickers
});




}
/// @nodoc
class __$StickerPackCopyWithImpl<$Res>
    implements _$StickerPackCopyWith<$Res> {
  __$StickerPackCopyWithImpl(this._self, this._then);

  final _StickerPack _self;
  final $Res Function(_StickerPack) _then;

/// Create a copy of StickerPack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? stickers = null,}) {
  return _then(_StickerPack(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,stickers: null == stickers ? _self._stickers : stickers // ignore: cast_nullable_to_non_nullable
as List<Sticker>,
  ));
}


}

// dart format on
