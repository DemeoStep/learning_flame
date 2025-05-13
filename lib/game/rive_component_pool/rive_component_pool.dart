import 'package:flutter/foundation.dart';
import 'package:learning_flame/game/actors/actor.dart';

class ActorsPool<T extends Actor> {
  final List<T> _pool = [];

  final List<T> _active = [];

  List<T> get pool => _pool.toList();

  int get poolSize => _pool.length;
  int get activeCount => _active.length;

  int get totalCount => _pool.length + _active.length;

  T? get lastActive => _active.lastOrNull;

  ValueNotifier<int> activeCountNotifier = ValueNotifier(0);

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
    activeCountNotifier.value = _active.length;
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
    activeCountNotifier.value = _active.length;
  }
}
