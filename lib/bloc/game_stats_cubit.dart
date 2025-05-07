import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/game/actors/asteroid.dart';
import 'package:learning_flame/game/actors/cannon.dart';

class GameStatsCubit extends Cubit<GameStatsState> {
  GameStatsCubit() : super(GameStatsState.empty());

  void gameStart() {
    for (var i = 0; i < state.fireAtOnce; i++) {
      state.cannonsPool.add(CannonActor());
    }

    Future.delayed(const Duration(seconds: 2), () {
      emit(state.copyWith(isGameStarted: true));
    });
  }

  void increaseScore() {
    if (state.isGameOver) {
      return;
    }
    final score = state.score + 1;
    emit(
      state.copyWith(
        score: score,
        planeSpeed: _calculatePlaneSpeed(score),
        cannonSpeed: _calculateCannonSpeed(score),
        cannonReloadTime: _calculateCannonReloadTime(score),
        asteroidSpeed: _calculateAsteroidSpeed(),
        fireAtOnce: _calculateFireAtOnce(score),
      ),
    );
  }

  void decreaseScore() {
    if (state.isGameOver) {
      return;
    }
    final score = state.score >= 2 ? state.score - 2 : 0;
    emit(
      state.copyWith(
        score: score,
        planeSpeed: _calculatePlaneSpeed(score),
        cannonSpeed: _calculateCannonSpeed(score),
        cannonReloadTime: _calculateCannonReloadTime(score),
        asteroidSpeed: _calculateAsteroidSpeed(),
        fireAtOnce: _calculateFireAtOnce(score),
      ),
    );
  }

  void decreaseLive() {
    if (state.isGameOver) {
      return;
    }
    emit(
      GameStatsState.empty().copyWith(
        isGameStarted: true,
        gameStartTime: state.gameStartTime,
        lives: state.lives - 1,
        asteroidSpeed: state.asteroidSpeed,
        isGameOver: state.lives <= 1,
        asteroidsPool: state.asteroidsPool,
      ),
    );
  }

  void addAsteroid() {
    if (state.isGameOver) {
      return;
    }

    final now = DateTime.now();

    if (now.difference(state.gameStartTime) <
        Duration(minutes: state.asteroidCount)) {
      return;
    }

    if (state.asteroidsPool.totalCount < state.asteroidCount + 1) {
      state.asteroidsPool.add(AsteroidActor());
    }

    emit(state.copyWith(asteroidCount: state.asteroidCount + 1));
  }

  int _calculatePlaneSpeed(int score) {
    return 100 + (score.clamp(0, 200) ~/ 10) * 10;
  }

  int _calculateCannonSpeed(int score) {
    return 100 + (score.clamp(0, 400) ~/ 10) * 10;
  }

  int _calculateCannonReloadTime(int score) {
    final result = 300 - (score.clamp(0, 400) ~/ 10) * 5;
    return result < 100 ? 100 : result;
  }

  int _calculateAsteroidSpeed() {
    final gamingTimeMinutes =
        DateTime.now().difference(state.gameStartTime).inMinutes;

    return 100 + (gamingTimeMinutes.clamp(0, 6) ~/ 10) * 10;
  }

  int _calculateFireAtOnce(int score) {
    final res = 3 + (score.clamp(0, 200) ~/ 20);

    if (res < state.cannonsPool.totalCount) {
      state.cannonsPool.add(CannonActor());
    }

    return res;
  }
}
