import 'package:audioplayers/audioplayers.dart';
import 'package:learning_flame/game/config.dart';

class AudioService {
  final double volume = 0.1;
  final int _explosionsPoolSize = Config.maxAsteroidCount;
  final int _cannonPoolSize = Config.maxClipSize;

  final List<AudioPlayer> _explosionPlayers = [];
  final List<AudioPlayer> _cannonPlayers = [];

  int _explosionIndex = 0;
  int _cannonIndex = 0;

  late final AssetSource _explosionSource;

  AudioService() {
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _explosionSource = AssetSource('audio/explosion.wav');

    for (int i = 0; i < _explosionsPoolSize; i++) {
      final player = AudioPlayer();
      player.setReleaseMode(ReleaseMode.stop);
      player.setVolume(volume);
      _explosionPlayers.add(player);
    }

    for (int i = 0; i < _cannonPoolSize; i++) {
      final player = AudioPlayer();
      player.setReleaseMode(ReleaseMode.stop);
      player.setVolume(volume);
      _cannonPlayers.add(player);
    }
  }

  Future<void> playExplosion() async {
    final player = _explosionPlayers[_explosionIndex];
    _explosionIndex = (_explosionIndex + 1) % _explosionsPoolSize;
    await player.stop();
    await player.play(_explosionSource);
  }

  Future<void> playCannonFire() async {
    final player = _cannonPlayers[_cannonIndex];
    _cannonIndex = (_cannonIndex + 1) % _cannonPoolSize;
    await player.stop();
    await player.play(AssetSource('audio/gun_fire.wav'));
  }

  Future<void> playSound({required String sound}) async {
    final player = AudioPlayer();
    await player.setReleaseMode(ReleaseMode.stop);
    await player.setVolume(volume);
    await player.play(AssetSource(sound));
  }
}