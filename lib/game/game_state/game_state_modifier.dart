import 'dart:math' show Random;

import 'package:learning_flame/game/config.dart';
import 'package:learning_flame/game/game.dart';

extension GameStateModifier on FlyGame {
  void setGameStarted() {
    gameState.isGameStartedNotifier.value = true;
    gameState.gameStartTime = DateTime.now();
  }

  void setGameOver() {
    gameState.isGameOverNotifier.value = true;
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
    final random = Random().nextInt(4);

    switch (random) {
      case 0:
        _increaseClipSize();
        break;
      case 1:
        _increaseCannonSpeed();
        break;
      case 2:
        _increaseCannonReloadTime();
        break;
      case 3:
        _increasePlaneSpeed();
        break;
    }
  }

  void _increaseClipSize() {
    if (gameState.clipSizeNotifier.value < Config.maxClipSize) {
      gameState.clipSizeNotifier.value = gameState.clipSize + 1;
      print('clipSize: ${gameState.clipSize}');
    } else {
      powerUp();
    }
  }

  void _increaseCannonSpeed() {
    if (gameState.cannonSpeedNotifier.value < Config.maxCannonSpeed) {
      gameState.cannonSpeedNotifier.value = gameState.cannonSpeed + 10;
      print('cannonSpeed: ${gameState.cannonSpeed}');
    } else {
      powerUp();
    }
  }

  void _increaseCannonReloadTime() {
    if (gameState.cannonReloadTimeNotifier.value > Config.minCannonReloadTime) {
      gameState.cannonReloadTimeNotifier.value = gameState.cannonReloadTime - 10;
      print('cannonReloadTime: ${gameState.cannonReloadTime}');
    } else {
      powerUp();
    }
  }

  void _increasePlaneSpeed() {
    if (gameState.planeSpeedNotifier.value < Config.maxPlaneSpeed) {
      gameState.planeSpeedNotifier.value = gameState.planeSpeed + 10;
      print('planeSpeed: ${gameState.planeSpeed}');
    } else {
      powerUp();
    }
  }
}