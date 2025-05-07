import 'package:rive/rive.dart';

import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/game/fly_game.dart';

import '../consts.dart';

class ScoreOverlay extends StatefulWidget {
  final FlyGame game;

  const ScoreOverlay({required this.game, super.key});

  @override
  State<ScoreOverlay> createState() => _ScoreOverlayState();
}

class _ScoreOverlayState extends State<ScoreOverlay> {
  SMITrigger? _messageShowTrigger;
  SMITrigger? _messageHideTrigger;

  TextValueRun? levelValue;

  int level = 0;

  void _onInit(Artboard artboard, GameStatsCubit cubit) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'MessageSM',
    );

    artboard.addController(controller!);

    levelValue = artboard.component<TextValueRun>('Message')!;

    _messageShowTrigger = controller.getTriggerInput('ShowMessage')!;
    _messageHideTrigger = controller.getTriggerInput('HideMessage')!;

    cubit.gameStart();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<GameStatsCubit, GameStatsState>(
          builder: (context, state) {
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
            return Stack(
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
                            (index) => SvgPicture.asset(
                              'assets/svg/plane.svg',
                              height: 30,
                              colorFilter: ColorFilter.mode(
                                Colors.white54,
                                BlendMode.srcIn,
                              ),
                            ),
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
                            state.fireAtOnce,
                            (index) => SvgPicture.asset(
                              'assets/svg/cannon.svg',
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                Colors.white54,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned.fill(
                  child: RiveAnimation.asset(
                    Consts.mainRiveFilePath,
                    artboard: 'Message',
                    // fit: BoxFit.fill,
                    stateMachines: ['MessageSM'],
                    onInit:
                        (artboard) =>
                            _onInit(artboard, context.read<GameStatsCubit>()),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
