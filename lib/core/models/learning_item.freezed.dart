// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LearningItem {

 String get id; String get deckId; String get front; String get back; String? get arabicText; int? get nameNumber;
/// Create a copy of LearningItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LearningItemCopyWith<LearningItem> get copyWith => _$LearningItemCopyWithImpl<LearningItem>(this as LearningItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LearningItem&&(identical(other.id, id) || other.id == id)&&(identical(other.deckId, deckId) || other.deckId == deckId)&&(identical(other.front, front) || other.front == front)&&(identical(other.back, back) || other.back == back)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.nameNumber, nameNumber) || other.nameNumber == nameNumber));
}


@override
int get hashCode => Object.hash(runtimeType,id,deckId,front,back,arabicText,nameNumber);

@override
String toString() {
  return 'LearningItem(id: $id, deckId: $deckId, front: $front, back: $back, arabicText: $arabicText, nameNumber: $nameNumber)';
}


}

/// @nodoc
abstract mixin class $LearningItemCopyWith<$Res>  {
  factory $LearningItemCopyWith(LearningItem value, $Res Function(LearningItem) _then) = _$LearningItemCopyWithImpl;
@useResult
$Res call({
 String id, String deckId, String front, String back, String? arabicText, int? nameNumber
});




}
/// @nodoc
class _$LearningItemCopyWithImpl<$Res>
    implements $LearningItemCopyWith<$Res> {
  _$LearningItemCopyWithImpl(this._self, this._then);

  final LearningItem _self;
  final $Res Function(LearningItem) _then;

/// Create a copy of LearningItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? deckId = null,Object? front = null,Object? back = null,Object? arabicText = freezed,Object? nameNumber = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deckId: null == deckId ? _self.deckId : deckId // ignore: cast_nullable_to_non_nullable
as String,front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as String,back: null == back ? _self.back : back // ignore: cast_nullable_to_non_nullable
as String,arabicText: freezed == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String?,nameNumber: freezed == nameNumber ? _self.nameNumber : nameNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LearningItem].
extension LearningItemPatterns on LearningItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LearningItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LearningItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LearningItem value)  $default,){
final _that = this;
switch (_that) {
case _LearningItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LearningItem value)?  $default,){
final _that = this;
switch (_that) {
case _LearningItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String deckId,  String front,  String back,  String? arabicText,  int? nameNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LearningItem() when $default != null:
return $default(_that.id,_that.deckId,_that.front,_that.back,_that.arabicText,_that.nameNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String deckId,  String front,  String back,  String? arabicText,  int? nameNumber)  $default,) {final _that = this;
switch (_that) {
case _LearningItem():
return $default(_that.id,_that.deckId,_that.front,_that.back,_that.arabicText,_that.nameNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String deckId,  String front,  String back,  String? arabicText,  int? nameNumber)?  $default,) {final _that = this;
switch (_that) {
case _LearningItem() when $default != null:
return $default(_that.id,_that.deckId,_that.front,_that.back,_that.arabicText,_that.nameNumber);case _:
  return null;

}
}

}

/// @nodoc


class _LearningItem implements LearningItem {
  const _LearningItem({required this.id, required this.deckId, required this.front, required this.back, this.arabicText, this.nameNumber});
  

@override final  String id;
@override final  String deckId;
@override final  String front;
@override final  String back;
@override final  String? arabicText;
@override final  int? nameNumber;

/// Create a copy of LearningItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LearningItemCopyWith<_LearningItem> get copyWith => __$LearningItemCopyWithImpl<_LearningItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LearningItem&&(identical(other.id, id) || other.id == id)&&(identical(other.deckId, deckId) || other.deckId == deckId)&&(identical(other.front, front) || other.front == front)&&(identical(other.back, back) || other.back == back)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.nameNumber, nameNumber) || other.nameNumber == nameNumber));
}


@override
int get hashCode => Object.hash(runtimeType,id,deckId,front,back,arabicText,nameNumber);

@override
String toString() {
  return 'LearningItem(id: $id, deckId: $deckId, front: $front, back: $back, arabicText: $arabicText, nameNumber: $nameNumber)';
}


}

/// @nodoc
abstract mixin class _$LearningItemCopyWith<$Res> implements $LearningItemCopyWith<$Res> {
  factory _$LearningItemCopyWith(_LearningItem value, $Res Function(_LearningItem) _then) = __$LearningItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String deckId, String front, String back, String? arabicText, int? nameNumber
});




}
/// @nodoc
class __$LearningItemCopyWithImpl<$Res>
    implements _$LearningItemCopyWith<$Res> {
  __$LearningItemCopyWithImpl(this._self, this._then);

  final _LearningItem _self;
  final $Res Function(_LearningItem) _then;

/// Create a copy of LearningItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? deckId = null,Object? front = null,Object? back = null,Object? arabicText = freezed,Object? nameNumber = freezed,}) {
  return _then(_LearningItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,deckId: null == deckId ? _self.deckId : deckId // ignore: cast_nullable_to_non_nullable
as String,front: null == front ? _self.front : front // ignore: cast_nullable_to_non_nullable
as String,back: null == back ? _self.back : back // ignore: cast_nullable_to_non_nullable
as String,arabicText: freezed == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String?,nameNumber: freezed == nameNumber ? _self.nameNumber : nameNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
