import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart' hide Plane;
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:learning_flame/game/actors/cannon.dart';
import 'package:learning_flame/game/actors/plane.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/fly_game.dart';

class Asteroid extends PositionComponent
    with
        HasGameReference<FlyGame>,
        CollisionCallbacks,
        FlameBlocReader<GameStatsCubit, GameStatsState>
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

  late final RectangleHitbox hitBox;

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
        bloc.decreaseScore();
      }

      position = _startPosition();
    } else {
      position.add(Vector2(0, bloc.state.asteroidSpeed * dt));
    }
    super.update(dt);
  }

  // Made public so FlyGame can call it
  void destroyAsteroid() {
    if (isDestroyed.value) return; // Prevent duplicate destructions

    isDestroyed.value = true;
    hitBox.collisionType = CollisionType.inactive;

    // Use the game reference to play the sound
    audioService.play(sound: Consts.explosion);

    Future.delayed(Duration(milliseconds: 400)).then((_) {
      position = _startPosition();
      isDestroyed.value = false;
      firedAtTimestamp = DateTime.now().microsecondsSinceEpoch;
      hitBox.collisionType = CollisionType.active;
    });
  }

  void spawnAsteroid() {
    isDestroyed.value = false;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Cannon) {
      destroyAsteroid();
      other.removeFromParent();
      bloc.increaseScore();
    } else if (other is GamePlane) {
      destroyAsteroid();
      other.hitTrigger.fire();
      bloc.decreaseLive();
    }
  }

  Vector2 _startPosition() => Vector2(35 + Random().nextInt(500).toDouble(), 0);
}
