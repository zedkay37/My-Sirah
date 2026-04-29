// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'name_action_bank.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NameActionBank {

 String get theme; List<NameActionItem> get actions;
/// Create a copy of NameActionBank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NameActionBankCopyWith<NameActionBank> get copyWith => _$NameActionBankCopyWithImpl<NameActionBank>(this as NameActionBank, _$identity);

  /// Serializes this NameActionBank to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NameActionBank&&(identical(other.theme, theme) || other.theme == theme)&&const DeepCollectionEquality().equals(other.actions, actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,theme,const DeepCollectionEquality().hash(actions));

@override
String toString() {
  return 'NameActionBank(theme: $theme, actions: $actions)';
}


}

/// @nodoc
abstract mixin class $NameActionBankCopyWith<$Res>  {
  factory $NameActionBankCopyWith(NameActionBank value, $Res Function(NameActionBank) _then) = _$NameActionBankCopyWithImpl;
@useResult
$Res call({
 String theme, List<NameActionItem> actions
});




}
/// @nodoc
class _$NameActionBankCopyWithImpl<$Res>
    implements $NameActionBankCopyWith<$Res> {
  _$NameActionBankCopyWithImpl(this._self, this._then);

  final NameActionBank _self;
  final $Res Function(NameActionBank) _then;

/// Create a copy of NameActionBank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? theme = null,Object? actions = null,}) {
  return _then(_self.copyWith(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<NameActionItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [NameActionBank].
extension NameActionBankPatterns on NameActionBank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NameActionBank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NameActionBank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NameActionBank value)  $default,){
final _that = this;
switch (_that) {
case _NameActionBank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NameActionBank value)?  $default,){
final _that = this;
switch (_that) {
case _NameActionBank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String theme,  List<NameActionItem> actions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NameActionBank() when $default != null:
return $default(_that.theme,_that.actions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String theme,  List<NameActionItem> actions)  $default,) {final _that = this;
switch (_that) {
case _NameActionBank():
return $default(_that.theme,_that.actions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String theme,  List<NameActionItem> actions)?  $default,) {final _that = this;
switch (_that) {
case _NameActionBank() when $default != null:
return $default(_that.theme,_that.actions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NameActionBank implements NameActionBank {
  const _NameActionBank({required this.theme, final  List<NameActionItem> actions = const []}): _actions = actions;
  factory _NameActionBank.fromJson(Map<String, dynamic> json) => _$NameActionBankFromJson(json);

@override final  String theme;
 final  List<NameActionItem> _actions;
@override@JsonKey() List<NameActionItem> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}


/// Create a copy of NameActionBank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameActionBankCopyWith<_NameActionBank> get copyWith => __$NameActionBankCopyWithImpl<_NameActionBank>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NameActionBankToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameActionBank&&(identical(other.theme, theme) || other.theme == theme)&&const DeepCollectionEquality().equals(other._actions, _actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,theme,const DeepCollectionEquality().hash(_actions));

@override
String toString() {
  return 'NameActionBank(theme: $theme, actions: $actions)';
}


}

/// @nodoc
abstract mixin class _$NameActionBankCopyWith<$Res> implements $NameActionBankCopyWith<$Res> {
  factory _$NameActionBankCopyWith(_NameActionBank value, $Res Function(_NameActionBank) _then) = __$NameActionBankCopyWithImpl;
@override @useResult
$Res call({
 String theme, List<NameActionItem> actions
});




}
/// @nodoc
class __$NameActionBankCopyWithImpl<$Res>
    implements _$NameActionBankCopyWith<$Res> {
  __$NameActionBankCopyWithImpl(this._self, this._then);

  final _NameActionBank _self;
  final $Res Function(_NameActionBank) _then;

/// Create a copy of NameActionBank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? theme = null,Object? actions = null,}) {
  return _then(_NameActionBank(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<NameActionItem>,
  ));
}


}


/// @nodoc
mixin _$NameActionItem {

 String get id; String get textFr; String get editorialStatus; String get duration; String get difficulty; List<String> get contexts; List<int> get nameNumbers; String get sourceNote; List<String> get sourceRefs; String get reviewedBy; String get validatedAt; String get reviewNotes;
/// Create a copy of NameActionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NameActionItemCopyWith<NameActionItem> get copyWith => _$NameActionItemCopyWithImpl<NameActionItem>(this as NameActionItem, _$identity);

  /// Serializes this NameActionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NameActionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.textFr, textFr) || other.textFr == textFr)&&(identical(other.editorialStatus, editorialStatus) || other.editorialStatus == editorialStatus)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other.contexts, contexts)&&const DeepCollectionEquality().equals(other.nameNumbers, nameNumbers)&&(identical(other.sourceNote, sourceNote) || other.sourceNote == sourceNote)&&const DeepCollectionEquality().equals(other.sourceRefs, sourceRefs)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.validatedAt, validatedAt) || other.validatedAt == validatedAt)&&(identical(other.reviewNotes, reviewNotes) || other.reviewNotes == reviewNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,textFr,editorialStatus,duration,difficulty,const DeepCollectionEquality().hash(contexts),const DeepCollectionEquality().hash(nameNumbers),sourceNote,const DeepCollectionEquality().hash(sourceRefs),reviewedBy,validatedAt,reviewNotes);

@override
String toString() {
  return 'NameActionItem(id: $id, textFr: $textFr, editorialStatus: $editorialStatus, duration: $duration, difficulty: $difficulty, contexts: $contexts, nameNumbers: $nameNumbers, sourceNote: $sourceNote, sourceRefs: $sourceRefs, reviewedBy: $reviewedBy, validatedAt: $validatedAt, reviewNotes: $reviewNotes)';
}


}

/// @nodoc
abstract mixin class $NameActionItemCopyWith<$Res>  {
  factory $NameActionItemCopyWith(NameActionItem value, $Res Function(NameActionItem) _then) = _$NameActionItemCopyWithImpl;
@useResult
$Res call({
 String id, String textFr, String editorialStatus, String duration, String difficulty, List<String> contexts, List<int> nameNumbers, String sourceNote, List<String> sourceRefs, String reviewedBy, String validatedAt, String reviewNotes
});




}
/// @nodoc
class _$NameActionItemCopyWithImpl<$Res>
    implements $NameActionItemCopyWith<$Res> {
  _$NameActionItemCopyWithImpl(this._self, this._then);

  final NameActionItem _self;
  final $Res Function(NameActionItem) _then;

/// Create a copy of NameActionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? textFr = null,Object? editorialStatus = null,Object? duration = null,Object? difficulty = null,Object? contexts = null,Object? nameNumbers = null,Object? sourceNote = null,Object? sourceRefs = null,Object? reviewedBy = null,Object? validatedAt = null,Object? reviewNotes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,textFr: null == textFr ? _self.textFr : textFr // ignore: cast_nullable_to_non_nullable
as String,editorialStatus: null == editorialStatus ? _self.editorialStatus : editorialStatus // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,contexts: null == contexts ? _self.contexts : contexts // ignore: cast_nullable_to_non_nullable
as List<String>,nameNumbers: null == nameNumbers ? _self.nameNumbers : nameNumbers // ignore: cast_nullable_to_non_nullable
as List<int>,sourceNote: null == sourceNote ? _self.sourceNote : sourceNote // ignore: cast_nullable_to_non_nullable
as String,sourceRefs: null == sourceRefs ? _self.sourceRefs : sourceRefs // ignore: cast_nullable_to_non_nullable
as List<String>,reviewedBy: null == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String,validatedAt: null == validatedAt ? _self.validatedAt : validatedAt // ignore: cast_nullable_to_non_nullable
as String,reviewNotes: null == reviewNotes ? _self.reviewNotes : reviewNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NameActionItem].
extension NameActionItemPatterns on NameActionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NameActionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NameActionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NameActionItem value)  $default,){
final _that = this;
switch (_that) {
case _NameActionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NameActionItem value)?  $default,){
final _that = this;
switch (_that) {
case _NameActionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String textFr,  String editorialStatus,  String duration,  String difficulty,  List<String> contexts,  List<int> nameNumbers,  String sourceNote,  List<String> sourceRefs,  String reviewedBy,  String validatedAt,  String reviewNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NameActionItem() when $default != null:
return $default(_that.id,_that.textFr,_that.editorialStatus,_that.duration,_that.difficulty,_that.contexts,_that.nameNumbers,_that.sourceNote,_that.sourceRefs,_that.reviewedBy,_that.validatedAt,_that.reviewNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String textFr,  String editorialStatus,  String duration,  String difficulty,  List<String> contexts,  List<int> nameNumbers,  String sourceNote,  List<String> sourceRefs,  String reviewedBy,  String validatedAt,  String reviewNotes)  $default,) {final _that = this;
switch (_that) {
case _NameActionItem():
return $default(_that.id,_that.textFr,_that.editorialStatus,_that.duration,_that.difficulty,_that.contexts,_that.nameNumbers,_that.sourceNote,_that.sourceRefs,_that.reviewedBy,_that.validatedAt,_that.reviewNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String textFr,  String editorialStatus,  String duration,  String difficulty,  List<String> contexts,  List<int> nameNumbers,  String sourceNote,  List<String> sourceRefs,  String reviewedBy,  String validatedAt,  String reviewNotes)?  $default,) {final _that = this;
switch (_that) {
case _NameActionItem() when $default != null:
return $default(_that.id,_that.textFr,_that.editorialStatus,_that.duration,_that.difficulty,_that.contexts,_that.nameNumbers,_that.sourceNote,_that.sourceRefs,_that.reviewedBy,_that.validatedAt,_that.reviewNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NameActionItem implements NameActionItem {
  const _NameActionItem({required this.id, required this.textFr, this.editorialStatus = 'needs_review', this.duration = 'short', this.difficulty = 'simple', final  List<String> contexts = const [], final  List<int> nameNumbers = const [], this.sourceNote = '', final  List<String> sourceRefs = const [], this.reviewedBy = '', this.validatedAt = '', this.reviewNotes = ''}): _contexts = contexts,_nameNumbers = nameNumbers,_sourceRefs = sourceRefs;
  factory _NameActionItem.fromJson(Map<String, dynamic> json) => _$NameActionItemFromJson(json);

@override final  String id;
@override final  String textFr;
@override@JsonKey() final  String editorialStatus;
@override@JsonKey() final  String duration;
@override@JsonKey() final  String difficulty;
 final  List<String> _contexts;
@override@JsonKey() List<String> get contexts {
  if (_contexts is EqualUnmodifiableListView) return _contexts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contexts);
}

 final  List<int> _nameNumbers;
@override@JsonKey() List<int> get nameNumbers {
  if (_nameNumbers is EqualUnmodifiableListView) return _nameNumbers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nameNumbers);
}

@override@JsonKey() final  String sourceNote;
 final  List<String> _sourceRefs;
@override@JsonKey() List<String> get sourceRefs {
  if (_sourceRefs is EqualUnmodifiableListView) return _sourceRefs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sourceRefs);
}

@override@JsonKey() final  String reviewedBy;
@override@JsonKey() final  String validatedAt;
@override@JsonKey() final  String reviewNotes;

/// Create a copy of NameActionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NameActionItemCopyWith<_NameActionItem> get copyWith => __$NameActionItemCopyWithImpl<_NameActionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NameActionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NameActionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.textFr, textFr) || other.textFr == textFr)&&(identical(other.editorialStatus, editorialStatus) || other.editorialStatus == editorialStatus)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._contexts, _contexts)&&const DeepCollectionEquality().equals(other._nameNumbers, _nameNumbers)&&(identical(other.sourceNote, sourceNote) || other.sourceNote == sourceNote)&&const DeepCollectionEquality().equals(other._sourceRefs, _sourceRefs)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.validatedAt, validatedAt) || other.validatedAt == validatedAt)&&(identical(other.reviewNotes, reviewNotes) || other.reviewNotes == reviewNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,textFr,editorialStatus,duration,difficulty,const DeepCollectionEquality().hash(_contexts),const DeepCollectionEquality().hash(_nameNumbers),sourceNote,const DeepCollectionEquality().hash(_sourceRefs),reviewedBy,validatedAt,reviewNotes);

@override
String toString() {
  return 'NameActionItem(id: $id, textFr: $textFr, editorialStatus: $editorialStatus, duration: $duration, difficulty: $difficulty, contexts: $contexts, nameNumbers: $nameNumbers, sourceNote: $sourceNote, sourceRefs: $sourceRefs, reviewedBy: $reviewedBy, validatedAt: $validatedAt, reviewNotes: $reviewNotes)';
}


}

/// @nodoc
abstract mixin class _$NameActionItemCopyWith<$Res> implements $NameActionItemCopyWith<$Res> {
  factory _$NameActionItemCopyWith(_NameActionItem value, $Res Function(_NameActionItem) _then) = __$NameActionItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String textFr, String editorialStatus, String duration, String difficulty, List<String> contexts, List<int> nameNumbers, String sourceNote, List<String> sourceRefs, String reviewedBy, String validatedAt, String reviewNotes
});




}
/// @nodoc
class __$NameActionItemCopyWithImpl<$Res>
    implements _$NameActionItemCopyWith<$Res> {
  __$NameActionItemCopyWithImpl(this._self, this._then);

  final _NameActionItem _self;
  final $Res Function(_NameActionItem) _then;

/// Create a copy of NameActionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? textFr = null,Object? editorialStatus = null,Object? duration = null,Object? difficulty = null,Object? contexts = null,Object? nameNumbers = null,Object? sourceNote = null,Object? sourceRefs = null,Object? reviewedBy = null,Object? validatedAt = null,Object? reviewNotes = null,}) {
  return _then(_NameActionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,textFr: null == textFr ? _self.textFr : textFr // ignore: cast_nullable_to_non_nullable
as String,editorialStatus: null == editorialStatus ? _self.editorialStatus : editorialStatus // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,contexts: null == contexts ? _self._contexts : contexts // ignore: cast_nullable_to_non_nullable
as List<String>,nameNumbers: null == nameNumbers ? _self._nameNumbers : nameNumbers // ignore: cast_nullable_to_non_nullable
as List<int>,sourceNote: null == sourceNote ? _self.sourceNote : sourceNote // ignore: cast_nullable_to_non_nullable
as String,sourceRefs: null == sourceRefs ? _self._sourceRefs : sourceRefs // ignore: cast_nullable_to_non_nullable
as List<String>,reviewedBy: null == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String,validatedAt: null == validatedAt ? _self.validatedAt : validatedAt // ignore: cast_nullable_to_non_nullable
as String,reviewNotes: null == reviewNotes ? _self.reviewNotes : reviewNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
