// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icebreaker_topec.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IcebreakerTopec {

 int get id; String get text;
/// Create a copy of IcebreakerTopec
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IcebreakerTopecCopyWith<IcebreakerTopec> get copyWith => _$IcebreakerTopecCopyWithImpl<IcebreakerTopec>(this as IcebreakerTopec, _$identity);

  /// Serializes this IcebreakerTopec to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IcebreakerTopec&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text);

@override
String toString() {
  return 'IcebreakerTopec(id: $id, text: $text)';
}


}

/// @nodoc
abstract mixin class $IcebreakerTopecCopyWith<$Res>  {
  factory $IcebreakerTopecCopyWith(IcebreakerTopec value, $Res Function(IcebreakerTopec) _then) = _$IcebreakerTopecCopyWithImpl;
@useResult
$Res call({
 int id, String text
});




}
/// @nodoc
class _$IcebreakerTopecCopyWithImpl<$Res>
    implements $IcebreakerTopecCopyWith<$Res> {
  _$IcebreakerTopecCopyWithImpl(this._self, this._then);

  final IcebreakerTopec _self;
  final $Res Function(IcebreakerTopec) _then;

/// Create a copy of IcebreakerTopec
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IcebreakerTopec].
extension IcebreakerTopecPatterns on IcebreakerTopec {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IcebreakerTopec value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IcebreakerTopec() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IcebreakerTopec value)  $default,){
final _that = this;
switch (_that) {
case _IcebreakerTopec():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IcebreakerTopec value)?  $default,){
final _that = this;
switch (_that) {
case _IcebreakerTopec() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IcebreakerTopec() when $default != null:
return $default(_that.id,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String text)  $default,) {final _that = this;
switch (_that) {
case _IcebreakerTopec():
return $default(_that.id,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String text)?  $default,) {final _that = this;
switch (_that) {
case _IcebreakerTopec() when $default != null:
return $default(_that.id,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IcebreakerTopec implements IcebreakerTopec {
  const _IcebreakerTopec({required this.id, required this.text});
  factory _IcebreakerTopec.fromJson(Map<String, dynamic> json) => _$IcebreakerTopecFromJson(json);

@override final  int id;
@override final  String text;

/// Create a copy of IcebreakerTopec
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IcebreakerTopecCopyWith<_IcebreakerTopec> get copyWith => __$IcebreakerTopecCopyWithImpl<_IcebreakerTopec>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IcebreakerTopecToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IcebreakerTopec&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text);

@override
String toString() {
  return 'IcebreakerTopec(id: $id, text: $text)';
}


}

/// @nodoc
abstract mixin class _$IcebreakerTopecCopyWith<$Res> implements $IcebreakerTopecCopyWith<$Res> {
  factory _$IcebreakerTopecCopyWith(_IcebreakerTopec value, $Res Function(_IcebreakerTopec) _then) = __$IcebreakerTopecCopyWithImpl;
@override @useResult
$Res call({
 int id, String text
});




}
/// @nodoc
class __$IcebreakerTopecCopyWithImpl<$Res>
    implements _$IcebreakerTopecCopyWith<$Res> {
  __$IcebreakerTopecCopyWithImpl(this._self, this._then);

  final _IcebreakerTopec _self;
  final $Res Function(_IcebreakerTopec) _then;

/// Create a copy of IcebreakerTopec
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,}) {
  return _then(_IcebreakerTopec(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
