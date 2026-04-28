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

 ThemeKey get theme; TextSize get textSize; Set<int> get favorites; Set<int> get learned; Set<int> get viewed; Set<int> get meditatedNames; Set<int> get practicedNames; Set<int> get recognizedNames; Map<int, DateTime> get lastSeen; DateTime? get onboardingCompletedAt; int? get dailyNotifHour; int get quizzesCompleted; int get totalQuizScore;// Genealogy module
 Set<String> get favoriteMembers; Set<String> get viewedMembers; String get preferredTreeView;// Study module — V1.3
 Map<int, int> get leitnerBoxes; Set<String> get completedParcours; String get studyMode;// Asmāʾ al-Ḥusnā — V1.4
 Set<int> get husnaLearned;
/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStateCopyWith<UserState> get copyWith => _$UserStateCopyWithImpl<UserState>(this as UserState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserState&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.textSize, textSize) || other.textSize == textSize)&&const DeepCollectionEquality().equals(other.favorites, favorites)&&const DeepCollectionEquality().equals(other.learned, learned)&&const DeepCollectionEquality().equals(other.viewed, viewed)&&const DeepCollectionEquality().equals(other.meditatedNames, meditatedNames)&&const DeepCollectionEquality().equals(other.practicedNames, practicedNames)&&const DeepCollectionEquality().equals(other.recognizedNames, recognizedNames)&&const DeepCollectionEquality().equals(other.lastSeen, lastSeen)&&(identical(other.onboardingCompletedAt, onboardingCompletedAt) || other.onboardingCompletedAt == onboardingCompletedAt)&&(identical(other.dailyNotifHour, dailyNotifHour) || other.dailyNotifHour == dailyNotifHour)&&(identical(other.quizzesCompleted, quizzesCompleted) || other.quizzesCompleted == quizzesCompleted)&&(identical(other.totalQuizScore, totalQuizScore) || other.totalQuizScore == totalQuizScore)&&const DeepCollectionEquality().equals(other.favoriteMembers, favoriteMembers)&&const DeepCollectionEquality().equals(other.viewedMembers, viewedMembers)&&(identical(other.preferredTreeView, preferredTreeView) || other.preferredTreeView == preferredTreeView)&&const DeepCollectionEquality().equals(other.leitnerBoxes, leitnerBoxes)&&const DeepCollectionEquality().equals(other.completedParcours, completedParcours)&&(identical(other.studyMode, studyMode) || other.studyMode == studyMode)&&const DeepCollectionEquality().equals(other.husnaLearned, husnaLearned));
}


@override
int get hashCode => Object.hashAll([runtimeType,theme,textSize,const DeepCollectionEquality().hash(favorites),const DeepCollectionEquality().hash(learned),const DeepCollectionEquality().hash(viewed),const DeepCollectionEquality().hash(meditatedNames),const DeepCollectionEquality().hash(practicedNames),const DeepCollectionEquality().hash(recognizedNames),const DeepCollectionEquality().hash(lastSeen),onboardingCompletedAt,dailyNotifHour,quizzesCompleted,totalQuizScore,const DeepCollectionEquality().hash(favoriteMembers),const DeepCollectionEquality().hash(viewedMembers),preferredTreeView,const DeepCollectionEquality().hash(leitnerBoxes),const DeepCollectionEquality().hash(completedParcours),studyMode,const DeepCollectionEquality().hash(husnaLearned)]);

@override
String toString() {
  return 'UserState(theme: $theme, textSize: $textSize, favorites: $favorites, learned: $learned, viewed: $viewed, meditatedNames: $meditatedNames, practicedNames: $practicedNames, recognizedNames: $recognizedNames, lastSeen: $lastSeen, onboardingCompletedAt: $onboardingCompletedAt, dailyNotifHour: $dailyNotifHour, quizzesCompleted: $quizzesCompleted, totalQuizScore: $totalQuizScore, favoriteMembers: $favoriteMembers, viewedMembers: $viewedMembers, preferredTreeView: $preferredTreeView, leitnerBoxes: $leitnerBoxes, completedParcours: $completedParcours, studyMode: $studyMode, husnaLearned: $husnaLearned)';
}


}

