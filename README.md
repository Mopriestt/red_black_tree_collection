This Dart library offers high performance Red-Black Tree based Set and Map data structures that provide ordered collections with efficient search, insertion, and deletion operations.

## Features

**Adaptability**: Offers all standard Map and Set functionalities as defined in Dart's interface. Plug and Play!

**Ordering**: The Red-Black Tree Set and Map maintain a balanced structure, ensuring that elements are ordered efficiently within the collection.

**Performance**: Approximately 110% performance improvement compared to Dart's `SplayTreeMap` and `SplayTreeSet` in terms of search, insertion, and deletion.

**Additional Functionality**: This library provides efficient implementation of binary searching on keys:
 - `firstAfter` and `lastBefore` on RBTreeSet.
 - `firstKeyAfter` and `lastKeyBefore` on RBTreeMap.

**Test Coverage**: This library is well unit tested and integration tested.

## Basic Usage

### RBTreeMap

```dart
    final treeMap = RBTreeMap<String, int>(
      // Example of custom comparator
      // Use case insensitive string compare.
          (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
    );

    // add
    treeMap['john'] = 30;
    treeMap['BoB'] = 20;
    treeMap['Kevin'] = 31;
    
    // remove
    print(treeMap['BoB']); // 20
    treeMap.remove('BoB');
    print(treeMap['BoB']); // null
    
    // add from other map
    treeMap.addAll(const {'alice': 18, 'Charles': 70});
    
    // to pre-sorted list
    print(treeMap.keys.toList()); // [alice, Charles, john, Kevin]
    print(treeMap.values.toList()); // [18, 70, 30, 31]

    // [MapEntry(alice: 18), MapEntry(Charles: 70), MapEntry(john: 30), MapEntry(Kevin: 31)]
    print(treeMap.entrys.toList());
    
    // binary search key
    print(treeMap.firstKeyAfter('Alice')); // 'Charles'
    print(treeMap.lastKeyBefore('Nobody')); // 'Kevin'
    
    for (MapEntry<String, int> entry in treeMap.entries) {
      // Iterate through all (key, value) pair in key sorted order.
    }
    
    // Initialize from built in Map.
    final newMap = RBTreeMap.of(<String, String>{'a' : 'A', 'b' : 'B'});
```

### RBTreeSet

```dart
    final treeSet = RBTreeSet<int>();
    // alternative constructor
    // final treeSet = RBTreeSet.from([10, 20, 30, 7, 1, 3, 5]);
  
    // add
    treeSet.add(5);
    treeSet.addAll([10, 20, 30, 7, 1, 3]);

    // lookup
    print(treeSet.contains(3)); // true
    print(treeSet.contains(100)); // false;
    print(treeSet.lookup(30)); // 30
    print(treeSet.lookup(45.0)); // null

    // binary search element
    print(treeSet.firstAfter(15)); // 20
    print(treeSet.lastBefore(10)); // 7

    // remove
    treeSet.removeAll([1, 7, 30]);

    // to pre-sorted list
    print(treeSet.toList()); // [3, 5, 10, 20]

    for (int element in treeSet) {
      // Iterate through all elements in sorted order.
    }

    // Initialize from built in Set.
    final newSet = RBTreeSet.of(<String>{'a', 'b', 'c'});
```

For advanced usage, please refer to API doc.

## Performance Benchmarking

Benchmarking is done with same data set doing same operations on `RBTreeSet` and `SplayTreeSet` separately.

Code to reproduce the performance metrics can be found [here](https://github.com/Mopriestt/red_black_tree_collection/blob/master/test/benchmark.dart).

#### Single Set Test

| Test case                                         | SplayTreeSet | RBTreeSet | Improvement |
|:--------------------------------------------------|:------------:|:---------:|:-----------:|
| 1 million insert + 1 million find                 |    4324ms    |  2009ms   |   ~115.2%   |
| 1 million insert + 2 million mixed remove/find    |    7215ms    |  3704ms   |   ~94.7%    |

#### Multiple Set Test

|                     Test case                      | SplayTreeSet | RBTreeSet | Improvement |
|:--------------------------------------------------:|:------------:|:---------:|:-----------:|
| 1000 individual sets with 5k insert + 5k find each |    3756ms    |  2039ms   |   ~84.2%    |

## Misc

### [Source Code](https://github.com/Mopriestt/red_black_tree_collection/tree/master/lib) and [pub.dev Link](https://pub.dev/packages/red_black_tree_collection)