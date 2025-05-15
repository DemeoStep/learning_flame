import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:learning_flame/game/game.dart';
import 'package:learning_flame/game/rive_component_pool/rive_component_pool.dart';

class CannonActor extends PositionComponent
    with HasGameReference<FlyGame>
    implements Actor {
  @override
  final String artBoardName = Consts.cannonArtBoardName;
  @override
  final String stateMachineName = Consts.cannonStateMachineName;
  @override
  final Vector2 actorSize = Consts.cannonSize;

  late RiveComponent cannon;

  late int firedAtTimestamp;

  late RectangleHitbox hitBox;

  bool isVisible = false;

  final ActorsPool<CannonActor> cannonsPool;

  CannonActor({required this.cannonsPool});

  @override
  Future<void> onLoad() async {
    cannon = await riveComponentService.loadRiveComponent(this);

    hitBox = RectangleHitbox(size: cannon.size);

    add(cannon);
    add(hitBox);

    super.onLoad();
  }

  @override
  update(double dt) {
    if (!isVisible) {
      return;
    }

    final speed = game.gameState.cannonSpeed;
    if (position.y < 0) {
      destroy();
    } else {
      position.add(Vector2(0, -speed * dt));
    }
    super.update(dt);
  }

  void fire() {
    isVisible = true;
    position = _startingPosition;
    size = cannon.size;

    hitBox.collisionType = CollisionType.active;

    audioService.playCannonFire();
  }

  void destroy() {
    isVisible = false;
    position = _stackingPosition;

    hitBox.collisionType = CollisionType.inactive;

    cannonsPool.toPool(this);
  }

  Vector2 get _startingPosition => Vector2(
    game.plane.position.x - 2 + Consts.planeSize.x / 2,
    game.plane.position.y,
  );

  Vector2 get _stackingPosition => Vector2(-20, -20);
}
