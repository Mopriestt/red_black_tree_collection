import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:red_black_tree_collection/red_black_tree.dart';
import 'package:test/test.dart';

const testCase = 10000;
const N = 20000;
final random = Random(DateTime.now().millisecondsSinceEpoch);

void main() {
  test('RBTreeSet vs SplayTreeSet', () {
    final rbSet = RBTreeSet<int>();
    final splaySet = SplayTreeSet<int>();

    // Add initial data
    for (var i = 0; i <= N; i += 2) {
      rbSet.add(i);
      splaySet.add(i);
    }

    for (var i = 0; i < testCase; i++) {
      final operation = random.nextInt(3);

      switch (operation) {
        case 0: // Add a number
          final v = random.nextInt(N);
          rbSet.add(v);
          splaySet.add(v);
          break;
        case 1: // Remove a number
          final v = random.nextInt(N);
          rbSet.remove(v);
          splaySet.remove(v);
          break;
        case 2: // Test contains
          final v = random.nextInt(N);
          expect(rbSet.contains(v), splaySet.contains(v));
          break;
      }
      if (i % (testCase / 10) == 0) {
        expect(
          const ListEquality().equals(
            rbSet.toList(),
            splaySet.toList(),
          ),
          true,
        );
      }
    }
  });

  test('RBTreeMap vs SplayTreeMap', () {
    final rbMap = RBTreeMap<int, int>();
    final splayMap = SplayTreeMap<int, int>();

    // Add initial data
    for (var i = 0; i <= N; i += 2) {
      final v = random.nextInt(N);
      rbMap[i] = v;
      splayMap[i] = v;
    }

    for (var i = 0; i < testCase; i++) {
      final operation = random.nextInt(3);

      switch (operation) {
        case 0: // Add an entry
          final k = random.nextInt(N);
          final v = random.nextInt(N);
          rbMap[k] = v;
          splayMap[k] = v;
          break;
        case 1: // Remove an entry
          final k = random.nextInt(N);
          rbMap.remove(k);
          splayMap.remove(k);
          break;
        case 2: // Test value
          final k = random.nextInt(N);
          expect(rbMap[k], splayMap[k]);
          break;
      }
      if (i % (testCase / 10) == 0) {
        expect(
          const ListEquality().equals(
            rbMap.keys.toList(),
            splayMap.keys.toList(),
          ),
          true,
        );
        expect(
          const ListEquality().equals(
            rbMap.values.toList(),
            splayMap.values.toList(),
          ),
          true,
        );
      }
    }
  });
}
