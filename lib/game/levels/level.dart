import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/components.dart' hide Plane;
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';
import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:learning_flame/game/actors/asteroid.dart';
import 'package:learning_flame/game/actors/cannon.dart';
import 'package:learning_flame/game/actors/plane.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/consts.dart';
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

  late final PlaneActor plane;

  @override
  Future<void> onLoad() async {
    final space = await riveComponentService.loadRiveComponent(this);

    plane = PlaneActor();

    add(space);
    add(plane);

    add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.space: (keysPressed) {
            plane.firing = false;
            return false;
          },
          LogicalKeyboardKey.arrowLeft: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
              plane.flyDirection = FlyDirection.right;
            } else {
              plane.flyDirection = FlyDirection.none;
            }
            return false;
          },
          LogicalKeyboardKey.arrowRight: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
              plane.flyDirection = FlyDirection.left;
            } else {
              plane.flyDirection = FlyDirection.none;
            }
            return false;
          },
        },
        keyDown: {
          LogicalKeyboardKey.space: (keysPressed) {
            plane.firing = true;
            return false;
          },
          LogicalKeyboardKey.arrowLeft: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
              plane.flyDirection = FlyDirection.right;
            } else {
              plane.flyDirection = FlyDirection.left;
            }
            return false;
          },
          LogicalKeyboardKey.arrowRight: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
              plane.flyDirection = FlyDirection.left;
            } else {
              plane.flyDirection = FlyDirection.right;
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
      if (plane.firing) {
        _spawnCannon();
      }
    } else {
      _removeResources();
    }
    super.update(dt);
  }

  void _spawnCannon() {
    final firedCannons = children.whereType<CannonActor>().sortedBy(
      (c) => c.firedAtTimestamp,
    );

    if (firedCannons.isNotEmpty) {
      if (DateTime.now().millisecondsSinceEpoch -
                  firedCannons.last.firedAtTimestamp <
              bloc.state.cannonReloadTime ||
          firedCannons.length >= bloc.state.fireAtOnce) {
        return;
      }
    }

    add(
      CannonActor(
        startPosition: Vector2(
          plane.position.x - 2 + Consts.planeSize.x / 2,
          plane.position.y,
        ),
      ),
    );
  }

  void _spawnAsteroid() {
    if (!bloc.state.isGameStarted) {
      return;
    }

    final firedAsteroids = children.whereType<AsteroidActor>().sortedBy(
      (c) => c.firedAtTimestamp,
    );

    bloc.addAsteroid();

    if (firedAsteroids.length < bloc.state.asteroidCount) {
      add(AsteroidActor());
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
