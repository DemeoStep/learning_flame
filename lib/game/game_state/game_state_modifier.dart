import 'dart:math' show Random;

import 'package:learning_flame/game/config.dart';
import 'package:learning_flame/game/game.dart';

extension GameStateModifier on FlyGame {
  void setGameStarted() {
    gameState.isGameStartedNotifier.value = true;
    gameState.gameStartTime = DateTime.now();
    levelUp();
  }

  void switchGamePaused() {
    gameState.isPausedNotifier.value = !gameState.isPaused;
  }

  void levelUp() {
    gameState.levelNotifier.value = gameState.level + 1;
    addAsteroid();
    if (gameState.level > 2) {
      addMojaher();
    }
  }

  void setGameOver() {
    gameState.isGameOverNotifier.value = true;
  }

  void addAsteroid() {
    if (gameState.asteroidCount < Config.maxAsteroidCount) {
      gameState.asteroidCountNotifier.value = gameState.asteroidCount + 1;
    }
  }

  void addMojaher() {
    if (gameState.mojaherCount < Config.maxMojaherCount) {
      gameState.mojaherCountNotifier.value = gameState.mojaherCount + 1;
    }
  }

  void minusLife() {
    gameState.livesNotifier.value = gameState.lives - 1;
    if (gameState.lives < 0) {
      gameState.isGameOverNotifier.value = true;
    }
  }

  void increaseScore({int amount = 1}) {
    gameState.scoreNotifier.value = gameState.score + amount;
  }

  void decreaseScore({int amount = 1}) {
    gameState.scoreNotifier.value = gameState.score - amount;
  }

  void powerUp() {
    final availablePowerUps = <PowerUpType>[];

    for (final powerUp in PowerUpType.values) {
      switch (powerUp) {
        case PowerUpType.clipSize:
          if (gameState.clipSize < Config.maxClipSize) {
            availablePowerUps.add(powerUp);
          }
        case PowerUpType.cannonSpeed:
          if (gameState.cannonSpeed < Config.maxCannonSpeed) {
            availablePowerUps.add(powerUp);
          }
        case PowerUpType.cannonReloadTime:
          if (gameState.cannonReloadTime > Config.minCannonReloadTime) {
            availablePowerUps.add(powerUp);
          }
        case PowerUpType.planeSpeed:
          if (gameState.planeSpeed < Config.maxPlaneSpeed) {
            availablePowerUps.add(powerUp);
          }
      }
    }

    if (availablePowerUps.isEmpty) {
      return;
    }

    final powerUp =
        availablePowerUps[Random().nextInt(availablePowerUps.length)];

    switch (powerUp) {
      case PowerUpType.clipSize:
        _increaseClipSize();
      case PowerUpType.cannonSpeed:
        _increaseCannonSpeed();
      case PowerUpType.cannonReloadTime:
        _increaseCannonReloadTime();
      case PowerUpType.planeSpeed:
        _increasePlaneSpeed();
    }
  }

  void _increaseClipSize() {
    gameState.clipSizeNotifier.value = gameState.clipSize + 1;
    gameState.powerUpNotifier.value = 'Clip size: ${gameState.clipSize}';
  }

  void _increaseCannonSpeed() {
    gameState.cannonSpeedNotifier.value = gameState.cannonSpeed + 10;
    gameState.powerUpNotifier.value = 'Cannon speed: ${gameState.cannonSpeed}';
  }

  void _increaseCannonReloadTime() {
    gameState.cannonReloadTimeNotifier.value = gameState.cannonReloadTime - 10;
    gameState.powerUpNotifier.value =
        'Cannon reload time: ${gameState.cannonReloadTime}';
  }

  void _increasePlaneSpeed() {
    gameState.planeSpeedNotifier.value = gameState.planeSpeed + 10;
    gameState.powerUpNotifier.value = 'Plane speed: ${gameState.planeSpeed}';
  }
}

enum PowerUpType { clipSize, cannonSpeed, cannonReloadTime, planeSpeed }
