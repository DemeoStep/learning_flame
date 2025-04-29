// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_stats_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameStatsState {

 int get gameStartTimestamp; int get score; int get lives; int get planeSpeed; int get fireAtOnce; int get cannonSpeed; int get cannonReloadTime; int get asteroidCount; int get asteroidSpeed;
/// Create a copy of GameStatsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStatsStateCopyWith<GameStatsState> get copyWith => _$GameStatsStateCopyWithImpl<GameStatsState>(this as GameStatsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStatsState&&(identical(other.gameStartTimestamp, gameStartTimestamp) || other.gameStartTimestamp == gameStartTimestamp)&&(identical(other.score, score) || other.score == score)&&(identical(other.lives, lives) || other.lives == lives)&&(identical(other.planeSpeed, planeSpeed) || other.planeSpeed == planeSpeed)&&(identical(other.fireAtOnce, fireAtOnce) || other.fireAtOnce == fireAtOnce)&&(identical(other.cannonSpeed, cannonSpeed) || other.cannonSpeed == cannonSpeed)&&(identical(other.cannonReloadTime, cannonReloadTime) || other.cannonReloadTime == cannonReloadTime)&&(identical(other.asteroidCount, asteroidCount) || other.asteroidCount == asteroidCount)&&(identical(other.asteroidSpeed, asteroidSpeed) || other.asteroidSpeed == asteroidSpeed));
}


@override
int get hashCode => Object.hash(runtimeType,gameStartTimestamp,score,lives,planeSpeed,fireAtOnce,cannonSpeed,cannonReloadTime,asteroidCount,asteroidSpeed);

@override
String toString() {
  return 'GameStatsState(gameStartTimestamp: $gameStartTimestamp, score: $score, lives: $lives, planeSpeed: $planeSpeed, fireAtOnce: $fireAtOnce, cannonSpeed: $cannonSpeed, cannonReloadTime: $cannonReloadTime, asteroidCount: $asteroidCount, asteroidSpeed: $asteroidSpeed)';
}


}

