import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/fly_game.dart';
import 'package:learning_flame/score_overlay.dart';
import 'package:window_manager/window_manager.dart';

import 'consts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = WindowOptions(
        size: Consts.windowSize,
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.hidden,
      );

      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    } else {
      Flame.device.fullScreen();
      Flame.device.setPortrait();
      Flame.device.setOrientation(DeviceOrientation.portraitUp);
    }
  }

  final gameStatsCubit = GameStatsCubit();

  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (context) => gameStatsCubit,
        child: Scaffold(
          body: GameWidget(
            game: FlyGame(cubit: gameStatsCubit),
            overlayBuilderMap: {
              'score': (context, FlyGame game) => ScoreOverlay(game: game),
            },
          ),
        ),
      ),
    ),
  );
}
