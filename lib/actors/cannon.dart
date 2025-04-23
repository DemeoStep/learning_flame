import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/services.dart';
import 'package:learning_flame/fly.dart';

import '../levels/level.dart';

class Cannon extends PositionComponent
    with HasGameReference<FlyGame>, KeyboardHandler {
  late final RiveComponent cannon;
  final cannonSpeed = 50;
  late final Vector2 startPosition;

  Cannon({required this.startPosition});

  @override
  Future<void> onLoad() async {
    position = startPosition;

    final cannonArtboard = await loadArtboard(
      RiveFile.asset('assets/rive/fly.riv'),
      artboardName: 'Cannon',
    );

    final controller = StateMachineController.fromArtboard(
      cannonArtboard,
      "CannonSM",
    );

    cannonArtboard.addController(controller!);

    cannon = RiveComponent(artboard: cannonArtboard, size: Vector2(5, 10));

    add(cannon);
  }

  @override
  update(double dt) {
    if (position.y < 0) {
      game.children.whereType<Level>().forEach((c) {
        c.remove(this);
      });
    } else {
      position.add(Vector2(0, -cannonSpeed * dt));
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    return true;
  }
}
