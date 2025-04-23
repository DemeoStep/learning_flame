import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/services.dart';
import 'package:learning_flame/fly.dart';
import 'package:learning_flame/levels/level.dart';

import 'cannon.dart';

class Player extends PositionComponent
    with HasGameReference<FlyGame>, KeyboardHandler {
  late final RiveComponent fly;
  bool firing = false;

  FlyDirection flyDirection = FlyDirection.none;
  final flySpeed = 100;
  final startPosition = Vector2(250, 490);

  @override
  FutureOr<void> onLoad() async {
    position = startPosition;

    final flyArtboard = await loadArtboard(
      RiveFile.asset('assets/rive/fly.riv'),
      artboardName: 'Plane',
    );

    final controller = StateMachineController.fromArtboard(
      flyArtboard,
      "FlySM",
    );

    flyArtboard.addController(controller!);

    fly = RiveComponent(artboard: flyArtboard, size: Vector2.all(100));

    add(fly);

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
    game.children.whereType<Level>().forEach(
      (l) => l.add(Cannon(startPosition: Vector2(position.x + 48, position.y))),
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
