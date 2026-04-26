// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserState {

 ThemeKey get theme; TextSize get textSize; Set<int> get favorites; Set<int> get learned; Set<int> get viewed; Map<int, DateTime> get lastSeen; DateTime? get onboardingCompletedAt; int? get dailyNotifHour; int get quizzesCompleted; int get totalQuizScore;// Genealogy module
 Set<String> get favoriteMembers; Set<String> get viewedMembers; String get preferredTreeView;
/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStateCopyWith<UserState> get copyWith => _$UserStateCopyWithImpl<UserState>(this as UserState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserState&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.textSize, textSize) || other.textSize == textSize)&&const DeepCollectionEquality().equals(other.favorites, favorites)&&const DeepCollectionEquality().equals(other.learned, learned)&&const DeepCollectionEquality().equals(other.viewed, viewed)&&const DeepCollectionEquality().equals(other.lastSeen, lastSeen)&&(identical(other.onboardingCompletedAt, onboardingCompletedAt) || other.onboardingCompletedAt == onboardingCompletedAt)&&(identical(other.dailyNotifHour, dailyNotifHour) || other.dailyNotifHour == dailyNotifHour)&&(identical(other.quizzesCompleted, quizzesCompleted) || other.quizzesCompleted == quizzesCompleted)&&(identical(other.totalQuizScore, totalQuizScore) || other.totalQuizScore == totalQuizScore)&&const DeepCollectionEquality().equals(other.favoriteMembers, favoriteMembers)&&const DeepCollectionEquality().equals(other.viewedMembers, viewedMembers)&&(identical(other.preferredTreeView, preferredTreeView) || other.preferredTreeView == preferredTreeView));
}


@override
int get hashCode => Object.hash(runtimeType,theme,textSize,const DeepCollectionEquality().hash(favorites),const DeepCollectionEquality().hash(learned),const DeepCollectionEquality().hash(viewed),const DeepCollectionEquality().hash(lastSeen),onboardingCompletedAt,dailyNotifHour,quizzesCompleted,totalQuizScore,const DeepCollectionEquality().hash(favoriteMembers),const DeepCollectionEquality().hash(viewedMembers),preferredTreeView);

@override
String toString() {
  return 'UserState(theme: $theme, textSize: $textSize, favorites: $favorites, learned: $learned, viewed: $viewed, lastSeen: $lastSeen, onboardingCompletedAt: $onboardingCompletedAt, dailyNotifHour: $dailyNotifHour, quizzesCompleted: $quizzesCompleted, totalQuizScore: $totalQuizScore, favoriteMembers: $favoriteMembers, viewedMembers: $viewedMembers, preferredTreeView: $preferredTreeView)';
}


}

