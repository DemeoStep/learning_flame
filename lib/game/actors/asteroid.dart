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

class AsteroidActor extends PositionComponent
    with
        HasGameReference<FlyGame>,
        CollisionCallbacks
    implements Actor {
  @override
  final String artBoardName = Consts.asteroidArtBoardName;
  @override
  final String stateMachineName = Consts.asteroidStateMachineName;
  @override
  final Vector2 actorSize = Consts.asteroidSize;

  late final RiveComponent asteroid;

  int reloadTime = 10000000;

  late int firedAtTimestamp;

  late RectangleHitbox hitBox;

  late SMIBool isDestroyed;

  @override
  Future<void> onLoad() async {
    position = _startPosition();
    firedAtTimestamp = DateTime.now().microsecondsSinceEpoch;

    final asteroid = await riveComponentService.loadRiveComponent(this);

    final controller = StateMachineController.fromArtboard(
      asteroid.artboard,
      stateMachineName,
    );

    isDestroyed = controller!.findSMI<SMIBool>('isDestroyed')!;

    asteroid.artboard.addController(controller);

    hitBox = RectangleHitbox(size: asteroid.size);

    add(asteroid);
    add(hitBox);

    super.onLoad();
  }

  @override
  update(double dt) {
    if (position.y > Consts.windowSize.height + Consts.asteroidSize.y) {
      if (!isDestroyed.value) {
        gameStatsCubit.decreaseScore();
      }
      position = _startPosition();
    } else {
      position.add(Vector2(0, gameStatsCubit.state.asteroidSpeed * dt));
    }
    super.update(dt);
  }

  void destroyAsteroid() {
    if (isDestroyed.value) return;

    isDestroyed.value = true;

    hitBox.collisionType = CollisionType.inactive;

    audioService.play(sound: Consts.explosion);

    Future.delayed(Duration(milliseconds: 400)).then((_) {
      isDestroyed.value = false;
      firedAtTimestamp = DateTime.now().microsecondsSinceEpoch;
      hitBox.collisionType = CollisionType.active;
      gameStatsCubit.state.asteroidsPool.toPool(this);
      position = _startPosition();
    });
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is CannonActor) {
      destroyAsteroid();
      other.destroy();
      gameStatsCubit.increaseScore();
    } else if (other is PlaneActor) {
      destroyAsteroid();
      other.hitTrigger.fire();
      gameStatsCubit.decreaseLive();
    }
  }

  Vector2 _startPosition() => Vector2(35 + Random().nextInt(500).toDouble(), 0);
}
