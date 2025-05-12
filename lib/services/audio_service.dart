import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final double volume = 0.1;
  final Map<String, AudioPlayer> _players = {};

  AudioService() {
    _init();
  }

  Future<void> _init() async {
    // No need to preload with audioplayers v1.0+, assets are loaded on demand.
  }

  void playSound({required String sound}) async {
    var player = AudioPlayer();
    
    if (_players.containsKey(sound)) {
      player = _players[sound]!;
    } else {
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setVolume(volume);
    }
    
    //player.stop();
    player.play(AssetSource(sound));
    _players[sound] = player;
  }
}
