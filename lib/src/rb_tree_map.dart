// Copyright (c) 2023, Mopriestt.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'red_black_tree.dart';

/// A node in a red black tree based map.
///
/// An [_RBTreeNode] that also contains a value which implements [MapEntry].
class _RBTreeMapNode<K, V> extends _RBTreeNode<K, _RBTreeMapNode<K, V>> {
  V value;

  _RBTreeMapNode(K key, this.value) : super(key);

  @override
  void _copyDateFrom(_RBTreeMapNode<K, V> other) {
    key = other.key;
    value = other.value;
  }

  @override
  _RBTreeMapNode<K, V> get _clone => _RBTreeMapNode<K, V>(key, value);
}

class RBTreeMap<K, V> extends _RBTree<K, _RBTreeMapNode<K, V>>
    with MapMixin<K, V> {
  Comparator<K> _compare;
  Predicate _validKey;

  RBTreeMap([
    int Function(K key1, K key2)? compare,
    bool Function(dynamic potentialKey)? isValidKey,
  ])  : _compare = compare ?? _defaultCompare<K>(),
        _validKey = isValidKey ?? ((dynamic a) => a is K);

  /// Creates a [RBTreeMap] that contains all key/value pairs of [other].
  /// Example:
  /// ```dart
  /// final baseMap = <int, String>{3: 'A', 2: 'B', 1: 'C', 4: 'D'};
  /// final mapOf = RBTreeMap<num, Object>.of(baseMap);
  /// print(mapOf); // {1: C, 2: B, 3: A, 4: D}
  /// ```
  factory RBTreeMap.of(
    Map<K, V> other, [
    int Function(K key1, K key2)? compare,
    bool Function(dynamic potentialKey)? isValidKey,
  ]) =>
      RBTreeMap<K, V>(compare, isValidKey)..addAll(other);

  @override
  V? operator [](Object? key) {
    if (!_validKey(key)) return null;
    return _findNode(key as dynamic)?.value;
  }

  @override
  void operator []=(K key, V value) {
    final node = _findNode(key);
    if (node != null) {
      node.value = value;
    } else {
      _addNewNode(_RBTreeMapNode(key, value));
    }
  }

  @override
  V? remove(Object? key) {
    if (!_validKey(key)) return null;
    return _removeNode(key as dynamic)?.value;
  }

  V update(K key, V update(V value), {V Function()? ifAbsent}) {
    final node = _findNode(key);
    if (node != null) {
      var modificationCount = _modificationCount;
      var newValue = update(node.value);
      if (modificationCount != _modificationCount) {
        throw ConcurrentModificationError(this);
      }
      node.value = newValue;
      return newValue;
    }
    if (ifAbsent != null) {
      var modificationCount = _modificationCount;
      var newValue = ifAbsent();
      if (modificationCount != _modificationCount) {
        throw ConcurrentModificationError(this);
      }
      _addNewNode(_RBTreeMapNode(key, newValue));
      return newValue;
    }
    throw ArgumentError.value(key, "key", "Key not in map.");
  }

  @override
  void clear() => _clear();

  /// Returns the largest key in the map that is smaller than the given [key]
  /// in O(log n) time. If no such key is found, returns `null`.
  ///
  /// Example:
  /// ```dart
  /// final treeMap = RBTreeMap<int, String>()..addAll({3: 'A', 7: 'B', 10: 'C'});
  /// print(treeMap.lastKeyBefore(8)); // Output: 7
  /// print(treeMap.lastKeyBefore(1)); // Output: null
  /// ```
  K? lastKeyBefore(K key) => _lastNodeBefore(key)?.key;

  /// Returns the smallest key in the map that is greater than the given [key]
  /// in O(log n) time. If no such key is found, returns `null`.
  ///
  /// Example:
  /// ```dart
  /// final treeMap = RBTreeMap<int, String>()..addAll({3: 'A', 7: 'B', 10: 'C'});
  /// print(treeMap.firstKeyAfter(6)); // Output: 7
  /// print(treeMap.firstKeyAfter(10)); // Output: null
  /// ```
  ///
  K? firstKeyAfter(K key) => _firstNodeAfter(key)?.key;

  Iterable<K> get keys => _RBTreeKeyIterable<K, _RBTreeMapNode<K, V>>(this);

  Iterable<V> get values => _RBTreeValueIterable<K, V>(this);

  Iterable<MapEntry<K, V>> get entries => _RBTreeMapEntryIterable<K, V>(this);
}

class _RBTreeKeyIterable<K, Node extends _RBTreeNode<K, Node>>
    extends Iterable<K> {
  _RBTree<K, Node> _tree;

  _RBTreeKeyIterable(this._tree);

  int get length => _tree._count;

  bool get isEmpty => _tree._count == 0;

  @override
  Iterator<K> get iterator => _RBTreeKeyIterator<K, Node>(_tree);

  @override
  bool contains(Object? o) => _tree._containsKey(o);
}

class _RBTreeValueIterable<K, V> extends Iterable<V> {
  RBTreeMap<K, V> _map;

  _RBTreeValueIterable(this._map);

  int get length => _map._count;

  bool get isEmpty => _map._count == 0;

  Iterator<V> get iterator => _RBTreeValueIterator<K, V>(_map);
}

class _RBTreeValueIterator<K, V>
    extends _RBTreeIterator<K, _RBTreeMapNode<K, V>, V> {
  _RBTreeValueIterator(RBTreeMap<K, V> map) : super(map);

  V _getValue(_RBTreeMapNode<K, V> node) => node.value;
}

class _RBTreeMapEntryIterable<K, V> extends Iterable<MapEntry<K, V>> {
  RBTreeMap<K, V> _map;

  _RBTreeMapEntryIterable(this._map);

  int get length => _map._count;

  bool get isEmpty => _map._count == 0;

  Iterator<MapEntry<K, V>> get iterator => _RBTreeMapEntryIterator<K, V>(_map);
}

class _RBTreeMapEntryIterator<K, V>
    extends _RBTreeIterator<K, _RBTreeMapNode<K, V>, MapEntry<K, V>> {
  _RBTreeMapEntryIterator(RBTreeMap<K, V> tree) : super(tree);

  MapEntry<K, V> _getValue(_RBTreeMapNode<K, V> node) =>
      MapEntry<K, V>(node.key, node.value);
}
