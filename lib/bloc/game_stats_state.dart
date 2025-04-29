import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_stats_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class GameStatsState with _$GameStatsState {
  factory GameStatsState({
    @Default(0) int gameStartTimestamp,
    @Default(0) int score,
    @Default(3) int lives,
    @Default(100) int planeSpeed,
    @Default(3) int fireAtOnce,
    @Default(100) int cannonSpeed,
    @Default(200) int cannonReloadTime,
    @Default(1) int asteroidCount,
    @Default(100) int asteroidSpeed,
  }) = _GameStatsState;

  factory GameStatsState.empty() {
    return GameStatsState(
      gameStartTimestamp: DateTime.now().millisecondsSinceEpoch,
      score: 0,
      lives: 3,
      planeSpeed: 100,
      fireAtOnce: 3,
      cannonSpeed: 100,
      cannonReloadTime: 200,
      asteroidCount: 1,
      asteroidSpeed: 100,
    );
  }
}
