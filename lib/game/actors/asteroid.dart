import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
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

class AsteroidActor extends PositionComponent
    with HasGameReference<FlyGame>, CollisionCallbacks
    implements Actor {
  @override
  final String artBoardName = Consts.asteroidArtBoardName;
  @override
  final String stateMachineName = Consts.asteroidStateMachineName;
  @override
  final Vector2 actorSize = Consts.asteroidSize;

  late RectangleHitbox hitBox;

  late SMIBool isDestroyed;

  bool isVisible = false;

  static final Random _random = Random();

  final ActorsPool<AsteroidActor> asteroidsPool;

  final player = AudioPlayer();

  AsteroidActor({required this.asteroidsPool});

  @override
  Future<void> onLoad() async {
    position = _startPosition();

    await player.setReleaseMode(ReleaseMode.stop);
    await player.setVolume(0.1);

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

    await super.onLoad();
  }

  @override
  update(double dt) {
    if (!isVisible) {
      return;
    }

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

    audioService.playExplosion();

    Future.delayed(Duration(milliseconds: 400), _resetAsteroid);
  }

  void _resetAsteroid() {
    asteroidsPool.toPool(this);
    position = _startPosition();
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
      destroyAsteroid();
      other.destroy();
      gameStatsCubit.increaseScore();
    } else if (other is PlaneActor) {
      destroyAsteroid();
      other.hitTrigger.fire();
      gameStatsCubit.decreaseLive();
    }
  }

  Vector2 _startPosition() =>
      Vector2(35 + _random.nextInt(500).toDouble(), -100);
}
