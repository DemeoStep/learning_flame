import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/actors/actor.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/consts.dart';
import 'package:learning_flame/fly_game.dart';
import 'package:learning_flame/rive_component_loader_mixin.dart';

class GamePlane extends PositionComponent
    with
        HasGameReference<FlyGame>,
        CollisionCallbacks,
        FlameBlocListenable<GameStatsCubit, GameStatsState>
    implements Actor {
  @override
  final String artBoardName = Consts.planeArtBoardName;
  @override
  final String stateMachineName = Consts.planeStateMachineName;
  @override
  final Vector2 actorSize = Consts.planeSize;

  late final RiveComponent plane;
  late final RectangleHitbox hitBox;
  late final SMITrigger hitTrigger;

  bool firing = false;

  FlyDirection flyDirection = FlyDirection.none;
  int _speed = 100;
  final startPosition = Vector2(250, 490);

  @override
  FutureOr<void> onLoad() async {
    position = startPosition;

    final plane = await loadRiveComponent();

    final controller = StateMachineController.fromArtboard(
      plane.artboard,
      stateMachineName,
    );

    hitTrigger = controller!.findSMI<SMITrigger>('Hit')!;

    plane.artboard.addController(controller);

    add(plane);

    anchor = Anchor.topCenter;

    hitBox = RectangleHitbox(size: plane.size);

    add(hitBox);

    return super.onLoad();
  }

  @override
  update(double dt) {
    switch (flyDirection) {
      case FlyDirection.left:
        if (position.x < 0) {
          flyDirection = FlyDirection.none;
        } else {
          position.add(Vector2(-_speed * dt, 0));
        }
      case FlyDirection.right:
        if (position.x + Consts.planeSize.x > Consts.windowSize.width) {
          flyDirection = FlyDirection.none;
        } else {
          position.add(Vector2(_speed * dt, 0));
        }
      case FlyDirection.none:
        break;
    }

    super.update(dt);
  }

  @override
  void onNewState(state) {
    _speed = state.planeSpeed;
  }
}

enum FlyDirection { left, right, none }
