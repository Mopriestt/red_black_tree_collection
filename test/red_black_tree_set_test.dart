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

  test('simple add', () {
    addData(50);

    for (int i = 0; i < 50; i ++) expect(set.contains(i), true);
    expect(set.contains(50), false);
  });

  test('simple clear', () {
    addData(50);

    set.clear();

    expect(set.length, 0);
    expect(set.contains(1), false);
  });
}
