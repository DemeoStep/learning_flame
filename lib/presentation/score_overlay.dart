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
  SMITrigger? _messageShowTrigger;
  SMITrigger? _messageHideTrigger;

  late final RiveAnimation messageAnimation;
  late final SvgPicture planeSvg;
  late final SvgPicture cannonSvg;

  late final GameState state;

  TextValueRun? levelValue;

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

    messageAnimation = RiveAnimation.direct(
      riveComponentService.file,
      artboard: 'Message',
      stateMachines: ['MessageSM'],
      onInit: _onInit,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.isGameOverNotifier.addListener(() {
        final isGameOver = state.isGameOver;
        if (isGameOver) {
          levelValue?.text = 'Game Over';
          _messageShowTrigger?.fire();
        }
      });

      state.isPausedNotifier.addListener(() {
        final isPaused = state.isPaused;
        if (isPaused) {
          levelValue?.text = 'Paused';
          _messageShowTrigger?.fire();
        } else {
          _messageHideTrigger?.fire();
        }
      });

      state.asteroidCountNotifier.addListener(() {
        final gameLevel = state.asteroidCount;
        if (gameLevel > level) {
          if (levelValue != null) {
            level = state.asteroidCount;
            levelValue?.text = 'Level $level';
            _messageShowTrigger?.fire();
            Future.delayed(const Duration(seconds: 2), () {
              _messageHideTrigger?.fire();
            });
          }
        }
      });
    });
  }

  void _onInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'MessageSM',
    );

    artboard.addController(controller!);

    levelValue = artboard.component<TextValueRun>('Message')!;

    _messageShowTrigger = controller.getTriggerInput('ShowMessage')!;
    _messageHideTrigger = controller.getTriggerInput('HideMessage')!;
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
            Positioned.fill(child: messageAnimation),
          ],
        ),
      ),
    );
  }
}
