// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FamilyMember {

 String get id; String get arabic; String get transliteration; String? get kunya; List<String> get laqab; FamilyRole get role; String? get birth; String? get death; String? get bio; int? get generation; int? get marriageOrder;// Graph edges — used for BFS path traversal
 String? get parentId; String? get motherId; String? get spouseOf; List<String> get parentIds; bool get isBoundary; bool get isTraditional; String? get variant;
/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyMemberCopyWith<FamilyMember> get copyWith => _$FamilyMemberCopyWithImpl<FamilyMember>(this as FamilyMember, _$identity);

  /// Serializes this FamilyMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyMember&&(identical(other.id, id) || other.id == id)&&(identical(other.arabic, arabic) || other.arabic == arabic)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.kunya, kunya) || other.kunya == kunya)&&const DeepCollectionEquality().equals(other.laqab, laqab)&&(identical(other.role, role) || other.role == role)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.death, death) || other.death == death)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.generation, generation) || other.generation == generation)&&(identical(other.marriageOrder, marriageOrder) || other.marriageOrder == marriageOrder)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.motherId, motherId) || other.motherId == motherId)&&(identical(other.spouseOf, spouseOf) || other.spouseOf == spouseOf)&&const DeepCollectionEquality().equals(other.parentIds, parentIds)&&(identical(other.isBoundary, isBoundary) || other.isBoundary == isBoundary)&&(identical(other.isTraditional, isTraditional) || other.isTraditional == isTraditional)&&(identical(other.variant, variant) || other.variant == variant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,arabic,transliteration,kunya,const DeepCollectionEquality().hash(laqab),role,birth,death,bio,generation,marriageOrder,parentId,motherId,spouseOf,const DeepCollectionEquality().hash(parentIds),isBoundary,isTraditional,variant);

@override
String toString() {
  return 'FamilyMember(id: $id, arabic: $arabic, transliteration: $transliteration, kunya: $kunya, laqab: $laqab, role: $role, birth: $birth, death: $death, bio: $bio, generation: $generation, marriageOrder: $marriageOrder, parentId: $parentId, motherId: $motherId, spouseOf: $spouseOf, parentIds: $parentIds, isBoundary: $isBoundary, isTraditional: $isTraditional, variant: $variant)';
}


}

