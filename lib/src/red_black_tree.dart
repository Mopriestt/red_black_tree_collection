// Copyright (c) 2023, Mopriestt.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

part 'rb_tree_map.dart';

part 'rb_tree_set.dart';

typedef Predicate<T> = bool Function(T value);

enum _Color { red, black }

/// A node in a red black tree. It holds the sorting key and the left
/// and right children in the tree.
abstract class _RBTreeNode<K, Node extends _RBTreeNode<K, Node>> {
  K key;

  _Color _color = _Color.red;
  Node? _left;
  Node? _right;
  Node? _parent;

  bool get _isLeftChild => _parent?._left == this;

  Node? get _sibling => _isLeftChild == true ? _parent?._right : _parent?._left;

  Node? get _grandParent => _parent?._parent;

  Node? get _uncle => _parent?._isLeftChild == true
      ? _grandParent?._right
      : _grandParent?._left;

  _RBTreeNode(this.key);

  void _copyDateFrom(Node other) => key = other.key;
  Node get _clone;
}

abstract class _RBTree<K, Node extends _RBTreeNode<K, Node>> {
  Node? _root;
  int _count = 0;

  Comparator<K> get _compare;

  Predicate get _validKey;

  /// Counter incremented whenever the tree structure changes.
  ///
  /// Used to detect concurrent modifications.
  int _modificationCount = 0;

  void _rotateLeft(Node node) {
    assert(node._right != null);

    var newRoot = node._right!;
    node._right = newRoot._left;
    newRoot._left?._parent = node;
    newRoot._left = node;
    newRoot._parent = node._parent;
    node._parent = newRoot;
    if (newRoot._parent?._left == node) {
      newRoot._parent?._left = newRoot;
    } else {
      newRoot._parent?._right = newRoot;
    }

    if (node == _root) _root = newRoot;
  }

  void _rotateRight(Node node) {
    assert(node._left != null);

    var newRoot = node._left!;
    node._left = newRoot._right;
    newRoot._right?._parent = node;
    newRoot._right = node;
    newRoot._parent = node._parent;
    node._parent = newRoot;
    if (newRoot._parent?._left == node) {
      newRoot._parent?._left = newRoot;
    } else {
      newRoot._parent?._right = newRoot;
    }

    if (node == _root) _root = newRoot;
  }

  // Insert new node in the tree without fixing up red black properties.
  // Returns whether the node is inserted.
  bool _treeInsert(Node node) {
    _count++;
    if (_root == null) {
      _root = node;
      return true;
    }

    var current = _root!;
    while (true) {
      var comp = _compare(current.key, node.key);
      if (comp == 0) {
        _count--;
        return false;
      }
      if (comp > 0) {
        if (current._left == null) {
          current._left = node;
          node._parent = current;
          return true;
        }
        current = current._left!;
      } else {
        if (current._right == null) {
          current._right = node;
          node._parent = current;
          return true;
        }
        current = current._right!;
      }
    }
  }

  void _fixInsert(Node node) {
    node._color = _Color.red;
    while (node != _root && node._parent!._color == _Color.red) {
      if (node._parent!._isLeftChild) {
        if (node._uncle?._color == _Color.red) {
          node._parent!._color = _Color.black;
          node._uncle!._color = _Color.black;
          node._grandParent!._color = _Color.red;
          node = node._grandParent!;
        } else {
          if (!node._isLeftChild) {
            node = node._parent!;
            _rotateLeft(node);
          }
          node._parent!._color = _Color.black;
          node._grandParent!._color = _Color.red;
          _rotateRight(node._grandParent!);
        }
      } else {
        if (node._uncle?._color == _Color.red) {
          node._parent!._color = _Color.black;
          node._uncle!._color = _Color.black;
          node._grandParent!._color = _Color.red;
          node = node._grandParent!;
        } else {
          if (node._isLeftChild) {
            node = node._parent!;
            _rotateRight(node);
          }
          node._parent!._color = _Color.black;
          node._grandParent!._color = _Color.red;
          _rotateLeft(node._grandParent!);
        }
      }
    }
    _root!._color = _Color.black;
  }

  bool _addNewNode(Node node) {
    // Return false if same key already exists in the tree.
    if (!_treeInsert(node)) return false;

    // Fix-up the red black property for the new node inserted.
    _fixInsert(node);

    _modificationCount++;
    return true;
  }

