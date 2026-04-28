// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'name_experience.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NameStory {

 String get id; String get titleFr; String get bodyFr; List<String> get tags; String get sourceNote; List<String> get relatedPeople;
/// Create a copy of NameStory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NameStoryCopyWith<NameStory> get copyWith => _$NameStoryCopyWithImpl<NameStory>(this as NameStory, _$identity);

  /// Serializes this NameStory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NameStory&&(identical(other.id, id) || other.id == id)&&(identical(other.titleFr, titleFr) || other.titleFr == titleFr)&&(identical(other.bodyFr, bodyFr) || other.bodyFr == bodyFr)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.sourceNote, sourceNote) || other.sourceNote == sourceNote)&&const DeepCollectionEquality().equals(other.relatedPeople, relatedPeople));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,titleFr,bodyFr,const DeepCollectionEquality().hash(tags),sourceNote,const DeepCollectionEquality().hash(relatedPeople));

@override
String toString() {
  return 'NameStory(id: $id, titleFr: $titleFr, bodyFr: $bodyFr, tags: $tags, sourceNote: $sourceNote, relatedPeople: $relatedPeople)';
}


}

/// @nodoc
abstract mixin class $NameStoryCopyWith<$Res>  {
  factory $NameStoryCopyWith(NameStory value, $Res Function(NameStory) _then) = _$NameStoryCopyWithImpl;
@useResult
$Res call({
 String id, String titleFr, String bodyFr, List<String> tags, String sourceNote, List<String> relatedPeople
});




}
/// @nodoc
class _$NameStoryCopyWithImpl<$Res>
    implements $NameStoryCopyWith<$Res> {
  _$NameStoryCopyWithImpl(this._self, this._then);

  final NameStory _self;
  final $Res Function(NameStory) _then;

/// Create a copy of NameStory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titleFr = null,Object? bodyFr = null,Object? tags = null,Object? sourceNote = null,Object? relatedPeople = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleFr: null == titleFr ? _self.titleFr : titleFr // ignore: cast_nullable_to_non_nullable
as String,bodyFr: null == bodyFr ? _self.bodyFr : bodyFr // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,sourceNote: null == sourceNote ? _self.sourceNote : sourceNote // ignore: cast_nullable_to_non_nullable
as String,relatedPeople: null == relatedPeople ? _self.relatedPeople : relatedPeople // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [NameStory].
extension NameStoryPatterns on NameStory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NameStory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NameStory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NameStory value)  $default,){
final _that = this;
switch (_that) {
case _NameStory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NameStory value)?  $default,){
final _that = this;
switch (_that) {
case _NameStory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String titleFr,  String bodyFr,  List<String> tags,  String sourceNote,  List<String> relatedPeople)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NameStory() when $default != null:
return $default(_that.id,_that.titleFr,_that.bodyFr,_that.tags,_that.sourceNote,_that.relatedPeople);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String titleFr,  String bodyFr,  List<String> tags,  String sourceNote,  List<String> relatedPeople)  $default,) {final _that = this;
switch (_that) {
case _NameStory():
return $default(_that.id,_that.titleFr,_that.bodyFr,_that.tags,_that.sourceNote,_that.relatedPeople);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String titleFr,  String bodyFr,  List<String> tags,  String sourceNote,  List<String> relatedPeople)?  $default,) {final _that = this;
switch (_that) {
case _NameStory() when $default != null:
return $default(_that.id,_that.titleFr,_that.bodyFr,_that.tags,_that.sourceNote,_that.relatedPeople);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NameStory implements NameStory {
  const _NameStory({required this.id, required this.titleFr, required this.bodyFr, final  List<String> tags = const [], required this.sourceNote, final  List<String> relatedPeople = const []}): _tags = tags,_relatedPeople = relatedPeople;
  factory _NameStory.fromJson(Map<String, dynamic> json) => _$NameStoryFromJson(json);

@override final  String id;
@override final  String titleFr;
@override final  String bodyFr;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String sourceNote;
 final  List<String> _relatedPeople;
@override@JsonKey() List<String> get relatedPeople {
  if (_relatedPeople is EqualUnmodifiableListView) return _relatedPeople;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relatedPeople);
}


/// Create a copy of NameStory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameStoryCopyWith<_NameStory> get copyWith => __$NameStoryCopyWithImpl<_NameStory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NameStoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameStory&&(identical(other.id, id) || other.id == id)&&(identical(other.titleFr, titleFr) || other.titleFr == titleFr)&&(identical(other.bodyFr, bodyFr) || other.bodyFr == bodyFr)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.sourceNote, sourceNote) || other.sourceNote == sourceNote)&&const DeepCollectionEquality().equals(other._relatedPeople, _relatedPeople));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,titleFr,bodyFr,const DeepCollectionEquality().hash(_tags),sourceNote,const DeepCollectionEquality().hash(_relatedPeople));

@override
String toString() {
  return 'NameStory(id: $id, titleFr: $titleFr, bodyFr: $bodyFr, tags: $tags, sourceNote: $sourceNote, relatedPeople: $relatedPeople)';
}


}

/// @nodoc
abstract mixin class _$NameStoryCopyWith<$Res> implements $NameStoryCopyWith<$Res> {
  factory _$NameStoryCopyWith(_NameStory value, $Res Function(_NameStory) _then) = __$NameStoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String titleFr, String bodyFr, List<String> tags, String sourceNote, List<String> relatedPeople
});




}
/// @nodoc
class __$NameStoryCopyWithImpl<$Res>
    implements _$NameStoryCopyWith<$Res> {
  __$NameStoryCopyWithImpl(this._self, this._then);

  final _NameStory _self;
  final $Res Function(_NameStory) _then;

/// Create a copy of NameStory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titleFr = null,Object? bodyFr = null,Object? tags = null,Object? sourceNote = null,Object? relatedPeople = null,}) {
  return _then(_NameStory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleFr: null == titleFr ? _self.titleFr : titleFr // ignore: cast_nullable_to_non_nullable
as String,bodyFr: null == bodyFr ? _self.bodyFr : bodyFr // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,sourceNote: null == sourceNote ? _self.sourceNote : sourceNote // ignore: cast_nullable_to_non_nullable
as String,relatedPeople: null == relatedPeople ? _self._relatedPeople : relatedPeople // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$NameExperience {

 int get nameNumber; List<NameStory> get stories; String get tafakkurPromptFr; String get practiceTheme;
/// Create a copy of NameExperience
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NameExperienceCopyWith<NameExperience> get copyWith => _$NameExperienceCopyWithImpl<NameExperience>(this as NameExperience, _$identity);

  /// Serializes this NameExperience to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NameExperience&&(identical(other.nameNumber, nameNumber) || other.nameNumber == nameNumber)&&const DeepCollectionEquality().equals(other.stories, stories)&&(identical(other.tafakkurPromptFr, tafakkurPromptFr) || other.tafakkurPromptFr == tafakkurPromptFr)&&(identical(other.practiceTheme, practiceTheme) || other.practiceTheme == practiceTheme));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nameNumber,const DeepCollectionEquality().hash(stories),tafakkurPromptFr,practiceTheme);

@override
String toString() {
  return 'NameExperience(nameNumber: $nameNumber, stories: $stories, tafakkurPromptFr: $tafakkurPromptFr, practiceTheme: $practiceTheme)';
}


}

/// @nodoc
abstract mixin class $NameExperienceCopyWith<$Res>  {
  factory $NameExperienceCopyWith(NameExperience value, $Res Function(NameExperience) _then) = _$NameExperienceCopyWithImpl;
@useResult
$Res call({
 int nameNumber, List<NameStory> stories, String tafakkurPromptFr, String practiceTheme
});




}
/// @nodoc
class _$NameExperienceCopyWithImpl<$Res>
    implements $NameExperienceCopyWith<$Res> {
  _$NameExperienceCopyWithImpl(this._self, this._then);

  final NameExperience _self;
  final $Res Function(NameExperience) _then;

/// Create a copy of NameExperience
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nameNumber = null,Object? stories = null,Object? tafakkurPromptFr = null,Object? practiceTheme = null,}) {
  return _then(_self.copyWith(
nameNumber: null == nameNumber ? _self.nameNumber : nameNumber // ignore: cast_nullable_to_non_nullable
as int,stories: null == stories ? _self.stories : stories // ignore: cast_nullable_to_non_nullable
as List<NameStory>,tafakkurPromptFr: null == tafakkurPromptFr ? _self.tafakkurPromptFr : tafakkurPromptFr // ignore: cast_nullable_to_non_nullable
as String,practiceTheme: null == practiceTheme ? _self.practiceTheme : practiceTheme // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NameExperience].
extension NameExperiencePatterns on NameExperience {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NameExperience value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NameExperience() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NameExperience value)  $default,){
final _that = this;
switch (_that) {
case _NameExperience():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NameExperience value)?  $default,){
final _that = this;
switch (_that) {
case _NameExperience() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int nameNumber,  List<NameStory> stories,  String tafakkurPromptFr,  String practiceTheme)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NameExperience() when $default != null:
return $default(_that.nameNumber,_that.stories,_that.tafakkurPromptFr,_that.practiceTheme);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int nameNumber,  List<NameStory> stories,  String tafakkurPromptFr,  String practiceTheme)  $default,) {final _that = this;
switch (_that) {
case _NameExperience():
return $default(_that.nameNumber,_that.stories,_that.tafakkurPromptFr,_that.practiceTheme);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int nameNumber,  List<NameStory> stories,  String tafakkurPromptFr,  String practiceTheme)?  $default,) {final _that = this;
switch (_that) {
case _NameExperience() when $default != null:
return $default(_that.nameNumber,_that.stories,_that.tafakkurPromptFr,_that.practiceTheme);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NameExperience implements NameExperience {
  const _NameExperience({required this.nameNumber, final  List<NameStory> stories = const [], required this.tafakkurPromptFr, required this.practiceTheme}): _stories = stories;
  factory _NameExperience.fromJson(Map<String, dynamic> json) => _$NameExperienceFromJson(json);

@override final  int nameNumber;
 final  List<NameStory> _stories;
@override@JsonKey() List<NameStory> get stories {
  if (_stories is EqualUnmodifiableListView) return _stories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stories);
}

@override final  String tafakkurPromptFr;
@override final  String practiceTheme;

/// Create a copy of NameExperience
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameExperienceCopyWith<_NameExperience> get copyWith => __$NameExperienceCopyWithImpl<_NameExperience>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NameExperienceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameExperience&&(identical(other.nameNumber, nameNumber) || other.nameNumber == nameNumber)&&const DeepCollectionEquality().equals(other._stories, _stories)&&(identical(other.tafakkurPromptFr, tafakkurPromptFr) || other.tafakkurPromptFr == tafakkurPromptFr)&&(identical(other.practiceTheme, practiceTheme) || other.practiceTheme == practiceTheme));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nameNumber,const DeepCollectionEquality().hash(_stories),tafakkurPromptFr,practiceTheme);

@override
String toString() {
  return 'NameExperience(nameNumber: $nameNumber, stories: $stories, tafakkurPromptFr: $tafakkurPromptFr, practiceTheme: $practiceTheme)';
}


}

