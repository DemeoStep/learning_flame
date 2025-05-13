import 'package:flame_audio/flame_audio.dart';
import 'package:learning_flame/consts.dart';

class AudioService {
  final double volume = 0.1;

  void playExplosion() {
    FlameAudio.play(Consts.explosion, volume: volume);
  }

  void playCannonFire() {
    FlameAudio.play(Consts.gunFire, volume: volume);
  }
}
