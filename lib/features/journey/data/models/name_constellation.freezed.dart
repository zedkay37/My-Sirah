// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'name_constellation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NameConstellation {

 String get id; String get titleFr; String get titleAr; String get descriptionFr; List<int> get nameNumbers; String get colorHex;
/// Create a copy of NameConstellation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NameConstellationCopyWith<NameConstellation> get copyWith => _$NameConstellationCopyWithImpl<NameConstellation>(this as NameConstellation, _$identity);

  /// Serializes this NameConstellation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NameConstellation&&(identical(other.id, id) || other.id == id)&&(identical(other.titleFr, titleFr) || other.titleFr == titleFr)&&(identical(other.titleAr, titleAr) || other.titleAr == titleAr)&&(identical(other.descriptionFr, descriptionFr) || other.descriptionFr == descriptionFr)&&const DeepCollectionEquality().equals(other.nameNumbers, nameNumbers)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,titleFr,titleAr,descriptionFr,const DeepCollectionEquality().hash(nameNumbers),colorHex);

@override
String toString() {
  return 'NameConstellation(id: $id, titleFr: $titleFr, titleAr: $titleAr, descriptionFr: $descriptionFr, nameNumbers: $nameNumbers, colorHex: $colorHex)';
}


}

/// @nodoc
abstract mixin class $NameConstellationCopyWith<$Res>  {
  factory $NameConstellationCopyWith(NameConstellation value, $Res Function(NameConstellation) _then) = _$NameConstellationCopyWithImpl;
@useResult
$Res call({
 String id, String titleFr, String titleAr, String descriptionFr, List<int> nameNumbers, String colorHex
});




}
/// @nodoc
class _$NameConstellationCopyWithImpl<$Res>
    implements $NameConstellationCopyWith<$Res> {
  _$NameConstellationCopyWithImpl(this._self, this._then);

  final NameConstellation _self;
  final $Res Function(NameConstellation) _then;

/// Create a copy of NameConstellation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titleFr = null,Object? titleAr = null,Object? descriptionFr = null,Object? nameNumbers = null,Object? colorHex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleFr: null == titleFr ? _self.titleFr : titleFr // ignore: cast_nullable_to_non_nullable
as String,titleAr: null == titleAr ? _self.titleAr : titleAr // ignore: cast_nullable_to_non_nullable
as String,descriptionFr: null == descriptionFr ? _self.descriptionFr : descriptionFr // ignore: cast_nullable_to_non_nullable
as String,nameNumbers: null == nameNumbers ? _self.nameNumbers : nameNumbers // ignore: cast_nullable_to_non_nullable
as List<int>,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NameConstellation].
extension NameConstellationPatterns on NameConstellation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NameConstellation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NameConstellation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NameConstellation value)  $default,){
final _that = this;
switch (_that) {
case _NameConstellation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NameConstellation value)?  $default,){
final _that = this;
switch (_that) {
case _NameConstellation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String titleFr,  String titleAr,  String descriptionFr,  List<int> nameNumbers,  String colorHex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NameConstellation() when $default != null:
return $default(_that.id,_that.titleFr,_that.titleAr,_that.descriptionFr,_that.nameNumbers,_that.colorHex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String titleFr,  String titleAr,  String descriptionFr,  List<int> nameNumbers,  String colorHex)  $default,) {final _that = this;
switch (_that) {
case _NameConstellation():
return $default(_that.id,_that.titleFr,_that.titleAr,_that.descriptionFr,_that.nameNumbers,_that.colorHex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String titleFr,  String titleAr,  String descriptionFr,  List<int> nameNumbers,  String colorHex)?  $default,) {final _that = this;
switch (_that) {
case _NameConstellation() when $default != null:
return $default(_that.id,_that.titleFr,_that.titleAr,_that.descriptionFr,_that.nameNumbers,_that.colorHex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NameConstellation implements NameConstellation {
  const _NameConstellation({required this.id, required this.titleFr, required this.titleAr, required this.descriptionFr, required final  List<int> nameNumbers, required this.colorHex}): _nameNumbers = nameNumbers;
  factory _NameConstellation.fromJson(Map<String, dynamic> json) => _$NameConstellationFromJson(json);

@override final  String id;
@override final  String titleFr;
@override final  String titleAr;
@override final  String descriptionFr;
 final  List<int> _nameNumbers;
@override List<int> get nameNumbers {
  if (_nameNumbers is EqualUnmodifiableListView) return _nameNumbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nameNumbers);
}

@override final  String colorHex;

/// Create a copy of NameConstellation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameConstellationCopyWith<_NameConstellation> get copyWith => __$NameConstellationCopyWithImpl<_NameConstellation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NameConstellationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameConstellation&&(identical(other.id, id) || other.id == id)&&(identical(other.titleFr, titleFr) || other.titleFr == titleFr)&&(identical(other.titleAr, titleAr) || other.titleAr == titleAr)&&(identical(other.descriptionFr, descriptionFr) || other.descriptionFr == descriptionFr)&&const DeepCollectionEquality().equals(other._nameNumbers, _nameNumbers)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,titleFr,titleAr,descriptionFr,const DeepCollectionEquality().hash(_nameNumbers),colorHex);

@override
String toString() {
  return 'NameConstellation(id: $id, titleFr: $titleFr, titleAr: $titleAr, descriptionFr: $descriptionFr, nameNumbers: $nameNumbers, colorHex: $colorHex)';
}


}

/// @nodoc
abstract mixin class _$NameConstellationCopyWith<$Res> implements $NameConstellationCopyWith<$Res> {
  factory _$NameConstellationCopyWith(_NameConstellation value, $Res Function(_NameConstellation) _then) = __$NameConstellationCopyWithImpl;
@override @useResult
$Res call({
 String id, String titleFr, String titleAr, String descriptionFr, List<int> nameNumbers, String colorHex
});




}
/// @nodoc
class __$NameConstellationCopyWithImpl<$Res>
    implements _$NameConstellationCopyWith<$Res> {
  __$NameConstellationCopyWithImpl(this._self, this._then);

  final _NameConstellation _self;
  final $Res Function(_NameConstellation) _then;

/// Create a copy of NameConstellation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titleFr = null,Object? titleAr = null,Object? descriptionFr = null,Object? nameNumbers = null,Object? colorHex = null,}) {
  return _then(_NameConstellation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleFr: null == titleFr ? _self.titleFr : titleFr // ignore: cast_nullable_to_non_nullable
as String,titleAr: null == titleAr ? _self.titleAr : titleAr // ignore: cast_nullable_to_non_nullable
as String,descriptionFr: null == descriptionFr ? _self.descriptionFr : descriptionFr // ignore: cast_nullable_to_non_nullable
as String,nameNumbers: null == nameNumbers ? _self._nameNumbers : nameNumbers // ignore: cast_nullable_to_non_nullable
as List<int>,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
