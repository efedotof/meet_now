// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_selection_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaSelectionState {

 List<MediaItem> get selectedMedia; bool get isPickerOpen;
/// Create a copy of MediaSelectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaSelectionStateCopyWith<MediaSelectionState> get copyWith => _$MediaSelectionStateCopyWithImpl<MediaSelectionState>(this as MediaSelectionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaSelectionState&&const DeepCollectionEquality().equals(other.selectedMedia, selectedMedia)&&(identical(other.isPickerOpen, isPickerOpen) || other.isPickerOpen == isPickerOpen));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(selectedMedia),isPickerOpen);

@override
String toString() {
  return 'MediaSelectionState(selectedMedia: $selectedMedia, isPickerOpen: $isPickerOpen)';
}


}

/// @nodoc
abstract mixin class $MediaSelectionStateCopyWith<$Res>  {
  factory $MediaSelectionStateCopyWith(MediaSelectionState value, $Res Function(MediaSelectionState) _then) = _$MediaSelectionStateCopyWithImpl;
@useResult
$Res call({
 List<MediaItem> selectedMedia, bool isPickerOpen
});




}
/// @nodoc
class _$MediaSelectionStateCopyWithImpl<$Res>
    implements $MediaSelectionStateCopyWith<$Res> {
  _$MediaSelectionStateCopyWithImpl(this._self, this._then);

  final MediaSelectionState _self;
  final $Res Function(MediaSelectionState) _then;

/// Create a copy of MediaSelectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedMedia = null,Object? isPickerOpen = null,}) {
  return _then(_self.copyWith(
selectedMedia: null == selectedMedia ? _self.selectedMedia : selectedMedia // ignore: cast_nullable_to_non_nullable
as List<MediaItem>,isPickerOpen: null == isPickerOpen ? _self.isPickerOpen : isPickerOpen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaSelectionState].
extension MediaSelectionStatePatterns on MediaSelectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaSelectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaSelectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaSelectionState value)  $default,){
final _that = this;
switch (_that) {
case _MediaSelectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaSelectionState value)?  $default,){
final _that = this;
switch (_that) {
case _MediaSelectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MediaItem> selectedMedia,  bool isPickerOpen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaSelectionState() when $default != null:
return $default(_that.selectedMedia,_that.isPickerOpen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MediaItem> selectedMedia,  bool isPickerOpen)  $default,) {final _that = this;
switch (_that) {
case _MediaSelectionState():
return $default(_that.selectedMedia,_that.isPickerOpen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MediaItem> selectedMedia,  bool isPickerOpen)?  $default,) {final _that = this;
switch (_that) {
case _MediaSelectionState() when $default != null:
return $default(_that.selectedMedia,_that.isPickerOpen);case _:
  return null;

}
}

}

/// @nodoc


class _MediaSelectionState implements MediaSelectionState {
  const _MediaSelectionState({required final  List<MediaItem> selectedMedia, this.isPickerOpen = false}): _selectedMedia = selectedMedia;
  

 final  List<MediaItem> _selectedMedia;
@override List<MediaItem> get selectedMedia {
  if (_selectedMedia is EqualUnmodifiableListView) return _selectedMedia;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedMedia);
}

@override@JsonKey() final  bool isPickerOpen;

/// Create a copy of MediaSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaSelectionStateCopyWith<_MediaSelectionState> get copyWith => __$MediaSelectionStateCopyWithImpl<_MediaSelectionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaSelectionState&&const DeepCollectionEquality().equals(other._selectedMedia, _selectedMedia)&&(identical(other.isPickerOpen, isPickerOpen) || other.isPickerOpen == isPickerOpen));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_selectedMedia),isPickerOpen);

@override
String toString() {
  return 'MediaSelectionState(selectedMedia: $selectedMedia, isPickerOpen: $isPickerOpen)';
}


}

/// @nodoc
abstract mixin class _$MediaSelectionStateCopyWith<$Res> implements $MediaSelectionStateCopyWith<$Res> {
  factory _$MediaSelectionStateCopyWith(_MediaSelectionState value, $Res Function(_MediaSelectionState) _then) = __$MediaSelectionStateCopyWithImpl;
@override @useResult
$Res call({
 List<MediaItem> selectedMedia, bool isPickerOpen
});




}
/// @nodoc
class __$MediaSelectionStateCopyWithImpl<$Res>
    implements _$MediaSelectionStateCopyWith<$Res> {
  __$MediaSelectionStateCopyWithImpl(this._self, this._then);

  final _MediaSelectionState _self;
  final $Res Function(_MediaSelectionState) _then;

/// Create a copy of MediaSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedMedia = null,Object? isPickerOpen = null,}) {
  return _then(_MediaSelectionState(
selectedMedia: null == selectedMedia ? _self._selectedMedia : selectedMedia // ignore: cast_nullable_to_non_nullable
as List<MediaItem>,isPickerOpen: null == isPickerOpen ? _self.isPickerOpen : isPickerOpen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
