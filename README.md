# Red Black Tree Collection

[![Pub Version](https://img.shields.io/pub/v/red_black_tree_collection?logo=dart)](https://pub.dev/packages/red_black_tree_collection)
[![Pub Points](https://img.shields.io/pub/points/red_black_tree_collection?logo=dart)](https://pub.dev/packages/red_black_tree_collection)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/Mopriestt/red_black_tree_collection/blob/master/LICENSE)

A high-performance, strictly ordered **Set** and **Map** implementation based on self-balancing Red-Black Trees.

Designed as a drop-in replacement for Dart's native `SplayTreeMap` and `SplayTreeSet`, this library offers significantly better performance (**up to 2x faster**) in random-access scenarios where the temporal locality of Splay Trees becomes a bottleneck.

## 🚀 Why Use This?

Dart's standard `dart:collection` uses **Splay Trees**, which optimize for frequently accessing the same elements ("temporal locality"). However, for **random access patterns**, Splay Trees suffer from constant rebalancing overhead.

**Red-Black Trees** offer a stable `O(log n)` performance guarantee for all operations, making them the superior choice for:
* **High-frequency random insertions/deletions.**
* **Latency-sensitive applications** (gaming, high-frequency data processing).
* **Read-heavy workloads** where you don't want read operations to mutate the tree structure (memory write overhead).

### Key Features
* **⚡ High Performance:** Optimized for Dart AOT/JIT, outperforming `SplayTree` by **~115%** in random operations.
* **🛠️ Drop-in Replacement:** Fully implements `Map<K, V>` and `Set<E>` interfaces. Plug and play compatibility.
* **🔍 Advanced Navigation:** Provides `firstAfter`, `lastBefore`, `firstKeyAfter`, and `lastKeyBefore` for efficient range queries (floor/ceiling operations).
* **⚖️ Balanced:** Guarantees strict balancing, ensuring worst-case execution time remains logarithmic.

---

## 📊 Performance Benchmarks

Benchmarks were conducted comparing `RBTreeSet` vs `SplayTreeSet` on the same dataset.
*(Source code: [test/benchmark.dart](https://github.com/Mopriestt/red_black_tree_collection/blob/master/test/benchmark.dart))*

### 1. Single Set Operations (1 Million Elements)

| Operation | SplayTreeSet (Dart SDK) | RBTreeSet (This Lib) | Improvement |
| :--- | :---: | :---: | :---: |
| **Insert + Find** | 4324 ms | **2009 ms** | **2.15x Faster** (+115%) |
| **Insert + Mixed Remove/Find** | 7215 ms | **3704 ms** | **1.95x Faster** (+95%) |

### 2. Multiple Sets (1000 Sets x 5k ops)

| Operation | SplayTreeSet (Dart SDK) | RBTreeSet (This Lib) | Improvement |
| :--- | :---: | :---: | :---: |
| **Batch Processing** | 3756 ms | **2039 ms** | **1.84x Faster** (+84%) |

> **Note:** Splay Trees may still be faster for scenarios with extreme temporal locality (accessing the same 1% of data 99% of the time). For general or random workloads, `RBTree` is the winner.

---

## 💻 Usage

### RBTreeMap (Ordered Map)

Works exactly like a standard Map, but keys are always sorted.

```dart
import 'package:red_black_tree_collection/red_black_tree_collection.dart';

void main() {
  // 1. Create with a custom comparator (optional)
  final treeMap = RBTreeMap<String, int>(
    (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
  );

  // 2. Standard Map operations
  treeMap['john'] = 30;
  treeMap['BoB'] = 20;
  treeMap['Kevin'] = 31;
  
  print(treeMap.keys.toList()); // [BoB, john, Kevin] (Sorted by lowercase)

  // 3. 🌟 Advanced: Range Navigation (Floor/Ceiling)
  // Find the first key strictly greater than 'Alice'
  print(treeMap.firstKeyAfter('Alice')); // 'BoB'
  
  // Find the last key strictly less than 'Nobody'
  print(treeMap.lastKeyBefore('Nobody')); // 'Kevin'

  // 4. Iterate efficiently
  for (final entry in treeMap.entries) {
    print('${entry.key}: ${entry.value}');
  }
}
```

### RBTreeSet (Ordered Set)

```dart
import 'package:red_black_tree_collection/red_black_tree_collection.dart';

void main() {
  final treeSet = RBTreeSet<int>();
  treeSet.addAll([10, 20, 30, 7, 1, 3]);

  // Standard lookups
  print(treeSet.contains(10)); // true
  
  // 🌟 Advanced: Binary Search for Closest Matches
  print(treeSet.firstAfter(15)); // 20 (Smallest element > 15)
  print(treeSet.lastBefore(10)); // 7  (Largest element < 10)

  // Subsets and Conversions
  print(treeSet.toList()); // [1, 3, 7, 10, 20, 30]
}
```

---

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  red_black_tree_collection: ^latest_version
```

## Contribution

Issues and Pull Requests are welcome!
Check out the source code on [GitHub](https://github.com/Mopriestt/red_black_tree_collection).