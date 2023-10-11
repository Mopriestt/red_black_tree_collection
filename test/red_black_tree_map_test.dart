import 'dart:math';

import 'package:test/test.dart';
import 'package:red_black_tree_collection/red_black_tree.dart';

final random = Random(DateTime.now().millisecondsSinceEpoch);

void main() {
  late RBTreeMap<int, int> map;
  setUp(() => map = RBTreeMap());

  void addData(int n) {
    assert(n > 0);

    final data = List.generate(n, (index) => index);
    data.shuffle(random);

    for (int i in data) map[i] = i;
  }

  group('test add', () {
    test('simple add', () {
      addData(50);

      for (int i = 0; i < 50; i ++) expect(map[i], i);
      expect(map[50], null);
    });

    test('duplicate add', () {
      addData(50);
      addData(50);

      expect(map.length, 50);
      for (int i = 0; i < 50; i ++) expect(map[i], i);
      expect(map[50], null);
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
      expect(map[0], false);
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

      for (int i = 0; i < 50; i ++) {
        expect(map[i], i);
        expect(map.remove(i), true);
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
    test('iteration', () {
    });
  });

  group('test constructor', () {});
}
