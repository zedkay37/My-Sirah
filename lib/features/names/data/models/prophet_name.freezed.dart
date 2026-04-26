// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prophet_name.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProphetName {

// JSON: "id" → numéro 1-201
@JsonKey(name: 'id') int get number;// JSON: "arabic" → مُحَمَّد
 String get arabic;// JSON: "transliteration" → Muḥammad
 String get transliteration;// JSON: "categorySlug" → clé technique "praise"
@JsonKey(name: 'categorySlug') String get categorySlug;// JSON: "category" → label FR "Louange"
@JsonKey(name: 'category') String get categoryLabel; String get etymology; String get commentary; String get references; String get primarySource; String get secondarySources;
/// Create a copy of ProphetName
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProphetNameCopyWith<ProphetName> get copyWith => _$ProphetNameCopyWithImpl<ProphetName>(this as ProphetName, _$identity);

  /// Serializes this ProphetName to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProphetName&&(identical(other.number, number) || other.number == number)&&(identical(other.arabic, arabic) || other.arabic == arabic)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.categoryLabel, categoryLabel) || other.categoryLabel == categoryLabel)&&(identical(other.etymology, etymology) || other.etymology == etymology)&&(identical(other.commentary, commentary) || other.commentary == commentary)&&(identical(other.references, references) || other.references == references)&&(identical(other.primarySource, primarySource) || other.primarySource == primarySource)&&(identical(other.secondarySources, secondarySources) || other.secondarySources == secondarySources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,arabic,transliteration,categorySlug,categoryLabel,etymology,commentary,references,primarySource,secondarySources);

@override
String toString() {
  return 'ProphetName(number: $number, arabic: $arabic, transliteration: $transliteration, categorySlug: $categorySlug, categoryLabel: $categoryLabel, etymology: $etymology, commentary: $commentary, references: $references, primarySource: $primarySource, secondarySources: $secondarySources)';
}


}

