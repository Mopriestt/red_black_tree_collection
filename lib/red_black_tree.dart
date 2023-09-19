library red_black_tree_collection;

import 'dart:collection';

/// A node in a red black tree. It holds the sorting key and the left
/// and right children in the tree.
class _RBTreeNode<K, Node extends _RBTreeNode<K, Node>> {
  final K key;

  Node? _left;
  Node? _right;

  _RBTreeNode(this.key);
}

/// A node in a red black tree based set.
class _RBTreeSetNode<K> extends _RBTreeNode<K, _RBTreeSetNode<K>> {
  _RBTreeSetNode(K key) : super(key);
}

/// A node in a red black tree based map.
///
/// An [_RBTreeNode] that also contains a value,
/// and which implements [MapEntry].
class _RBTreeMapNode<K, V> extends _RBTreeNode<K, _RBTreeMapNode<K, V>> {
  final V value;
  _RBTreeMapNode(K key, this.value) : super(key);

  _RBTreeMapNode<K, V> _replaceValue(V value) =>
      _RBTreeMapNode<K, V>(key, value)
        .._left = _left
        .._right = _right;
}

abstract class _RBTree<K, Node extends _RBTreeNode<K, Node>> {

}


final class RBTreeMap<K, V> extends _RBTree<K, _RBTreeMapNode<K, V>>
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

final class RBTreeSet<E> extends _RBTree<E, _RBTreeSetNode<E>>
    with Iterable<E>, SetMixin<E> {
  @override
  bool add(E value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  // TODO: implement iterator
  Iterator<E> get iterator => throw UnimplementedError();

  @override
  E? lookup(Object? element) {
    // TODO: implement lookup
    throw UnimplementedError();
  }

  @override
  bool remove(Object? value) {
    // TODO: implement remove
    throw UnimplementedError();
  }

}