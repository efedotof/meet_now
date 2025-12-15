// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContentState {

 bool get isLoading; ContentType get currentContentType; String get searchQuery; int get currentPage; int get totalPages; String? get error; List<City>? get cities; List<IcebreakerTopec>? get icebreakers; List<Interest>? get interests; List<Purpose>? get purposes; List<StickerPack>? get stickerPacks; List<Sticker>? get stickers; List<ChatGame>? get games; List<AdminGiftDto>? get gifts; List<AdminGiftRarityDto>? get giftRarities; String? get selectedPackId; String? get gameTypeFilter;
/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentStateCopyWith<ContentState> get copyWith => _$ContentStateCopyWithImpl<ContentState>(this as ContentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.currentContentType, currentContentType) || other.currentContentType == currentContentType)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.cities, cities)&&const DeepCollectionEquality().equals(other.icebreakers, icebreakers)&&const DeepCollectionEquality().equals(other.interests, interests)&&const DeepCollectionEquality().equals(other.purposes, purposes)&&const DeepCollectionEquality().equals(other.stickerPacks, stickerPacks)&&const DeepCollectionEquality().equals(other.stickers, stickers)&&const DeepCollectionEquality().equals(other.games, games)&&const DeepCollectionEquality().equals(other.gifts, gifts)&&const DeepCollectionEquality().equals(other.giftRarities, giftRarities)&&(identical(other.selectedPackId, selectedPackId) || other.selectedPackId == selectedPackId)&&(identical(other.gameTypeFilter, gameTypeFilter) || other.gameTypeFilter == gameTypeFilter));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,currentContentType,searchQuery,currentPage,totalPages,error,const DeepCollectionEquality().hash(cities),const DeepCollectionEquality().hash(icebreakers),const DeepCollectionEquality().hash(interests),const DeepCollectionEquality().hash(purposes),const DeepCollectionEquality().hash(stickerPacks),const DeepCollectionEquality().hash(stickers),const DeepCollectionEquality().hash(games),const DeepCollectionEquality().hash(gifts),const DeepCollectionEquality().hash(giftRarities),selectedPackId,gameTypeFilter);

@override
String toString() {
  return 'ContentState(isLoading: $isLoading, currentContentType: $currentContentType, searchQuery: $searchQuery, currentPage: $currentPage, totalPages: $totalPages, error: $error, cities: $cities, icebreakers: $icebreakers, interests: $interests, purposes: $purposes, stickerPacks: $stickerPacks, stickers: $stickers, games: $games, gifts: $gifts, giftRarities: $giftRarities, selectedPackId: $selectedPackId, gameTypeFilter: $gameTypeFilter)';
}


}