/// @nodoc
abstract mixin class $UserStateCopyWith<$Res>  {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) _then) = _$UserStateCopyWithImpl;
@useResult
$Res call({
 ThemeKey theme, TextSize textSize, Set<int> favorites, Set<int> learned, Set<int> viewed, Map<int, DateTime> lastSeen, DateTime? onboardingCompletedAt, int? dailyNotifHour, int quizzesCompleted, int totalQuizScore, Set<String> favoriteMembers, Set<String> viewedMembers, String preferredTreeView
});




}
/// @nodoc
class _$UserStateCopyWithImpl<$Res>
    implements $UserStateCopyWith<$Res> {
  _$UserStateCopyWithImpl(this._self, this._then);

  final UserState _self;
  final $Res Function(UserState) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? theme = null,Object? textSize = null,Object? favorites = null,Object? learned = null,Object? viewed = null,Object? lastSeen = null,Object? onboardingCompletedAt = freezed,Object? dailyNotifHour = freezed,Object? quizzesCompleted = null,Object? totalQuizScore = null,Object? favoriteMembers = null,Object? viewedMembers = null,Object? preferredTreeView = null,}) {
  return _then(_self.copyWith(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeKey,textSize: null == textSize ? _self.textSize : textSize // ignore: cast_nullable_to_non_nullable
as TextSize,favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as Set<int>,learned: null == learned ? _self.learned : learned // ignore: cast_nullable_to_non_nullable
as Set<int>,viewed: null == viewed ? _self.viewed : viewed // ignore: cast_nullable_to_non_nullable
as Set<int>,lastSeen: null == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as Map<int, DateTime>,onboardingCompletedAt: freezed == onboardingCompletedAt ? _self.onboardingCompletedAt : onboardingCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dailyNotifHour: freezed == dailyNotifHour ? _self.dailyNotifHour : dailyNotifHour // ignore: cast_nullable_to_non_nullable
as int?,quizzesCompleted: null == quizzesCompleted ? _self.quizzesCompleted : quizzesCompleted // ignore: cast_nullable_to_non_nullable
as int,totalQuizScore: null == totalQuizScore ? _self.totalQuizScore : totalQuizScore // ignore: cast_nullable_to_non_nullable
as int,favoriteMembers: null == favoriteMembers ? _self.favoriteMembers : favoriteMembers // ignore: cast_nullable_to_non_nullable
as Set<String>,viewedMembers: null == viewedMembers ? _self.viewedMembers : viewedMembers // ignore: cast_nullable_to_non_nullable
as Set<String>,preferredTreeView: null == preferredTreeView ? _self.preferredTreeView : preferredTreeView // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserState].
extension UserStatePatterns on UserState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserState value)  $default,){
final _that = this;
switch (_that) {
case _UserState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserState value)?  $default,){
final _that = this;
switch (_that) {
case _UserState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeKey theme,  TextSize textSize,  Set<int> favorites,  Set<int> learned,  Set<int> viewed,  Map<int, DateTime> lastSeen,  DateTime? onboardingCompletedAt,  int? dailyNotifHour,  int quizzesCompleted,  int totalQuizScore,  Set<String> favoriteMembers,  Set<String> viewedMembers,  String preferredTreeView)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserState() when $default != null:
return $default(_that.theme,_that.textSize,_that.favorites,_that.learned,_that.viewed,_that.lastSeen,_that.onboardingCompletedAt,_that.dailyNotifHour,_that.quizzesCompleted,_that.totalQuizScore,_that.favoriteMembers,_that.viewedMembers,_that.preferredTreeView);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeKey theme,  TextSize textSize,  Set<int> favorites,  Set<int> learned,  Set<int> viewed,  Map<int, DateTime> lastSeen,  DateTime? onboardingCompletedAt,  int? dailyNotifHour,  int quizzesCompleted,  int totalQuizScore,  Set<String> favoriteMembers,  Set<String> viewedMembers,  String preferredTreeView)  $default,) {final _that = this;
switch (_that) {
case _UserState():
return $default(_that.theme,_that.textSize,_that.favorites,_that.learned,_that.viewed,_that.lastSeen,_that.onboardingCompletedAt,_that.dailyNotifHour,_that.quizzesCompleted,_that.totalQuizScore,_that.favoriteMembers,_that.viewedMembers,_that.preferredTreeView);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeKey theme,  TextSize textSize,  Set<int> favorites,  Set<int> learned,  Set<int> viewed,  Map<int, DateTime> lastSeen,  DateTime? onboardingCompletedAt,  int? dailyNotifHour,  int quizzesCompleted,  int totalQuizScore,  Set<String> favoriteMembers,  Set<String> viewedMembers,  String preferredTreeView)?  $default,) {final _that = this;
switch (_that) {
case _UserState() when $default != null:
return $default(_that.theme,_that.textSize,_that.favorites,_that.learned,_that.viewed,_that.lastSeen,_that.onboardingCompletedAt,_that.dailyNotifHour,_that.quizzesCompleted,_that.totalQuizScore,_that.favoriteMembers,_that.viewedMembers,_that.preferredTreeView);case _:
  return null;

}
}

}

/// @nodoc


class _UserState implements UserState {
  const _UserState({this.theme = ThemeKey.light, this.textSize = TextSize.medium, final  Set<int> favorites = const {}, final  Set<int> learned = const {}, final  Set<int> viewed = const {}, final  Map<int, DateTime> lastSeen = const {}, this.onboardingCompletedAt, this.dailyNotifHour, this.quizzesCompleted = 0, this.totalQuizScore = 0, final  Set<String> favoriteMembers = const {}, final  Set<String> viewedMembers = const {}, this.preferredTreeView = 'radial'}): _favorites = favorites,_learned = learned,_viewed = viewed,_lastSeen = lastSeen,_favoriteMembers = favoriteMembers,_viewedMembers = viewedMembers;
  

@override@JsonKey() final  ThemeKey theme;
@override@JsonKey() final  TextSize textSize;
 final  Set<int> _favorites;
@override@JsonKey() Set<int> get favorites {
  if (_favorites is EqualUnmodifiableSetView) return _favorites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_favorites);
}

 final  Set<int> _learned;
@override@JsonKey() Set<int> get learned {
  if (_learned is EqualUnmodifiableSetView) return _learned;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_learned);
}

 final  Set<int> _viewed;
@override@JsonKey() Set<int> get viewed {
  if (_viewed is EqualUnmodifiableSetView) return _viewed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_viewed);
}

 final  Map<int, DateTime> _lastSeen;
@override@JsonKey() Map<int, DateTime> get lastSeen {
  if (_lastSeen is EqualUnmodifiableMapView) return _lastSeen;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_lastSeen);
}

@override final  DateTime? onboardingCompletedAt;
@override final  int? dailyNotifHour;
@override@JsonKey() final  int quizzesCompleted;
@override@JsonKey() final  int totalQuizScore;
// Genealogy module
 final  Set<String> _favoriteMembers;
// Genealogy module
@override@JsonKey() Set<String> get favoriteMembers {
  if (_favoriteMembers is EqualUnmodifiableSetView) return _favoriteMembers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_favoriteMembers);
}

 final  Set<String> _viewedMembers;
@override@JsonKey() Set<String> get viewedMembers {
  if (_viewedMembers is EqualUnmodifiableSetView) return _viewedMembers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_viewedMembers);
}

