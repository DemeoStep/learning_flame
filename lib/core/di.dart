import 'package:get_it/get_it.dart';
import 'package:learning_flame/services/audio_service.dart';
import 'package:learning_flame/services/rive_component_service.dart';

void initDi() {
  final getIt = GetIt.I;

  getIt
    ..registerSingleton<AudioService>(AudioService())
    ..registerSingleton<RiveComponentService>(RiveComponentService());
}

AudioService get audioService => GetIt.I.get<AudioService>();
RiveComponentService get riveComponentService =>
    GetIt.I.get<RiveComponentService>();