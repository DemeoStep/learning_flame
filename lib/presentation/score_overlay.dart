import 'package:learning_flame/core/di.dart';
import 'package:learning_flame/game/levels/level.dart';
import 'package:rive/rive.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:learning_flame/game/fly_game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learning_flame/providers/game_stats_provider.dart';

class ScoreOverlay extends ConsumerStatefulWidget {
  final FlyGame game;

  const ScoreOverlay({required this.game, super.key});

  @override
  ConsumerState<ScoreOverlay> createState() => _ScoreOverlayState();
}

class _ScoreOverlayState extends ConsumerState<ScoreOverlay> {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(gameStatsProvider);

      widget.game.isGameOver.addListener(() {
        final isGameOver = widget.game.isGameOver.value;
        if (isGameOver) {
          levelValue?.text = 'Game Over';
          _messageShowTrigger?.fire();
        }
      });

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
    final state = ref.watch(gameStatsProvider);

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
                      valueListenable: widget.game.score,
                      builder: (context, value, _) {
                        return Text(
                          value.toString(),
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        );
                      }
                    ),
                    const Gap(20),
                    const Text(
                      'Speed:',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const Gap(5),
                    Text(
                      state.planeSpeed.toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const Gap(20),
                    const Text(
                      'Lives:',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    const Gap(5),
                    ValueListenableBuilder<int>(
                      valueListenable: widget.game.lives,
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
              child: ValueListenableBuilder(
                valueListenable:
                    (widget.game.world as Level)
                        .cannonsPool
                        .activeCountNotifier,
                builder: (context, value, _) {
                  return Row(
                    spacing: 5,
                    children: [
                      ...List.generate(
                        widget.game.clipSize.value - value,
                        (index) => cannonSvg,
                      ),
                      ...List.generate(
                        value,
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
