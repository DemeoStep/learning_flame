import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:window_manager/window_manager.dart';

import 'levels/level.dart';

class FlyGame extends FlameGame
    with HasKeyboardHandlerComponents, WindowListener {
  @override
  Future<void> onLoad() async {
    world = Level();

    camera = CameraComponent.withFixedResolution(width: 600, height: 600);

    camera.viewfinder.anchor = Anchor.topLeft;

    addAll([camera, world]);

    windowManager.addListener(this);
    super.onLoad();
  }

  @override
  void onWindowResized() {
    windowManager.setAspectRatio(1.0);
    super.onWindowResize();
  }
}
