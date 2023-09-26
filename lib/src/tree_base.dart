typedef _Predicate<T> = bool Function(T value);

/// A node in a red black tree. It holds the sorting key and the left
/// and right children in the tree.
class RBTreeNode<K, Node extends RBTreeNode<K, Node>> {
  final K key;

  // Color of node, true for red, false for black.
  bool color = true;
  Node? _left;
  Node? _right;

  RBTreeNode(this.key);
}

/// A node in a red black tree based map.
///
/// An [RBTreeNode] that also contains a value,
/// and which implements [MapEntry].
class _RBTreeMapNode<K, V> extends RBTreeNode<K, _RBTreeMapNode<K, V>> {
  final V value;
  _RBTreeMapNode(K key, this.value) : super(key);

  _RBTreeMapNode<K, V> _replaceValue(V value) =>
      _RBTreeMapNode<K, V>(key, value)
        .._left = _left
        .._right = _right;
}

abstract class RBTree<K, Node extends RBTreeNode<K, Node>> {
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

  void addNewNode(Node node) {
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
    Node? parent = null;
    Node current = _root!;

    void removeChild(Node? parent, Node child) {
      if (parent?._left == child) parent?._left = null;
      if (parent?._right == child) parent?._right = null;
    }

    void removeNode(Node? parent, Node child) {
      if (child._left == null && child._right == null) {
        removeChild(parent, child);
        return;
      }
      if (child._left == null) {
        if (parent?._left == child) {
          parent?._left = child._right;
        } else {
          parent?._right = child._right;
        }
      } else {
        if (parent?._left == child) {
          parent?._left = child._left;
        } else {
          parent?._right = child._left;
        }
      }
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

  Node? removeNode(K key) {
    return _naiveRemove(key);
  }

  Node? findNode(K key) {
    var current = _root;
    while (current != null) {
      var comp = _compare(key, current.key);

      if (comp == 0) return current;
      current = comp < 0 ? current._left : current._right;
    }

    return null;
  }

  Node? get firstNode  {
    if (_root == null) return null;
    var current = _root!;

    while (current._left != null) {
      current = current._left!;
    }

    return current;
  }

  Node? get lastNode {
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
