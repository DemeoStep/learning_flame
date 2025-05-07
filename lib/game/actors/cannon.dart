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

class Cannon extends PositionComponent
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

  late final Vector2 startPosition;

  late final RectangleHitbox hitBox;

  Cannon({required this.startPosition});

  @override
  Future<void> onLoad() async {
    position = startPosition;
    firedAtTimestamp = DateTime.now().millisecondsSinceEpoch;

    final cannon = await riveComponentService.loadRiveComponent(this);

    hitBox = RectangleHitbox(size: cannon.size);

    add(cannon);
    add(hitBox);

    // Use the game reference to play the sound
    audioService.play(sound: Consts.gunFire);

    super.onLoad();
  }

  @override
  update(double dt) {
    final speed = bloc.state.cannonSpeed;
    if (position.y < 0) {
      removeFromParent();
    } else {
      position.add(Vector2(0, -speed * dt));
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    // We'll handle the Asteroid collision in the Asteroid class
    // This method is here for potential future use or if you want
    // to handle additional collision logic for the Cannon
  }
}
