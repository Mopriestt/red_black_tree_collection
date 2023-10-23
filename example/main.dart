import 'package:red_black_tree_collection/red_black_tree_collection.dart';

void main() {
  /// RBTreeSet
  // final treeSet = RBTreeSet.from([10, 20, 30, 7, 1, 3, 5]);
  final treeSet = RBTreeSet<int>();
  treeSet.add(5);
  treeSet.addAll([10, 20, 30, 7, 1, 3]);

  print(treeSet.contains(3)); // true
  print(treeSet.contains(100)); // false;
  print(treeSet.lookup(30)); // 30
  print(treeSet.lookup(45.0)); // null

  print(treeSet.firstAfter(15)); // 20
  print(treeSet.lastBefore(10)); // 7

  treeSet.removeAll([1, 7, 30]);
  print(treeSet.toList()); // [3, 5, 10, 20]

  for (int element in treeSet) {
    // Iterate through all elements in sorted order.
  }

  /// RBTreeMap
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

  // [MapEntry(alice: 18), MapEntry(Charles: 70), MapEntry(john: 30), MapEntry(Kevin: 31)]
  print(treeMap.entries.toList());

  print(treeMap.firstKeyAfter('Alice')); // Charles
  print(treeMap.lastKeyBefore('Nobody')); // Kevin

  for (MapEntry<String, int> entry in treeMap.entries) {
    // Iterate through all (key, value) pair in key sorted order.
  }
}
