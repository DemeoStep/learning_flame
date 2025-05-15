import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/game.dart';
import 'package:learning_flame/presentation/score_overlay.dart';
import 'package:window_manager/window_manager.dart';

import 'consts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initDi();

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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: kDebugMode,
      home: Scaffold(
        body: GameWidget(
          game: FlyGame(),
          overlayBuilderMap: {
            'score': (context, FlyGame game) => ScoreOverlay(game: game),
          },
        ),
      ),
    );
  }
}
