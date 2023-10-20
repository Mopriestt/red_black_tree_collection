This Dart library offers Red-Black Tree based Set and Map data structures that provide ordered collections with efficient search, insertion, and deletion operations.

## Features

Ordering: The Red-Black Tree Set and Map maintain a balanced structure, ensuring that elements are ordered efficiently within the collection.

Performance: The Red-Black Tree implementation outperforms Dart's SplayTreeMap and SplayTreeSet in terms of search, insertion, and deletion operations.

Additional Functionality: This library provides efficient implementation of binary searching based on keys:
 - firstAfter and lastBefore on RBTreeSet.
 - firstKeyAfter and lastKeyBefore on RBTreeMap.

## Usage

### RBTreeMap

```dart
  final treeMap = RBTreeMap<String, int>(
  // Support custom comparator
  // Use case insensitive string compare.
      (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
  );
  treeMap['john'] = 30;
  treeMap['BoB'] = 20;
  treeMap['Kevin'] = 31;

  print(treeMap['BoB']); // 20;
  treeMap.remove('BoB');
  print(treeMap['BoB']); // null;

  treeMap.addAll(const {'alice': 18, 'Charles': 70});

  print(treeMap.keys.toList()); // [alice, Charles, john, Kevin]
  print(treeMap.values.toList()); // [18, 70, 30, 31]

  print(treeMap.firstKeyAfter('Alice')); // Charles
  print(treeMap.lastKeyBefore('Nobody')); // Kevin
```

### RBTreeSet

```dart
  // final treeSet = RBTreeSet.from([10, 20, 30, 7, 1, 3, 5]);
  final treeSet = RBTreeSet<int>();
  treeSet.addAll([10, 20, 30, 7, 1, 3, 5]);

  print(treeSet.contains(3)); // true
  print(treeSet.contains(100)); // false;

  print(treeSet.firstAfter(15)); // 20
  print(treeSet.lastBefore(10)); // 7

  treeSet.removeAll([1, 7, 30]);
  print(treeSet.toList()); // [3, 5, 10, 20]
```

## Performance Benchmarking


## Source Code
https://github.com/Mopriestt/red_black_tree_collection
