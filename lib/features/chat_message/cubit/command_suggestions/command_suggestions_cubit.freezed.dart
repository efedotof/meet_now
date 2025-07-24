// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'command_suggestions_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommandSuggestionsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommandSuggestionsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommandSuggestionsState()';
}


}

/// @nodoc
class $CommandSuggestionsStateCopyWith<$Res>  {
$CommandSuggestionsStateCopyWith(CommandSuggestionsState _, $Res Function(CommandSuggestionsState) __);
}


/// Adds pattern-matching-related methods to [CommandSuggestionsState].
extension CommandSuggestionsStatePatterns on CommandSuggestionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Visible value)?  visible,TResult Function( _Hidden value)?  hidden,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Visible() when visible != null:
return visible(_that);case _Hidden() when hidden != null:
return hidden(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Visible value)  visible,required TResult Function( _Hidden value)  hidden,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Visible():
return visible(_that);case _Hidden():
return hidden(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Visible value)?  visible,TResult? Function( _Hidden value)?  hidden,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Visible() when visible != null:
return visible(_that);case _Hidden() when hidden != null:
return hidden(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( List<String> suggestions)?  visible,TResult Function()?  hidden,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Visible() when visible != null:
return visible(_that.suggestions);case _Hidden() when hidden != null:
return hidden();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( List<String> suggestions)  visible,required TResult Function()  hidden,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Visible():
return visible(_that.suggestions);case _Hidden():
return hidden();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( List<String> suggestions)?  visible,TResult? Function()?  hidden,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Visible() when visible != null:
return visible(_that.suggestions);case _Hidden() when hidden != null:
return hidden();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements CommandSuggestionsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommandSuggestionsState.initial()';
}


}




/// @nodoc


class _Visible implements CommandSuggestionsState {
  const _Visible({required final  List<String> suggestions}): _suggestions = suggestions;
  

 final  List<String> _suggestions;
 List<String> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestions);
}


/// Create a copy of CommandSuggestionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VisibleCopyWith<_Visible> get copyWith => __$VisibleCopyWithImpl<_Visible>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Visible&&const DeepCollectionEquality().equals(other._suggestions, _suggestions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_suggestions));

@override
String toString() {
  return 'CommandSuggestionsState.visible(suggestions: $suggestions)';
}


}

/// @nodoc
abstract mixin class _$VisibleCopyWith<$Res> implements $CommandSuggestionsStateCopyWith<$Res> {
  factory _$VisibleCopyWith(_Visible value, $Res Function(_Visible) _then) = __$VisibleCopyWithImpl;
@useResult
$Res call({
 List<String> suggestions
});




}
/// @nodoc
class __$VisibleCopyWithImpl<$Res>
    implements _$VisibleCopyWith<$Res> {
  __$VisibleCopyWithImpl(this._self, this._then);

  final _Visible _self;
  final $Res Function(_Visible) _then;

/// Create a copy of CommandSuggestionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? suggestions = null,}) {
  return _then(_Visible(
suggestions: null == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class _Hidden implements CommandSuggestionsState {
  const _Hidden();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Hidden);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CommandSuggestionsState.hidden()';
}


}




// dart format on
