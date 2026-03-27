// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_mode_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchModeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchModeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchModeState()';
}


}

/// @nodoc
class $SearchModeStateCopyWith<$Res>  {
$SearchModeStateCopyWith(SearchModeState _, $Res Function(SearchModeState) __);
}


/// Adds pattern-matching-related methods to [SearchModeState].
extension SearchModeStatePatterns on SearchModeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _IsSearch value)?  isSearch,TResult Function( _IsCardSwiper value)?  isCardSwiper,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IsSearch() when isSearch != null:
return isSearch(_that);case _IsCardSwiper() when isCardSwiper != null:
return isCardSwiper(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _IsSearch value)  isSearch,required TResult Function( _IsCardSwiper value)  isCardSwiper,}){
final _that = this;
switch (_that) {
case _IsSearch():
return isSearch(_that);case _IsCardSwiper():
return isCardSwiper(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _IsSearch value)?  isSearch,TResult? Function( _IsCardSwiper value)?  isCardSwiper,}){
final _that = this;
switch (_that) {
case _IsSearch() when isSearch != null:
return isSearch(_that);case _IsCardSwiper() when isCardSwiper != null:
return isCardSwiper(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  isSearch,TResult Function()?  isCardSwiper,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IsSearch() when isSearch != null:
return isSearch();case _IsCardSwiper() when isCardSwiper != null:
return isCardSwiper();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  isSearch,required TResult Function()  isCardSwiper,}) {final _that = this;
switch (_that) {
case _IsSearch():
return isSearch();case _IsCardSwiper():
return isCardSwiper();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  isSearch,TResult? Function()?  isCardSwiper,}) {final _that = this;
switch (_that) {
case _IsSearch() when isSearch != null:
return isSearch();case _IsCardSwiper() when isCardSwiper != null:
return isCardSwiper();case _:
  return null;

}
}

}

/// @nodoc


class _IsSearch implements SearchModeState {
  const _IsSearch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IsSearch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchModeState.isSearch()';
}


}




/// @nodoc


class _IsCardSwiper implements SearchModeState {
  const _IsCardSwiper();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IsCardSwiper);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchModeState.isCardSwiper()';
}


}




// dart format on
