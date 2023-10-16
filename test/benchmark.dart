import 'dart:collection';
import 'dart:math';

import 'package:red_black_tree_collection/red_black_tree.dart';
import 'package:test/test.dart';

final _random = Random(DateTime.now().millisecondsSinceEpoch);
const _N = 1000000;

const chars = 'abcdefghijklmnopqrstuvwxyz';

String get _randomString => String.fromCharCodes(
      List.generate(10, (_) => chars.codeUnitAt(_random.nextInt(26))),
    );

List<String> get _dataSet => List.generate(_N, (_) => _randomString);

void main() {
  final data = _dataSet;

  test('SplayTreeSet 1 million add + 1 million query', () {
    var start = DateTime.now().millisecondsSinceEpoch;
    final splayTreeSet = SplayTreeSet<String>();
    for (final s in data) {
      splayTreeSet.add(s);
    }

    for (final s in data) {
      splayTreeSet.contains(s);
    }
    var end = DateTime.now().millisecondsSinceEpoch;
    print('\nSplayTreeSet 1 million add + 1 million search:');
    print('${end - start} ms');
  });

  test('RBTreeSet 1 million add + 1 million query', () {
    final data = _dataSet;
    var start = DateTime.now().millisecondsSinceEpoch;
    final rbTreeSet = RBTreeSet<String>();
    for (final s in data) {
      rbTreeSet.add(s);
    }

    for (final s in data) {
      rbTreeSet.contains(s);
    }
    var end = DateTime.now().millisecondsSinceEpoch;
    print('\nRbTreeSet 1 million add + 1 million search:');
    print('${end - start} ms');
  });

  test('HashSet 1 million add + 1 million query', () {
    final data = _dataSet;
    var start = DateTime.now().millisecondsSinceEpoch;
    final hashSet = HashSet<String>();
    for (final s in data) {
      hashSet.add(s);
    }

    for (final s in data) {
      hashSet.contains(s);
    }
    var end = DateTime.now().millisecondsSinceEpoch;
    print('\nHashSet 1 million add + 1 million search:');
    print('${end - start} ms');
  });
}