  void _fixDelete(Node node) {
    while (node != _root && node._color == _Color.black) {
      var sibling = node._sibling;
      if (node._isLeftChild) {
        if (sibling?._color == _Color.red) {
          sibling!._color = _Color.black;
          node._parent!._color = _Color.red;
          _rotateLeft(node._parent!);
          sibling = node._parent?._right;
        }
        if ((sibling?._left?._color ?? _Color.black) == _Color.black &&
            (sibling?._right?._color ?? _Color.black) == _Color.black) {
          sibling?._color = _Color.red;
          node = node._parent!;
        } else {
          if ((sibling?._right?._color ?? _Color.black) == _Color.black) {
            sibling?._left?._color = _Color.black;
            sibling?._color = _Color.red;
            _rotateRight(sibling!);
            sibling = node._parent?._right;
          }
          sibling?._color = node._parent!._color;
          node._parent?._color = _Color.black;
          sibling?._right?._color = _Color.black;
          _rotateLeft(node._parent!);
          node = _root!;
        }
      } else {
        if (sibling?._color == _Color.red) {
          sibling!._color = _Color.black;
          node._parent!._color = _Color.red;
          _rotateRight(node._parent!);
          sibling = node._parent?._left;
        }
        if ((sibling?._right?._color ?? _Color.black) == _Color.black &&
            (sibling?._left?._color ?? _Color.black) == _Color.black) {
          sibling?._color = _Color.red;
          node = node._parent!;
        } else {
          if ((sibling?._left?._color ?? _Color.black) == _Color.black) {
            sibling?._right?._color = _Color.black;
            sibling?._color = _Color.red;
            _rotateLeft(sibling!);
            sibling = node._parent?._left;
          }
          sibling?._color = node._parent!._color;
          node._parent?._color = _Color.black;
          sibling?._left?._color = _Color.black;
          _rotateRight(node._parent!);
          node = _root!;
        }
      }
    }
    node._color = _Color.black;
  }

  Node? _deleteNodeWithZeroOrOneChild(Node node) {
    Node? replaceChild;
    final parent = node._parent;
    if (node._left == null) {
      replaceChild = node._right;
      if (node._isLeftChild) {
        parent?._left = node._right;
      } else {
        parent?._right = node._right;
      }
      node._right?._parent = parent;
    } else {
      replaceChild = node._left;
      if (node._isLeftChild) {
        parent?._left = node._left;
      } else {
        parent?._right = node._left;
      }
      node._left?._parent = parent;
    }
    if (node == _root) _root = replaceChild;
    --_count;
    return replaceChild;
  }

  Node? _removeNode(K key) {
    var node = _findNode(key);
    if (node == null) return null;
    var returnNode = node;

    // If target node has 2 children, copy the data from either successor or
    // predecessor to it and delete the successor/predecessor instead.
    if (node._left != null && node._right != null) {
      // Randomly replace current node with successor or predecessor.
      late Node replacement;
      if (node.hashCode & 1 == 0) {
        replacement = node._left!;
        while (replacement._right != null) {
          replacement = replacement._right!;
        }
      } else {
        replacement = node._right!;
        while (replacement._left != null) {
          replacement = replacement._left!;
        }
      }
      returnNode = node._clone;
      node._copyDateFrom(replacement);
      node = replacement;
    }

    // Node has at most 1 child at this point.
    var nodeToFix = _deleteNodeWithZeroOrOneChild(node);
    if (nodeToFix != null) _fixDelete(nodeToFix);
    _modificationCount++;
    return returnNode;
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

  Node? get _firstNode {
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

  Node? _lastNodeBefore(K key) {
    if (_root == null) return null;
    Node? current = _root;
    Node? target;

    while (current != null) {
      if (_compare(current.key, key) < 0) {
        if (target == null || _compare(target.key, current.key) < 0) {
          target = current;
        }
        current = current._right;
      } else {
        current = current._left;
      }
    }

    return target;
  }

  Node? _firstNodeAfter(K key) {
    if (_root == null) return null;
    Node? current = _root;
    Node? target;

    while (current != null) {
      if (_compare(current.key, key) > 0) {
        if (target == null || _compare(target.key, current.key) > 0) {
          target = current;
        }
        current = current._left;
      } else {
        current = current._right;
      }
    }

    return target;
  }

  void _clear() {
    _root = null;
    _count = 0;
    _modificationCount++;
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

abstract class IterableElementError {
  /// Error thrown by, e.g., [Iterable.first] when there is no result.
  static StateError noElement() => StateError("No element");
  /// Error thrown by, e.g., [Iterable.single] if there are too many results.
  static StateError tooMany() => StateError("Too many elements");
}
