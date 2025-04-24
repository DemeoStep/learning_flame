import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/actors/actor.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/fly_game.dart';
import 'package:learning_flame/rive_component_loader_mixin.dart';

class Plane extends PositionComponent
    with HasGameReference<FlyGame>, CollisionCallbacks
    implements Actor {
  @override
  final String artBoardName = Consts.planeArtBoardName;
  @override
  final String stateMachineName = Consts.planeStateMachineName;
  @override
  final Vector2 actorSize = Consts.planeSize;

  late final RiveComponent plane;

  bool firing = false;

  FlyDirection flyDirection = FlyDirection.none;
  final flySpeed = 100;
  final startPosition = Vector2(250, 490);

  @override
  FutureOr<void> onLoad() async {
    position = startPosition;

    plane = await loadRiveComponent();

    add(plane);

    anchor = Anchor.topCenter;

    add(RectangleHitbox());

    return super.onLoad();
  }

  @override
  update(double dt) {
    switch (flyDirection) {
      case FlyDirection.left:
        if (position.x < 0) {
          flyDirection = FlyDirection.none;
        } else {
          position.add(Vector2(-flySpeed * dt, 0));
        }
      case FlyDirection.right:
        if (position.x + Consts.planeSize.x > Consts.windowSize.width) {
          flyDirection = FlyDirection.none;
        } else {
          position.add(Vector2(flySpeed * dt, 0));
        }
      case FlyDirection.none:
        break;
    }

    super.update(dt);
  }
}

enum FlyDirection { left, right, none }
