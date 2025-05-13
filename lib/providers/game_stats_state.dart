import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_flame/game/config.dart';

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
    @Default(Config.maxCannonReloadTime) int cannonReloadTime,
    @Default(Config.minPlaneSpeed) int planeSpeed,
    required DateTime gameStartTime,
  }) = _GameStatsState;
}
