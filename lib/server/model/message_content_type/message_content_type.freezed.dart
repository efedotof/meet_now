// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_content_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageContentType {

 String get id;@JsonKey(name: 'type_name') String get typeName;
/// Create a copy of MessageContentType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageContentTypeCopyWith<MessageContentType> get copyWith => _$MessageContentTypeCopyWithImpl<MessageContentType>(this as MessageContentType, _$identity);

  /// Serializes this MessageContentType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageContentType&&(identical(other.id, id) || other.id == id)&&(identical(other.typeName, typeName) || other.typeName == typeName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,typeName);

@override
String toString() {
  return 'MessageContentType(id: $id, typeName: $typeName)';
}


}

/// @nodoc
abstract mixin class $MessageContentTypeCopyWith<$Res>  {
  factory $MessageContentTypeCopyWith(MessageContentType value, $Res Function(MessageContentType) _then) = _$MessageContentTypeCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'type_name') String typeName
});




}
/// @nodoc
class _$MessageContentTypeCopyWithImpl<$Res>
    implements $MessageContentTypeCopyWith<$Res> {
  _$MessageContentTypeCopyWithImpl(this._self, this._then);

  final MessageContentType _self;
  final $Res Function(MessageContentType) _then;

/// Create a copy of MessageContentType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? typeName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,typeName: null == typeName ? _self.typeName : typeName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageContentType].
extension MessageContentTypePatterns on MessageContentType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageContentType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageContentType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageContentType value)  $default,){
final _that = this;
switch (_that) {
case _MessageContentType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageContentType value)?  $default,){
final _that = this;
switch (_that) {
case _MessageContentType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'type_name')  String typeName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageContentType() when $default != null:
return $default(_that.id,_that.typeName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'type_name')  String typeName)  $default,) {final _that = this;
switch (_that) {
case _MessageContentType():
return $default(_that.id,_that.typeName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'type_name')  String typeName)?  $default,) {final _that = this;
switch (_that) {
case _MessageContentType() when $default != null:
return $default(_that.id,_that.typeName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageContentType implements MessageContentType {
  const _MessageContentType({required this.id, @JsonKey(name: 'type_name') required this.typeName});
  factory _MessageContentType.fromJson(Map<String, dynamic> json) => _$MessageContentTypeFromJson(json);

@override final  String id;
@override@JsonKey(name: 'type_name') final  String typeName;

/// Create a copy of MessageContentType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageContentTypeCopyWith<_MessageContentType> get copyWith => __$MessageContentTypeCopyWithImpl<_MessageContentType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageContentTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageContentType&&(identical(other.id, id) || other.id == id)&&(identical(other.typeName, typeName) || other.typeName == typeName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,typeName);

@override
String toString() {
  return 'MessageContentType(id: $id, typeName: $typeName)';
}


}

/// @nodoc
abstract mixin class _$MessageContentTypeCopyWith<$Res> implements $MessageContentTypeCopyWith<$Res> {
  factory _$MessageContentTypeCopyWith(_MessageContentType value, $Res Function(_MessageContentType) _then) = __$MessageContentTypeCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'type_name') String typeName
});




}
/// @nodoc
class __$MessageContentTypeCopyWithImpl<$Res>
    implements _$MessageContentTypeCopyWith<$Res> {
  __$MessageContentTypeCopyWithImpl(this._self, this._then);

  final _MessageContentType _self;
  final $Res Function(_MessageContentType) _then;

/// Create a copy of MessageContentType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? typeName = null,}) {
  return _then(_MessageContentType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,typeName: null == typeName ? _self.typeName : typeName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
