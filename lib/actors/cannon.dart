import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/fly.dart';
import 'package:learning_flame/levels/level.dart';

class Cannon extends PositionComponent with HasGameReference<FlyGame> {
  final Artboard cannonArtBoard;
  final Vector2 cannonArtBoardSize;

  late final RiveComponent cannon;
  final cannonSpeed = 400;
  int reloadTime = 500;

  late final int firedAtTimestamp;

  late final Vector2 startPosition;

  Cannon({
    required this.startPosition,
    required this.cannonArtBoard,
    required this.cannonArtBoardSize,
  });

  @override
  Future<void> onLoad() async {
    position = startPosition;
    firedAtTimestamp = DateTime.now().millisecondsSinceEpoch;

    cannon = RiveComponent(artboard: cannonArtBoard, size: cannonArtBoardSize);

    add(cannon);
  }

  @override
  update(double dt) {
    if (position.y < 0) {
      game.children.whereType<Level>().forEach((c) {
        c.remove(this);
      });
    } else {
      position.add(Vector2(0, -cannonSpeed * dt));
    }
    super.update(dt);
  }
}
