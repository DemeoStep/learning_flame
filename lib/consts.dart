import 'package:flame/extensions.dart';

class Consts {
  static const Size windowSize = Size(600, 600);

  static const String mainRiveFilePath = 'assets/rive/fly.riv';

  static const String spaceArtBoardName = 'Space';
  static const String planeArtBoardName = 'Plane';
  static const String cannonArtBoardName = 'Cannon';
  static const String asteroidArtBoardName = 'Asteroid';

  static const String spaceStateMachineName = 'SpaceSM';
  static const String planeStateMachineName = 'FlySM';
  static const String cannonStateMachineName = 'CannonSM';
  static const String asteroidStateMachineName = 'AsteroidSM';

  static Vector2 spaceSize = Vector2(600, 600);
  static Vector2 planeSize = Vector2(100, 100);
  static Vector2 cannonSize = Vector2(5, 10);
  static Vector2 asteroidSize = Vector2(30, 30);
}
