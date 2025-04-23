import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/actors/asteroid.dart';
import 'package:learning_flame/actors/player.dart';
import 'package:learning_flame/fly.dart';

class Level extends World with HasGameReference<FlyGame> {
  final Artboard spaceArtBoard;
  final Vector2 artBoardSize;

  final Player player;

  final Artboard asteroidArtBoard;
  final Vector2 asteroidArtBoardSize;

  late final RiveComponent space;

  Level({
    required this.spaceArtBoard,
    required this.player,
    required this.artBoardSize,
    required this.asteroidArtBoard,
    required this.asteroidArtBoardSize,
  });

  @override
  FutureOr<void> onLoad() async {
    space = RiveComponent(artboard: spaceArtBoard, size: artBoardSize);

    add(space);
    add(player);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _spawnAsteroid();
    super.update(dt);
  }

  void _spawnAsteroid() {
    final firedAsteroids = children.whereType<Asteroid>().sortedBy(
      (c) => c.firedAtTimestamp,
    );

    if (firedAsteroids.isNotEmpty) {
      if (DateTime.now().millisecondsSinceEpoch -
              firedAsteroids.last.firedAtTimestamp <
          firedAsteroids.last.reloadTime) {
        return;
      }
    }

    add(
      Asteroid(
        startPosition: Vector2(35 + Random().nextInt(500).toDouble(), 0),
        asteroidArtBoard: asteroidArtBoard,
        asteroidArtBoardSize: asteroidArtBoardSize,
      ),
    );
  }
}
