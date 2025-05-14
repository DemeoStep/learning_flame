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

 bool get isGameStarted; int get lives; int get asteroidCount; int get mojaherCount; int get asteroidSpeed; int get mojaherSpeed; int get cannonSpeed; int get cannonReloadTime; int get planeSpeed; DateTime get gameStartTime;
/// Create a copy of GameStatsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStatsStateCopyWith<GameStatsState> get copyWith => _$GameStatsStateCopyWithImpl<GameStatsState>(this as GameStatsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStatsState&&(identical(other.isGameStarted, isGameStarted) || other.isGameStarted == isGameStarted)&&(identical(other.lives, lives) || other.lives == lives)&&(identical(other.asteroidCount, asteroidCount) || other.asteroidCount == asteroidCount)&&(identical(other.mojaherCount, mojaherCount) || other.mojaherCount == mojaherCount)&&(identical(other.asteroidSpeed, asteroidSpeed) || other.asteroidSpeed == asteroidSpeed)&&(identical(other.mojaherSpeed, mojaherSpeed) || other.mojaherSpeed == mojaherSpeed)&&(identical(other.cannonSpeed, cannonSpeed) || other.cannonSpeed == cannonSpeed)&&(identical(other.cannonReloadTime, cannonReloadTime) || other.cannonReloadTime == cannonReloadTime)&&(identical(other.planeSpeed, planeSpeed) || other.planeSpeed == planeSpeed)&&(identical(other.gameStartTime, gameStartTime) || other.gameStartTime == gameStartTime));
}


@override
int get hashCode => Object.hash(runtimeType,isGameStarted,lives,asteroidCount,mojaherCount,asteroidSpeed,mojaherSpeed,cannonSpeed,cannonReloadTime,planeSpeed,gameStartTime);

@override
String toString() {
  return 'GameStatsState(isGameStarted: $isGameStarted, lives: $lives, asteroidCount: $asteroidCount, mojaherCount: $mojaherCount, asteroidSpeed: $asteroidSpeed, mojaherSpeed: $mojaherSpeed, cannonSpeed: $cannonSpeed, cannonReloadTime: $cannonReloadTime, planeSpeed: $planeSpeed, gameStartTime: $gameStartTime)';
}


}

