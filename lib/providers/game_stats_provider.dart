import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flame/providers/game_stats_state.dart';

class GameStatsNotifier extends StateNotifier<GameStatsState> {
  GameStatsNotifier() : super(GameStatsState(gameStartTime: DateTime.now()));

  // void increaseLive() => state = state.copyWith(lives: state.lives + 1);

  void decreaseLive() {
    state = state.copyWith(lives: state.lives - 1);
  }

  void setAsteroidCount(int count) =>
      state = state.copyWith(asteroidCount: count);

  //void setClipSize(int size) => state = state.copyWith(clipSize: size);

  void setPlaneSpeed(int speed) => state = state.copyWith(planeSpeed: speed);

  void setGameStarted(bool isGameStarted) =>
      state = state.copyWith(isGameStarted: isGameStarted);

  void setGameStartTime(DateTime time) =>
      state = state.copyWith(gameStartTime: time);

  void setCannonReloadTime(int ms) =>
      state = state.copyWith(cannonReloadTime: ms);

  void setAsteroidSpeed(int speed) =>
      state = state.copyWith(asteroidSpeed: speed);

  // void _makeCalculations(int score) {
  //   final gamingTimeMinutes =
  //       DateTime.now().difference(state.gameStartTime).inMinutes;

  //   state = state.copyWith(
  //     score: score,
  //     planeSpeed: _calculatePlaneSpeed(score),
  //     cannonSpeed: _calculateCannonSpeed(score),
  //     cannonReloadTime: _calculateCannonReloadTime(score),
  //     asteroidSpeed: _calculateAsteroidSpeed(gamingTimeMinutes),
  //     mojaherSpeed: _calculateMojaherSpeed(gamingTimeMinutes),
  //     clipSize: _calculateClipSize(score),
  //   );
  // }

  // int _calculatePlaneSpeed(int score) {
  //   return 100 + (score.clamp(0, 200) ~/ 10) * 10;
  // }

  // int _calculateCannonSpeed(int score) {
  //   final result = 100 + (score.clamp(0, 400) ~/ 10) * 10;
  //   return result < Config.minCannonSpeed
  //       ? Config.minCannonSpeed
  //       : result > Config.maxCannonSpeed
  //       ? Config.maxCannonSpeed
  //       : result;
  // }

  // int _calculateCannonReloadTime(int score) {
  //   final result = 300 - (score.clamp(0, 400) ~/ 10) * 5;
  //   return result < 100 ? 100 : result;
  // }

  // int _calculateAsteroidSpeed(int gamingTimeMinutes) {
  //   return Config.minAsteroidSpeed + (gamingTimeMinutes.clamp(0, 6) ~/ 10) * 10;
  // }

  // int _calculateMojaherSpeed(int gamingTimeMinutes) {
  //   final result =
  //       Config.minMojaherSpeed + (gamingTimeMinutes.clamp(0, 6) ~/ 10) * 10;
  //   return result.clamp(Config.minMojaherSpeed, Config.maxMojaherSpeed);
  // }

  // int _calculateClipSize(int score) {
  //   final res = Config.minClipSize + (score.clamp(0, 400) ~/ 10);

  //   return res.clamp(Config.minClipSize, Config.maxClipSize);
  // }
}

final gameStatsProvider =
    StateNotifierProvider<GameStatsNotifier, GameStatsState>((ref) {
      return GameStatsNotifier();
    });
