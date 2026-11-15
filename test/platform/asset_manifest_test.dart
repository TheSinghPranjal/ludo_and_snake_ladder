import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every file in assets/manifest.json exists', () {
    final manifest =
        jsonDecode(File('assets/manifest.json').readAsStringSync())
            as Map<String, dynamic>;
    expect(manifest['schemaVersion'], 1);
    final assets = manifest['assets'] as List<dynamic>;
    expect(assets, isNotEmpty);
    final missing = <String>[];
    final names = <String>{};
    for (final a in assets.cast<Map<String, dynamic>>()) {
      final key = '${a['game']}/${a['kind']}/${a['name']}';
      expect(names.add(key), isTrue, reason: 'duplicate entry $key');
      final paths = <String>[
        a['path'] as String,
        ...((a['files'] as List<dynamic>?) ?? const []).cast<String>(),
      ];
      for (final p in paths) {
        if (!File(p).existsSync()) missing.add(p);
      }
    }
    expect(missing, isEmpty);
  });
}
