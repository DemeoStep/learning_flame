import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_flame/bloc/game_stats_cubit.dart';
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
    return SizedBox(
      height: 50,
      child: BlocBuilder<GameStatsCubit, GameStatsState>(
        builder: (context, state) {
          return Row(
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
            ],
          );
        },
      ),
    );
  }
}
