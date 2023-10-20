// Copyright (c) 2023, Mopriestt.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:red_black_tree_collection/red_black_tree_collection.dart';
import 'package:test/test.dart';

const _testCase = 300000;
const _testRange = 600000;
final _random = Random(DateTime.now().millisecondsSinceEpoch);
int get _randomNumber => _random.nextInt(_testRange);

void main() {
  test('RBTreeSet vs SplayTreeSet', () {
    final rbSet = RBTreeSet<int>();
    final splaySet = SplayTreeSet<int>();

    // Add initial data
    for (var i = 0; i <= _testRange; i += 2) {
      rbSet.add(i);
      splaySet.add(i);
    }

    for (var i = 0; i < _testCase; i++) {
      final operation = _random.nextInt(3);

      switch (operation) {
        case 0: // Add a number
          final v = _randomNumber;
          rbSet.add(v);
          splaySet.add(v);
          break;
        case 1: // Remove a number
          final v = _randomNumber;
          rbSet.remove(v);
          splaySet.remove(v);
          break;
        case 2: // Test contains
        case 3:
          final v = _randomNumber;
          expect(rbSet.contains(v), splaySet.contains(v));
          break;
      }

      // Validate whole set for every 10% of operations.
      if (i % (_testCase / 10) == 0) {
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
    for (var i = 0; i <= _testRange; i += 2) {
      final v = _randomNumber;
      rbMap[i] = v;
      splayMap[i] = v;
    }

    for (var i = 0; i < _testCase; i++) {
      final operation = _random.nextInt(3);

      switch (operation) {
        case 0: // Add an entry
          final k = _randomNumber;
          final v = _randomNumber;
          rbMap[k] = v;
          splayMap[k] = v;
          break;
        case 1: // Remove an entry
          final k = _randomNumber;
          expect(rbMap.remove(k), splayMap.remove(k));
          break;
        case 2: // Test value
        case 3:
          final k = _randomNumber;
          expect(rbMap[k], splayMap[k]);
          break;
      }

      // Validate whole map for every 10% of operations.
      if (i % (_testCase / 10) == 0) {
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