/// @nodoc
abstract mixin class _$NameExperienceCopyWith<$Res> implements $NameExperienceCopyWith<$Res> {
  factory _$NameExperienceCopyWith(_NameExperience value, $Res Function(_NameExperience) _then) = __$NameExperienceCopyWithImpl;
@override @useResult
$Res call({
 int nameNumber, List<NameStory> stories, String tafakkurPromptFr, String practiceTheme
});




}
/// @nodoc
class __$NameExperienceCopyWithImpl<$Res>
    implements _$NameExperienceCopyWith<$Res> {
  __$NameExperienceCopyWithImpl(this._self, this._then);

  final _NameExperience _self;
  final $Res Function(_NameExperience) _then;

/// Create a copy of NameExperience
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nameNumber = null,Object? stories = null,Object? tafakkurPromptFr = null,Object? practiceTheme = null,}) {
  return _then(_NameExperience(
nameNumber: null == nameNumber ? _self.nameNumber : nameNumber // ignore: cast_nullable_to_non_nullable
as int,stories: null == stories ? _self._stories : stories // ignore: cast_nullable_to_non_nullable
as List<NameStory>,tafakkurPromptFr: null == tafakkurPromptFr ? _self.tafakkurPromptFr : tafakkurPromptFr // ignore: cast_nullable_to_non_nullable
as String,practiceTheme: null == practiceTheme ? _self.practiceTheme : practiceTheme // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