/// @nodoc
abstract mixin class $GameStatsStateCopyWith<$Res>  {
  factory $GameStatsStateCopyWith(GameStatsState value, $Res Function(GameStatsState) _then) = _$GameStatsStateCopyWithImpl;
@useResult
$Res call({
 int gameStartTimestamp, int score, int lives, int planeSpeed, int fireAtOnce, int cannonSpeed, int cannonReloadTime, int asteroidCount, int asteroidSpeed
});




}
/// @nodoc
class _$GameStatsStateCopyWithImpl<$Res>
    implements $GameStatsStateCopyWith<$Res> {
  _$GameStatsStateCopyWithImpl(this._self, this._then);

  final GameStatsState _self;
  final $Res Function(GameStatsState) _then;

/// Create a copy of GameStatsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gameStartTimestamp = null,Object? score = null,Object? lives = null,Object? planeSpeed = null,Object? fireAtOnce = null,Object? cannonSpeed = null,Object? cannonReloadTime = null,Object? asteroidCount = null,Object? asteroidSpeed = null,}) {
  return _then(_self.copyWith(
gameStartTimestamp: null == gameStartTimestamp ? _self.gameStartTimestamp : gameStartTimestamp // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,lives: null == lives ? _self.lives : lives // ignore: cast_nullable_to_non_nullable
as int,planeSpeed: null == planeSpeed ? _self.planeSpeed : planeSpeed // ignore: cast_nullable_to_non_nullable
as int,fireAtOnce: null == fireAtOnce ? _self.fireAtOnce : fireAtOnce // ignore: cast_nullable_to_non_nullable
as int,cannonSpeed: null == cannonSpeed ? _self.cannonSpeed : cannonSpeed // ignore: cast_nullable_to_non_nullable
as int,cannonReloadTime: null == cannonReloadTime ? _self.cannonReloadTime : cannonReloadTime // ignore: cast_nullable_to_non_nullable
as int,asteroidCount: null == asteroidCount ? _self.asteroidCount : asteroidCount // ignore: cast_nullable_to_non_nullable
as int,asteroidSpeed: null == asteroidSpeed ? _self.asteroidSpeed : asteroidSpeed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc


class _GameStatsState implements GameStatsState {
   _GameStatsState({this.gameStartTimestamp = 0, this.score = 0, this.lives = 3, this.planeSpeed = 100, this.fireAtOnce = 3, this.cannonSpeed = 100, this.cannonReloadTime = 200, this.asteroidCount = 1, this.asteroidSpeed = 100});
  

@override@JsonKey() final  int gameStartTimestamp;
@override@JsonKey() final  int score;
@override@JsonKey() final  int lives;
@override@JsonKey() final  int planeSpeed;
@override@JsonKey() final  int fireAtOnce;
@override@JsonKey() final  int cannonSpeed;
@override@JsonKey() final  int cannonReloadTime;
@override@JsonKey() final  int asteroidCount;
@override@JsonKey() final  int asteroidSpeed;

/// Create a copy of GameStatsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStatsStateCopyWith<_GameStatsState> get copyWith => __$GameStatsStateCopyWithImpl<_GameStatsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameStatsState&&(identical(other.gameStartTimestamp, gameStartTimestamp) || other.gameStartTimestamp == gameStartTimestamp)&&(identical(other.score, score) || other.score == score)&&(identical(other.lives, lives) || other.lives == lives)&&(identical(other.planeSpeed, planeSpeed) || other.planeSpeed == planeSpeed)&&(identical(other.fireAtOnce, fireAtOnce) || other.fireAtOnce == fireAtOnce)&&(identical(other.cannonSpeed, cannonSpeed) || other.cannonSpeed == cannonSpeed)&&(identical(other.cannonReloadTime, cannonReloadTime) || other.cannonReloadTime == cannonReloadTime)&&(identical(other.asteroidCount, asteroidCount) || other.asteroidCount == asteroidCount)&&(identical(other.asteroidSpeed, asteroidSpeed) || other.asteroidSpeed == asteroidSpeed));
}


@override
int get hashCode => Object.hash(runtimeType,gameStartTimestamp,score,lives,planeSpeed,fireAtOnce,cannonSpeed,cannonReloadTime,asteroidCount,asteroidSpeed);

@override
String toString() {
  return 'GameStatsState(gameStartTimestamp: $gameStartTimestamp, score: $score, lives: $lives, planeSpeed: $planeSpeed, fireAtOnce: $fireAtOnce, cannonSpeed: $cannonSpeed, cannonReloadTime: $cannonReloadTime, asteroidCount: $asteroidCount, asteroidSpeed: $asteroidSpeed)';
}


}

/// @nodoc
abstract mixin class _$GameStatsStateCopyWith<$Res> implements $GameStatsStateCopyWith<$Res> {
  factory _$GameStatsStateCopyWith(_GameStatsState value, $Res Function(_GameStatsState) _then) = __$GameStatsStateCopyWithImpl;
@override @useResult
$Res call({
 int gameStartTimestamp, int score, int lives, int planeSpeed, int fireAtOnce, int cannonSpeed, int cannonReloadTime, int asteroidCount, int asteroidSpeed
});




}
/// @nodoc
class __$GameStatsStateCopyWithImpl<$Res>
    implements _$GameStatsStateCopyWith<$Res> {
  __$GameStatsStateCopyWithImpl(this._self, this._then);

  final _GameStatsState _self;
  final $Res Function(_GameStatsState) _then;

/// Create a copy of GameStatsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gameStartTimestamp = null,Object? score = null,Object? lives = null,Object? planeSpeed = null,Object? fireAtOnce = null,Object? cannonSpeed = null,Object? cannonReloadTime = null,Object? asteroidCount = null,Object? asteroidSpeed = null,}) {
  return _then(_GameStatsState(
gameStartTimestamp: null == gameStartTimestamp ? _self.gameStartTimestamp : gameStartTimestamp // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,lives: null == lives ? _self.lives : lives // ignore: cast_nullable_to_non_nullable
as int,planeSpeed: null == planeSpeed ? _self.planeSpeed : planeSpeed // ignore: cast_nullable_to_non_nullable
as int,fireAtOnce: null == fireAtOnce ? _self.fireAtOnce : fireAtOnce // ignore: cast_nullable_to_non_nullable
as int,cannonSpeed: null == cannonSpeed ? _self.cannonSpeed : cannonSpeed // ignore: cast_nullable_to_non_nullable
as int,cannonReloadTime: null == cannonReloadTime ? _self.cannonReloadTime : cannonReloadTime // ignore: cast_nullable_to_non_nullable
as int,asteroidCount: null == asteroidCount ? _self.asteroidCount : asteroidCount // ignore: cast_nullable_to_non_nullable
as int,asteroidSpeed: null == asteroidSpeed ? _self.asteroidSpeed : asteroidSpeed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
