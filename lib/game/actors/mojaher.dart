import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart' hide Plane;
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:learning_flame/game/actors/cannon.dart';
import 'package:learning_flame/game/actors/plane.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/fly_game.dart';
import 'package:learning_flame/game/rive_component_pool/rive_component_pool.dart';
import 'package:learning_flame/providers/game_stats_provider.dart';

class MojaherActor extends PositionComponent
    with HasGameReference<FlyGame>, CollisionCallbacks
    implements Actor {
  @override
  final String artBoardName = Consts.mojaherArtBoardName;
  @override
  final String stateMachineName = Consts.mojaherStateMachineName;
  @override
  final Vector2 actorSize = Consts.mojaherSize;

  late RectangleHitbox hitBox;

  late SMIBool isDestroyed;

  bool isVisible = false;

  final ActorsPool<MojaherActor> mojahersPool;

  MojaherActor({required this.mojahersPool});

  @override
  Future<void> onLoad() async {
    position = startPosition();

    final mojaher = await riveComponentService.loadRiveComponent(this);

    final controller = StateMachineController.fromArtboard(
      mojaher.artboard,
      stateMachineName,
    );

    isDestroyed = controller!.findSMI<SMIBool>('isDestroyed')!;

    mojaher.artboard.addController(controller);

    hitBox = RectangleHitbox(size: mojaher.size);

    add(mojaher);
    add(hitBox);

    await super.onLoad();
  }

  @override
  update(double dt) {
    if (!isVisible) {
      return;
    }

    if (position.y > Consts.windowSize.height + actorSize.y) {
      position = startPosition();
    } else {
      final speed = FlyGame.ref.read(gameStatsProvider).mojaherSpeed;
      position.add(Vector2(0, speed * dt));
    }
    super.update(dt);
  }

  void destroyMojaher() {
    if (isDestroyed.value) return;

    isDestroyed.value = true;

    hitBox.collisionType = CollisionType.inactive;

    audioService.playExplosion();

    Future.delayed(Duration(milliseconds: 400), _resetMojaher);
  }

  void _resetMojaher() {
    mojahersPool.toPool(this);
    position = startPosition();
    hitBox.collisionType = CollisionType.active;
    isDestroyed.value = false;
    isVisible = false;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is CannonActor) {
      destroyMojaher();
      other.destroy();
      game.increaseScore(amount: 2);
    } else if (other is PlaneActor) {
      destroyMojaher();
      other.hitTrigger.fire();
      game.minusLife();
    }
  }

  Vector2 startPosition() =>
      Vector2(35 + Random().nextInt(500).toDouble(), -100);
}
