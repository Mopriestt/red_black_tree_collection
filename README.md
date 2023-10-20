This Dart library offers Red-Black Tree based Set and Map data structures that provide ordered collections with efficient search, insertion, and deletion operations.

## Features

Basic Functionalities: Offers all standard Map and Set functionalities as defined in Dart's interface.

Ordering: The Red-Black Tree Set and Map maintain a balanced structure, ensuring that elements are ordered efficiently within the collection.

Performance: The Red-Black Tree implementation outperforms Dart's `SplayTreeMap` and `SplayTreeSet` in terms of search, insertion, and deletion operations.

Additional Functionality: This library provides efficient implementation of binary searching based on keys:
 - `firstAfter` and `lastBefore` on RBTreeSet.
 - `firstKeyAfter` and `lastKeyBefore` on RBTreeMap.

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

Benching marking are done with same data set doing same operations on RBTreeSet and SplayTreeSet separately.
Each element in the data set is a length 10 random lowercase string.

Benchmarking testing code can be found and reproduced at: https://github.com/Mopriestt/red_black_tree_collection/blob/master/test/benchmark.dart 

### Single Set Test

|                    Test case                     | SplayTreeSet | RBTreeSet | Improvement |
|:------------------------------------------------:|:------------:|:---------:|:-----------:|
|        1 million insert + 1 million find         |    4266ms    |  2028ms   |    110%     |
|  1 million insert + 2 million mixed remove/find  |    7131ms    |  3544ms   |    101%     |

### Multiple Set Test

|                    Test case                     | SplayTreeSet | RBTreeSet | Improvement |
|:------------------------------------------------:|:------------:|:---------:|:-----------:|
| 2k individual sets with 2k insert + 2k find each |    2533ms    |  1420ms   |     78%     |

## Source Code
https://github.com/Mopriestt/red_black_tree_collection
