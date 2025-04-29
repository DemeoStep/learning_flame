import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
import 'package:learning_flame/bloc/game_stats_state.dart';
import 'package:learning_flame/fly_game.dart';

class ScoreOverlay extends StatefulWidget {
  final FlyGame game;

  const ScoreOverlay({required this.game, super.key});

  @override
  State<ScoreOverlay> createState() => _ScoreOverlayState();
}

class _ScoreOverlayState extends State<ScoreOverlay> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<GameStatsCubit, GameStatsState>(
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
                      style: const TextStyle(fontSize: 20, color: Colors.white),
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
            );
          },
        ),
      ),
    );
  }
}
