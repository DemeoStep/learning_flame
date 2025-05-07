import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_flame/game/actors/asteroid.dart';
import 'package:learning_flame/game/actors/cannon.dart';
import 'package:learning_flame/game/rive_component_pool/rive_component_pool.dart';

part 'game_stats_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class GameStatsState with _$GameStatsState {
  factory GameStatsState({
    @Default(false) bool isGameOver,
    @Default(false) bool isGameStarted,
    @Default(0) int score,
    @Default(3) int lives,
    @Default(100) int planeSpeed,
    @Default(3) int fireAtOnce,
    @Default(100) int cannonSpeed,
    @Default(200) int cannonReloadTime,
    @Default(0) int asteroidCount,
    @Default(100) int asteroidSpeed,
    required ActorsPool<AsteroidActor> asteroidsPool,
    required ActorsPool<CannonActor> cannonsPool,
    required DateTime gameStartTime,
  }) = _GameStatsState;

  factory GameStatsState.empty() {
    return GameStatsState(
      isGameOver: false,
      isGameStarted: false,
      gameStartTime: DateTime.now(),
      score: 0,
      lives: 3,
      planeSpeed: 100,
      fireAtOnce: 3,
      cannonSpeed: 100,
      cannonReloadTime: 200,
      asteroidCount: 0,
      asteroidSpeed: 100,
      asteroidsPool: ActorsPool<AsteroidActor>(),
      cannonsPool: ActorsPool<CannonActor>(),
    );
  }
}
