// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sticker_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StickerState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StickerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StickerState()';
}


}

/// @nodoc
class $StickerStateCopyWith<$Res>  {
$StickerStateCopyWith(StickerState _, $Res Function(StickerState) __);
}


/// Adds pattern-matching-related methods to [StickerState].
extension StickerStatePatterns on StickerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Hidden value)?  hidden,TResult Function( _Visible value)?  visible,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Hidden() when hidden != null:
return hidden(_that);case _Visible() when visible != null:
return visible(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Hidden value)  hidden,required TResult Function( _Visible value)  visible,}){
final _that = this;
switch (_that) {
case _Hidden():
return hidden(_that);case _Visible():
return visible(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Hidden value)?  hidden,TResult? Function( _Visible value)?  visible,}){
final _that = this;
switch (_that) {
case _Hidden() when hidden != null:
return hidden(_that);case _Visible() when visible != null:
return visible(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  hidden,TResult Function()?  visible,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Hidden() when hidden != null:
return hidden();case _Visible() when visible != null:
return visible();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  hidden,required TResult Function()  visible,}) {final _that = this;
switch (_that) {
case _Hidden():
return hidden();case _Visible():
return visible();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  hidden,TResult? Function()?  visible,}) {final _that = this;
switch (_that) {
case _Hidden() when hidden != null:
return hidden();case _Visible() when visible != null:
return visible();case _:
  return null;

}
}

}

/// @nodoc


class _Hidden implements StickerState {
  const _Hidden();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hidden);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StickerState.hidden()';
}


}




/// @nodoc


class _Visible implements StickerState {
  const _Visible();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Visible);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StickerState.visible()';
}


}




// dart format on
