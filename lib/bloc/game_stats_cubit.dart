import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_stats_state.dart';

class GameStatsCubit extends Cubit<GameStatsState> {
  GameStatsCubit() : super(GameStatsState());

  void updateScore() {
    final score = state.score + 1;
    emit(
      GameStatsState(
        score: score,
        planeSpeed: _calculatePlaneSpeed(score),
        cannonSpeed: _calculateCannonSpeed(score),
      ),
    );
  }

  int _calculatePlaneSpeed(int score) {
    return 100 + (score.clamp(0, 200) ~/ 10) * 10;
  }

  int _calculateCannonSpeed(int score) {
    return 200 + (score.clamp(0, 200) ~/ 10) * 10;
  }
}
