import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/actors/actor.dart';

import 'consts.dart';

extension RiveComponentLoader on Actor {
  Future<RiveComponent> loadRiveComponent() async {
    final artBoard = await loadArtboard(
      RiveFile.asset(Consts.mainRiveFilePath),
      artboardName: artBoardName,
    );

    final component = RiveComponent(artboard: artBoard, size: actorSize);

    final controller = StateMachineController.fromArtboard(
      artBoard,
      stateMachineName,
    );

    component.artboard.addController(controller!);

    return component;
  }
}
