import 'dart:collection';

part 'rb_tree_map.dart';
part 'rb_tree_set.dart';

typedef Predicate<T> = bool Function(T value);

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

abstract class _RBTree<K, Node extends _RBTreeNode<K, Node>> {
  Node? _root;
  int _count = 0;

  Comparator<K> get _compare;
  Predicate get _validKey;

  /// Counter incremented whenever the keys in the map change.
  ///
  /// Used to detect concurrent modifications.
  int _modificationCount = 0;

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

  bool _addNewNode(Node node) {
    _count++;
    if (_root == null) {
      _root = node;
      return true;
    }

    var current = _root!;
    while (true) {
      var comp = _compare(current.key, node.key);
      if (comp == 0) return false;
      if (comp > 0) {
        if (current._left == null) {
          current._left = node;
          return true;
        }
        current = current._left!;
      } else {
        if (current._right == null) {
          current._right = node;
          return true;
        }
        current = current._right!;
      }
    }
  }

  Node? _naiveRemove(K key) {
    if (_root == null) return null;
    Node? parent = null;
    Node current = _root!;

    void removeNode(Node? parent, Node child) {
      Node? replaceChild;
      if (child._left == null) {
        replaceChild = child._right;
        if (parent?._left == child) {
          parent?._left = child._right;
        } else {
          parent?._right = child._right;
        }
      } else {
        replaceChild = child._left;
        if (parent?._left == child) {
          parent?._left = child._left;
        } else {
          parent?._right = child._left;
        }
      }
      if (child == _root) _root = replaceChild;
      --_count;
    }

    while (true) {
      var comp = _compare(key, current.key);
      if (comp == 0) {
        // Push down
        while (current._left != null && current._right != null) {
          if (current == _root) {
            _root = _rotateRight(current);
            parent = _root;
            continue;
          }
          parent = _rotateRight(current);
        }
        removeNode(parent, current);
        return current;
      }
      if (comp < 0) {
        if (current._left == null) return null;
        parent = current;
        current = current._left!;
      } else {
        if (current._right == null) return null;
        parent = current;
        current = current._right!;
      }
    }
  }

  Node? _removeNode(K key) {
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

  Node? get _firstNode  {
    if (_root == null) return null;
    var current = _root!;

    while (current._left != null) {
      current = current._left!;
    }

    return current;
  }

  Node? get _lastNode {
    if (_root == null) return null;
    var current = _root!;

    while (current._right != null) {
      current = current._right!;
    }

    return current;
  }

  bool _containsKey(Object? key) {
    return _validKey(key) && _findNode(key as dynamic) != null;
  }

  void _clear() {
    _root = null;
    _count = 0;
  }
}

int _dynamicCompare(dynamic a, dynamic b) => Comparable.compare(a, b);

Comparator<K> defaultCompare<K>() {
  // If K <: Comparable, then we can just use Comparable.compare
  // with no casts.
  Object compare = Comparable.compare;
  if (compare is Comparator<K>) {
    return compare;
  }
  // Otherwise wrap and cast the arguments on each call.
  return _dynamicCompare;
}

abstract class _RBTreeIterator<K, Node extends _RBTreeNode<K, Node>, T>
    implements Iterator<T> {
  final _RBTree<K, Node> _tree;

  /// The current node, and all its ancestors in the tree.
  ///
  /// Only valid as long as the original tree isn't reordered.
  final List<Node> _path = [];

  /// Original modification counter of [_tree].
  ///
  /// Incremented on [_tree] when a key is added or removed.
  /// If it changes, iteration is aborted.
  ///
  /// Not final because some iterators may modify the tree knowingly,
  /// and they update the modification count in that case.
  ///
  /// Starts at `null` to represent a fresh, unstarted iterator.
  int? _modificationCount;

  _RBTreeIterator(_RBTree<K, Node> tree) : _tree = tree;

  T get current {
    if (_path.isEmpty) return null as T;
    var node = _path.last;
    return _getValue(node);
  }

  bool moveNext() {
    if (_modificationCount != _tree._modificationCount) {
      if (_modificationCount == null) {
        _modificationCount = _tree._modificationCount;
        var node = _tree._root;
        while (node != null) {
          _path.add(node);
          node = node._left;
        }
        return _path.isNotEmpty;
      }
      throw ConcurrentModificationError(_tree);
    }
    if (_path.isEmpty) return false;
    var node = _path.last;
    var next = node._right;
    if (next != null) {
      while (next != null) {
        _path.add(next);
        next = next._left;
      }
      return true;
    }
    _path.removeLast();
    while (_path.isNotEmpty && identical(_path.last._right, node)) {
      node = _path.removeLast();
    }
    return _path.isNotEmpty;
  }

  T _getValue(Node node);
}

class _RBTreeKeyIterator<K, Node extends _RBTreeNode<K, Node>>
    extends _RBTreeIterator<K, Node, K> {
  _RBTreeKeyIterator(_RBTree<K, Node> tree) : super(tree);
  K _getValue(Node node) => node.key;
}