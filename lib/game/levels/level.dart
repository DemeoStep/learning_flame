import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart' hide Plane;
import 'package:flutter/services.dart';
import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:learning_flame/game/actors/asteroid.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/game/actors/plane.dart';
import 'package:learning_flame/game/config.dart';
import 'package:learning_flame/game/fly_game.dart';
import 'package:learning_flame/game/rive_component_pool/rive_component_pool.dart';

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

    addAll(gameStatsCubit.state.cannonsPool.pool);
    addAll(gameStatsCubit.state.asteroidsPool.pool);

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
    final now = DateTime.now().millisecondsSinceEpoch;

    if (now - _lastFiredTimestamp < gameStatsCubit.state.cannonReloadTime) {
      return;
    }

    if (activeCount < maxCannons && cannonsPool.poolSize > 0) {
      final cannon = cannonsPool.fromPool();

      if (cannon != null) {
        _lastFiredTimestamp = now;
        cannon.fire();
      }
    }
  }

  void _spawnAsteroid() {
    final now = DateTime.now();
    final timeSinceLastSpawn =
        now.difference(_lastAsteroidSpawnedTime).inMilliseconds;

    // Rate limit: only spawn once per second
    if (timeSinceLastSpawn < 1000) {
      return;
    }

    if (!gameStatsCubit.state.isGameStarted ||
        gameStatsCubit.state.isGameOver) {
      return;
    }

    // Maintain asteroid count at desired level (usually 1)
    final targetAsteroidCount = math.min(
      Config.maxAsteroidCount,
      1 + (now.difference(gameStatsCubit.state.gameStartTime).inMinutes ~/ 2),
    );

    if (gameStatsCubit.state.asteroidCount != targetAsteroidCount) {
      gameStatsCubit.setAsteroidCount(targetAsteroidCount);
    }

    // Only spawn if we have fewer active asteroids than the target count
    ActorsPool<AsteroidActor> asteroidsPool =
        gameStatsCubit.state.asteroidsPool;
    int activeAsteroids = asteroidsPool.activeCount;

    if (activeAsteroids < targetAsteroidCount && asteroidsPool.poolSize > 0) {
      _lastAsteroidSpawnedTime = now;

      final asteroid = asteroidsPool.fromPool();
      if (asteroid != null) {
        asteroid.isVisible = true;
      }
    }
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
