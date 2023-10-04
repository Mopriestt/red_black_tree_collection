import 'dart:math';

import 'package:test/test.dart';
import 'package:red_black_tree_collection/red_black_tree.dart';

final random = Random(DateTime.now().millisecondsSinceEpoch);

void main() {
  late RBTreeSet<int> set;
  setUp(() => set = RBTreeSet());

  test('simple add', () {
    final data = List.generate(50, (index) => index);
    data.shuffle(random);

    for (int i in data) set.add(i);

    for (int i = 0; i < 50; i ++) expect(set.contains(i), true);
    expect(set.contains(50), false);
  });
}
