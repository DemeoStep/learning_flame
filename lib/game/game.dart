import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:learning_flame/consts.dart';
import 'package:learning_flame/game/game_state/game_state.dart';
import 'package:learning_flame/game/game_state/game_state_modifier.dart';
import 'package:learning_flame/game/levels/level.dart';
import 'package:window_manager/window_manager.dart';

import 'package:learning_flame/game/actors/plane.dart';

class FlyGame extends FlameGame
    with HasKeyboardHandlerComponents, WindowListener, HasCollisionDetection {
  late final PlaneActor plane;

  final gameState = GameState();

  @override
  Future<void> onLoad() async {
    world = Level();
    plane = PlaneActor();

    camera = CameraComponent.withFixedResolution(
      width: Consts.windowSize.width,
      height: Consts.windowSize.height,
    );

    camera.viewfinder.anchor = Anchor.topLeft;

    windowManager.addListener(this);

    overlays.add('score');

    super.onLoad();
  }

  @override
  void onWindowResized() {
    windowManager.setAspectRatio(1.0);
    super.onWindowResize();
  }

  @override
  void update(double dt) {
    if (gameState.isPaused) {
      gameState.gameStartTime = gameState.gameStartTime.add(
        Duration(microseconds: (dt * 1000000).toInt()),
      );
      return;
    }

    if (!gameState.isGameOver) {
      final now = DateTime.now();

      if (gameState.isGameStarted) {
        if (now.difference(gameState.gameStartTime).inMinutes > gameState.level * 2) {
          levelUp();
        }
      }
    }

    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent) {
      if (gameState.isPaused) {
        switchGamePaused();
        if (event.logicalKey == LogicalKeyboardKey.space) {
          return KeyEventResult.handled;
        }
      } else if (event.logicalKey == Consts.pauseKey) {
        switchGamePaused();
        return KeyEventResult.handled;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
