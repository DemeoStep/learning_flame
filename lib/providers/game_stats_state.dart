import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_flame/game/config.dart';

part 'game_stats_state.freezed.dart';

@Freezed(toJson: false, fromJson: false)
abstract class GameStatsState with _$GameStatsState {
  factory GameStatsState({
    @Default(false) bool isGameStarted,
    @Default(0) int asteroidCount,
    @Default(0) int mojaherCount,
    @Default(Config.minAsteroidSpeed) int asteroidSpeed,
    @Default(Config.minMojaherSpeed) int mojaherSpeed,
    required DateTime gameStartTime,
  }) = _GameStatsState;
}
