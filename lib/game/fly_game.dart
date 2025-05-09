import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'package:flame_bloc/flame_bloc.dart';
// import 'package:learning_flame/bloc/game_stats_cubit.dart';
// import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/game/levels/level.dart';
import 'package:window_manager/window_manager.dart';

import 'package:learning_flame/game/actors/plane.dart';

class FlyGame extends FlameGame
    with HasKeyboardHandlerComponents, WindowListener, HasCollisionDetection {
  //final GameStatsCubit cubit;

  late final PlaneActor plane;

  // FlyGame({required this.cubit});

  @override
  Future<void> onLoad() async {
    world = Level();
    plane = PlaneActor();

    camera = CameraComponent.withFixedResolution(
      width: Consts.windowSize.width,
      height: Consts.windowSize.height,
    );

    camera.viewfinder.anchor = Anchor.topLeft;

    // await add(
    //   FlameBlocProvider<GameStatsCubit, GameStatsState>(
    //     create: () => cubit,
    //     children: [camera, world],
    //   ),
    // );

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
