import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/actors/cannon.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/fly_game.dart';

class Asteroid extends PositionComponent
    with HasGameReference<FlyGame>, CollisionCallbacks {
  final Artboard asteroidArtBoard;

  late final RiveComponent asteroid;

  final asteroidSpeed = 100;
  int reloadTime = 10000;

  late final Vector2 startPosition;
  late final int firedAtTimestamp;

  late final RectangleHitbox hitBox;

  final List<PositionComponent> collisionComponents = [];

  Asteroid({required this.startPosition, required this.asteroidArtBoard});

  @override
  Future<void> onLoad() async {
    position = startPosition;
    firedAtTimestamp = DateTime.now().millisecondsSinceEpoch;

    asteroid = RiveComponent(
      artboard: asteroidArtBoard,
      size: Consts.asteroidSize,
    );

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
        removeFromParent();
      }
    }
    collisionComponents.clear();
  }
}
