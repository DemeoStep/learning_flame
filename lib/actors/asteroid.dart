import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/fly.dart';
import 'package:learning_flame/levels/level.dart';

class Asteroid extends PositionComponent with HasGameReference<FlyGame> {
  final Artboard asteroidArtBoard;
  final Vector2 asteroidArtBoardSize;

  late final RiveComponent asteroid;

  final asteroidSpeed = 100;
  int reloadTime = 10000;

  late final Vector2 startPosition;
  late final int firedAtTimestamp;

  Asteroid({
    required this.startPosition,
    required this.asteroidArtBoard,
    required this.asteroidArtBoardSize,
  });

  @override
  Future<void> onLoad() async {
    position = startPosition;
    firedAtTimestamp = DateTime.now().millisecondsSinceEpoch;

    asteroid = RiveComponent(
      artboard: asteroidArtBoard,
      size: asteroidArtBoardSize,
    );

    add(asteroid);
  }

  @override
  update(double dt) {
    if (position.y > Consts.windowSize.height + asteroidArtBoardSize.y) {
      game.children.whereType<Level>().forEach((c) {
        c.remove(this);
      });
    } else {
      position.add(Vector2(0, asteroidSpeed * dt));
    }
    super.update(dt);
  }
}
