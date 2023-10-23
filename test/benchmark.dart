// Copyright (c) 2023, Mopriestt.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:math';

import 'package:red_black_tree_collection/red_black_tree_collection.dart';
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

  group('speed test add', () {
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
  });

  group('speed test mixed', () {
    final deleteSet = List.generate(_N, (index) => data[_random.nextInt(_N)]);
    final querySet = List.generate(_N, (index) => _random.nextInt(_N));

    test('SplayTreeSet 1 million add + 1 million delete + 1 million query', () {
      var start = DateTime.now().millisecondsSinceEpoch;
      final splayTreeSet = SplayTreeSet<String>();
      for (final s in data) {
        splayTreeSet.add(s);
      }

      for (int i = 0; i < _N; i++) {
        splayTreeSet.remove(deleteSet[i]);
        splayTreeSet.contains(data[querySet[i]]);
      }
      var end = DateTime.now().millisecondsSinceEpoch;
      print('\nSplayTreeSet 1 million add + 2 million mixed delete & search:');
      print('${end - start} ms');
    });

    test('RBTreeSet 1 million add + 1 million delete + 1 million query', () {
      var start = DateTime.now().millisecondsSinceEpoch;
      final rbTreeSet = RBTreeSet<String>();
      for (final s in data) {
        rbTreeSet.add(s);
      }

      for (int i = 0; i < _N; i++) {
        rbTreeSet.remove(deleteSet[i]);
        rbTreeSet.contains(data[querySet[i]]);
      }
      var end = DateTime.now().millisecondsSinceEpoch;
      print('\nRbTreeSet 1 million add + 2 million mixed delete & search:');
      print('${end - start} ms');
    });
  });

  group('speed test with 1000 individual instances', () {
    const dataCase = 1000;
    final data = List.generate(
      dataCase,
      (_) => List.generate(5000, (index) => _random.nextInt(_N)),
    );
    test('1000 SplayTreeSets with 5000 add + 5000 query', () {
      var start = DateTime.now().millisecondsSinceEpoch;
      final sets = List.generate(dataCase, (_) => SplayTreeSet<int>());
      for (int i = 0; i < dataCase; i++) {
        for (int j = 0; j < 5000; j++) sets[i].add(data[i][j]);
        for (int j = 0; j < 5000; j++) sets[i].contains(data[i][j]);
      }
      var end = DateTime.now().millisecondsSinceEpoch;
      print('\n1000 SplayTreeSets with 5000 add + 5000 query each:');
      print('${end - start} ms');
    });

    test('1000 RBTreeSets with 5000 add + 5000 query', () {
      var start = DateTime.now().millisecondsSinceEpoch;
      final sets = List.generate(dataCase, (_) => RBTreeSet<int>());
      for (int i = 0; i < dataCase; i++) {
        for (int j = 0; j < 5000; j++) sets[i].add(data[i][j]);
        for (int j = 0; j < 5000; j++) sets[i].contains(data[i][j]);
      }
      var end = DateTime.now().millisecondsSinceEpoch;
      print('\n1000 RBTreeSets with 5000 add + 5000 query each:');
      print('${end - start} ms');
    });
  });
}
