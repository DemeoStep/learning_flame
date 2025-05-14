import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

import 'package:flame/components.dart' hide Plane;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:learning_flame/game/actors/asteroid.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/game/actors/cannon.dart';
import 'package:learning_flame/game/actors/mojaher.dart';
import 'package:learning_flame/game/actors/plane.dart';
import 'package:learning_flame/game/actors/power_up.dart';
import 'package:learning_flame/game/config.dart';
import 'package:learning_flame/game/fly_game.dart';
import 'package:learning_flame/game/rive_component_pool/rive_component_pool.dart';
import 'package:learning_flame/providers/game_stats_provider.dart';

class Level extends World
    with HasGameReference<FlyGame>, KeyboardHandler
    implements Actor {
  @override
  final String artBoardName = Consts.spaceArtBoardName;
  @override
  final String stateMachineName = Consts.spaceStateMachineName;
  @override
  final Vector2 actorSize = Consts.spaceSize;

  int _lastFiredTimestamp = 0;

  DateTime _lastAsteroidSpawnedTime = DateTime(2000);

  int _lastMojaherSpawnedTimestamp = 0;
  static const int mojaherMinIntervalMs = 3000;
  static const int mojaherMaxIntervalMs = 8000;
  int _nextMojaherIntervalMs = 5000;
  final Random _random = Random();

  final asteroidsPool = ActorsPool<AsteroidActor>();
  final mojahersPool = ActorsPool<MojaherActor>();
  final cannonsPool = ActorsPool<CannonActor>();

  final powerUp = PowerUp();

  @override
  Future<void> onLoad() async {
    final space = await riveComponentService.loadRiveComponent(this);

    add(space);
    add(game.plane);

    await riveComponentService.ensureInitialized();

    for (var i = 0; i < Config.maxClipSize; i++) {
      final cannon = CannonActor(cannonsPool: cannonsPool);
      cannonsPool.add(cannon);
    }

    for (var i = 0; i < Config.maxAsteroidCount; i++) {
      final asteroid = AsteroidActor(asteroidsPool: asteroidsPool);
      asteroidsPool.add(asteroid);
    }

    for (var i = 0; i < Config.maxMojaherCount; i++) {
      final mojaher = MojaherActor(mojahersPool: mojahersPool);
      mojahersPool.add(mojaher);
    }

    addAll(cannonsPool.pool);
    addAll(asteroidsPool.pool);
    addAll(mojahersPool.pool);

    add(powerUp);

    powerUp.isVisible = true;

    _scheduleNextMojaherSpawn();

    // Set game as started and set start time
    FlyGame.ref.read(gameStatsProvider.notifier).setGameStarted(true);
    FlyGame.ref
        .read(gameStatsProvider.notifier)
        .setGameStartTime(DateTime.now());

    add(
      KeyboardListenerComponent(
        keyUp: {
          LogicalKeyboardKey.space: (keysPressed) {
            game.plane.firing = false;
            return false;
          },
          LogicalKeyboardKey.arrowLeft: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
              game.plane.flyDirection = FlyDirection.right;
            } else {
              game.plane.flyDirection = FlyDirection.none;
            }
            return false;
          },
          LogicalKeyboardKey.arrowRight: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
              game.plane.flyDirection = FlyDirection.left;
            } else {
              game.plane.flyDirection = FlyDirection.none;
            }
            return false;
          },
        },
        keyDown: {
          LogicalKeyboardKey.space: (keysPressed) {
            game.plane.firing = true;
            return false;
          },
          LogicalKeyboardKey.arrowLeft: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
              game.plane.flyDirection = FlyDirection.right;
            } else {
              game.plane.flyDirection = FlyDirection.left;
            }
            return false;
          },
          LogicalKeyboardKey.arrowRight: (keysPressed) {
            if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
              game.plane.flyDirection = FlyDirection.left;
            } else {
              game.plane.flyDirection = FlyDirection.right;
            }
            return false;
          },
        },
      ),
    );

    return super.onLoad();
  }

  void _scheduleNextMojaherSpawn() {
    _nextMojaherIntervalMs =
        mojaherMinIntervalMs +
        _random.nextInt(mojaherMaxIntervalMs - mojaherMinIntervalMs);
  }

  @override
  void update(double dt) {
    if (game.isPaused) return;

    if (!game.isGameOver.value) {
      _spawnEnemy();
      _spawnMojaher();
      if (game.plane.firing) {
        _spawnCannon();
      }
    } else {
      _removeResources();
    }
    super.update(dt);
  }

  void _spawnCannon() {
    final gameStats = FlyGame.ref.read(gameStatsProvider);
    final activeCount = cannonsPool.activeCount;
    final maxCannons = game.clipSize.value;
    final now = DateTime.now().millisecondsSinceEpoch;

    if (now - _lastFiredTimestamp < gameStats.cannonReloadTime) {
      return;
    }

    if (activeCount < maxCannons && cannonsPool.poolSize > 0) {
      final cannon = cannonsPool.fromPool();

      if (cannon != null) {
        _lastFiredTimestamp = now;
        cannon.fire();
      }
    }
  }

  void _spawnEnemy() {
    final now = DateTime.now();
    final gameStats = FlyGame.ref.read(gameStatsProvider);
    final timeSinceLastSpawn =
        now.difference(_lastAsteroidSpawnedTime).inMilliseconds;

    if (timeSinceLastSpawn < Config.maxAsteroidSpeed) {
      return;
    }

    if (!gameStats.isGameStarted || game.isGameOver.value) {
      return;
    }

    final targetAsteroidCount = math.min(
      Config.maxAsteroidCount,
      1 + (now.difference(gameStats.gameStartTime).inMinutes),
    );

    if (gameStats.asteroidCount != targetAsteroidCount) {
      FlyGame.ref
          .read(gameStatsProvider.notifier)
          .setAsteroidCount(targetAsteroidCount);
    }

    int activeAsteroids = asteroidsPool.activeCount;

    if (activeAsteroids < targetAsteroidCount && asteroidsPool.poolSize > 0) {
      _lastAsteroidSpawnedTime = now;

      final asteroid = asteroidsPool.fromPool();
      if (asteroid != null) {
        asteroid.isVisible = true;
      }
    }
  }

  void _spawnMojaher() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastMojaherSpawnedTimestamp < _nextMojaherIntervalMs) {
      return;
    }

    int activeMojahers = mojahersPool.activeCount;
    if (activeMojahers < Config.maxMojaherCount && mojahersPool.poolSize > 0) {
      _lastMojaherSpawnedTimestamp = now;
      _scheduleNextMojaherSpawn();
      final mojaher = mojahersPool.fromPool();
      if (mojaher != null) {
        mojaher.position = mojaher.startPosition();
        mojaher.isVisible = true;
      }
    }
  }

  void _removeResources() {
    final asteroids = children.whereType<AsteroidActor>();

    if (asteroids.isNotEmpty) {
      removeAll(asteroids);
    }

    final plane = children.whereType<PlaneActor>();

    if (plane.isNotEmpty) {
      removeAll(plane);
    }
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    return false;
  }
}
