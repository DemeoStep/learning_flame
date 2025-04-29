import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/components.dart' hide Plane;
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/services.dart';
import 'package:learning_flame/actors/actor.dart';
import 'package:learning_flame/actors/asteroid.dart';
import 'package:learning_flame/actors/cannon.dart';
import 'package:learning_flame/actors/plane.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/fly_game.dart';
import 'package:learning_flame/rive_component_loader_mixin.dart';

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

  late final Plane plane;

  late final RiveComponent space;

  @override
  Future<void> onLoad() async {
    space = await loadRiveComponent();

    plane = Plane();

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
    _spawnAsteroid();
    if (plane.firing) {
      _spawnCannon();
    }
    super.update(dt);
  }

  void _spawnCannon() {
    final firedCannons = children.whereType<Cannon>().sortedBy(
      (c) => c.firedAtTimestamp,
    );

    if (firedCannons.isNotEmpty) {
      if (DateTime.now().millisecondsSinceEpoch -
              firedCannons.last.firedAtTimestamp <
          bloc.state.cannonReloadTime) {
        return;
      }
    }

    if (firedCannons.length >= bloc.state.fireAtOnce) {
      return;
    }

    add(
      Cannon(
        startPosition: Vector2(
          plane.position.x - 2 + Consts.planeSize.x / 2,
          plane.position.y,
        ),
      ),
    );
  }

  void _spawnAsteroid() {
    final firedAsteroids = children.whereType<Asteroid>().sortedBy(
      (c) => c.firedAtTimestamp,
    );

    bloc.addAsteroid();

    if (firedAsteroids.length < bloc.state.asteroidCount) {
      add(Asteroid());
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    return false;
  }
}