/// @nodoc
abstract mixin class $UserStateCopyWith<$Res>  {
  factory $UserStateCopyWith(UserState value, $Res Function(UserState) _then) = _$UserStateCopyWithImpl;
@useResult
$Res call({
 ThemeKey theme, TextSize textSize, Set<int> favorites, Set<int> learned, Set<int> viewed, Set<int> meditatedNames, Set<int> practicedNames, Set<int> recognizedNames, Map<int, DateTime> lastSeen, DateTime? onboardingCompletedAt, int? dailyNotifHour, int quizzesCompleted, int totalQuizScore, Set<String> favoriteMembers, Set<String> viewedMembers, String preferredTreeView, Map<int, int> leitnerBoxes, Set<String> completedParcours, String studyMode, Set<int> husnaLearned
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
@pragma('vm:prefer-inline') @override $Res call({Object? theme = null,Object? textSize = null,Object? favorites = null,Object? learned = null,Object? viewed = null,Object? meditatedNames = null,Object? practicedNames = null,Object? recognizedNames = null,Object? lastSeen = null,Object? onboardingCompletedAt = freezed,Object? dailyNotifHour = freezed,Object? quizzesCompleted = null,Object? totalQuizScore = null,Object? favoriteMembers = null,Object? viewedMembers = null,Object? preferredTreeView = null,Object? leitnerBoxes = null,Object? completedParcours = null,Object? studyMode = null,Object? husnaLearned = null,}) {
  return _then(_self.copyWith(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeKey,textSize: null == textSize ? _self.textSize : textSize // ignore: cast_nullable_to_non_nullable
as TextSize,favorites: null == favorites ? _self.favorites : favorites // ignore: cast_nullable_to_non_nullable
as Set<int>,learned: null == learned ? _self.learned : learned // ignore: cast_nullable_to_non_nullable
as Set<int>,viewed: null == viewed ? _self.viewed : viewed // ignore: cast_nullable_to_non_nullable
as Set<int>,meditatedNames: null == meditatedNames ? _self.meditatedNames : meditatedNames // ignore: cast_nullable_to_non_nullable
as Set<int>,practicedNames: null == practicedNames ? _self.practicedNames : practicedNames // ignore: cast_nullable_to_non_nullable
as Set<int>,recognizedNames: null == recognizedNames ? _self.recognizedNames : recognizedNames // ignore: cast_nullable_to_non_nullable
as Set<int>,lastSeen: null == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as Map<int, DateTime>,onboardingCompletedAt: freezed == onboardingCompletedAt ? _self.onboardingCompletedAt : onboardingCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dailyNotifHour: freezed == dailyNotifHour ? _self.dailyNotifHour : dailyNotifHour // ignore: cast_nullable_to_non_nullable
as int?,quizzesCompleted: null == quizzesCompleted ? _self.quizzesCompleted : quizzesCompleted // ignore: cast_nullable_to_non_nullable
as int,totalQuizScore: null == totalQuizScore ? _self.totalQuizScore : totalQuizScore // ignore: cast_nullable_to_non_nullable
as int,favoriteMembers: null == favoriteMembers ? _self.favoriteMembers : favoriteMembers // ignore: cast_nullable_to_non_nullable
as Set<String>,viewedMembers: null == viewedMembers ? _self.viewedMembers : viewedMembers // ignore: cast_nullable_to_non_nullable
as Set<String>,preferredTreeView: null == preferredTreeView ? _self.preferredTreeView : preferredTreeView // ignore: cast_nullable_to_non_nullable
as String,leitnerBoxes: null == leitnerBoxes ? _self.leitnerBoxes : leitnerBoxes // ignore: cast_nullable_to_non_nullable
as Map<int, int>,completedParcours: null == completedParcours ? _self.completedParcours : completedParcours // ignore: cast_nullable_to_non_nullable
as Set<String>,studyMode: null == studyMode ? _self.studyMode : studyMode // ignore: cast_nullable_to_non_nullable
as String,husnaLearned: null == husnaLearned ? _self.husnaLearned : husnaLearned // ignore: cast_nullable_to_non_nullable
as Set<int>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeKey theme,  TextSize textSize,  Set<int> favorites,  Set<int> learned,  Set<int> viewed,  Set<int> meditatedNames,  Set<int> practicedNames,  Set<int> recognizedNames,  Map<int, DateTime> lastSeen,  DateTime? onboardingCompletedAt,  int? dailyNotifHour,  int quizzesCompleted,  int totalQuizScore,  Set<String> favoriteMembers,  Set<String> viewedMembers,  String preferredTreeView,  Map<int, int> leitnerBoxes,  Set<String> completedParcours,  String studyMode,  Set<int> husnaLearned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserState() when $default != null:
return $default(_that.theme,_that.textSize,_that.favorites,_that.learned,_that.viewed,_that.meditatedNames,_that.practicedNames,_that.recognizedNames,_that.lastSeen,_that.onboardingCompletedAt,_that.dailyNotifHour,_that.quizzesCompleted,_that.totalQuizScore,_that.favoriteMembers,_that.viewedMembers,_that.preferredTreeView,_that.leitnerBoxes,_that.completedParcours,_that.studyMode,_that.husnaLearned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeKey theme,  TextSize textSize,  Set<int> favorites,  Set<int> learned,  Set<int> viewed,  Set<int> meditatedNames,  Set<int> practicedNames,  Set<int> recognizedNames,  Map<int, DateTime> lastSeen,  DateTime? onboardingCompletedAt,  int? dailyNotifHour,  int quizzesCompleted,  int totalQuizScore,  Set<String> favoriteMembers,  Set<String> viewedMembers,  String preferredTreeView,  Map<int, int> leitnerBoxes,  Set<String> completedParcours,  String studyMode,  Set<int> husnaLearned)  $default,) {final _that = this;
switch (_that) {
case _UserState():
return $default(_that.theme,_that.textSize,_that.favorites,_that.learned,_that.viewed,_that.meditatedNames,_that.practicedNames,_that.recognizedNames,_that.lastSeen,_that.onboardingCompletedAt,_that.dailyNotifHour,_that.quizzesCompleted,_that.totalQuizScore,_that.favoriteMembers,_that.viewedMembers,_that.preferredTreeView,_that.leitnerBoxes,_that.completedParcours,_that.studyMode,_that.husnaLearned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeKey theme,  TextSize textSize,  Set<int> favorites,  Set<int> learned,  Set<int> viewed,  Set<int> meditatedNames,  Set<int> practicedNames,  Set<int> recognizedNames,  Map<int, DateTime> lastSeen,  DateTime? onboardingCompletedAt,  int? dailyNotifHour,  int quizzesCompleted,  int totalQuizScore,  Set<String> favoriteMembers,  Set<String> viewedMembers,  String preferredTreeView,  Map<int, int> leitnerBoxes,  Set<String> completedParcours,  String studyMode,  Set<int> husnaLearned)?  $default,) {final _that = this;
switch (_that) {
case _UserState() when $default != null:
return $default(_that.theme,_that.textSize,_that.favorites,_that.learned,_that.viewed,_that.meditatedNames,_that.practicedNames,_that.recognizedNames,_that.lastSeen,_that.onboardingCompletedAt,_that.dailyNotifHour,_that.quizzesCompleted,_that.totalQuizScore,_that.favoriteMembers,_that.viewedMembers,_that.preferredTreeView,_that.leitnerBoxes,_that.completedParcours,_that.studyMode,_that.husnaLearned);case _:
  return null;

}
}

}

/// @nodoc


class _UserState implements UserState {
  const _UserState({this.theme = ThemeKey.light, this.textSize = TextSize.medium, final  Set<int> favorites = const {}, final  Set<int> learned = const {}, final  Set<int> viewed = const {}, final  Set<int> meditatedNames = const {}, final  Set<int> practicedNames = const {}, final  Set<int> recognizedNames = const {}, final  Map<int, DateTime> lastSeen = const {}, this.onboardingCompletedAt, this.dailyNotifHour, this.quizzesCompleted = 0, this.totalQuizScore = 0, final  Set<String> favoriteMembers = const {}, final  Set<String> viewedMembers = const {}, this.preferredTreeView = 'radial', final  Map<int, int> leitnerBoxes = const {}, final  Set<String> completedParcours = const {}, this.studyMode = 'random', final  Set<int> husnaLearned = const {}}): _favorites = favorites,_learned = learned,_viewed = viewed,_meditatedNames = meditatedNames,_practicedNames = practicedNames,_recognizedNames = recognizedNames,_lastSeen = lastSeen,_favoriteMembers = favoriteMembers,_viewedMembers = viewedMembers,_leitnerBoxes = leitnerBoxes,_completedParcours = completedParcours,_husnaLearned = husnaLearned;
  

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

 final  Set<int> _meditatedNames;
@override@JsonKey() Set<int> get meditatedNames {
  if (_meditatedNames is EqualUnmodifiableSetView) return _meditatedNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_meditatedNames);
}

 final  Set<int> _practicedNames;
@override@JsonKey() Set<int> get practicedNames {
  if (_practicedNames is EqualUnmodifiableSetView) return _practicedNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_practicedNames);
}

 final  Set<int> _recognizedNames;
@override@JsonKey() Set<int> get recognizedNames {
  if (_recognizedNames is EqualUnmodifiableSetView) return _recognizedNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_recognizedNames);
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
// Study module — V1.3
 final  Map<int, int> _leitnerBoxes;
// Study module — V1.3
@override@JsonKey() Map<int, int> get leitnerBoxes {
  if (_leitnerBoxes is EqualUnmodifiableMapView) return _leitnerBoxes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_leitnerBoxes);
}

 final  Set<String> _completedParcours;
@override@JsonKey() Set<String> get completedParcours {
  if (_completedParcours is EqualUnmodifiableSetView) return _completedParcours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_completedParcours);
}

@override@JsonKey() final  String studyMode;
// Asmāʾ al-Ḥusnā — V1.4
 final  Set<int> _husnaLearned;
// Asmāʾ al-Ḥusnā — V1.4
@override@JsonKey() Set<int> get husnaLearned {
  if (_husnaLearned is EqualUnmodifiableSetView) return _husnaLearned;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_husnaLearned);
}


/// Create a copy of UserState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStateCopyWith<_UserState> get copyWith => __$UserStateCopyWithImpl<_UserState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserState&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.textSize, textSize) || other.textSize == textSize)&&const DeepCollectionEquality().equals(other._favorites, _favorites)&&const DeepCollectionEquality().equals(other._learned, _learned)&&const DeepCollectionEquality().equals(other._viewed, _viewed)&&const DeepCollectionEquality().equals(other._meditatedNames, _meditatedNames)&&const DeepCollectionEquality().equals(other._practicedNames, _practicedNames)&&const DeepCollectionEquality().equals(other._recognizedNames, _recognizedNames)&&const DeepCollectionEquality().equals(other._lastSeen, _lastSeen)&&(identical(other.onboardingCompletedAt, onboardingCompletedAt) || other.onboardingCompletedAt == onboardingCompletedAt)&&(identical(other.dailyNotifHour, dailyNotifHour) || other.dailyNotifHour == dailyNotifHour)&&(identical(other.quizzesCompleted, quizzesCompleted) || other.quizzesCompleted == quizzesCompleted)&&(identical(other.totalQuizScore, totalQuizScore) || other.totalQuizScore == totalQuizScore)&&const DeepCollectionEquality().equals(other._favoriteMembers, _favoriteMembers)&&const DeepCollectionEquality().equals(other._viewedMembers, _viewedMembers)&&(identical(other.preferredTreeView, preferredTreeView) || other.preferredTreeView == preferredTreeView)&&const DeepCollectionEquality().equals(other._leitnerBoxes, _leitnerBoxes)&&const DeepCollectionEquality().equals(other._completedParcours, _completedParcours)&&(identical(other.studyMode, studyMode) || other.studyMode == studyMode)&&const DeepCollectionEquality().equals(other._husnaLearned, _husnaLearned));
}


