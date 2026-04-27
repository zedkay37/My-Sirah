// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'husna_name.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HusnaName {

 int get id; String get arabic; String get transliteration; String get meaningFr; String get etymology; String get reference;
/// Create a copy of HusnaName
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HusnaNameCopyWith<HusnaName> get copyWith => _$HusnaNameCopyWithImpl<HusnaName>(this as HusnaName, _$identity);

  /// Serializes this HusnaName to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HusnaName&&(identical(other.id, id) || other.id == id)&&(identical(other.arabic, arabic) || other.arabic == arabic)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.meaningFr, meaningFr) || other.meaningFr == meaningFr)&&(identical(other.etymology, etymology) || other.etymology == etymology)&&(identical(other.reference, reference) || other.reference == reference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,arabic,transliteration,meaningFr,etymology,reference);

@override
String toString() {
  return 'HusnaName(id: $id, arabic: $arabic, transliteration: $transliteration, meaningFr: $meaningFr, etymology: $etymology, reference: $reference)';
}


}

/// @nodoc
abstract mixin class $HusnaNameCopyWith<$Res>  {
  factory $HusnaNameCopyWith(HusnaName value, $Res Function(HusnaName) _then) = _$HusnaNameCopyWithImpl;
@useResult
$Res call({
 int id, String arabic, String transliteration, String meaningFr, String etymology, String reference
});




}
/// @nodoc
class _$HusnaNameCopyWithImpl<$Res>
    implements $HusnaNameCopyWith<$Res> {
  _$HusnaNameCopyWithImpl(this._self, this._then);

  final HusnaName _self;
  final $Res Function(HusnaName) _then;

/// Create a copy of HusnaName
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? arabic = null,Object? transliteration = null,Object? meaningFr = null,Object? etymology = null,Object? reference = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,arabic: null == arabic ? _self.arabic : arabic // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,meaningFr: null == meaningFr ? _self.meaningFr : meaningFr // ignore: cast_nullable_to_non_nullable
as String,etymology: null == etymology ? _self.etymology : etymology // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HusnaName].
extension HusnaNamePatterns on HusnaName {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HusnaName value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HusnaName() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HusnaName value)  $default,){
final _that = this;
switch (_that) {
case _HusnaName():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HusnaName value)?  $default,){
final _that = this;
switch (_that) {
case _HusnaName() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String arabic,  String transliteration,  String meaningFr,  String etymology,  String reference)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HusnaName() when $default != null:
return $default(_that.id,_that.arabic,_that.transliteration,_that.meaningFr,_that.etymology,_that.reference);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String arabic,  String transliteration,  String meaningFr,  String etymology,  String reference)  $default,) {final _that = this;
switch (_that) {
case _HusnaName():
return $default(_that.id,_that.arabic,_that.transliteration,_that.meaningFr,_that.etymology,_that.reference);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String arabic,  String transliteration,  String meaningFr,  String etymology,  String reference)?  $default,) {final _that = this;
switch (_that) {
case _HusnaName() when $default != null:
return $default(_that.id,_that.arabic,_that.transliteration,_that.meaningFr,_that.etymology,_that.reference);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HusnaName implements HusnaName {
  const _HusnaName({required this.id, required this.arabic, required this.transliteration, required this.meaningFr, this.etymology = '', this.reference = ''});
  factory _HusnaName.fromJson(Map<String, dynamic> json) => _$HusnaNameFromJson(json);

@override final  int id;
@override final  String arabic;
@override final  String transliteration;
@override final  String meaningFr;
@override@JsonKey() final  String etymology;
@override@JsonKey() final  String reference;

/// Create a copy of HusnaName
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HusnaNameCopyWith<_HusnaName> get copyWith => __$HusnaNameCopyWithImpl<_HusnaName>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HusnaNameToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HusnaName&&(identical(other.id, id) || other.id == id)&&(identical(other.arabic, arabic) || other.arabic == arabic)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.meaningFr, meaningFr) || other.meaningFr == meaningFr)&&(identical(other.etymology, etymology) || other.etymology == etymology)&&(identical(other.reference, reference) || other.reference == reference));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,arabic,transliteration,meaningFr,etymology,reference);

@override
String toString() {
  return 'HusnaName(id: $id, arabic: $arabic, transliteration: $transliteration, meaningFr: $meaningFr, etymology: $etymology, reference: $reference)';
}


}

/// @nodoc
abstract mixin class _$HusnaNameCopyWith<$Res> implements $HusnaNameCopyWith<$Res> {
  factory _$HusnaNameCopyWith(_HusnaName value, $Res Function(_HusnaName) _then) = __$HusnaNameCopyWithImpl;
@override @useResult
$Res call({
 int id, String arabic, String transliteration, String meaningFr, String etymology, String reference
});




}
/// @nodoc
class __$HusnaNameCopyWithImpl<$Res>
    implements _$HusnaNameCopyWith<$Res> {
  __$HusnaNameCopyWithImpl(this._self, this._then);

  final _HusnaName _self;
  final $Res Function(_HusnaName) _then;

/// Create a copy of HusnaName
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? arabic = null,Object? transliteration = null,Object? meaningFr = null,Object? etymology = null,Object? reference = null,}) {
  return _then(_HusnaName(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,arabic: null == arabic ? _self.arabic : arabic // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,meaningFr: null == meaningFr ? _self.meaningFr : meaningFr // ignore: cast_nullable_to_non_nullable
as String,etymology: null == etymology ? _self.etymology : etymology // ignore: cast_nullable_to_non_nullable
as String,reference: null == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
