import 'package:test/test.dart';
import 'package:red_black_tree_collection/red_black_tree.dart';

void main() {
  test('add', () {
    final set = RBTreeSet<int>();

    set.add(1);

    expect(set.contains(1), true);
  });
}
