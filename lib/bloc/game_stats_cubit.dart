import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/game/actors/asteroid.dart';
import 'package:learning_flame/game/actors/cannon.dart';
import 'package:learning_flame/game/config.dart';
import 'package:learning_flame/game/rive_component_pool/rive_component_pool.dart';

class GameStatsCubit extends Cubit<GameStatsState> {
  GameStatsCubit() : super(GameStatsState(
    asteroidsPool: ActorsPool<AsteroidActor>(),
    cannonsPool: ActorsPool<CannonActor>(),
    gameStartTime: DateTime.now(),
  ));

  void gameStart() {
    for (var i = 0; i < Config.maxClipSize; i++) {
      final cannon = CannonActor();
      //cannon.onLoad();
      state.cannonsPool.add(cannon);
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
        clipSize: _calculateClipSize(score),
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
        clipSize: _calculateClipSize(score),
      ),
    );
  }

  void decreaseLive() {
    if (state.isGameOver) {
      return;
    }
    emit(
      state.copyWith(
        lives: state.lives - 1,
        isGameOver: state.lives <= 1,
        clipSize: Config.minClipSize,
        planeSpeed: Config.minPlaneSpeed,
        cannonSpeed: Config.minCannonSpeed,
        cannonReloadTime: Config.minCannonReloadTime,
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

  int _calculateClipSize(int score) {
    final res = 3 + (score.clamp(0, 200) ~/ 5);

    if (state.cannonsPool.totalCount < res &&
        state.cannonsPool.totalCount < Config.maxClipSize) {
      while (state.cannonsPool.totalCount < res) {
        state.cannonsPool.add(CannonActor());
      }
    }

    return res.clamp(3, Config.maxClipSize);
  }
}
