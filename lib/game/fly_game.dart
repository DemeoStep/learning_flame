import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:learning_flame/consts.dart';
import 'package:learning_flame/game/config.dart';
import 'package:learning_flame/game/levels/level.dart';
import 'package:window_manager/window_manager.dart';

import 'package:learning_flame/game/actors/plane.dart';

class FlyGame extends FlameGame
    with HasKeyboardHandlerComponents, WindowListener, HasCollisionDetection {
  late final PlaneActor plane;

  bool isPaused = false;

  static late WidgetRef ref;

  ValueNotifier<bool> isGameOver = ValueNotifier(false);
  ValueNotifier<int> lives = ValueNotifier(Config.startLives);
  ValueNotifier<int> score = ValueNotifier(0);
  ValueNotifier<int> clipSize = ValueNotifier(Config.minClipSize);

  FlyGame(WidgetRef refInstance) {
    ref = refInstance;
  }

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
    if (isPaused) return;
    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent && event.logicalKey == Consts.pauseKey) {
      isPaused = !isPaused;
      return KeyEventResult.handled;
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void minusLife() {
    lives.value = lives.value - 1;
    if (lives.value < 0) {
      isGameOver.value = true;
    }
  }

  void increaseScore({int amount = 1}) {
    score.value = score.value + amount;
  }

  void decreaseScore({int amount = 1}) {
    score.value = score.value - amount;
  }

  void increaseClipSize() {
    if (clipSize.value < Config.maxClipSize) {
      clipSize.value = clipSize.value + 1;
    }
  }
}
