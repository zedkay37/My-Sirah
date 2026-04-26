// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_deck.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LearningDeck {

 String get id; String get titleFr; String get titleAr; IconData get icon; int get itemCount;
/// Create a copy of LearningDeck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearningDeckCopyWith<LearningDeck> get copyWith => _$LearningDeckCopyWithImpl<LearningDeck>(this as LearningDeck, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningDeck&&(identical(other.id, id) || other.id == id)&&(identical(other.titleFr, titleFr) || other.titleFr == titleFr)&&(identical(other.titleAr, titleAr) || other.titleAr == titleAr)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,titleFr,titleAr,icon,itemCount);

@override
String toString() {
  return 'LearningDeck(id: $id, titleFr: $titleFr, titleAr: $titleAr, icon: $icon, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class $LearningDeckCopyWith<$Res>  {
  factory $LearningDeckCopyWith(LearningDeck value, $Res Function(LearningDeck) _then) = _$LearningDeckCopyWithImpl;
@useResult
$Res call({
 String id, String titleFr, String titleAr, IconData icon, int itemCount
});




}
/// @nodoc
class _$LearningDeckCopyWithImpl<$Res>
    implements $LearningDeckCopyWith<$Res> {
  _$LearningDeckCopyWithImpl(this._self, this._then);

  final LearningDeck _self;
  final $Res Function(LearningDeck) _then;

/// Create a copy of LearningDeck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titleFr = null,Object? titleAr = null,Object? icon = null,Object? itemCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleFr: null == titleFr ? _self.titleFr : titleFr // ignore: cast_nullable_to_non_nullable
as String,titleAr: null == titleAr ? _self.titleAr : titleAr // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LearningDeck].
extension LearningDeckPatterns on LearningDeck {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearningDeck value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearningDeck() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearningDeck value)  $default,){
final _that = this;
switch (_that) {
case _LearningDeck():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearningDeck value)?  $default,){
final _that = this;
switch (_that) {
case _LearningDeck() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String titleFr,  String titleAr,  IconData icon,  int itemCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearningDeck() when $default != null:
return $default(_that.id,_that.titleFr,_that.titleAr,_that.icon,_that.itemCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String titleFr,  String titleAr,  IconData icon,  int itemCount)  $default,) {final _that = this;
switch (_that) {
case _LearningDeck():
return $default(_that.id,_that.titleFr,_that.titleAr,_that.icon,_that.itemCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String titleFr,  String titleAr,  IconData icon,  int itemCount)?  $default,) {final _that = this;
switch (_that) {
case _LearningDeck() when $default != null:
return $default(_that.id,_that.titleFr,_that.titleAr,_that.icon,_that.itemCount);case _:
  return null;

}
}

}

/// @nodoc


class _LearningDeck implements LearningDeck {
  const _LearningDeck({required this.id, required this.titleFr, required this.titleAr, required this.icon, required this.itemCount});
  

@override final  String id;
@override final  String titleFr;
@override final  String titleAr;
@override final  IconData icon;
@override final  int itemCount;

/// Create a copy of LearningDeck
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningDeckCopyWith<_LearningDeck> get copyWith => __$LearningDeckCopyWithImpl<_LearningDeck>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningDeck&&(identical(other.id, id) || other.id == id)&&(identical(other.titleFr, titleFr) || other.titleFr == titleFr)&&(identical(other.titleAr, titleAr) || other.titleAr == titleAr)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,titleFr,titleAr,icon,itemCount);

@override
String toString() {
  return 'LearningDeck(id: $id, titleFr: $titleFr, titleAr: $titleAr, icon: $icon, itemCount: $itemCount)';
}


}

/// @nodoc
abstract mixin class _$LearningDeckCopyWith<$Res> implements $LearningDeckCopyWith<$Res> {
  factory _$LearningDeckCopyWith(_LearningDeck value, $Res Function(_LearningDeck) _then) = __$LearningDeckCopyWithImpl;
@override @useResult
$Res call({
 String id, String titleFr, String titleAr, IconData icon, int itemCount
});




}
/// @nodoc
class __$LearningDeckCopyWithImpl<$Res>
    implements _$LearningDeckCopyWith<$Res> {
  __$LearningDeckCopyWithImpl(this._self, this._then);

  final _LearningDeck _self;
  final $Res Function(_LearningDeck) _then;

/// Create a copy of LearningDeck
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titleFr = null,Object? titleAr = null,Object? icon = null,Object? itemCount = null,}) {
  return _then(_LearningDeck(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleFr: null == titleFr ? _self.titleFr : titleFr // ignore: cast_nullable_to_non_nullable
as String,titleAr: null == titleAr ? _self.titleAr : titleAr // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
