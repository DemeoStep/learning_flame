import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_flame/fly.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = WindowOptions(
        size: Size(600, 600),
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

  runApp(GameWidget(game: FlyGame()));
}
