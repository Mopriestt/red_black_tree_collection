import 'dart:collection';

import 'package:red_black_tree_collection/src/tree_base.dart';

/// A node in a red black tree based map.
///
/// An [RBTreeNode] that also contains a value,
/// and which implements [MapEntry].
class _RBTreeMapNode<K, V> extends RBTreeNode<K, _RBTreeMapNode<K, V>> {
  final V value;
  _RBTreeMapNode(K key, this.value) : super(key);
}


class RBTreeMap<K, V> extends RBTree<K, _RBTreeMapNode<K, V>>
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
}
