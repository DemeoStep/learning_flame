import 'package:learning_flame/core/di.dart';
import 'package:rive/rive.dart';

import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/game/fly_game.dart';

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

  TextValueRun? levelValue;

  int level = 0;

  @override
  void initState() {
    super.initState();

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
            BlocConsumer<GameStatsCubit, GameStatsState>(
              listener: (context, state) {
                if (state.isGameOver) {
                  levelValue?.text = 'Game Over';
                  _messageShowTrigger?.fire();
                }

                if (state.asteroidCount > level) {
                  if (levelValue != null) {
                    level = state.asteroidCount;

                    levelValue?.text = 'Level $level';
                    _messageShowTrigger?.fire();

                    Future.delayed(const Duration(seconds: 2), () {
                      _messageHideTrigger?.fire();
                    });
                  }
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Score:',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const Gap(5),
                        Text(
                          state.score.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const Gap(20),
                        const Text(
                          'Speed:',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const Gap(5),
                        Text(
                          state.planeSpeed.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const Gap(20),
                        const Text(
                          'Lives:',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const Gap(5),
                        Row(
                          children: List.generate(
                            state.lives,
                            (index) => planeSvg,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 5,
                          children: List.generate(
                            state.clipSize,
                            (index) => cannonSvg,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            Positioned.fill(child: messageAnimation),
          ],
        ),
      ),
    );
  }
}
