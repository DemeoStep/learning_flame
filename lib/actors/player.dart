import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/services.dart';
import 'package:learning_flame/fly.dart';
import 'package:learning_flame/levels/level.dart';
import 'package:collection/collection.dart';

import 'cannon.dart';

class Player extends PositionComponent
    with HasGameReference<FlyGame>, KeyboardHandler {
  final Artboard planeArtBoard;
  final Vector2 planeArtBoardSize;

  final Artboard cannonArtBoard;
  final Vector2 cannonArtBoardSize;

  late final RiveComponent plane;

  bool firing = false;

  FlyDirection flyDirection = FlyDirection.none;
  final flySpeed = 100;
  final startPosition = Vector2(250, 490);

  Player({
    required this.planeArtBoard,
    required this.planeArtBoardSize,
    required this.cannonArtBoard,
    required this.cannonArtBoardSize,
  });

  @override
  FutureOr<void> onLoad() async {
    position = startPosition;

    plane = RiveComponent(artboard: planeArtBoard, size: planeArtBoardSize);

    add(plane);

    add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.space: (keysPressed) {
            firing = false;
            return false;
          },
          LogicalKeyboardKey.arrowLeft: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
              flyDirection = FlyDirection.right;
            } else {
              flyDirection = FlyDirection.none;
            }
            return false;
          },
          LogicalKeyboardKey.arrowRight: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
              flyDirection = FlyDirection.left;
            } else {
              flyDirection = FlyDirection.none;
            }
            return false;
          },
        },
        keyDown: {
          LogicalKeyboardKey.space: (keysPressed) {
            firing = true;
            return false;
          },
          LogicalKeyboardKey.arrowLeft: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
              flyDirection = FlyDirection.right;
            } else {
              flyDirection = FlyDirection.left;
            }
            return false;
          },
          LogicalKeyboardKey.arrowRight: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
              flyDirection = FlyDirection.left;
            } else {
              flyDirection = FlyDirection.right;
            }
            return false;
          },
        },
      ),
    );
    return super.onLoad();
  }

  void _spawnCannon() {
    final level = game.children.whereType<Level>().first;

    final firedCannons = level.children.whereType<Cannon>().sortedBy(
      (c) => c.firedAtTimestamp,
    );

    if (firedCannons.isNotEmpty) {
      if (DateTime.now().millisecondsSinceEpoch -
              firedCannons.last.firedAtTimestamp <
          firedCannons.last.reloadTime) {
        return;
      }
    }

    level.add(
      Cannon(
        startPosition: Vector2(position.x + 48, position.y),
        cannonArtBoard: cannonArtBoard,
        cannonArtBoardSize: cannonArtBoardSize,
      ),
    );
  }

  @override
  update(double dt) {
    if (firing) {
      _spawnCannon();
    }
    switch (flyDirection) {
      case FlyDirection.left:
        if (position.x < 0) {
          flyDirection = FlyDirection.none;
        } else {
          position.add(Vector2(-flySpeed * dt, 0));
        }
      case FlyDirection.right:
        if (position.x > 500) {
          flyDirection = FlyDirection.none;
        } else {
          position.add(Vector2(flySpeed * dt, 0));
        }
      case FlyDirection.none:
        break;
    }

    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    return false;
  }
}

enum FlyDirection { left, right, none }
