import 'package:get_it/get_it.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/services/audio_service.dart';
import 'package:learning_flame/services/rive_component_service.dart';

void initDi() {
  final getIt = GetIt.I;

  getIt
    ..registerSingleton<AudioService>(AudioService())
    ..registerSingleton<RiveComponentService>(RiveComponentService())
    ..registerSingleton<GameStatsCubit>(GameStatsCubit());
}

AudioService get audioService => GetIt.I.get<AudioService>();
RiveComponentService get riveComponentService =>
    GetIt.I.get<RiveComponentService>();
    
GameStatsCubit get gameStatsCubit => GetIt.I.get<GameStatsCubit>();
