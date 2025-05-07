import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:learning_flame/consts.dart';

class RiveComponentService {
  late final RiveFile _file;

  RiveFile get file => _file;

  RiveComponentService() {
    _init();
  }

  void _init() {
    RiveFile.asset(Consts.mainRiveFilePath).then((riveFile) {
      _file = riveFile;
    });
  }

  Future<RiveComponent> loadRiveComponent(Actor actor) async {
    final artBoard = await loadArtboard(file, artboardName: actor.artBoardName);

    final component = RiveComponent(artboard: artBoard, size: actor.actorSize);

    final controller = StateMachineController.fromArtboard(
      artBoard,
      actor.stateMachineName,
    );

    component.artboard.addController(controller!);

    return component;
  }
}
