// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purpose.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Purpose {

@HiveField(0) String get id;@HiveField(1) String? get title;
/// Create a copy of Purpose
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurposeCopyWith<Purpose> get copyWith => _$PurposeCopyWithImpl<Purpose>(this as Purpose, _$identity);

  /// Serializes this Purpose to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Purpose&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'Purpose(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class $PurposeCopyWith<$Res>  {
  factory $PurposeCopyWith(Purpose value, $Res Function(Purpose) _then) = _$PurposeCopyWithImpl;
@useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String? title
});




}
/// @nodoc
class _$PurposeCopyWithImpl<$Res>
    implements $PurposeCopyWith<$Res> {
  _$PurposeCopyWithImpl(this._self, this._then);

  final Purpose _self;
  final $Res Function(Purpose) _then;

/// Create a copy of Purpose
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Purpose].
extension PurposePatterns on Purpose {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Purpose value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Purpose() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Purpose value)  $default,){
final _that = this;
switch (_that) {
case _Purpose():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Purpose value)?  $default,){
final _that = this;
switch (_that) {
case _Purpose() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String? title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Purpose() when $default != null:
return $default(_that.id,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@HiveField(0)  String id, @HiveField(1)  String? title)  $default,) {final _that = this;
switch (_that) {
case _Purpose():
return $default(_that.id,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@HiveField(0)  String id, @HiveField(1)  String? title)?  $default,) {final _that = this;
switch (_that) {
case _Purpose() when $default != null:
return $default(_that.id,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Purpose implements Purpose {
   _Purpose({@HiveField(0) required this.id, @HiveField(1) required this.title});
  factory _Purpose.fromJson(Map<String, dynamic> json) => _$PurposeFromJson(json);

@override@HiveField(0) final  String id;
@override@HiveField(1) final  String? title;

/// Create a copy of Purpose
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurposeCopyWith<_Purpose> get copyWith => __$PurposeCopyWithImpl<_Purpose>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurposeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Purpose&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'Purpose(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class _$PurposeCopyWith<$Res> implements $PurposeCopyWith<$Res> {
  factory _$PurposeCopyWith(_Purpose value, $Res Function(_Purpose) _then) = __$PurposeCopyWithImpl;
@override @useResult
$Res call({
@HiveField(0) String id,@HiveField(1) String? title
});




}
/// @nodoc
class __$PurposeCopyWithImpl<$Res>
    implements _$PurposeCopyWith<$Res> {
  __$PurposeCopyWithImpl(this._self, this._then);

  final _Purpose _self;
  final $Res Function(_Purpose) _then;

/// Create a copy of Purpose
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,}) {
  return _then(_Purpose(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