@override
int get hashCode => Object.hashAll([runtimeType,theme,textSize,const DeepCollectionEquality().hash(_favorites),const DeepCollectionEquality().hash(_learned),const DeepCollectionEquality().hash(_viewed),const DeepCollectionEquality().hash(_meditatedNames),const DeepCollectionEquality().hash(_practicedNames),const DeepCollectionEquality().hash(_recognizedNames),const DeepCollectionEquality().hash(_lastSeen),onboardingCompletedAt,dailyNotifHour,quizzesCompleted,totalQuizScore,const DeepCollectionEquality().hash(_favoriteMembers),const DeepCollectionEquality().hash(_viewedMembers),preferredTreeView,const DeepCollectionEquality().hash(_leitnerBoxes),const DeepCollectionEquality().hash(_completedParcours),studyMode,const DeepCollectionEquality().hash(_husnaLearned)]);

@override
String toString() {
  return 'UserState(theme: $theme, textSize: $textSize, favorites: $favorites, learned: $learned, viewed: $viewed, meditatedNames: $meditatedNames, practicedNames: $practicedNames, recognizedNames: $recognizedNames, lastSeen: $lastSeen, onboardingCompletedAt: $onboardingCompletedAt, dailyNotifHour: $dailyNotifHour, quizzesCompleted: $quizzesCompleted, totalQuizScore: $totalQuizScore, favoriteMembers: $favoriteMembers, viewedMembers: $viewedMembers, preferredTreeView: $preferredTreeView, leitnerBoxes: $leitnerBoxes, completedParcours: $completedParcours, studyMode: $studyMode, husnaLearned: $husnaLearned)';
}


}

