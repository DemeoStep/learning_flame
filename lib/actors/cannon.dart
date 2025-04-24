import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/fly_game.dart';

class Cannon extends PositionComponent with HasGameReference<FlyGame> {
  final Artboard cannonArtBoard;

  late final RiveComponent cannon;
  final cannonSpeed = 400;
  int reloadTime = 100;

  late final int firedAtTimestamp;

  late final Vector2 startPosition;

  late final RectangleHitbox hitBox;

  Cannon({required this.startPosition, required this.cannonArtBoard});

  @override
  Future<void> onLoad() async {
    position = startPosition;
    firedAtTimestamp = DateTime.now().millisecondsSinceEpoch;

    cannon = RiveComponent(artboard: cannonArtBoard, size: Consts.cannonSize);

    hitBox = RectangleHitbox(size: cannon.size);

    add(cannon);
    add(hitBox);
  }

  @override
  update(double dt) {
    if (position.y < 0) {
      removeFromParent();
    } else {
      position.add(Vector2(0, -cannonSpeed * dt));
    }
    super.update(dt);
  }
}
