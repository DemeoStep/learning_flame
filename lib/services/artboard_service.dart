import 'package:flame_rive/flame_rive.dart';
import 'package:learning_flame/consts.dart';

class ArtboardService {
  final List<Artboard> artboards = [];

  ArtboardService() {
    _init();
  }

  Future<void> _init() async {
    var [
      spaceArtBoard,
      planeArtBoard,
      cannonArtBoard,
      asteroidArtBoard,
    ] = await Future.wait([
      _loadArtboards(
        artBoardName: Consts.spaceArtBoardName,
        stateMachineName: Consts.spaceStateMachineName,
      ),
      _loadArtboards(
        artBoardName: Consts.planeArtBoardName,
        stateMachineName: Consts.planeStateMachineName,
      ),
      _loadArtboards(
        artBoardName: Consts.cannonArtBoardName,
        stateMachineName: Consts.cannonStateMachineName,
      ),
      _loadArtboards(
        artBoardName: Consts.asteroidArtBoardName,
        stateMachineName: Consts.asteroidStateMachineName,
      ),
    ]);

    artboards.addAll([
      spaceArtBoard,
      planeArtBoard,
      cannonArtBoard,
      asteroidArtBoard,
    ]);
  }

  Future<Artboard> _loadArtboards({
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

  Artboard getArtboard(String name) {
    return artboards.firstWhere((artboard) => artboard.name == name);
  }
}
