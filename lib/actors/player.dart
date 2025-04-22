import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/services.dart';
import 'package:learning_flame/fly.dart';

class Player extends PositionComponent
    with HasGameReference<FlyGame>, KeyboardHandler {
  late final RiveComponent fly;

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

  @override
  update(double dt) {
    super.update(dt);

    switch (flyDirection) {
      case FlyDirection.left:
        position.add(Vector2(-flySpeed * dt, 0));

      case FlyDirection.right:
        position.add(Vector2(flySpeed * dt, 0));
      case FlyDirection.none:
        break;
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    return false;
  }
}

enum FlyDirection { left, right, none }
