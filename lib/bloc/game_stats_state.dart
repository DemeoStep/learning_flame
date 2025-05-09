import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_flame/game/actors/asteroid.dart';
import 'package:learning_flame/game/actors/cannon.dart';
import 'package:learning_flame/game/config.dart';
import 'package:learning_flame/game/rive_component_pool/rive_component_pool.dart';

part 'game_stats_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class GameStatsState with _$GameStatsState {
  factory GameStatsState({
    @Default(false) bool isGameOver,
    @Default(false) bool isGameStarted,
    @Default(0) int score,
    @Default(Config.minClipSize) int clipSize,
    @Default(Config.startLives) int lives,
    @Default(0) int asteroidCount,
    @Default(Config.minAsteroidSpeed) int asteroidSpeed,
    @Default(Config.minCannonSpeed) int cannonSpeed,
    @Default(Config.minCannonReloadTime) int cannonReloadTime,
    @Default(Config.minPlaneSpeed) int planeSpeed,
    required ActorsPool<AsteroidActor> asteroidsPool,
    required ActorsPool<CannonActor> cannonsPool,
    required DateTime gameStartTime,
  }) = _GameStatsState;
}
