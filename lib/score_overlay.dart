import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
      child: BlocBuilder<GameStatsCubit, GameStatsState>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Score:',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    state.score.toString(),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Speed:',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    state.planeSpeed.toString(),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Lives:',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(width: 5),
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
                    spacing: 2,
                    children: List.generate(
                      state.fireAtOnce,
                      (index) => SvgPicture.asset(
                        'assets/svg/cannon.svg',
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
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }
}
