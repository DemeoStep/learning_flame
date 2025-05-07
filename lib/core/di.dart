import 'package:get_it/get_it.dart';
import 'package:learning_flame/services/artboard_service.dart';
import 'package:learning_flame/services/audio_service.dart';

void initDi() {
  final getIt = GetIt.I;

  getIt
    ..registerSingleton<AudioService>(AudioService())
    ..registerSingleton<ArtboardService>(ArtboardService());
}

AudioService get audioService => GetIt.I.get<AudioService>();
ArtboardService get artboardService => GetIt.I.get<ArtboardService>();
