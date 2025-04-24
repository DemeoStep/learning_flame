import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart' hide Plane;
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/services.dart';
import 'package:learning_flame/actors/asteroid.dart';
import 'package:learning_flame/actors/cannon.dart';
import 'package:learning_flame/actors/plane.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/fly_game.dart';

class Level extends World with HasGameReference<FlyGame>, KeyboardHandler {
  late final Plane plane;

  late final RiveComponent space;

  @override
  FutureOr<void> onLoad() async {
    space = RiveComponent(artboard: game.spaceArtBoard, size: Consts.spaceSize);

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
          firedCannons.last.reloadTime) {
        return;
      }
    }

    add(
      Cannon(
        startPosition: Vector2(plane.position.x + 48, plane.position.y),
        cannonArtBoard: game.cannonArtBoard,
      ),
    );
  }

  void _spawnAsteroid() {
    final firedAsteroids = children.whereType<Asteroid>().sortedBy(
      (c) => c.firedAtTimestamp,
    );

    if (firedAsteroids.isNotEmpty) {
      if (DateTime.now().millisecondsSinceEpoch -
              firedAsteroids.last.firedAtTimestamp <
          firedAsteroids.last.reloadTime) {
        return;
      }
    }

    add(
      Asteroid(
        startPosition: Vector2(35 + Random().nextInt(500).toDouble(), 0),
        asteroidArtBoard: game.asteroidArtBoard,
      ),
    );
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    return false;
  }
}