@override@JsonKey() final  String preferredTreeView;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStateCopyWith<_UserState> get copyWith => __$UserStateCopyWithImpl<_UserState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserState&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.textSize, textSize) || other.textSize == textSize)&&const DeepCollectionEquality().equals(other._favorites, _favorites)&&const DeepCollectionEquality().equals(other._learned, _learned)&&const DeepCollectionEquality().equals(other._viewed, _viewed)&&const DeepCollectionEquality().equals(other._lastSeen, _lastSeen)&&(identical(other.onboardingCompletedAt, onboardingCompletedAt) || other.onboardingCompletedAt == onboardingCompletedAt)&&(identical(other.dailyNotifHour, dailyNotifHour) || other.dailyNotifHour == dailyNotifHour)&&(identical(other.quizzesCompleted, quizzesCompleted) || other.quizzesCompleted == quizzesCompleted)&&(identical(other.totalQuizScore, totalQuizScore) || other.totalQuizScore == totalQuizScore)&&const DeepCollectionEquality().equals(other._favoriteMembers, _favoriteMembers)&&const DeepCollectionEquality().equals(other._viewedMembers, _viewedMembers)&&(identical(other.preferredTreeView, preferredTreeView) || other.preferredTreeView == preferredTreeView));
}


@override
int get hashCode => Object.hash(runtimeType,theme,textSize,const DeepCollectionEquality().hash(_favorites),const DeepCollectionEquality().hash(_learned),const DeepCollectionEquality().hash(_viewed),const DeepCollectionEquality().hash(_lastSeen),onboardingCompletedAt,dailyNotifHour,quizzesCompleted,totalQuizScore,const DeepCollectionEquality().hash(_favoriteMembers),const DeepCollectionEquality().hash(_viewedMembers),preferredTreeView);

@override
String toString() {
  return 'UserState(theme: $theme, textSize: $textSize, favorites: $favorites, learned: $learned, viewed: $viewed, lastSeen: $lastSeen, onboardingCompletedAt: $onboardingCompletedAt, dailyNotifHour: $dailyNotifHour, quizzesCompleted: $quizzesCompleted, totalQuizScore: $totalQuizScore, favoriteMembers: $favoriteMembers, viewedMembers: $viewedMembers, preferredTreeView: $preferredTreeView)';
}


}

/// @nodoc
abstract mixin class _$UserStateCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory _$UserStateCopyWith(_UserState value, $Res Function(_UserState) _then) = __$UserStateCopyWithImpl;
@override @useResult
$Res call({
 ThemeKey theme, TextSize textSize, Set<int> favorites, Set<int> learned, Set<int> viewed, Map<int, DateTime> lastSeen, DateTime? onboardingCompletedAt, int? dailyNotifHour, int quizzesCompleted, int totalQuizScore, Set<String> favoriteMembers, Set<String> viewedMembers, String preferredTreeView
});




}
/// @nodoc
class __$UserStateCopyWithImpl<$Res>
    implements _$UserStateCopyWith<$Res> {
  __$UserStateCopyWithImpl(this._self, this._then);

  final _UserState _self;
  final $Res Function(_UserState) _then;

/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? theme = null,Object? textSize = null,Object? favorites = null,Object? learned = null,Object? viewed = null,Object? lastSeen = null,Object? onboardingCompletedAt = freezed,Object? dailyNotifHour = freezed,Object? quizzesCompleted = null,Object? totalQuizScore = null,Object? favoriteMembers = null,Object? viewedMembers = null,Object? preferredTreeView = null,}) {
  return _then(_UserState(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeKey,textSize: null == textSize ? _self.textSize : textSize // ignore: cast_nullable_to_non_nullable
as TextSize,favorites: null == favorites ? _self._favorites : favorites // ignore: cast_nullable_to_non_nullable
as Set<int>,learned: null == learned ? _self._learned : learned // ignore: cast_nullable_to_non_nullable
as Set<int>,viewed: null == viewed ? _self._viewed : viewed // ignore: cast_nullable_to_non_nullable
as Set<int>,lastSeen: null == lastSeen ? _self._lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as Map<int, DateTime>,onboardingCompletedAt: freezed == onboardingCompletedAt ? _self.onboardingCompletedAt : onboardingCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dailyNotifHour: freezed == dailyNotifHour ? _self.dailyNotifHour : dailyNotifHour // ignore: cast_nullable_to_non_nullable
as int?,quizzesCompleted: null == quizzesCompleted ? _self.quizzesCompleted : quizzesCompleted // ignore: cast_nullable_to_non_nullable
as int,totalQuizScore: null == totalQuizScore ? _self.totalQuizScore : totalQuizScore // ignore: cast_nullable_to_non_nullable
as int,favoriteMembers: null == favoriteMembers ? _self._favoriteMembers : favoriteMembers // ignore: cast_nullable_to_non_nullable
as Set<String>,viewedMembers: null == viewedMembers ? _self._viewedMembers : viewedMembers // ignore: cast_nullable_to_non_nullable
as Set<String>,preferredTreeView: null == preferredTreeView ? _self.preferredTreeView : preferredTreeView // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
