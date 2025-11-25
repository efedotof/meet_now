// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gift_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GiftState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GiftState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GiftState()';
}


}

/// @nodoc
class $GiftStateCopyWith<$Res>  {
$GiftStateCopyWith(GiftState _, $Res Function(GiftState) __);
}


/// Adds pattern-matching-related methods to [GiftState].
extension GiftStatePatterns on GiftState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Gift> gifts,  List<UserInventory> inventory,  bool isDailyGiftAvailable,  int currentStreak,  GiftStats giftStats,  Gift? lastClaimedGift)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.gifts,_that.inventory,_that.isDailyGiftAvailable,_that.currentStreak,_that.giftStats,_that.lastClaimedGift);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Gift> gifts,  List<UserInventory> inventory,  bool isDailyGiftAvailable,  int currentStreak,  GiftStats giftStats,  Gift? lastClaimedGift)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.gifts,_that.inventory,_that.isDailyGiftAvailable,_that.currentStreak,_that.giftStats,_that.lastClaimedGift);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Gift> gifts,  List<UserInventory> inventory,  bool isDailyGiftAvailable,  int currentStreak,  GiftStats giftStats,  Gift? lastClaimedGift)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.gifts,_that.inventory,_that.isDailyGiftAvailable,_that.currentStreak,_that.giftStats,_that.lastClaimedGift);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements GiftState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GiftState.initial()';
}


}




/// @nodoc


class _Loading implements GiftState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GiftState.loading()';
}


}




/// @nodoc


class _Loaded implements GiftState {
  const _Loaded({required final  List<Gift> gifts, required final  List<UserInventory> inventory, required this.isDailyGiftAvailable, required this.currentStreak, required this.giftStats, this.lastClaimedGift}): _gifts = gifts,_inventory = inventory;
  

 final  List<Gift> _gifts;
 List<Gift> get gifts {
  if (_gifts is EqualUnmodifiableListView) return _gifts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gifts);
}

 final  List<UserInventory> _inventory;
 List<UserInventory> get inventory {
  if (_inventory is EqualUnmodifiableListView) return _inventory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inventory);
}

 final  bool isDailyGiftAvailable;
 final  int currentStreak;
 final  GiftStats giftStats;
 final  Gift? lastClaimedGift;

/// Create a copy of GiftState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._gifts, _gifts)&&const DeepCollectionEquality().equals(other._inventory, _inventory)&&(identical(other.isDailyGiftAvailable, isDailyGiftAvailable) || other.isDailyGiftAvailable == isDailyGiftAvailable)&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.giftStats, giftStats) || other.giftStats == giftStats)&&(identical(other.lastClaimedGift, lastClaimedGift) || other.lastClaimedGift == lastClaimedGift));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_gifts),const DeepCollectionEquality().hash(_inventory),isDailyGiftAvailable,currentStreak,giftStats,lastClaimedGift);

@override
String toString() {
  return 'GiftState.loaded(gifts: $gifts, inventory: $inventory, isDailyGiftAvailable: $isDailyGiftAvailable, currentStreak: $currentStreak, giftStats: $giftStats, lastClaimedGift: $lastClaimedGift)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $GiftStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<Gift> gifts, List<UserInventory> inventory, bool isDailyGiftAvailable, int currentStreak, GiftStats giftStats, Gift? lastClaimedGift
});


$GiftStatsCopyWith<$Res> get giftStats;$GiftCopyWith<$Res>? get lastClaimedGift;

}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of GiftState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? gifts = null,Object? inventory = null,Object? isDailyGiftAvailable = null,Object? currentStreak = null,Object? giftStats = null,Object? lastClaimedGift = freezed,}) {
  return _then(_Loaded(
gifts: null == gifts ? _self._gifts : gifts // ignore: cast_nullable_to_non_nullable
as List<Gift>,inventory: null == inventory ? _self._inventory : inventory // ignore: cast_nullable_to_non_nullable
as List<UserInventory>,isDailyGiftAvailable: null == isDailyGiftAvailable ? _self.isDailyGiftAvailable : isDailyGiftAvailable // ignore: cast_nullable_to_non_nullable
as bool,currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,giftStats: null == giftStats ? _self.giftStats : giftStats // ignore: cast_nullable_to_non_nullable
as GiftStats,lastClaimedGift: freezed == lastClaimedGift ? _self.lastClaimedGift : lastClaimedGift // ignore: cast_nullable_to_non_nullable
as Gift?,
  ));
}

/// Create a copy of GiftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GiftStatsCopyWith<$Res> get giftStats {
  
  return $GiftStatsCopyWith<$Res>(_self.giftStats, (value) {
    return _then(_self.copyWith(giftStats: value));
  });
}/// Create a copy of GiftState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GiftCopyWith<$Res>? get lastClaimedGift {
    if (_self.lastClaimedGift == null) {
    return null;
  }

  return $GiftCopyWith<$Res>(_self.lastClaimedGift!, (value) {
    return _then(_self.copyWith(lastClaimedGift: value));
  });
}
}

/// @nodoc


class _Error implements GiftState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of GiftState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'GiftState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $GiftStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of GiftState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