/// @nodoc
abstract mixin class _$UserStateCopyWith<$Res> implements $UserStateCopyWith<$Res> {
  factory _$UserStateCopyWith(_UserState value, $Res Function(_UserState) _then) = __$UserStateCopyWithImpl;
@override @useResult
$Res call({
 ThemeKey theme, TextSize textSize, Set<int> favorites, Set<int> learned, Set<int> viewed, Set<int> meditatedNames, Set<int> practicedNames, Set<int> recognizedNames, Map<int, DateTime> lastSeen, DateTime? onboardingCompletedAt, int? dailyNotifHour, int quizzesCompleted, int totalQuizScore, Set<String> favoriteMembers, Set<String> viewedMembers, String preferredTreeView, Map<int, int> leitnerBoxes, Set<String> completedParcours, String studyMode, Set<int> husnaLearned
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
@override @pragma('vm:prefer-inline') $Res call({Object? theme = null,Object? textSize = null,Object? favorites = null,Object? learned = null,Object? viewed = null,Object? meditatedNames = null,Object? practicedNames = null,Object? recognizedNames = null,Object? lastSeen = null,Object? onboardingCompletedAt = freezed,Object? dailyNotifHour = freezed,Object? quizzesCompleted = null,Object? totalQuizScore = null,Object? favoriteMembers = null,Object? viewedMembers = null,Object? preferredTreeView = null,Object? leitnerBoxes = null,Object? completedParcours = null,Object? studyMode = null,Object? husnaLearned = null,}) {
  return _then(_UserState(
theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeKey,textSize: null == textSize ? _self.textSize : textSize // ignore: cast_nullable_to_non_nullable
as TextSize,favorites: null == favorites ? _self._favorites : favorites // ignore: cast_nullable_to_non_nullable
as Set<int>,learned: null == learned ? _self._learned : learned // ignore: cast_nullable_to_non_nullable
as Set<int>,viewed: null == viewed ? _self._viewed : viewed // ignore: cast_nullable_to_non_nullable
as Set<int>,meditatedNames: null == meditatedNames ? _self._meditatedNames : meditatedNames // ignore: cast_nullable_to_non_nullable
as Set<int>,practicedNames: null == practicedNames ? _self._practicedNames : practicedNames // ignore: cast_nullable_to_non_nullable
as Set<int>,recognizedNames: null == recognizedNames ? _self._recognizedNames : recognizedNames // ignore: cast_nullable_to_non_nullable
as Set<int>,lastSeen: null == lastSeen ? _self._lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as Map<int, DateTime>,onboardingCompletedAt: freezed == onboardingCompletedAt ? _self.onboardingCompletedAt : onboardingCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,dailyNotifHour: freezed == dailyNotifHour ? _self.dailyNotifHour : dailyNotifHour // ignore: cast_nullable_to_non_nullable
as int?,quizzesCompleted: null == quizzesCompleted ? _self.quizzesCompleted : quizzesCompleted // ignore: cast_nullable_to_non_nullable
as int,totalQuizScore: null == totalQuizScore ? _self.totalQuizScore : totalQuizScore // ignore: cast_nullable_to_non_nullable
as int,favoriteMembers: null == favoriteMembers ? _self._favoriteMembers : favoriteMembers // ignore: cast_nullable_to_non_nullable
as Set<String>,viewedMembers: null == viewedMembers ? _self._viewedMembers : viewedMembers // ignore: cast_nullable_to_non_nullable
as Set<String>,preferredTreeView: null == preferredTreeView ? _self.preferredTreeView : preferredTreeView // ignore: cast_nullable_to_non_nullable
as String,leitnerBoxes: null == leitnerBoxes ? _self._leitnerBoxes : leitnerBoxes // ignore: cast_nullable_to_non_nullable
as Map<int, int>,completedParcours: null == completedParcours ? _self._completedParcours : completedParcours // ignore: cast_nullable_to_non_nullable
as Set<String>,studyMode: null == studyMode ? _self.studyMode : studyMode // ignore: cast_nullable_to_non_nullable
as String,husnaLearned: null == husnaLearned ? _self._husnaLearned : husnaLearned // ignore: cast_nullable_to_non_nullable
as Set<int>,
  ));
}


}

// dart format on
