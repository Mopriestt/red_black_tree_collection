// Copyright (c) 2023, Mopriestt.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:red_black_tree_collection/red_black_tree_collection.dart';

final _random = Random(DateTime.now().millisecondsSinceEpoch);

void main() {
  late RBTreeSet<int> set;
  setUp(() => set = RBTreeSet());

  void addData(int n) {
    assert(n > 0);

    final data = List.generate(n, (index) => index);
    data.shuffle(_random);

    for (int i in data) {
      set.add(i);
    }
  }

  group('test add', () {
    const n = 50;
    test('simple add', () {
      addData(n);

      for (int i = 0; i < n; i++) expect(set.contains(i), true);
      expect(set.contains(n), false);
    });

    test('duplicate add', () {
      addData(n);
      addData(n);

      expect(set.length, n);
      for (int i = 0; i < n; i++) expect(set.contains(i), true);
      expect(set.contains(n), false);
    });
  });

  group('test clear', () {
    test('simple clear', () {
      addData(50);

      set.clear();

      expect(set.length, 0);
      expect(set.contains(1), false);
    });

    test('empty clear', () {
      set.clear();

      expect(set.length, 0);
      expect(set.contains(1), false);
    });

    test('re-clear', () {
      addData(50);
      set.clear();
      addData(50);
      set.clear();

      expect(set.length, 0);
      expect(set.contains(1), false);
    });
  });

  test('empty not empty', () {
    expect(set.isEmpty, true);

    addData(20);

    expect(set.isNotEmpty, true);
  });

  group('test delete', () {
    test('simple delete', () {
      set.add(1);
      set.remove(1);

      expect(set.contains(1), false);
      expect(set.length, 0);
    });

    test('delete all', () {
      addData(50);

      for (int i = 0; i < 50; i++) {
        expect(set.contains(i - 1), false);
        expect(set.contains(i), true);
        expect(set.remove(i), true);
        expect(set.contains(i), false);
        expect(set.length, 49 - i);
      }
    });
  });

  group('test accessors', () {
    test('first', () {
      addData(50);

      expect(set.first, 0);
    });

    test('last', () {
      addData(50);

      expect(set.last, 49);
    });

    test('single', () {
      set.add(1);
      expect(set.single, 1);
    });
  });

  group('test iterator', () {
    test('iteration', () {
      addData(50);

      final it = set.iterator;
      for (int i = 0; i < 50; i++) {
        expect(it.moveNext(), true);
        expect(it.current, i);
      }
    });
  });

  group('test constructor', () {
    test('from constructor', () {
      addData(50);
      final set2 = RBTreeSet<int>.from(set);
      for (int i = 0; i < 50; i++) {
        expect(set2.contains(i), true);
      }
    });

    test('of constructor', () {
      addData(50);
      final set2 = RBTreeSet.of(set);

      for (int i = 0; i < 50; i++) {
        expect(set2.contains(i), true);
      }
    });
  });

  group('test comparator', () {
    test('reverse order', () {
      final set = RBTreeSet<int>((int a, int b) => b - a);
      for (int i = 0; i < 50; i++) set.add(i);

      final inorder = set.toList();

      for (int i = 0; i < 50; i++) expect(inorder[i], 49 - i);
    });
  });

  group('test search', () {
    test('first after', () {
      for (int i = 0; i <= 100; i += 2) set.add(i);

      for (int i = -1; i <= 101; i++) {
        if (i >= 100)
          expect(set.firstAfter(i), null);
        else
          expect(set.firstAfter(i), i + 2 >> 1 << 1);
      }
    });

    test('last before', () {
      for (int i = 0; i <= 100; i += 2) set.add(i);

      for (int i = -1; i <= 101; i++) {
        if (i <= 0)
          expect(set.lastBefore(i), null);
        else
          expect(set.lastBefore(i), i - 1 >> 1 << 1);
      }
    });
  });

  group('test ConcurrentModificationError', () {
    late bool errorThrown;
    setUp(() => errorThrown = false);

    test('add while iterating', () {
      addData(10);
      try {
        for (final _ in set) {
          set.add(10);
        }
      } catch (e) {
        expect(e is ConcurrentModificationError, true);
        errorThrown = true;
      }
      expect(errorThrown, true);
    });

    test('delete while iterating', () {
      addData(10);
      try {
        for (final _ in set) {
          set.remove(5);
        }
      } catch (e) {
        expect(e is ConcurrentModificationError, true);
        errorThrown = true;
      }
      expect(errorThrown, true);
    });

    test('clear while iterating', () {
      addData(10);
      try {
        for (final _ in set) {
          set.clear();
        }
      } catch (e) {
        expect(e is ConcurrentModificationError, true);
        errorThrown = true;
      }
      expect(errorThrown, true);
    });
  });

  group('test set operations', () {
    test('union', () {
      final a = RBTreeSet<int>.from([1, 5, 3]);
      final b = RBTreeSet.of(<int>[2, 6, 4]);

      expect(
          const ListEquality().equals(a.union(b).toList(), [1, 2, 3, 4, 5, 6]),
          true);
    });

    test('intersection', () {
      final a = RBTreeSet<int>.from([1, 2, 4, 5]);
      final b = RBTreeSet.of(<int>[4, 5, 6, 7]);

      expect(
        const ListEquality().equals(a.intersection(b).toList(), [4, 5]),
        true,
      );
    });

    test('difference', () {
      final a = RBTreeSet<int>.from([1, 2, 3, 4, 5]);
      final b = RBTreeSet.of(<int>[4, 5, 6, 7]);

      expect(
        const ListEquality().equals(a.difference(b).toList(), [1, 2, 3]),
        true,
      );
    });
  });
}
