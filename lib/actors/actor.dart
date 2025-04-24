import 'package:flame/components.dart';

abstract class Actor {
  final String artBoardName;
  final String stateMachineName;
  final Vector2 actorSize;

  Actor({
    required this.artBoardName,
    required this.stateMachineName,
    required this.actorSize,
  });
}