/// @nodoc
abstract mixin class $ProphetNameCopyWith<$Res>  {
  factory $ProphetNameCopyWith(ProphetName value, $Res Function(ProphetName) _then) = _$ProphetNameCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int number, String arabic, String transliteration,@JsonKey(name: 'categorySlug') String categorySlug,@JsonKey(name: 'category') String categoryLabel, String etymology, String commentary, String references, String primarySource, String secondarySources
});




}
/// @nodoc
class _$ProphetNameCopyWithImpl<$Res>
    implements $ProphetNameCopyWith<$Res> {
  _$ProphetNameCopyWithImpl(this._self, this._then);

  final ProphetName _self;
  final $Res Function(ProphetName) _then;

/// Create a copy of ProphetName
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? number = null,Object? arabic = null,Object? transliteration = null,Object? categorySlug = null,Object? categoryLabel = null,Object? etymology = null,Object? commentary = null,Object? references = null,Object? primarySource = null,Object? secondarySources = null,}) {
  return _then(_self.copyWith(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,arabic: null == arabic ? _self.arabic : arabic // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,categorySlug: null == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String,categoryLabel: null == categoryLabel ? _self.categoryLabel : categoryLabel // ignore: cast_nullable_to_non_nullable
as String,etymology: null == etymology ? _self.etymology : etymology // ignore: cast_nullable_to_non_nullable
as String,commentary: null == commentary ? _self.commentary : commentary // ignore: cast_nullable_to_non_nullable
as String,references: null == references ? _self.references : references // ignore: cast_nullable_to_non_nullable
as String,primarySource: null == primarySource ? _self.primarySource : primarySource // ignore: cast_nullable_to_non_nullable
as String,secondarySources: null == secondarySources ? _self.secondarySources : secondarySources // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProphetName].
extension ProphetNamePatterns on ProphetName {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProphetName value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProphetName() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProphetName value)  $default,){
final _that = this;
switch (_that) {
case _ProphetName():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProphetName value)?  $default,){
final _that = this;
switch (_that) {
case _ProphetName() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int number,  String arabic,  String transliteration, @JsonKey(name: 'categorySlug')  String categorySlug, @JsonKey(name: 'category')  String categoryLabel,  String etymology,  String commentary,  String references,  String primarySource,  String secondarySources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProphetName() when $default != null:
return $default(_that.number,_that.arabic,_that.transliteration,_that.categorySlug,_that.categoryLabel,_that.etymology,_that.commentary,_that.references,_that.primarySource,_that.secondarySources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int number,  String arabic,  String transliteration, @JsonKey(name: 'categorySlug')  String categorySlug, @JsonKey(name: 'category')  String categoryLabel,  String etymology,  String commentary,  String references,  String primarySource,  String secondarySources)  $default,) {final _that = this;
switch (_that) {
case _ProphetName():
return $default(_that.number,_that.arabic,_that.transliteration,_that.categorySlug,_that.categoryLabel,_that.etymology,_that.commentary,_that.references,_that.primarySource,_that.secondarySources);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int number,  String arabic,  String transliteration, @JsonKey(name: 'categorySlug')  String categorySlug, @JsonKey(name: 'category')  String categoryLabel,  String etymology,  String commentary,  String references,  String primarySource,  String secondarySources)?  $default,) {final _that = this;
switch (_that) {
case _ProphetName() when $default != null:
return $default(_that.number,_that.arabic,_that.transliteration,_that.categorySlug,_that.categoryLabel,_that.etymology,_that.commentary,_that.references,_that.primarySource,_that.secondarySources);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProphetName implements ProphetName {
  const _ProphetName({@JsonKey(name: 'id') required this.number, required this.arabic, required this.transliteration, @JsonKey(name: 'categorySlug') required this.categorySlug, @JsonKey(name: 'category') required this.categoryLabel, required this.etymology, required this.commentary, required this.references, required this.primarySource, required this.secondarySources});
  factory _ProphetName.fromJson(Map<String, dynamic> json) => _$ProphetNameFromJson(json);

// JSON: "id" → numéro 1-201
@override@JsonKey(name: 'id') final  int number;
// JSON: "arabic" → مُحَمَّد
@override final  String arabic;
// JSON: "transliteration" → Muḥammad
@override final  String transliteration;
// JSON: "categorySlug" → clé technique "praise"
@override@JsonKey(name: 'categorySlug') final  String categorySlug;
// JSON: "category" → label FR "Louange"
@override@JsonKey(name: 'category') final  String categoryLabel;
@override final  String etymology;
@override final  String commentary;
@override final  String references;
@override final  String primarySource;
@override final  String secondarySources;

/// Create a copy of ProphetName
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProphetNameCopyWith<_ProphetName> get copyWith => __$ProphetNameCopyWithImpl<_ProphetName>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProphetNameToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProphetName&&(identical(other.number, number) || other.number == number)&&(identical(other.arabic, arabic) || other.arabic == arabic)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.categoryLabel, categoryLabel) || other.categoryLabel == categoryLabel)&&(identical(other.etymology, etymology) || other.etymology == etymology)&&(identical(other.commentary, commentary) || other.commentary == commentary)&&(identical(other.references, references) || other.references == references)&&(identical(other.primarySource, primarySource) || other.primarySource == primarySource)&&(identical(other.secondarySources, secondarySources) || other.secondarySources == secondarySources));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,number,arabic,transliteration,categorySlug,categoryLabel,etymology,commentary,references,primarySource,secondarySources);

@override
String toString() {
  return 'ProphetName(number: $number, arabic: $arabic, transliteration: $transliteration, categorySlug: $categorySlug, categoryLabel: $categoryLabel, etymology: $etymology, commentary: $commentary, references: $references, primarySource: $primarySource, secondarySources: $secondarySources)';
}


}

/// @nodoc
abstract mixin class _$ProphetNameCopyWith<$Res> implements $ProphetNameCopyWith<$Res> {
  factory _$ProphetNameCopyWith(_ProphetName value, $Res Function(_ProphetName) _then) = __$ProphetNameCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int number, String arabic, String transliteration,@JsonKey(name: 'categorySlug') String categorySlug,@JsonKey(name: 'category') String categoryLabel, String etymology, String commentary, String references, String primarySource, String secondarySources
});




}
/// @nodoc
class __$ProphetNameCopyWithImpl<$Res>
    implements _$ProphetNameCopyWith<$Res> {
  __$ProphetNameCopyWithImpl(this._self, this._then);

  final _ProphetName _self;
  final $Res Function(_ProphetName) _then;

/// Create a copy of ProphetName
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? number = null,Object? arabic = null,Object? transliteration = null,Object? categorySlug = null,Object? categoryLabel = null,Object? etymology = null,Object? commentary = null,Object? references = null,Object? primarySource = null,Object? secondarySources = null,}) {
  return _then(_ProphetName(
number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,arabic: null == arabic ? _self.arabic : arabic // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,categorySlug: null == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String,categoryLabel: null == categoryLabel ? _self.categoryLabel : categoryLabel // ignore: cast_nullable_to_non_nullable
as String,etymology: null == etymology ? _self.etymology : etymology // ignore: cast_nullable_to_non_nullable
as String,commentary: null == commentary ? _self.commentary : commentary // ignore: cast_nullable_to_non_nullable
as String,references: null == references ? _self.references : references // ignore: cast_nullable_to_non_nullable
as String,primarySource: null == primarySource ? _self.primarySource : primarySource // ignore: cast_nullable_to_non_nullable
as String,secondarySources: null == secondarySources ? _self.secondarySources : secondarySources // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