/// @nodoc
abstract mixin class $FamilyMemberCopyWith<$Res>  {
  factory $FamilyMemberCopyWith(FamilyMember value, $Res Function(FamilyMember) _then) = _$FamilyMemberCopyWithImpl;
@useResult
$Res call({
 String id, String arabic, String transliteration, String? kunya, List<String> laqab, FamilyRole role, String? birth, String? death, String? bio, int? generation, int? marriageOrder, String? parentId, String? motherId, String? spouseOf, List<String> parentIds, bool isBoundary, bool isTraditional, String? variant
});




}
/// @nodoc
class _$FamilyMemberCopyWithImpl<$Res>
    implements $FamilyMemberCopyWith<$Res> {
  _$FamilyMemberCopyWithImpl(this._self, this._then);

  final FamilyMember _self;
  final $Res Function(FamilyMember) _then;

/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? arabic = null,Object? transliteration = null,Object? kunya = freezed,Object? laqab = null,Object? role = null,Object? birth = freezed,Object? death = freezed,Object? bio = freezed,Object? generation = freezed,Object? marriageOrder = freezed,Object? parentId = freezed,Object? motherId = freezed,Object? spouseOf = freezed,Object? parentIds = null,Object? isBoundary = null,Object? isTraditional = null,Object? variant = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,arabic: null == arabic ? _self.arabic : arabic // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,kunya: freezed == kunya ? _self.kunya : kunya // ignore: cast_nullable_to_non_nullable
as String?,laqab: null == laqab ? _self.laqab : laqab // ignore: cast_nullable_to_non_nullable
as List<String>,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,death: freezed == death ? _self.death : death // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,generation: freezed == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as int?,marriageOrder: freezed == marriageOrder ? _self.marriageOrder : marriageOrder // ignore: cast_nullable_to_non_nullable
as int?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,motherId: freezed == motherId ? _self.motherId : motherId // ignore: cast_nullable_to_non_nullable
as String?,spouseOf: freezed == spouseOf ? _self.spouseOf : spouseOf // ignore: cast_nullable_to_non_nullable
as String?,parentIds: null == parentIds ? _self.parentIds : parentIds // ignore: cast_nullable_to_non_nullable
as List<String>,isBoundary: null == isBoundary ? _self.isBoundary : isBoundary // ignore: cast_nullable_to_non_nullable
as bool,isTraditional: null == isTraditional ? _self.isTraditional : isTraditional // ignore: cast_nullable_to_non_nullable
as bool,variant: freezed == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyMember].
extension FamilyMemberPatterns on FamilyMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyMember value)  $default,){
final _that = this;
switch (_that) {
case _FamilyMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyMember value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String arabic,  String transliteration,  String? kunya,  List<String> laqab,  FamilyRole role,  String? birth,  String? death,  String? bio,  int? generation,  int? marriageOrder,  String? parentId,  String? motherId,  String? spouseOf,  List<String> parentIds,  bool isBoundary,  bool isTraditional,  String? variant)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
return $default(_that.id,_that.arabic,_that.transliteration,_that.kunya,_that.laqab,_that.role,_that.birth,_that.death,_that.bio,_that.generation,_that.marriageOrder,_that.parentId,_that.motherId,_that.spouseOf,_that.parentIds,_that.isBoundary,_that.isTraditional,_that.variant);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String arabic,  String transliteration,  String? kunya,  List<String> laqab,  FamilyRole role,  String? birth,  String? death,  String? bio,  int? generation,  int? marriageOrder,  String? parentId,  String? motherId,  String? spouseOf,  List<String> parentIds,  bool isBoundary,  bool isTraditional,  String? variant)  $default,) {final _that = this;
switch (_that) {
case _FamilyMember():
return $default(_that.id,_that.arabic,_that.transliteration,_that.kunya,_that.laqab,_that.role,_that.birth,_that.death,_that.bio,_that.generation,_that.marriageOrder,_that.parentId,_that.motherId,_that.spouseOf,_that.parentIds,_that.isBoundary,_that.isTraditional,_that.variant);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String arabic,  String transliteration,  String? kunya,  List<String> laqab,  FamilyRole role,  String? birth,  String? death,  String? bio,  int? generation,  int? marriageOrder,  String? parentId,  String? motherId,  String? spouseOf,  List<String> parentIds,  bool isBoundary,  bool isTraditional,  String? variant)?  $default,) {final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
return $default(_that.id,_that.arabic,_that.transliteration,_that.kunya,_that.laqab,_that.role,_that.birth,_that.death,_that.bio,_that.generation,_that.marriageOrder,_that.parentId,_that.motherId,_that.spouseOf,_that.parentIds,_that.isBoundary,_that.isTraditional,_that.variant);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FamilyMember implements FamilyMember {
  const _FamilyMember({required this.id, required this.arabic, required this.transliteration, this.kunya, final  List<String> laqab = const [], required this.role, this.birth, this.death, this.bio, this.generation, this.marriageOrder, this.parentId, this.motherId, this.spouseOf, final  List<String> parentIds = const [], this.isBoundary = false, this.isTraditional = false, this.variant}): _laqab = laqab,_parentIds = parentIds;
  factory _FamilyMember.fromJson(Map<String, dynamic> json) => _$FamilyMemberFromJson(json);

@override final  String id;
@override final  String arabic;
@override final  String transliteration;
@override final  String? kunya;
 final  List<String> _laqab;
@override@JsonKey() List<String> get laqab {
  if (_laqab is EqualUnmodifiableListView) return _laqab;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_laqab);
}

@override final  FamilyRole role;
@override final  String? birth;
@override final  String? death;
@override final  String? bio;
@override final  int? generation;
@override final  int? marriageOrder;
// Graph edges — used for BFS path traversal
@override final  String? parentId;
@override final  String? motherId;
@override final  String? spouseOf;
 final  List<String> _parentIds;
@override@JsonKey() List<String> get parentIds {
  if (_parentIds is EqualUnmodifiableListView) return _parentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parentIds);
}

@override@JsonKey() final  bool isBoundary;
@override@JsonKey() final  bool isTraditional;
@override final  String? variant;

