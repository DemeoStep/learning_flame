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
    if (_pool.isEmpty) {
      return null;
    }

    final item = _pool.first;
    _pool.remove(item);
    _active.add(item);
    return item;
  }

  void toPool(T item) {
    // Make sure to remove from active and add to pool
    if (_active.contains(item)) {
      _active.remove(item);
      _pool.add(item);
    } else {
      // If not already active, just add to pool
      _pool.add(item);
    }
  }

  void printPool() {
    print('Active: $activeCount\nPool: $poolSize\nTotal: $totalCount');
  }
}
