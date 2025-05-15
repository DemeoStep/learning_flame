import 'package:flutter/foundation.dart';
import 'package:learning_flame/game/config.dart';

class GameState {
  DateTime gameStartTime = DateTime.now();

  ValueNotifier<int> levelNotifier = ValueNotifier(0);
  int get level => levelNotifier.value;

  ValueNotifier<bool> isGameStartedNotifier = ValueNotifier(false);
  bool get isGameStarted => isGameStartedNotifier.value;

  ValueNotifier<bool> isPausedNotifier = ValueNotifier(false);
  bool get isPaused => isPausedNotifier.value;

  ValueNotifier<bool> isGameOverNotifier = ValueNotifier(false);
  bool get isGameOver => isGameOverNotifier.value;

  ValueNotifier<int> livesNotifier = ValueNotifier(Config.startLives);
  int get lives => livesNotifier.value;

  ValueNotifier<int> scoreNotifier = ValueNotifier(0);
  int get score => scoreNotifier.value;

  ValueNotifier<int> clipSizeNotifier = ValueNotifier(Config.minClipSize);
  int get clipSize => clipSizeNotifier.value;

  ValueNotifier<int> cannonSpeedNotifier = ValueNotifier(Config.minCannonSpeed);
  int get cannonSpeed => cannonSpeedNotifier.value;

  ValueNotifier<int> cannonReloadTimeNotifier = ValueNotifier(
    Config.maxCannonReloadTime,
  );
  int get cannonReloadTime => cannonReloadTimeNotifier.value;

  ValueNotifier<int> planeSpeedNotifier = ValueNotifier(Config.minPlaneSpeed);
  int get planeSpeed => planeSpeedNotifier.value;

  ValueNotifier<int> asteroidCountNotifier = ValueNotifier(0);
  int get asteroidCount => asteroidCountNotifier.value;

  ValueNotifier<int> asteroidSpeedNotifier = ValueNotifier(Config.minAsteroidSpeed);
  int get asteroidSpeed => asteroidSpeedNotifier.value;

  ValueNotifier<int> mojaherCountNotifier = ValueNotifier(0);
  int get mojaherCount => mojaherCountNotifier.value;

  ValueNotifier<int> mojaherSpeedNotifier = ValueNotifier(Config.minMojaherSpeed);
  int get mojaherSpeed => mojaherSpeedNotifier.value;

  ValueNotifier<String> powerUpNotifier = ValueNotifier('');
  String get powerUp => powerUpNotifier.value;
}