/// @nodoc
abstract mixin class $GameStatsStateCopyWith<$Res>  {
  factory $GameStatsStateCopyWith(GameStatsState value, $Res Function(GameStatsState) _then) = _$GameStatsStateCopyWithImpl;
@useResult
$Res call({
 bool isGameStarted, int lives, int asteroidCount, int mojaherCount, int asteroidSpeed, int mojaherSpeed, int cannonSpeed, int cannonReloadTime, int planeSpeed, DateTime gameStartTime
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
@pragma('vm:prefer-inline') @override $Res call({Object? isGameStarted = null,Object? lives = null,Object? asteroidCount = null,Object? mojaherCount = null,Object? asteroidSpeed = null,Object? mojaherSpeed = null,Object? cannonSpeed = null,Object? cannonReloadTime = null,Object? planeSpeed = null,Object? gameStartTime = null,}) {
  return _then(_self.copyWith(
isGameStarted: null == isGameStarted ? _self.isGameStarted : isGameStarted // ignore: cast_nullable_to_non_nullable
as bool,lives: null == lives ? _self.lives : lives // ignore: cast_nullable_to_non_nullable
as int,asteroidCount: null == asteroidCount ? _self.asteroidCount : asteroidCount // ignore: cast_nullable_to_non_nullable
as int,mojaherCount: null == mojaherCount ? _self.mojaherCount : mojaherCount // ignore: cast_nullable_to_non_nullable
as int,asteroidSpeed: null == asteroidSpeed ? _self.asteroidSpeed : asteroidSpeed // ignore: cast_nullable_to_non_nullable
as int,mojaherSpeed: null == mojaherSpeed ? _self.mojaherSpeed : mojaherSpeed // ignore: cast_nullable_to_non_nullable
as int,cannonSpeed: null == cannonSpeed ? _self.cannonSpeed : cannonSpeed // ignore: cast_nullable_to_non_nullable
as int,cannonReloadTime: null == cannonReloadTime ? _self.cannonReloadTime : cannonReloadTime // ignore: cast_nullable_to_non_nullable
as int,planeSpeed: null == planeSpeed ? _self.planeSpeed : planeSpeed // ignore: cast_nullable_to_non_nullable
as int,gameStartTime: null == gameStartTime ? _self.gameStartTime : gameStartTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// @nodoc


class _GameStatsState implements GameStatsState {
   _GameStatsState({this.isGameStarted = false, this.lives = Config.startLives, this.asteroidCount = 0, this.mojaherCount = 0, this.asteroidSpeed = Config.minAsteroidSpeed, this.mojaherSpeed = Config.minMojaherSpeed, this.cannonSpeed = Config.minCannonSpeed, this.cannonReloadTime = Config.maxCannonReloadTime, this.planeSpeed = Config.minPlaneSpeed, required this.gameStartTime});
  

@override@JsonKey() final  bool isGameStarted;
@override@JsonKey() final  int lives;
@override@JsonKey() final  int asteroidCount;
@override@JsonKey() final  int mojaherCount;
@override@JsonKey() final  int asteroidSpeed;
@override@JsonKey() final  int mojaherSpeed;
@override@JsonKey() final  int cannonSpeed;
@override@JsonKey() final  int cannonReloadTime;
@override@JsonKey() final  int planeSpeed;
@override final  DateTime gameStartTime;

/// Create a copy of GameStatsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStatsStateCopyWith<_GameStatsState> get copyWith => __$GameStatsStateCopyWithImpl<_GameStatsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameStatsState&&(identical(other.isGameStarted, isGameStarted) || other.isGameStarted == isGameStarted)&&(identical(other.lives, lives) || other.lives == lives)&&(identical(other.asteroidCount, asteroidCount) || other.asteroidCount == asteroidCount)&&(identical(other.mojaherCount, mojaherCount) || other.mojaherCount == mojaherCount)&&(identical(other.asteroidSpeed, asteroidSpeed) || other.asteroidSpeed == asteroidSpeed)&&(identical(other.mojaherSpeed, mojaherSpeed) || other.mojaherSpeed == mojaherSpeed)&&(identical(other.cannonSpeed, cannonSpeed) || other.cannonSpeed == cannonSpeed)&&(identical(other.cannonReloadTime, cannonReloadTime) || other.cannonReloadTime == cannonReloadTime)&&(identical(other.planeSpeed, planeSpeed) || other.planeSpeed == planeSpeed)&&(identical(other.gameStartTime, gameStartTime) || other.gameStartTime == gameStartTime));
}


@override
int get hashCode => Object.hash(runtimeType,isGameStarted,lives,asteroidCount,mojaherCount,asteroidSpeed,mojaherSpeed,cannonSpeed,cannonReloadTime,planeSpeed,gameStartTime);

@override
String toString() {
  return 'GameStatsState(isGameStarted: $isGameStarted, lives: $lives, asteroidCount: $asteroidCount, mojaherCount: $mojaherCount, asteroidSpeed: $asteroidSpeed, mojaherSpeed: $mojaherSpeed, cannonSpeed: $cannonSpeed, cannonReloadTime: $cannonReloadTime, planeSpeed: $planeSpeed, gameStartTime: $gameStartTime)';
}


}

/// @nodoc
abstract mixin class _$GameStatsStateCopyWith<$Res> implements $GameStatsStateCopyWith<$Res> {
  factory _$GameStatsStateCopyWith(_GameStatsState value, $Res Function(_GameStatsState) _then) = __$GameStatsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isGameStarted, int lives, int asteroidCount, int mojaherCount, int asteroidSpeed, int mojaherSpeed, int cannonSpeed, int cannonReloadTime, int planeSpeed, DateTime gameStartTime
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
@override @pragma('vm:prefer-inline') $Res call({Object? isGameStarted = null,Object? lives = null,Object? asteroidCount = null,Object? mojaherCount = null,Object? asteroidSpeed = null,Object? mojaherSpeed = null,Object? cannonSpeed = null,Object? cannonReloadTime = null,Object? planeSpeed = null,Object? gameStartTime = null,}) {
  return _then(_GameStatsState(
isGameStarted: null == isGameStarted ? _self.isGameStarted : isGameStarted // ignore: cast_nullable_to_non_nullable
as bool,lives: null == lives ? _self.lives : lives // ignore: cast_nullable_to_non_nullable
as int,asteroidCount: null == asteroidCount ? _self.asteroidCount : asteroidCount // ignore: cast_nullable_to_non_nullable
as int,mojaherCount: null == mojaherCount ? _self.mojaherCount : mojaherCount // ignore: cast_nullable_to_non_nullable
as int,asteroidSpeed: null == asteroidSpeed ? _self.asteroidSpeed : asteroidSpeed // ignore: cast_nullable_to_non_nullable
as int,mojaherSpeed: null == mojaherSpeed ? _self.mojaherSpeed : mojaherSpeed // ignore: cast_nullable_to_non_nullable
as int,cannonSpeed: null == cannonSpeed ? _self.cannonSpeed : cannonSpeed // ignore: cast_nullable_to_non_nullable
as int,cannonReloadTime: null == cannonReloadTime ? _self.cannonReloadTime : cannonReloadTime // ignore: cast_nullable_to_non_nullable
as int,planeSpeed: null == planeSpeed ? _self.planeSpeed : planeSpeed // ignore: cast_nullable_to_non_nullable
as int,gameStartTime: null == gameStartTime ? _self.gameStartTime : gameStartTime // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
