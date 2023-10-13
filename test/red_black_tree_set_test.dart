import 'dart:collection';
import 'dart:math';

import 'package:test/test.dart';
import 'package:red_black_tree_collection/red_black_tree.dart';

final random = Random(DateTime.now().millisecondsSinceEpoch);

void main() {
  late RBTreeSet<int> set;
  setUp(() => set = RBTreeSet());

  void addData(int n) {
    assert(n > 0);

    final data = List.generate(n, (index) => index);
    data.shuffle(random);

    for (int i in data) set.add(i);
  }

  group('test add', () {
    test('simple add', () {
      addData(50);

      for (int i = 0; i < 50; i ++) expect(set.contains(i), true);
      expect(set.contains(50), false);
    });

    test('duplicate add', () {
      addData(50);
      addData(50);

      expect(set.length, 50);
      for (int i = 0; i < 50; i ++) expect(set.contains(i), true);
      expect(set.contains(50), false);
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

      for (int i = 0; i < 50; i ++) {
        expect(set.contains(i), true);
        expect(set.remove(i), true);
        expect(set.contains(i), false);
        expect(set.length, 49 - i);
      }
    });
  });

  group('test partial order', () {
    test('first', () {
      addData(50);

      expect(set.first, 0);
    });

    test('last', () {
      addData(50);

      expect(set.last, 49);
    });
  });

  group('test iterator', () {
    test('iteration', () {
      addData(50);

      final it = set.iterator;
      for (int i = 0; i < 50; i ++) {
        expect(it.moveNext(), true);
        expect(it.current, i);
      }
    });
  });

  group('test constructor', () {
    test('from constructor', () {
      addData(50);
      final set2 = RBTreeSet<int>.from(set);
      for (int i = 0; i < 50; i ++) {
        expect(set2.contains(i), true);
      }
    });

    test('of constructor', () {
      addData(50);
      final set2 = RBTreeSet.of(set);

      for (int i = 0; i < 50; i ++) {
        expect(set2.contains(i), true);
      }
    });
  });

  group('test comparator', () {
    test('reverse order', () {
      final set = RBTreeSet<int>((int a, int b) => b - a);
      for (int i = 0; i < 50; i ++) set.add(i);

      final inorder = set.toList();

      for (int i = 0; i < 50; i ++) expect(inorder[i], 49 - i);
    });
  });
}
