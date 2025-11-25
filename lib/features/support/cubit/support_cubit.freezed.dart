// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SupportState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SupportState()';
}


}

/// @nodoc
class $SupportStateCopyWith<$Res>  {
$SupportStateCopyWith(SupportState _, $Res Function(SupportState) __);
}


/// Adds pattern-matching-related methods to [SupportState].
extension SupportStatePatterns on SupportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _MyQuestionsLoaded value)?  myQuestionsLoaded,TResult Function( _QuestionDetail value)?  questionDetail,TResult Function( _QuestionCreated value)?  questionCreated,TResult Function( _StatusUpdated value)?  statusUpdated,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _MyQuestionsLoaded() when myQuestionsLoaded != null:
return myQuestionsLoaded(_that);case _QuestionDetail() when questionDetail != null:
return questionDetail(_that);case _QuestionCreated() when questionCreated != null:
return questionCreated(_that);case _StatusUpdated() when statusUpdated != null:
return statusUpdated(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _MyQuestionsLoaded value)  myQuestionsLoaded,required TResult Function( _QuestionDetail value)  questionDetail,required TResult Function( _QuestionCreated value)  questionCreated,required TResult Function( _StatusUpdated value)  statusUpdated,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _MyQuestionsLoaded():
return myQuestionsLoaded(_that);case _QuestionDetail():
return questionDetail(_that);case _QuestionCreated():
return questionCreated(_that);case _StatusUpdated():
return statusUpdated(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _MyQuestionsLoaded value)?  myQuestionsLoaded,TResult? Function( _QuestionDetail value)?  questionDetail,TResult? Function( _QuestionCreated value)?  questionCreated,TResult? Function( _StatusUpdated value)?  statusUpdated,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _MyQuestionsLoaded() when myQuestionsLoaded != null:
return myQuestionsLoaded(_that);case _QuestionDetail() when questionDetail != null:
return questionDetail(_that);case _QuestionCreated() when questionCreated != null:
return questionCreated(_that);case _StatusUpdated() when statusUpdated != null:
return statusUpdated(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Question> questions)?  myQuestionsLoaded,TResult Function( Question question)?  questionDetail,TResult Function( Question question)?  questionCreated,TResult Function( Question question)?  statusUpdated,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _MyQuestionsLoaded() when myQuestionsLoaded != null:
return myQuestionsLoaded(_that.questions);case _QuestionDetail() when questionDetail != null:
return questionDetail(_that.question);case _QuestionCreated() when questionCreated != null:
return questionCreated(_that.question);case _StatusUpdated() when statusUpdated != null:
return statusUpdated(_that.question);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Question> questions)  myQuestionsLoaded,required TResult Function( Question question)  questionDetail,required TResult Function( Question question)  questionCreated,required TResult Function( Question question)  statusUpdated,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _MyQuestionsLoaded():
return myQuestionsLoaded(_that.questions);case _QuestionDetail():
return questionDetail(_that.question);case _QuestionCreated():
return questionCreated(_that.question);case _StatusUpdated():
return statusUpdated(_that.question);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Question> questions)?  myQuestionsLoaded,TResult? Function( Question question)?  questionDetail,TResult? Function( Question question)?  questionCreated,TResult? Function( Question question)?  statusUpdated,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _MyQuestionsLoaded() when myQuestionsLoaded != null:
return myQuestionsLoaded(_that.questions);case _QuestionDetail() when questionDetail != null:
return questionDetail(_that.question);case _QuestionCreated() when questionCreated != null:
return questionCreated(_that.question);case _StatusUpdated() when statusUpdated != null:
return statusUpdated(_that.question);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements SupportState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SupportState.initial()';
}


}




/// @nodoc


class _Loading implements SupportState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SupportState.loading()';
}


}




/// @nodoc


class _MyQuestionsLoaded implements SupportState {
  const _MyQuestionsLoaded(final  List<Question> questions): _questions = questions;
  

 final  List<Question> _questions;
 List<Question> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyQuestionsLoadedCopyWith<_MyQuestionsLoaded> get copyWith => __$MyQuestionsLoadedCopyWithImpl<_MyQuestionsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyQuestionsLoaded&&const DeepCollectionEquality().equals(other._questions, _questions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'SupportState.myQuestionsLoaded(questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$MyQuestionsLoadedCopyWith<$Res> implements $SupportStateCopyWith<$Res> {
  factory _$MyQuestionsLoadedCopyWith(_MyQuestionsLoaded value, $Res Function(_MyQuestionsLoaded) _then) = __$MyQuestionsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Question> questions
});




}
/// @nodoc
class __$MyQuestionsLoadedCopyWithImpl<$Res>
    implements _$MyQuestionsLoadedCopyWith<$Res> {
  __$MyQuestionsLoadedCopyWithImpl(this._self, this._then);

  final _MyQuestionsLoaded _self;
  final $Res Function(_MyQuestionsLoaded) _then;

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? questions = null,}) {
  return _then(_MyQuestionsLoaded(
null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,
  ));
}


}

