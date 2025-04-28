import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/fly_game.dart';

class Cannon extends PositionComponent
    with
        HasGameReference<FlyGame>,
        FlameBlocReader<GameStatsCubit, GameStatsState> {
  late final RiveComponent cannon;

  int reloadTime = 200;

  late final int firedAtTimestamp;

  late final Vector2 startPosition;

  late final RectangleHitbox hitBox;

  Cannon({required this.startPosition});

  @override
  Future<void> onLoad() async {
    position = startPosition;
    firedAtTimestamp = DateTime.now().millisecondsSinceEpoch;

    final artBoard = game.cannonArtBoard;

    final controller = StateMachineController.fromArtboard(
      game.cannonArtBoard,
      Consts.cannonStateMachineName,
    );

    artBoard.addController(controller!);

    cannon = RiveComponent(artboard: artBoard);

    hitBox = RectangleHitbox(size: cannon.size);

    add(cannon);
    add(hitBox);

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
}
