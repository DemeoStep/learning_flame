import 'dart:async';

import 'package:flame/components.dart' hide Plane;
import 'package:flutter/services.dart';
import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:learning_flame/game/actors/asteroid.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/game/actors/plane.dart';
import 'package:learning_flame/game/fly_game.dart';

class Level extends World
    with HasGameReference<FlyGame>, KeyboardHandler
    implements Actor {
  @override
  final String artBoardName = Consts.spaceArtBoardName;
  @override
  final String stateMachineName = Consts.spaceStateMachineName;
  @override
  final Vector2 actorSize = Consts.spaceSize;

  int _lastFiredTimestamp = 0;

  DateTime _lastAsteroidSpawnedTime = DateTime(2000);

  @override
  Future<void> onLoad() async {
    final space = await riveComponentService.loadRiveComponent(this);

    add(space);
    add(game.plane);

    add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.space: (keysPressed) {
            game.plane.firing = false;
            return false;
          },
          LogicalKeyboardKey.arrowLeft: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
              game.plane.flyDirection = FlyDirection.right;
            } else {
              game.plane.flyDirection = FlyDirection.none;
            }
            return false;
          },
          LogicalKeyboardKey.arrowRight: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
              game.plane.flyDirection = FlyDirection.left;
            } else {
              game.plane.flyDirection = FlyDirection.none;
            }
            return false;
          },
        },
        keyDown: {
          LogicalKeyboardKey.space: (keysPressed) {
            game.plane.firing = true;
            return false;
          },
          LogicalKeyboardKey.arrowLeft: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
              game.plane.flyDirection = FlyDirection.right;
            } else {
              game.plane.flyDirection = FlyDirection.left;
            }
            return false;
          },
          LogicalKeyboardKey.arrowRight: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
              game.plane.flyDirection = FlyDirection.left;
            } else {
              game.plane.flyDirection = FlyDirection.right;
            }
            return false;
          },
        },
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!gameStatsCubit.state.isGameOver) {
      _spawnAsteroid();
      if (game.plane.firing) {
        _spawnCannon();
      }
    } else {
      _removeResources();
    }
    super.update(dt);
  }

  void _spawnCannon() {
    final cannonsPool = gameStatsCubit.state.cannonsPool;
    final activeCount = cannonsPool.activeCount;
    final maxCannons = gameStatsCubit.state.clipSize;
    final now = DateTime.now();

    print(
      'Attempting to spawn cannon. Active: $activeCount, Max: $maxCannons, Pool: ${cannonsPool.poolSize}',
    );

    if (now.difference(_lastAsteroidSpawnedTime).inMinutes < gameStatsCubit.state.asteroidCount) {
      return;
    }

    if (activeCount < maxCannons && cannonsPool.poolSize > 0) {
      final cannon = cannonsPool.fromPool();

      if (cannon != null) {
        _lastAsteroidSpawnedTime = now;

        add(cannon);
        cannon.fire();
      }
    }
  }

  void _spawnAsteroid() {
    if (!gameStatsCubit.state.isGameStarted) {
      return;
    }

    final asteroidsPool = gameStatsCubit.state.asteroidsPool;
    final maxAsteroids = gameStatsCubit.state.asteroidCount;
    final firedAsteroids = asteroidsPool.activeCount;
    final now = DateTime.now().millisecondsSinceEpoch;

    print(
      'Attempting to spawn asteroid. Active: $firedAsteroids, Pool: ${asteroidsPool.poolSize}',
    );

    if (now - _lastFiredTimestamp < gameStatsCubit.state.cannonReloadTime) {
      return;
    }

    gameStatsCubit.addAsteroid();

    if (firedAsteroids < maxAsteroids && asteroidsPool.poolSize > 0) {
      final asteroid = asteroidsPool.fromPool();

      if (asteroid != null) {
        _lastFiredTimestamp = now;

        add(asteroid);
        //asteroid.fire();
      }
    }

    // if (firedAsteroids < gameStatsCubit.state.asteroidCount) {
    //   final asteroid = asteroidsPool.fromPool();

    //   if (asteroid != null) {
    //     add(asteroid);
    //   }
    // }
  }

  void _removeResources() {
    final asteroids = children.whereType<AsteroidActor>();

    if (asteroids.isNotEmpty) {
      removeAll(asteroids);
    }

    final plane = children.whereType<PlaneActor>();

    if (plane.isNotEmpty) {
      removeAll(plane);
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    return false;
  }
}