/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyMemberCopyWith<_FamilyMember> get copyWith => __$FamilyMemberCopyWithImpl<_FamilyMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FamilyMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyMember&&(identical(other.id, id) || other.id == id)&&(identical(other.arabic, arabic) || other.arabic == arabic)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.kunya, kunya) || other.kunya == kunya)&&const DeepCollectionEquality().equals(other._laqab, _laqab)&&(identical(other.role, role) || other.role == role)&&(identical(other.birth, birth) || other.birth == birth)&&(identical(other.death, death) || other.death == death)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.generation, generation) || other.generation == generation)&&(identical(other.marriageOrder, marriageOrder) || other.marriageOrder == marriageOrder)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.motherId, motherId) || other.motherId == motherId)&&(identical(other.spouseOf, spouseOf) || other.spouseOf == spouseOf)&&const DeepCollectionEquality().equals(other._parentIds, _parentIds)&&(identical(other.isBoundary, isBoundary) || other.isBoundary == isBoundary)&&(identical(other.isTraditional, isTraditional) || other.isTraditional == isTraditional)&&(identical(other.variant, variant) || other.variant == variant));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,arabic,transliteration,kunya,const DeepCollectionEquality().hash(_laqab),role,birth,death,bio,generation,marriageOrder,parentId,motherId,spouseOf,const DeepCollectionEquality().hash(_parentIds),isBoundary,isTraditional,variant);

@override
String toString() {
  return 'FamilyMember(id: $id, arabic: $arabic, transliteration: $transliteration, kunya: $kunya, laqab: $laqab, role: $role, birth: $birth, death: $death, bio: $bio, generation: $generation, marriageOrder: $marriageOrder, parentId: $parentId, motherId: $motherId, spouseOf: $spouseOf, parentIds: $parentIds, isBoundary: $isBoundary, isTraditional: $isTraditional, variant: $variant)';
}


}

/// @nodoc
abstract mixin class _$FamilyMemberCopyWith<$Res> implements $FamilyMemberCopyWith<$Res> {
  factory _$FamilyMemberCopyWith(_FamilyMember value, $Res Function(_FamilyMember) _then) = __$FamilyMemberCopyWithImpl;
@override @useResult
$Res call({
 String id, String arabic, String transliteration, String? kunya, List<String> laqab, FamilyRole role, String? birth, String? death, String? bio, int? generation, int? marriageOrder, String? parentId, String? motherId, String? spouseOf, List<String> parentIds, bool isBoundary, bool isTraditional, String? variant
});




}
/// @nodoc
class __$FamilyMemberCopyWithImpl<$Res>
    implements _$FamilyMemberCopyWith<$Res> {
  __$FamilyMemberCopyWithImpl(this._self, this._then);

  final _FamilyMember _self;
  final $Res Function(_FamilyMember) _then;

/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? arabic = null,Object? transliteration = null,Object? kunya = freezed,Object? laqab = null,Object? role = null,Object? birth = freezed,Object? death = freezed,Object? bio = freezed,Object? generation = freezed,Object? marriageOrder = freezed,Object? parentId = freezed,Object? motherId = freezed,Object? spouseOf = freezed,Object? parentIds = null,Object? isBoundary = null,Object? isTraditional = null,Object? variant = freezed,}) {
  return _then(_FamilyMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,arabic: null == arabic ? _self.arabic : arabic // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,kunya: freezed == kunya ? _self.kunya : kunya // ignore: cast_nullable_to_non_nullable
as String?,laqab: null == laqab ? _self._laqab : laqab // ignore: cast_nullable_to_non_nullable
as List<String>,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,birth: freezed == birth ? _self.birth : birth // ignore: cast_nullable_to_non_nullable
as String?,death: freezed == death ? _self.death : death // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,generation: freezed == generation ? _self.generation : generation // ignore: cast_nullable_to_non_nullable
as int?,marriageOrder: freezed == marriageOrder ? _self.marriageOrder : marriageOrder // ignore: cast_nullable_to_non_nullable
as int?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,motherId: freezed == motherId ? _self.motherId : motherId // ignore: cast_nullable_to_non_nullable
as String?,spouseOf: freezed == spouseOf ? _self.spouseOf : spouseOf // ignore: cast_nullable_to_non_nullable
as String?,parentIds: null == parentIds ? _self._parentIds : parentIds // ignore: cast_nullable_to_non_nullable
as List<String>,isBoundary: null == isBoundary ? _self.isBoundary : isBoundary // ignore: cast_nullable_to_non_nullable
as bool,isTraditional: null == isTraditional ? _self.isTraditional : isTraditional // ignore: cast_nullable_to_non_nullable
as bool,variant: freezed == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
