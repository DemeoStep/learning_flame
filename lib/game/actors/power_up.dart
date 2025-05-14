import 'dart:math';

import 'package:learning_flame/consts.dart';
import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:learning_flame/game/actors/plane.dart';
import 'package:learning_flame/game/fly_game.dart';

class PowerUp extends PositionComponent
    with HasGameReference<FlyGame>, CollisionCallbacks
    implements Actor {
  @override
  final String artBoardName = Consts.powerUpArtBoardName;

  @override
  final String stateMachineName = Consts.powerUpStateMachineName;

  @override
  final Vector2 actorSize = Consts.powerUpSize;

  late RectangleHitbox hitBox;

  bool isVisible = false;

  @override
  Future<void> onLoad() async {
    reset();

    final powerUp = await riveComponentService.loadRiveComponent(this);

    hitBox = RectangleHitbox(size: powerUp.size);

    add(powerUp);
    add(hitBox);

    await super.onLoad();
  }

  @override
  void update(double dt) {
    if (!isVisible) {
      return;
    }

    if (position.y > Consts.windowSize.height + Consts.asteroidSize.y) {
      reset();
    } else {
      final speed = 50;
      position.add(Vector2(0, speed * dt));
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlaneActor) {
      reset();
      game.powerUp();
    }
  }

  void reset() {
    isVisible = false;
    position = _startPosition();
  }

  Vector2 _startPosition() =>
      Vector2(35 + Random().nextInt(500).toDouble(), -50);
}
