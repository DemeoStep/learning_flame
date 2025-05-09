import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/game/actors/actor.dart';
import 'package:learning_flame/consts.dart';

class RiveComponentService {
  late final RiveFile _file;
  Future<void>? _initFuture;
  
  RiveFile get file => _file;

  RiveComponentService() {
    _initFuture = _init();
  }
  
  Future<void> _init() async {
    _file = await RiveFile.asset(Consts.mainRiveFilePath);
  }

  Future<void> ensureInitialized() async {
    await _initFuture;
  }

  Future<RiveComponent> loadRiveComponent(Actor actor) async {
    await ensureInitialized();
    
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