// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tafakkur_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TafakkurState {

 List<String> get phrases; int get currentIndex; bool get isPaused; bool get isComplete; int get paceSeconds;// 6 | 9 | 12
 int get elapsedSeconds;
/// Create a copy of TafakkurState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TafakkurStateCopyWith<TafakkurState> get copyWith => _$TafakkurStateCopyWithImpl<TafakkurState>(this as TafakkurState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TafakkurState&&const DeepCollectionEquality().equals(other.phrases, phrases)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.paceSeconds, paceSeconds) || other.paceSeconds == paceSeconds)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(phrases),currentIndex,isPaused,isComplete,paceSeconds,elapsedSeconds);

@override
String toString() {
  return 'TafakkurState(phrases: $phrases, currentIndex: $currentIndex, isPaused: $isPaused, isComplete: $isComplete, paceSeconds: $paceSeconds, elapsedSeconds: $elapsedSeconds)';
}


}

/// @nodoc
abstract mixin class $TafakkurStateCopyWith<$Res>  {
  factory $TafakkurStateCopyWith(TafakkurState value, $Res Function(TafakkurState) _then) = _$TafakkurStateCopyWithImpl;
@useResult
$Res call({
 List<String> phrases, int currentIndex, bool isPaused, bool isComplete, int paceSeconds, int elapsedSeconds
});




}
/// @nodoc
class _$TafakkurStateCopyWithImpl<$Res>
    implements $TafakkurStateCopyWith<$Res> {
  _$TafakkurStateCopyWithImpl(this._self, this._then);

  final TafakkurState _self;
  final $Res Function(TafakkurState) _then;

/// Create a copy of TafakkurState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phrases = null,Object? currentIndex = null,Object? isPaused = null,Object? isComplete = null,Object? paceSeconds = null,Object? elapsedSeconds = null,}) {
  return _then(_self.copyWith(
phrases: null == phrases ? _self.phrases : phrases // ignore: cast_nullable_to_non_nullable
as List<String>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,paceSeconds: null == paceSeconds ? _self.paceSeconds : paceSeconds // ignore: cast_nullable_to_non_nullable
as int,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TafakkurState].
extension TafakkurStatePatterns on TafakkurState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TafakkurState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TafakkurState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TafakkurState value)  $default,){
final _that = this;
switch (_that) {
case _TafakkurState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TafakkurState value)?  $default,){
final _that = this;
switch (_that) {
case _TafakkurState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> phrases,  int currentIndex,  bool isPaused,  bool isComplete,  int paceSeconds,  int elapsedSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TafakkurState() when $default != null:
return $default(_that.phrases,_that.currentIndex,_that.isPaused,_that.isComplete,_that.paceSeconds,_that.elapsedSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> phrases,  int currentIndex,  bool isPaused,  bool isComplete,  int paceSeconds,  int elapsedSeconds)  $default,) {final _that = this;
switch (_that) {
case _TafakkurState():
return $default(_that.phrases,_that.currentIndex,_that.isPaused,_that.isComplete,_that.paceSeconds,_that.elapsedSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> phrases,  int currentIndex,  bool isPaused,  bool isComplete,  int paceSeconds,  int elapsedSeconds)?  $default,) {final _that = this;
switch (_that) {
case _TafakkurState() when $default != null:
return $default(_that.phrases,_that.currentIndex,_that.isPaused,_that.isComplete,_that.paceSeconds,_that.elapsedSeconds);case _:
  return null;

}
}

}

/// @nodoc


class _TafakkurState extends TafakkurState {
  const _TafakkurState({required final  List<String> phrases, this.currentIndex = 0, this.isPaused = false, this.isComplete = false, this.paceSeconds = 9, this.elapsedSeconds = 0}): _phrases = phrases,super._();
  

 final  List<String> _phrases;
@override List<String> get phrases {
  if (_phrases is EqualUnmodifiableListView) return _phrases;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_phrases);
}

@override@JsonKey() final  int currentIndex;
@override@JsonKey() final  bool isPaused;
@override@JsonKey() final  bool isComplete;
@override@JsonKey() final  int paceSeconds;
// 6 | 9 | 12
@override@JsonKey() final  int elapsedSeconds;

/// Create a copy of TafakkurState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TafakkurStateCopyWith<_TafakkurState> get copyWith => __$TafakkurStateCopyWithImpl<_TafakkurState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TafakkurState&&const DeepCollectionEquality().equals(other._phrases, _phrases)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.paceSeconds, paceSeconds) || other.paceSeconds == paceSeconds)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_phrases),currentIndex,isPaused,isComplete,paceSeconds,elapsedSeconds);

@override
String toString() {
  return 'TafakkurState(phrases: $phrases, currentIndex: $currentIndex, isPaused: $isPaused, isComplete: $isComplete, paceSeconds: $paceSeconds, elapsedSeconds: $elapsedSeconds)';
}


}

/// @nodoc
abstract mixin class _$TafakkurStateCopyWith<$Res> implements $TafakkurStateCopyWith<$Res> {
  factory _$TafakkurStateCopyWith(_TafakkurState value, $Res Function(_TafakkurState) _then) = __$TafakkurStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> phrases, int currentIndex, bool isPaused, bool isComplete, int paceSeconds, int elapsedSeconds
});




}
/// @nodoc
class __$TafakkurStateCopyWithImpl<$Res>
    implements _$TafakkurStateCopyWith<$Res> {
  __$TafakkurStateCopyWithImpl(this._self, this._then);

  final _TafakkurState _self;
  final $Res Function(_TafakkurState) _then;

/// Create a copy of TafakkurState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phrases = null,Object? currentIndex = null,Object? isPaused = null,Object? isComplete = null,Object? paceSeconds = null,Object? elapsedSeconds = null,}) {
  return _then(_TafakkurState(
phrases: null == phrases ? _self._phrases : phrases // ignore: cast_nullable_to_non_nullable
as List<String>,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,paceSeconds: null == paceSeconds ? _self.paceSeconds : paceSeconds // ignore: cast_nullable_to_non_nullable
as int,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
