import 'dart:collection';

import 'package:red_black_tree_collection/src/tree_base.dart';

/// A node in a red black tree based set.
class _RBTreeSetNode<K> extends RBTreeNode<K, _RBTreeSetNode<K>> {
  _RBTreeSetNode(K key) : super(key);
}

class RBTreeSet<E> extends RBTree<E, _RBTreeSetNode<E>>
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

  @override
  _RBTreeSetNode<E>? _root;

  @override
  // TODO: implement _compare
  Comparator<E> get _compare => throw UnimplementedError();
}