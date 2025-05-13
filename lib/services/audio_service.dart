import 'package:flame_audio/flame_audio.dart';
import 'package:learning_flame/game/config.dart';
import 'package:learning_flame/consts.dart';

class AudioService {
  final double volume = 0.1;
  final int _explosionsPoolSize = Config.maxAsteroidCount;
  final int _cannonPoolSize = Config.maxClipSize;

  AudioPool? _explosionPool;
  AudioPool? _cannonPool;

  Future<void> init() async {
    _explosionPool ??= await FlameAudio.createPool(
      Consts.explosion,
      maxPlayers: _explosionsPoolSize,
    );
    _cannonPool ??= await FlameAudio.createPool(
      Consts.gunFire,
      maxPlayers: _cannonPoolSize,
    );
  }

  void playExplosion() {
    _explosionPool?.start(volume: volume);
  }

  void playCannonFire() {
    _cannonPool?.start(volume: volume);
  }
}
