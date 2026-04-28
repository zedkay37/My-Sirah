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

 String get theme; List<String> get actions;
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
 String theme, List<String> actions
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
as List<String>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String theme,  List<String> actions)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String theme,  List<String> actions)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String theme,  List<String> actions)?  $default,) {final _that = this;
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
  const _NameActionBank({required this.theme, final  List<String> actions = const []}): _actions = actions;
  factory _NameActionBank.fromJson(Map<String, dynamic> json) => _$NameActionBankFromJson(json);

@override final  String theme;
 final  List<String> _actions;
@override@JsonKey() List<String> get actions {
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
 String theme, List<String> actions
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
as List<String>,
  ));
}


}

// dart format on
