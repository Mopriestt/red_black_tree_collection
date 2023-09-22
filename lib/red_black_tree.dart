library red_black_tree_collection;

import 'dart:collection';

typedef _Predicate<T> = bool Function(T value);

/// A node in a red black tree. It holds the sorting key and the left
/// and right children in the tree.
class _RBTreeNode<K, Node extends _RBTreeNode<K, Node>> {
  final K key;

  // Color of node, true for red, false for black.
  bool color = true;
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
  Node? _root;
  int _count = 0;

  Comparator<K> get _compare;

  _Predicate get _validKey;

  Node _rotateLeft(Node node) {
    if (node._right == null) return node;

    var newRoot = node._right!;
    node._right = newRoot._left;
    newRoot._left = node;

    return newRoot;
  }

  Node _rotateRight(Node node) {
    if (node._left == null) return node;

    var newRoot = node._left!;
    node._left = newRoot._right;
    newRoot._right = node;

    return newRoot;
  }

  void _addNewNode(Node node) {
    _count++;
    if (_root == null) {
      _root = node;
      return;
    }

    var current = _root!;
    while (true) {
      var comp = _compare(current.key, node.key);
      if (comp > 0) {
        if (current._left == null) {
          current._left = node;
          break;
        }
        current = current._left!;
      } else {
        if (current._right == null) {
          current._right = node;
          break;
        }
        current = current._right!;
      }
    }
  }

  Node? _naiveRemove(K key) {
    if (_root == null) return null;
    return null;
  }

  Node? _remove(K key) {
    return _naiveRemove(key);
  }

  Node? _findNode(K key) {
    var current = _root;
    while (current != null) {
      var comp = _compare(key, current.key);

      if (comp == 0) return current;
      current = comp < 0 ? current._left : current._right;
    }

    return null;
  }

  Node? get _first  {
    if (_root == null) return null;
    var current = _root!;

    while (current._left != null) {
      current = current._left!;
    }

    return current;
  }

  Node? get _last {
    if (_root == null) return null;
    var current = _root!;

    while (current._right != null) {
      current = current._right!;
    }

    return current;
  }
}

int _dynamicCompare(dynamic a, dynamic b) => Comparable.compare(a, b);

Comparator<K> _defaultCompare<K>() {
  // If K <: Comparable, then we can just use Comparable.compare
  // with no casts.
  Object compare = Comparable.compare;
  if (compare is Comparator<K>) {
    return compare;
  }
  // Otherwise wrap and cast the arguments on each call.
  return _dynamicCompare;
}

/*
class RBTreeMap<K, V> extends _RBTree<K, _RBTreeMapNode<K, V>>
    with MapMixin<K, V> {
  @override
  V? operator [](Object? key) {
    SplayTreeMap<int, int>((int a, int b) => a - b);
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

class RBTreeSet<E> extends _RBTree<E, _RBTreeSetNode<E>>
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

  @override
  // TODO: implement _validKey
  _Predicate get _validKey => throw UnimplementedError();

}
*/
