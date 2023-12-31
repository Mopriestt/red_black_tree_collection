// Copyright (c) 2023, Mopriestt.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:test/test.dart';
import 'package:red_black_tree_collection/red_black_tree_collection.dart';

final _random = Random(DateTime.now().millisecondsSinceEpoch);

void main() {
  late RBTreeMap<int, int> map;
  setUp(() => map = RBTreeMap());

  void addData(int n) {
    assert(n > 0);

    final data = List.generate(n, (index) => index);
    data.shuffle(_random);

    for (int i in data) map[i] = i;
  }

  group('test add', () {
    test('simple add', () {
      addData(50);

      for (int i = 0; i < 50; i++) expect(map[i], i);
      expect(map[50], null);
    });

    test('duplicate add', () {
      addData(50);
      addData(50);

      expect(map.length, 50);
      for (int i = 0; i < 50; i++) expect(map[i], i);
      expect(map[50], null);
    });

    test('putIfAbsent', () {
      addData(50);

      for (int i = 0; i < 100; i++) {
        map.putIfAbsent(i, () => i);
      }

      for (int i = 0; i < 100; i++) {
        expect(map[i], i);
      }
    });
  });

  group('test update', () {
    test('update', () {
      addData(50);

      for (int i = 0; i < 100; i++)
        map.update(i, (value) => -value, ifAbsent: () => -i);

      for (int i = 0; i < 100; i++) expect(map[i], -i);
    });

    test('updateAll', () {
      addData(50);

      map.updateAll((key, value) => key * value);

      for (int i = 0; i < 50; i++) expect(map[i], i * i);
    });
  });

  group('test clear', () {
    test('simple clear', () {
      addData(50);

      map.clear();

      expect(map.length, 0);
      expect(map[0], null);
    });

    test('empty clear', () {
      map.clear();

      expect(map.length, 0);
      expect(map[0], null);
    });

    test('re-clear', () {
      addData(50);
      map.clear();
      addData(50);
      map.clear();

      expect(map.length, 0);
      expect(map[0], null);
    });
  });

  test('empty not empty', () {
    expect(map.isEmpty, true);

    addData(20);

    expect(map.isNotEmpty, true);
  });

  group('test delete', () {
    test('simple delete', () {
      map[1] = 1;
      map.remove(1);

      expect(map[1], null);
      expect(map.length, 0);
    });

    test('delete all', () {
      addData(50);

      for (int i = 0; i < 50; i++) {
        expect(map[i], i);
        expect(map.remove(i), i);
        expect(map[i], null);
        expect(map.length, 49 - i);
      }
    });
  });

  group('test partial order', () {
    test('first', () {
      addData(50);

      expect(map.keys.first, 0);
    });

    test('last', () {
      addData(50);

      expect(map.keys.last, 49);
    });
  });

  group('test iterator', () {
    test('iterate keys', () {
      addData(50);

      int current = 0;
      expect(map.keys.length, 50);
      for (final key in map.keys) {
        expect(key, current);
        current++;
      }
    });

    test('iterate values', () {
      addData(50);

      int current = 0;
      expect(map.values.length, 50);
      for (final value in map.values) {
        expect(value, current);
        current++;
      }
    });

    test('iterate entries', () {
      addData(50);

      int current = 0;
      expect(map.entries.length, 50);
      for (final entry in map.entries) {
        expect(entry.key, current);
        expect(entry.value, current);
        current++;
      }
    });
  });

  group('test constructor', () {
    test('of constructor', () {
      final map2 = RBTreeMap.of({1: 'one', 2: 'two', 3: 'three'});

      expect(map2[1], 'one');
      expect(map2[2], 'two');
      expect(map2[3], 'three');
    });
  });

  group('test search', () {
    test('first key after', () {
      for (int i = 0; i <= 100; i += 2) map[i] = i;

      for (int i = -1; i <= 101; i++) {
        if (i >= 100)
          expect(map.firstKeyAfter(i), null);
        else
          expect(map.firstKeyAfter(i), i + 2 >> 1 << 1);
      }
    });

    test('last key before', () {
      for (int i = 0; i <= 100; i += 2) map[i] = i;

      for (int i = -1; i <= 101; i++) {
        if (i <= 0)
          expect(map.lastKeyBefore(i), null);
        else
          expect(map.lastKeyBefore(i), i - 1 >> 1 << 1);
      }
    });
  });

  group('test ConcurrentModificationError', () {
    var errorThrown = false;
    setUp(() => errorThrown = false);

    test('add while iterating keys', () {
      addData(10);
      try {
        for (final _ in map.keys) {
          map[10] = 11;
        }
      } catch (e) {
        errorThrown = true;
        expect(e is ConcurrentModificationError, true);
      }
      expect(errorThrown, true);
    });

    test('delete while iterating entries', () {
      addData(10);
      try {
        for (final _ in map.entries) {
          map.remove(5);
        }
      } catch (e) {
        errorThrown = true;
        expect(e is ConcurrentModificationError, true);
      }
      expect(errorThrown, true);
    });

    test('clear while iterating values', () {
      addData(10);
      try {
        for (final _ in map.values) {
          map.clear();
        }
      } catch (e) {
        errorThrown = true;
        expect(e is ConcurrentModificationError, true);
      }
      expect(errorThrown, true);
    });

    test('modify tree structure while update', () {
      addData(10);
      try {
        map.update(5, (v) {
          map[10] = 100; // Adding a new node, change tree structure.
          return v * v;
        });
      } catch (e) {
        errorThrown = true;
        expect(e is ConcurrentModificationError, true);
      }
      expect(errorThrown, true);
    });
  });
}
