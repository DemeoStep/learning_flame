import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/actors/asteroid.dart';
import 'package:learning_flame/actors/cannon.dart';
import 'package:learning_flame/actors/plane.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/levels/level.dart';
import 'package:window_manager/window_manager.dart';

class FlyGame extends FlameGame
    with HasKeyboardHandlerComponents, WindowListener, HasCollisionDetection {
  late final Artboard cannonArtBoard;
  final GameStatsCubit cubit;

  FlyGame({required this.cubit});

  @override
  Future<void> onLoad() async {
    await _worldInit();

    camera = CameraComponent.withFixedResolution(
      width: Consts.windowSize.width,
      height: Consts.windowSize.height,
    );

    camera.viewfinder.anchor = Anchor.topLeft;

    addAll([camera, world]);

    await add(
      FlameBlocProvider<GameStatsCubit, GameStatsState>(
        create: () => cubit,
        children: [world],
      ),
    );

    // Set up collision detection listener
    collisionDetection.collisionsCompletedNotifier.addListener(
      _resolveCollisions,
    );

    windowManager.addListener(this);

    overlays.add('score');

    await FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(['gun_fire.wav', 'explosion.mp3']);

    super.onLoad();
  }

  Future<void> _worldInit() async {
    var [
      spaceArtBoard,
      planeArtBoard,
      cannonArtBoard,
      asteroidArtBoard,
    ] = await Future.wait([
      _loadRiveComponent(
        artBoardName: Consts.spaceArtBoardName,
        stateMachineName: Consts.spaceStateMachineName,
      ),
      _loadRiveComponent(
        artBoardName: Consts.planeArtBoardName,
        stateMachineName: Consts.planeStateMachineName,
      ),
      _loadRiveComponent(
        artBoardName: Consts.cannonArtBoardName,
        stateMachineName: Consts.cannonStateMachineName,
      ),
      _loadRiveComponent(
        artBoardName: Consts.asteroidArtBoardName,
        stateMachineName: Consts.asteroidStateMachineName,
      ),
    ]);

    this.cannonArtBoard = cannonArtBoard;

    world = Level();
  }

  @override
  void onWindowResized() {
    windowManager.setAspectRatio(1.0);
    super.onWindowResize();
  }

  Future<Artboard> _loadRiveComponent({
    required String artBoardName,
    required String stateMachineName,
  }) async {
    final artBoard = await loadArtboard(
      RiveFile.asset(Consts.mainRiveFilePath),
      artboardName: artBoardName,
    );

    final controller = StateMachineController.fromArtboard(
      artBoard,
      stateMachineName,
    );

    artBoard.addController(controller!);

    return artBoard;
  }

  void _resolveCollisions() {
    final activeCollisions = collisionDetection.collisions;

    for (final collision in activeCollisions) {
      Asteroid? asteroid;
      PositionComponent? other;

      if (collision.first is Asteroid) {
        asteroid = collision.first as Asteroid;
        other = collision.second;
      } else if (collision.second is Asteroid) {
        asteroid = collision.second as Asteroid;
        other = collision.first;
      }

      if (asteroid == null || other == null) continue;

      if (other is Cannon) {
        asteroid.destroyAsteroid();
        other.removeFromParent();
        cubit.increaseScore();
      } else if (other is GamePlane) {
        asteroid.destroyAsteroid();
        other.hitTrigger.fire();
        cubit.decreaseLive();
      }
    }
  }
}