/// @nodoc


class _QuestionDetail implements SupportState {
  const _QuestionDetail(this.question);
  

 final  Question question;

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionDetailCopyWith<_QuestionDetail> get copyWith => __$QuestionDetailCopyWithImpl<_QuestionDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionDetail&&(identical(other.question, question) || other.question == question));
}


@override
int get hashCode => Object.hash(runtimeType,question);

@override
String toString() {
  return 'SupportState.questionDetail(question: $question)';
}


}

/// @nodoc
abstract mixin class _$QuestionDetailCopyWith<$Res> implements $SupportStateCopyWith<$Res> {
  factory _$QuestionDetailCopyWith(_QuestionDetail value, $Res Function(_QuestionDetail) _then) = __$QuestionDetailCopyWithImpl;
@useResult
$Res call({
 Question question
});


$QuestionCopyWith<$Res> get question;

}
/// @nodoc
class __$QuestionDetailCopyWithImpl<$Res>
    implements _$QuestionDetailCopyWith<$Res> {
  __$QuestionDetailCopyWithImpl(this._self, this._then);

  final _QuestionDetail _self;
  final $Res Function(_QuestionDetail) _then;

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? question = null,}) {
  return _then(_QuestionDetail(
null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as Question,
  ));
}

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionCopyWith<$Res> get question {
  
  return $QuestionCopyWith<$Res>(_self.question, (value) {
    return _then(_self.copyWith(question: value));
  });
}
}

/// @nodoc


class _QuestionCreated implements SupportState {
  const _QuestionCreated(this.question);
  

 final  Question question;

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCreatedCopyWith<_QuestionCreated> get copyWith => __$QuestionCreatedCopyWithImpl<_QuestionCreated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionCreated&&(identical(other.question, question) || other.question == question));
}


@override
int get hashCode => Object.hash(runtimeType,question);

@override
String toString() {
  return 'SupportState.questionCreated(question: $question)';
}


}

/// @nodoc
abstract mixin class _$QuestionCreatedCopyWith<$Res> implements $SupportStateCopyWith<$Res> {
  factory _$QuestionCreatedCopyWith(_QuestionCreated value, $Res Function(_QuestionCreated) _then) = __$QuestionCreatedCopyWithImpl;
@useResult
$Res call({
 Question question
});


$QuestionCopyWith<$Res> get question;

}
/// @nodoc
class __$QuestionCreatedCopyWithImpl<$Res>
    implements _$QuestionCreatedCopyWith<$Res> {
  __$QuestionCreatedCopyWithImpl(this._self, this._then);

  final _QuestionCreated _self;
  final $Res Function(_QuestionCreated) _then;

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? question = null,}) {
  return _then(_QuestionCreated(
null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as Question,
  ));
}

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionCopyWith<$Res> get question {
  
  return $QuestionCopyWith<$Res>(_self.question, (value) {
    return _then(_self.copyWith(question: value));
  });
}
}

/// @nodoc


class _StatusUpdated implements SupportState {
  const _StatusUpdated(this.question);
  

 final  Question question;

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatusUpdatedCopyWith<_StatusUpdated> get copyWith => __$StatusUpdatedCopyWithImpl<_StatusUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatusUpdated&&(identical(other.question, question) || other.question == question));
}


@override
int get hashCode => Object.hash(runtimeType,question);

@override
String toString() {
  return 'SupportState.statusUpdated(question: $question)';
}


}

/// @nodoc
abstract mixin class _$StatusUpdatedCopyWith<$Res> implements $SupportStateCopyWith<$Res> {
  factory _$StatusUpdatedCopyWith(_StatusUpdated value, $Res Function(_StatusUpdated) _then) = __$StatusUpdatedCopyWithImpl;
@useResult
$Res call({
 Question question
});


$QuestionCopyWith<$Res> get question;

}
/// @nodoc
class __$StatusUpdatedCopyWithImpl<$Res>
    implements _$StatusUpdatedCopyWith<$Res> {
  __$StatusUpdatedCopyWithImpl(this._self, this._then);

  final _StatusUpdated _self;
  final $Res Function(_StatusUpdated) _then;

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? question = null,}) {
  return _then(_StatusUpdated(
null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as Question,
  ));
}

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuestionCopyWith<$Res> get question {
  
  return $QuestionCopyWith<$Res>(_self.question, (value) {
    return _then(_self.copyWith(question: value));
  });
}
}

/// @nodoc


class _Error implements SupportState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of SupportState
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
  return 'SupportState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $SupportStateCopyWith<$Res> {
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

/// Create a copy of SupportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
