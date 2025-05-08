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

  late RiveComponent cannon;

  late int firedAtTimestamp;

  late RectangleHitbox hitBox;

  bool _isInitialized = false;

  bool visible = false;

  CannonActor();

  @override
  Future<void> onLoad() async {
    cannon = await riveComponentService.loadRiveComponent(this);

    hitBox = RectangleHitbox(size: cannon.size);

    _isInitialized = true;

    super.onLoad();
  }

  @override
  update(double dt) {
    if (!visible) {
      return;
    }

    final speed = bloc.state.cannonSpeed;
    if (position.y < 0) {
      destroy();
    } else {
      position.add(Vector2(0, -speed * dt));
    }
    super.update(dt);
  }

  void fire() async {
    if (!_isInitialized) {
      await onLoad();
    }

    visible = true;
    position = _startingPosition;
    size = cannon.size;

    firedAtTimestamp = DateTime.now().millisecondsSinceEpoch;

    if (!contains(cannon)) {
      add(cannon);
    }

    if (!contains(hitBox)) {
      add(hitBox);
    }

    audioService.play(sound: Consts.gunFire);
  }

  void destroy() {
    visible = false;
    position = _stackingPosition;
    bloc.state.cannonsPool.toPool(this);
  }

  Vector2 get _startingPosition => Vector2(
    game.plane.position.x - 2 + Consts.planeSize.x / 2,
    game.plane.position.y,
  );

  Vector2 get _stackingPosition => Vector2(
    game.plane.position.x - 2 + Consts.planeSize.x / 2,
    game.plane.position.y + 150,
  );
}
