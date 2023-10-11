part of 'red_black_tree.dart';

/// A node in a red black tree based map.
///
/// An [_RBTreeNode] that also contains a value,
/// and which implements [MapEntry].
class _RBTreeMapNode<K, V> extends _RBTreeNode<K, _RBTreeMapNode<K, V>> {
  V value;
  _RBTreeMapNode(K key, this.value) : super(key);
}

class RBTreeMap<K, V> extends _RBTree<K, _RBTreeMapNode<K, V>>
    with MapMixin<K, V> {

  Comparator<K> _compare;
  Predicate _validKey;

  RBTreeMap(
      [int Function(K key1, K key2)? compare,
        bool Function(dynamic potentialKey)? isValidKey])
      : _compare = compare ?? _defaultCompare<K>(),
        _validKey = isValidKey ?? ((dynamic a) => a is K);

  @override
  V? operator [](Object? key) {
    if (!_validKey(key)) return null;
    return _findNode(key as dynamic)?.value;
  }

  @override
  void operator []=(K key, V value) {
    final node = _findNode(key);
    if (node != null) node.value = value;
    else _addNewNode(_RBTreeMapNode(key, value));
  }

  @override
  void clear() => _clear();

  @override
  // TODO: implement keys
  Iterable<K> get keys => throw UnimplementedError();

  @override
  V? remove(Object? key) {
    if (!_validKey(key)) return null;
    return _removeNode(key as dynamic)?.value;
  }
}
