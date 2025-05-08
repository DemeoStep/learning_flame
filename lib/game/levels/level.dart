import 'dart:async';

import 'package:flame/components.dart' hide Plane;
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';
import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:learning_flame/game/actors/asteroid.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/game/actors/plane.dart';
import 'package:learning_flame/game/fly_game.dart';

class Level extends World
    with
        HasGameReference<FlyGame>,
        KeyboardHandler,
        FlameBlocReader<GameStatsCubit, GameStatsState>
    implements Actor {
  @override
  final String artBoardName = Consts.spaceArtBoardName;
  @override
  final String stateMachineName = Consts.spaceStateMachineName;
  @override
  final Vector2 actorSize = Consts.spaceSize;

  int _lastFiredTimestamp = 0;

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
    if (!bloc.state.isGameOver) {
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
    final cannonsPool = bloc.state.cannonsPool;
    final activeCount = cannonsPool.activeCount;
    final maxCannons = bloc.state.fireAtOnce;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Check if enough time has passed since the last cannon fire
    if (now - _lastFiredTimestamp < bloc.state.cannonReloadTime) {
      return; // Still in cooldown period
    }

    // Check if we have fewer active cannons than fireAtOnce limit
    if (activeCount < maxCannons && cannonsPool.poolSize > 0) {
      final cannon = cannonsPool.fromPool();

      if (cannon != null) {
        // Update the timestamp for the last fired cannon
        _lastFiredTimestamp = now;

        add(cannon);
        cannon.fire();
      }
    }
  }

  void _spawnAsteroid() {
    if (!bloc.state.isGameStarted) {
      return;
    }

    final asteroidsPool = bloc.state.asteroidsPool;

    final firedAsteroids = asteroidsPool.activeCount;

    bloc.addAsteroid();

    if (firedAsteroids < bloc.state.asteroidCount) {
      final asteroid = asteroidsPool.fromPool();

      if (asteroid != null) {
        add(asteroid);
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
