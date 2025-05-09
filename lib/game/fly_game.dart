import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'package:learning_flame/consts.dart';
import 'package:learning_flame/game/levels/level.dart';
import 'package:window_manager/window_manager.dart';

import 'package:learning_flame/game/actors/plane.dart';

class FlyGame extends FlameGame
    with HasKeyboardHandlerComponents, WindowListener, HasCollisionDetection {

  late final PlaneActor plane;

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
}
