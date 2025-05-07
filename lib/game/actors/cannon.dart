import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:learning_flame/game/fly_game.dart';

class CannonActor extends PositionComponent
    with
        HasGameReference<FlyGame>,
        FlameBlocReader<GameStatsCubit, GameStatsState>,
        CollisionCallbacks
    implements Actor {
  @override
  final String artBoardName = Consts.cannonArtBoardName;
  @override
  final String stateMachineName = Consts.cannonStateMachineName;
  @override
  final Vector2 actorSize = Consts.cannonSize;

  late final RiveComponent cannon;

  late final int firedAtTimestamp;

  late final RectangleHitbox hitBox;

  CannonActor();

  @override
  Future<void> onLoad() async {
    position = _startingPosition;

    firedAtTimestamp = DateTime.now().millisecondsSinceEpoch;

    cannon = await riveComponentService.loadRiveComponent(this);

    hitBox = RectangleHitbox(size: cannon.size);

    add(cannon);
    add(hitBox);

    audioService.play(sound: Consts.gunFire);

    super.onLoad();
  }

  @override
  update(double dt) {
    final speed = bloc.state.cannonSpeed;
    if (position.y < 0) {
      destroy();
    } else {
      position.add(Vector2(0, -speed * dt));
    }
    super.update(dt);
  }

  ///TODO: Implement this
  // void spawn() {
  //   position = _startingPosition;
  //   add(cannon);
  //   add(hitBox);
  // }

  void destroy() {
    bloc.state.cannonsPool.toPool(this);
    position = _startingPosition;
  }

  Vector2 get _startingPosition => Vector2(
    game.plane.position.x - 2 + Consts.planeSize.x / 2,
    game.plane.position.y,
  );
}
