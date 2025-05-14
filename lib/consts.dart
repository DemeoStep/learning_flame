import 'package:flame/extensions.dart';
import 'package:flutter/services.dart';

class Consts {
  static const Size windowSize = Size(600, 600);

  static const String mainRiveFilePath = 'assets/rive/fly.riv';

  static const String spaceArtBoardName = 'Space';
  static const String planeArtBoardName = 'Plane';
  static const String cannonArtBoardName = 'Cannon';
  static const String asteroidArtBoardName = 'Asteroid';
  static const String mojaherArtBoardName = 'Mojaher';
  static const String powerUpArtBoardName = 'PowerUp';

  static const String spaceStateMachineName = 'SpaceSM';
  static const String planeStateMachineName = 'FlySM';
  static const String cannonStateMachineName = 'CannonSM';
  static const String asteroidStateMachineName = 'AsteroidSM';
  static const String mojaherStateMachineName = 'MojaherSM';
  static const String powerUpStateMachineName = 'PowerUpSM';

  static Vector2 spaceSize = Vector2(600, 600);
  static Vector2 planeSize = Vector2(60, 100);
  static Vector2 cannonSize = Vector2(5, 10);
  static Vector2 asteroidSize = Vector2(30, 30);
  static Vector2 mojaherSize = Vector2(50, 24);
  static Vector2 powerUpSize = Vector2(35, 35);

  // Pause key
  static const pauseKey = LogicalKeyboardKey.keyP;

  //Sounds
  static const String _audioPathPrefix = '';
  static const String gunFire = '$_audioPathPrefix/gun_fire.mp3';
  static const String explosion = '$_audioPathPrefix/explosion.mp3';
  static const List<String> sounds = [gunFire, explosion];
}
