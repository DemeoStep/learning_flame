import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/actors/actor.dart';
import 'package:learning_flame/actors/cannon.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/fly_game.dart';
import 'package:learning_flame/rive_component_loader_mixin.dart';

class Asteroid extends PositionComponent
    with HasGameReference<FlyGame>, CollisionCallbacks
    implements Actor {
  @override
  final String artBoardName = Consts.asteroidArtBoardName;
  @override
  final String stateMachineName = Consts.asteroidStateMachineName;
  @override
  final Vector2 actorSize = Consts.asteroidSize;

  late final RiveComponent asteroid;

  final asteroidSpeed = 100;
  int reloadTime = 10000000;

  late final Vector2 startPosition;
  late final int firedAtTimestamp;

  late final RectangleHitbox hitBox;

  final List<PositionComponent> collisionComponents = [];

  late final SMITrigger destroyTrigger;

  Asteroid({required this.startPosition});

  @override
  Future<void> onLoad() async {
    position = startPosition;
    firedAtTimestamp = DateTime.now().microsecondsSinceEpoch;

    final asteroid = await loadRiveComponent();

    final controller = StateMachineController.fromArtboard(
      asteroid.artboard,
      stateMachineName,
    );

    destroyTrigger = controller!.findSMI<SMITrigger>('destroy')!;

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
  }

  @override
  update(double dt) {
    if (position.y > Consts.windowSize.height + Consts.asteroidSize.y) {
      removeFromParent();
    } else {
      position.add(Vector2(0, asteroidSpeed * dt));
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Cannon) {
      collisionComponents.add(other);
    }
  }

  void _resolveCollisions() {
    for (final component in collisionComponents) {
      if (component is Cannon) {
        destroyTrigger.fire();
        component.removeFromParent();
        hitBox.removeFromParent();

        Future.delayed(const Duration(milliseconds: 250), () {
          removeFromParent();
        });
      }
    }
    collisionComponents.clear();
  }
}
