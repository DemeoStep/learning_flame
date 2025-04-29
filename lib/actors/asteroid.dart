import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart' hide Plane;
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/actors/actor.dart';
import 'package:learning_flame/actors/cannon.dart';
import 'package:learning_flame/actors/plane.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/fly_game.dart';
import 'package:learning_flame/rive_component_loader_mixin.dart';

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

  final List<PositionComponent> collisionComponents = [];

  late final SMIBool isDestroyed;

  @override
  Future<void> onLoad() async {
    position = _startPosition();
    firedAtTimestamp = DateTime.now().microsecondsSinceEpoch;

    final asteroid = await loadRiveComponent();

    final controller = StateMachineController.fromArtboard(
      asteroid.artboard,
      stateMachineName,
    );

    isDestroyed = controller!.findSMI<SMIBool>('isDestroyed')!;

    asteroid.artboard.addController(controller);

    hitBox = RectangleHitbox(size: asteroid.size);

    add(asteroid);
    add(hitBox);

    (game as HasCollisionDetection)
        .collisionDetection
        .collisionsCompletedNotifier
        .addListener(() {
          _resolveCollisions();
        });

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

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Cannon || other is Plane) {
      _destroyAsteroid();
      collisionComponents.add(other);
    }
  }

  void _resolveCollisions() {
    for (final component in collisionComponents) {
      if (component is Cannon) {
        component.removeFromParent();
        bloc.increaseScore();
      } else if (component is Plane) {
        component.hitTrigger.fire();
        bloc.decreaseLive();
      }
    }

    collisionComponents.clear();
  }

  void _destroyAsteroid() {
    isDestroyed.value = true;
    hitBox.collisionType = CollisionType.inactive;
    FlameAudio.play('explosion.mp3', volume: 0.1);
    Future.delayed(Duration(milliseconds: 400)).then((_) {
      position = _startPosition();
      isDestroyed.value = false;
      firedAtTimestamp = DateTime.now().microsecondsSinceEpoch;
      hitBox.collisionType = CollisionType.active;
    });
  }

  Vector2 _startPosition() => Vector2(35 + Random().nextInt(500).toDouble(), 0);
}
