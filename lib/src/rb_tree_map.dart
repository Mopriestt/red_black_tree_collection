part of 'red_black_tree.dart';

/// A node in a red black tree based map.
///
/// An [_RBTreeNode] that also contains a value,
/// and which implements [MapEntry].
class _RBTreeMapNode<K, V> extends _RBTreeNode<K, _RBTreeMapNode<K, V>> {
  final V value;
  _RBTreeMapNode(K key, this.value) : super(key);
}

class RBTreeMap<K, V> extends _RBTree<K, _RBTreeMapNode<K, V>>
    with MapMixin<K, V> {
  @override
  V? operator [](Object? key) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  void operator []=(K key, V value) {
    // TODO: implement []=
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  // TODO: implement keys
  Iterable<K> get keys => throw UnimplementedError();

  @override
  V? remove(Object? key) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  // TODO: implement _compare
  Comparator<K> get _compare => throw UnimplementedError();

  @override
  // TODO: implement _validKey
  Predicate get _validKey => throw UnimplementedError();
}
