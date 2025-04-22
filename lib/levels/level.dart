import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/actors/player.dart';

class Level extends World {
  late final RiveComponent space;

  @override
  FutureOr<void> onLoad() async {
    final spaceArtboard = await loadArtboard(
      RiveFile.asset('assets/rive/fly.riv'),
      artboardName: 'Space',
    );

    final controller = StateMachineController.fromArtboard(
      spaceArtboard,
      "SpaceSM",
    );

    spaceArtboard.addController(controller!);

    space = RiveComponent(artboard: spaceArtboard, size: Vector2.all(600));

    add(space);

    add(Player());
    return super.onLoad();
  }
}
