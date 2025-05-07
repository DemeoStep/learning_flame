import 'package:flame_audio/flame_audio.dart';
import 'package:learning_flame/consts.dart';

class AudioService {
  double volume = 0.1;

  AudioService() {
    _init();
  }

  Future<void> _init() async {
    await FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll(Consts.sounds);
  }

  void play({required String sound}) {
    FlameAudio.play(sound, volume: volume);
  }
}
