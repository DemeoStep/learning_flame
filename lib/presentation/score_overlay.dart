import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/core/value_listenable_builder2.dart';
import 'package:learning_flame/game/game_state/game_state.dart';
import 'package:learning_flame/game/levels/level.dart';
import 'package:rive/rive.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:learning_flame/game/game.dart';

class ScoreOverlay extends StatefulWidget {
  final FlyGame game;

  const ScoreOverlay({required this.game, super.key});

  @override
  State<ScoreOverlay> createState() => _ScoreOverlayState();
}

class _ScoreOverlayState extends State<ScoreOverlay> {
  SMITrigger? _bigMessageShowTrigger;
  SMITrigger? _bigMessageHideTrigger;

  SMITrigger? _smallMessageShowTrigger;

  late final RiveAnimation bigMessageAnimation;
  late final RiveAnimation smallMessageAnimation;
  late final SvgPicture planeSvg;
  late final SvgPicture cannonSvg;

  late final GameState state;

  TextValueRun? levelValue;
  TextValueRun? smallMessageValue;

  int level = 0;

  @override
  void initState() {
    super.initState();

    state = widget.game.gameState;

    planeSvg = SvgPicture.asset(
      'assets/svg/plane.svg',
      height: 30,
      colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
    );

    cannonSvg = SvgPicture.asset(
      'assets/svg/cannon.svg',
      height: 30,
      colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
    );

    bigMessageAnimation = RiveAnimation.direct(
      riveComponentService.file,
      artboard: 'Message',
      stateMachines: ['MessageSM'],
      onInit: (artboard) => _onMessageInit(artboard, true),
    );

    smallMessageAnimation = RiveAnimation.direct(
      riveComponentService.file,
      artboard: 'SmallMessage',
      stateMachines: ['SmallMessageSM'],
      onInit: (artboard) => _onMessageInit(artboard, false),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.isGameOverNotifier.addListener(() {
        final isGameOver = state.isGameOver;
        if (isGameOver) {
          levelValue?.text = 'Game Over';
          _bigMessageShowTrigger?.fire();
        }
      });

      state.isPausedNotifier.addListener(() {
        final isPaused = state.isPaused;
        if (isPaused) {
          levelValue?.text = 'Paused';
          _bigMessageShowTrigger?.fire();
        } else {
          _bigMessageHideTrigger?.fire();
        }
      });

      state.levelNotifier.addListener(() {
        final gameLevel = state.level;
        if (gameLevel > level) {
          if (levelValue != null) {
            level = state.level;
            levelValue?.text = 'Level $level';
            _bigMessageShowTrigger?.fire();
            Future.delayed(const Duration(seconds: 2), () {
              _bigMessageHideTrigger?.fire();
            });
          }
        }
      });

      state.powerUpNotifier.addListener(() {
        final powerUp = state.powerUp;
        if (powerUp.isNotEmpty) {
          smallMessageValue?.text = powerUp;
          _smallMessageShowTrigger?.fire();
        }
      });
    });
  }

  void _onMessageInit(Artboard artboard, bool bigMessage) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      bigMessage ? 'MessageSM' : 'SmallMessageSM',
    );

    artboard.addController(controller!);

    if (bigMessage) {
      levelValue = artboard.component<TextValueRun>('Message')!;

      _bigMessageShowTrigger = controller.getTriggerInput('ShowMessage')!;
      _bigMessageHideTrigger = controller.getTriggerInput('HideMessage')!;
    } else {
      smallMessageValue = artboard.component<TextValueRun>('Message')!;
      _smallMessageShowTrigger = controller.getTriggerInput('Show')!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Score:',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const Gap(5),
                    ValueListenableBuilder(
                      valueListenable: state.scoreNotifier,
                      builder: (context, value, _) {
                        return Text(
                          value.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    const Gap(20),
                    const Text(
                      'Speed:',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const Gap(5),
                    ValueListenableBuilder(
                      valueListenable: state.planeSpeedNotifier,
                      builder: (context, value, _) {
                        return Text(
                          value.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    const Gap(20),
                    const Text(
                      'Lives:',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const Gap(5),
                    ValueListenableBuilder<int>(
                      valueListenable: state.livesNotifier,
                      builder: (context, value, _) {
                        if (value <= 0) {
                          return SizedBox();
                        }
                        return Row(
                          children: List.generate(value, (index) => planeSvg),
                        );
                      },
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: ValueListenableBuilder2<int, int>(
                first:
                    (widget.game.world as Level)
                        .cannonsPool
                        .activeCountNotifier,
                second: state.clipSizeNotifier,
                builder: (context, cannonsFired, clipSize, _) {
                  return Row(
                    spacing: 5,
                    children: [
                      ...List.generate(
                        clipSize - cannonsFired,
                        (index) => cannonSvg,
                      ),
                      ...List.generate(
                        cannonsFired,
                        (index) => Opacity(opacity: 0.5, child: cannonSvg),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned.fill(child: bigMessageAnimation),
            Positioned.fill(child: smallMessageAnimation),
          ],
        ),
      ),
    );
  }
}