/// @nodoc
abstract mixin class $ContentStateCopyWith<$Res>  {
  factory $ContentStateCopyWith(ContentState value, $Res Function(ContentState) _then) = _$ContentStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, ContentType currentContentType, String searchQuery, int currentPage, int totalPages, String? error, List<City>? cities, List<IcebreakerTopec>? icebreakers, List<Interest>? interests, List<Purpose>? purposes, List<StickerPack>? stickerPacks, List<Sticker>? stickers, List<ChatGame>? games, List<AdminGiftDto>? gifts, List<AdminGiftRarityDto>? giftRarities, String? selectedPackId, String? gameTypeFilter
});




}
/// @nodoc
class _$ContentStateCopyWithImpl<$Res>
    implements $ContentStateCopyWith<$Res> {
  _$ContentStateCopyWithImpl(this._self, this._then);

  final ContentState _self;
  final $Res Function(ContentState) _then;

/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? currentContentType = null,Object? searchQuery = null,Object? currentPage = null,Object? totalPages = null,Object? error = freezed,Object? cities = freezed,Object? icebreakers = freezed,Object? interests = freezed,Object? purposes = freezed,Object? stickerPacks = freezed,Object? stickers = freezed,Object? games = freezed,Object? gifts = freezed,Object? giftRarities = freezed,Object? selectedPackId = freezed,Object? gameTypeFilter = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,currentContentType: null == currentContentType ? _self.currentContentType : currentContentType // ignore: cast_nullable_to_non_nullable
as ContentType,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,cities: freezed == cities ? _self.cities : cities // ignore: cast_nullable_to_non_nullable
as List<City>?,icebreakers: freezed == icebreakers ? _self.icebreakers : icebreakers // ignore: cast_nullable_to_non_nullable
as List<IcebreakerTopec>?,interests: freezed == interests ? _self.interests : interests // ignore: cast_nullable_to_non_nullable
as List<Interest>?,purposes: freezed == purposes ? _self.purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<Purpose>?,stickerPacks: freezed == stickerPacks ? _self.stickerPacks : stickerPacks // ignore: cast_nullable_to_non_nullable
as List<StickerPack>?,stickers: freezed == stickers ? _self.stickers : stickers // ignore: cast_nullable_to_non_nullable
as List<Sticker>?,games: freezed == games ? _self.games : games // ignore: cast_nullable_to_non_nullable
as List<ChatGame>?,gifts: freezed == gifts ? _self.gifts : gifts // ignore: cast_nullable_to_non_nullable
as List<AdminGiftDto>?,giftRarities: freezed == giftRarities ? _self.giftRarities : giftRarities // ignore: cast_nullable_to_non_nullable
as List<AdminGiftRarityDto>?,selectedPackId: freezed == selectedPackId ? _self.selectedPackId : selectedPackId // ignore: cast_nullable_to_non_nullable
as String?,gameTypeFilter: freezed == gameTypeFilter ? _self.gameTypeFilter : gameTypeFilter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentState].
extension ContentStatePatterns on ContentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentState value)  $default,){
final _that = this;
switch (_that) {
case _ContentState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentState value)?  $default,){
final _that = this;
switch (_that) {
case _ContentState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  ContentType currentContentType,  String searchQuery,  int currentPage,  int totalPages,  String? error,  List<City>? cities,  List<IcebreakerTopec>? icebreakers,  List<Interest>? interests,  List<Purpose>? purposes,  List<StickerPack>? stickerPacks,  List<Sticker>? stickers,  List<ChatGame>? games,  List<AdminGiftDto>? gifts,  List<AdminGiftRarityDto>? giftRarities,  String? selectedPackId,  String? gameTypeFilter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentState() when $default != null:
return $default(_that.isLoading,_that.currentContentType,_that.searchQuery,_that.currentPage,_that.totalPages,_that.error,_that.cities,_that.icebreakers,_that.interests,_that.purposes,_that.stickerPacks,_that.stickers,_that.games,_that.gifts,_that.giftRarities,_that.selectedPackId,_that.gameTypeFilter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  ContentType currentContentType,  String searchQuery,  int currentPage,  int totalPages,  String? error,  List<City>? cities,  List<IcebreakerTopec>? icebreakers,  List<Interest>? interests,  List<Purpose>? purposes,  List<StickerPack>? stickerPacks,  List<Sticker>? stickers,  List<ChatGame>? games,  List<AdminGiftDto>? gifts,  List<AdminGiftRarityDto>? giftRarities,  String? selectedPackId,  String? gameTypeFilter)  $default,) {final _that = this;
switch (_that) {
case _ContentState():
return $default(_that.isLoading,_that.currentContentType,_that.searchQuery,_that.currentPage,_that.totalPages,_that.error,_that.cities,_that.icebreakers,_that.interests,_that.purposes,_that.stickerPacks,_that.stickers,_that.games,_that.gifts,_that.giftRarities,_that.selectedPackId,_that.gameTypeFilter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  ContentType currentContentType,  String searchQuery,  int currentPage,  int totalPages,  String? error,  List<City>? cities,  List<IcebreakerTopec>? icebreakers,  List<Interest>? interests,  List<Purpose>? purposes,  List<StickerPack>? stickerPacks,  List<Sticker>? stickers,  List<ChatGame>? games,  List<AdminGiftDto>? gifts,  List<AdminGiftRarityDto>? giftRarities,  String? selectedPackId,  String? gameTypeFilter)?  $default,) {final _that = this;
switch (_that) {
case _ContentState() when $default != null:
return $default(_that.isLoading,_that.currentContentType,_that.searchQuery,_that.currentPage,_that.totalPages,_that.error,_that.cities,_that.icebreakers,_that.interests,_that.purposes,_that.stickerPacks,_that.stickers,_that.games,_that.gifts,_that.giftRarities,_that.selectedPackId,_that.gameTypeFilter);case _:
  return null;

}
}

}

/// @nodoc


class _ContentState implements ContentState {
  const _ContentState({required this.isLoading, required this.currentContentType, required this.searchQuery, required this.currentPage, required this.totalPages, this.error, final  List<City>? cities, final  List<IcebreakerTopec>? icebreakers, final  List<Interest>? interests, final  List<Purpose>? purposes, final  List<StickerPack>? stickerPacks, final  List<Sticker>? stickers, final  List<ChatGame>? games, final  List<AdminGiftDto>? gifts, final  List<AdminGiftRarityDto>? giftRarities, this.selectedPackId, this.gameTypeFilter}): _cities = cities,_icebreakers = icebreakers,_interests = interests,_purposes = purposes,_stickerPacks = stickerPacks,_stickers = stickers,_games = games,_gifts = gifts,_giftRarities = giftRarities;
  

@override final  bool isLoading;
@override final  ContentType currentContentType;
@override final  String searchQuery;
@override final  int currentPage;
@override final  int totalPages;
@override final  String? error;
 final  List<City>? _cities;
@override List<City>? get cities {
  final value = _cities;
  if (value == null) return null;
  if (_cities is EqualUnmodifiableListView) return _cities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<IcebreakerTopec>? _icebreakers;
@override List<IcebreakerTopec>? get icebreakers {
  final value = _icebreakers;
  if (value == null) return null;
  if (_icebreakers is EqualUnmodifiableListView) return _icebreakers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Interest>? _interests;
@override List<Interest>? get interests {
  final value = _interests;
  if (value == null) return null;
  if (_interests is EqualUnmodifiableListView) return _interests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Purpose>? _purposes;
@override List<Purpose>? get purposes {
  final value = _purposes;
  if (value == null) return null;
  if (_purposes is EqualUnmodifiableListView) return _purposes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<StickerPack>? _stickerPacks;
@override List<StickerPack>? get stickerPacks {
  final value = _stickerPacks;
  if (value == null) return null;
  if (_stickerPacks is EqualUnmodifiableListView) return _stickerPacks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Sticker>? _stickers;
@override List<Sticker>? get stickers {
  final value = _stickers;
  if (value == null) return null;
  if (_stickers is EqualUnmodifiableListView) return _stickers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ChatGame>? _games;
@override List<ChatGame>? get games {
  final value = _games;
  if (value == null) return null;
  if (_games is EqualUnmodifiableListView) return _games;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AdminGiftDto>? _gifts;
@override List<AdminGiftDto>? get gifts {
  final value = _gifts;
  if (value == null) return null;
  if (_gifts is EqualUnmodifiableListView) return _gifts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AdminGiftRarityDto>? _giftRarities;
@override List<AdminGiftRarityDto>? get giftRarities {
  final value = _giftRarities;
  if (value == null) return null;
  if (_giftRarities is EqualUnmodifiableListView) return _giftRarities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? selectedPackId;
@override final  String? gameTypeFilter;

/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentStateCopyWith<_ContentState> get copyWith => __$ContentStateCopyWithImpl<_ContentState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.currentContentType, currentContentType) || other.currentContentType == currentContentType)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other._cities, _cities)&&const DeepCollectionEquality().equals(other._icebreakers, _icebreakers)&&const DeepCollectionEquality().equals(other._interests, _interests)&&const DeepCollectionEquality().equals(other._purposes, _purposes)&&const DeepCollectionEquality().equals(other._stickerPacks, _stickerPacks)&&const DeepCollectionEquality().equals(other._stickers, _stickers)&&const DeepCollectionEquality().equals(other._games, _games)&&const DeepCollectionEquality().equals(other._gifts, _gifts)&&const DeepCollectionEquality().equals(other._giftRarities, _giftRarities)&&(identical(other.selectedPackId, selectedPackId) || other.selectedPackId == selectedPackId)&&(identical(other.gameTypeFilter, gameTypeFilter) || other.gameTypeFilter == gameTypeFilter));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,currentContentType,searchQuery,currentPage,totalPages,error,const DeepCollectionEquality().hash(_cities),const DeepCollectionEquality().hash(_icebreakers),const DeepCollectionEquality().hash(_interests),const DeepCollectionEquality().hash(_purposes),const DeepCollectionEquality().hash(_stickerPacks),const DeepCollectionEquality().hash(_stickers),const DeepCollectionEquality().hash(_games),const DeepCollectionEquality().hash(_gifts),const DeepCollectionEquality().hash(_giftRarities),selectedPackId,gameTypeFilter);

@override
String toString() {
  return 'ContentState(isLoading: $isLoading, currentContentType: $currentContentType, searchQuery: $searchQuery, currentPage: $currentPage, totalPages: $totalPages, error: $error, cities: $cities, icebreakers: $icebreakers, interests: $interests, purposes: $purposes, stickerPacks: $stickerPacks, stickers: $stickers, games: $games, gifts: $gifts, giftRarities: $giftRarities, selectedPackId: $selectedPackId, gameTypeFilter: $gameTypeFilter)';
}


}

/// @nodoc
abstract mixin class _$ContentStateCopyWith<$Res> implements $ContentStateCopyWith<$Res> {
  factory _$ContentStateCopyWith(_ContentState value, $Res Function(_ContentState) _then) = __$ContentStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, ContentType currentContentType, String searchQuery, int currentPage, int totalPages, String? error, List<City>? cities, List<IcebreakerTopec>? icebreakers, List<Interest>? interests, List<Purpose>? purposes, List<StickerPack>? stickerPacks, List<Sticker>? stickers, List<ChatGame>? games, List<AdminGiftDto>? gifts, List<AdminGiftRarityDto>? giftRarities, String? selectedPackId, String? gameTypeFilter
});




}
/// @nodoc
class __$ContentStateCopyWithImpl<$Res>
    implements _$ContentStateCopyWith<$Res> {
  __$ContentStateCopyWithImpl(this._self, this._then);

  final _ContentState _self;
  final $Res Function(_ContentState) _then;

/// Create a copy of ContentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? currentContentType = null,Object? searchQuery = null,Object? currentPage = null,Object? totalPages = null,Object? error = freezed,Object? cities = freezed,Object? icebreakers = freezed,Object? interests = freezed,Object? purposes = freezed,Object? stickerPacks = freezed,Object? stickers = freezed,Object? games = freezed,Object? gifts = freezed,Object? giftRarities = freezed,Object? selectedPackId = freezed,Object? gameTypeFilter = freezed,}) {
  return _then(_ContentState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,currentContentType: null == currentContentType ? _self.currentContentType : currentContentType // ignore: cast_nullable_to_non_nullable
as ContentType,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,cities: freezed == cities ? _self._cities : cities // ignore: cast_nullable_to_non_nullable
as List<City>?,icebreakers: freezed == icebreakers ? _self._icebreakers : icebreakers // ignore: cast_nullable_to_non_nullable
as List<IcebreakerTopec>?,interests: freezed == interests ? _self._interests : interests // ignore: cast_nullable_to_non_nullable
as List<Interest>?,purposes: freezed == purposes ? _self._purposes : purposes // ignore: cast_nullable_to_non_nullable
as List<Purpose>?,stickerPacks: freezed == stickerPacks ? _self._stickerPacks : stickerPacks // ignore: cast_nullable_to_non_nullable
as List<StickerPack>?,stickers: freezed == stickers ? _self._stickers : stickers // ignore: cast_nullable_to_non_nullable
as List<Sticker>?,games: freezed == games ? _self._games : games // ignore: cast_nullable_to_non_nullable
as List<ChatGame>?,gifts: freezed == gifts ? _self._gifts : gifts // ignore: cast_nullable_to_non_nullable
as List<AdminGiftDto>?,giftRarities: freezed == giftRarities ? _self._giftRarities : giftRarities // ignore: cast_nullable_to_non_nullable
as List<AdminGiftRarityDto>?,selectedPackId: freezed == selectedPackId ? _self.selectedPackId : selectedPackId // ignore: cast_nullable_to_non_nullable
as String?,gameTypeFilter: freezed == gameTypeFilter ? _self.gameTypeFilter : gameTypeFilter // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
