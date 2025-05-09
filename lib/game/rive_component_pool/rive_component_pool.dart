import 'package:learning_flame/game/actors/actor.dart';

class ActorsPool<T extends Actor> {
  final List<T> _pool = [];

  final List<T> _active = [];

  int get poolSize => _pool.length;
  int get activeCount => _active.length;

  int get totalCount => _pool.length + _active.length;

  T? get lastActive => _active.lastOrNull;

  void add(T component) {
    _pool.add(component);
  }

  T? fromPool() {
    if (_pool.isNotEmpty) {
      final component = _pool.removeLast();
      _active.add(component);
      return component;
    }

    return null;
  }

  void toPool(T component) {
    if (_active.contains(component)) {
      _active.remove(component);
      _pool.add(component);
    }
  }

  void printPool() {
    print('Active: $activeCount\nPool: $poolSize\nTotal: $totalCount');
  }
}
