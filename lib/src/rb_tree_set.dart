// Copyright (c) 2023, Mopriestt.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'red_black_tree.dart';

/// A node in a red black tree based set.
class _RBTreeSetNode<K> extends _RBTreeNode<K, _RBTreeSetNode<K>> {
  _RBTreeSetNode(K key) : super(key);

  @override
  _RBTreeSetNode<K> get _clone => _RBTreeSetNode<K>(key);
}

class RBTreeSet<E> extends _RBTree<E, _RBTreeSetNode<E>>
    with Iterable<E>, SetMixin<E> {
  _RBTreeSetNode<E>? _root;

  Comparator<E> _compare;
  Predicate _validKey;

  /// Create a new [RBTreeSet] with the given compare function.
  ///
  /// If the [compare] function is omitted, it defaults to [Comparable.compare],
  /// and the elements must be comparable.
  ///
  /// A provided `compare` function may not work on all objects. It may not even
  /// work on all `E` instances.
  ///
  /// For operations that add elements to the set, the user is supposed to not
  /// pass in objects that don't work with the compare function.
  ///
  /// The methods [contains], [remove], [lookup], [removeAll] or [retainAll]
  /// are typed to accept any object(s), and the [isValidKey] test can used to
  /// filter those objects before handing them to the `compare` function.
  ///
  /// If [isValidKey] is provided, only values satisfying `isValidKey(other)`
  /// are compared using the `compare` method in the methods mentioned above.
  /// If the `isValidKey` function returns false for an object, it is assumed to
  /// not be in the set.
  ///
  /// If omitted, the `isValidKey` function defaults to checking against the
  /// type parameter: `other is E`.
  RBTreeSet(
      [int Function(E key1, E key2)? compare,
      bool Function(dynamic potentialKey)? isValidKey])
      : _compare = compare ?? _defaultCompare<E>(),
        _validKey = isValidKey ?? ((dynamic v) => v is E);

  /// Creates a [RBTreeSet] that contains all [elements].
  ///
  /// The set works as if created by `RBTreeSet<E>(compare, isValidKey)`.
  ///
  /// All the [elements] should be instances of [E] and valid arguments to
  /// [compare].
  /// The `elements` iterable itself may have any element type, so this
  /// constructor can be used to down-cast a `Set`, for example as:
  /// ```dart
  /// Set<SuperType> superSet = ...;
  /// Set<SubType> subSet =
  ///     RBTreeSet<SubType>.from(superSet.whereType<SubType>());
  /// ```
  /// Example:
  /// ```dart
  /// final numbers = <num>[20, 30, 10];
  /// final setFrom = RBTreeSet<int>.from(numbers);
  /// print(setFrom); // {10, 20, 30}
  /// ```
  factory RBTreeSet.from(Iterable elements,
      [int Function(E key1, E key2)? compare,
      bool Function(dynamic potentialKey)? isValidKey]) {
    if (elements is Iterable<E>) {
      return RBTreeSet<E>.of(elements, compare, isValidKey);
    }
    RBTreeSet<E> result = RBTreeSet<E>(compare, isValidKey);
    for (var element in elements) {
      result.add(element as dynamic);
    }
    return result;
  }

  /// Creates a [RBTreeSet] from [elements].
  ///
  /// The set works as if created by `new RBTreeSet<E>(compare, isValidKey)`.
  ///
  /// All the [elements] should be valid as arguments to the [compare] function.
  /// Example:
  /// ```dart
  /// final baseSet = <int>{1, 2, 3};
  /// final setOf = RBTreeSet<num>.of(baseSet);
  /// print(setOf); // {1, 2, 3}
  /// ```
  factory RBTreeSet.of(Iterable<E> elements,
          [int Function(E key1, E key2)? compare,
          bool Function(dynamic potentialKey)? isValidKey]) =>
      RBTreeSet(compare, isValidKey)..addAll(elements);

  Set<T> _newSet<T>() =>
      RBTreeSet<T>((T a, T b) => _compare(a as E, b as E), _validKey);

  Set<R> cast<R>() => Set.castFrom<E, R>(this, newSet: _newSet);

  @override
  Iterator<E> get iterator => _RBTreeKeyIterator<E, _RBTreeSetNode<E>>(this);

  @override
  int get length => _count;

  @override
  bool get isEmpty => _root == null;

  @override
  bool get isNotEmpty => _root != null;

  @override
  E get first {
    // TODO: Customize exceptions.
    if (_count == 0) throw Exception();
    return _firstNode!.key;
  }

  @override
  E get last {
    // TODO: Customize exceptions.
    if (_count == 0) throw Exception();
    return _lastNode!.key;
  }

  @override
  E get single {
    if (_count == 0) throw Exception();
    if (_count > 1) throw Exception();
    return _root!.key;
  }

  @override
  bool add(E value) {
    return _addNewNode(_RBTreeSetNode(value));
  }

  @override
  bool contains(Object? value) {
    return _containsKey(value);
  }

  @override
  E? lookup(Object? object) {
    if (!_validKey(object)) return null;
    return _findNode(object as E)?.key;
  }

  @override
  void clear() => _clear();

  @override
  bool remove(Object? value) {
    if (value is! E) return false;
    return _removeNode(value) != null;
  }

  E? firstAfter(E object) => _firstNodeAfter(object)?.key;

  E? lastBefore(E object) => _lastNodeBefore(object)?.key;
}
