import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _import = RegExp(r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''');

/// Imports a domain file may use.
const _domainAllowedPackages = {
  'package:freezed_annotation/',
  'package:json_annotation/',
  'package:meta/',
  'package:collection/',
};
const _domainAllowedDart = {
  'dart:core',
  'dart:math',
  'dart:collection',
  'dart:convert',
};
const _pureSubset = {
  'package:dice_party/platform/session/game_module.dart',
  'package:dice_party/platform/dice/dice_service.dart',
};

Iterable<(String, String)> _imports() sync* {
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.endsWith('.g.dart'))
      .where((f) => !f.path.endsWith('.freezed.dart'));
  for (final f in files) {
    for (final line in f.readAsLinesSync()) {
      final m = _import.firstMatch(line);
      if (m != null) yield (f.path.replaceAll(r'\', '/'), m.group(1)!);
    }
  }
}

bool _isDomain(String path) =>
    RegExp('^lib/games/[^/]+/domain/').hasMatch(path);

bool _domainMayImport(String uri) {
  if (uri.startsWith('dart:')) return _domainAllowedDart.contains(uri);
  if (_pureSubset.contains(uri)) return true;
  if (uri.startsWith('package:dice_party/core/')) return true;
  if (_domainAllowedPackages.any(uri.startsWith)) return true;
  if (uri.startsWith('package:dice_party/games/')) {
    return RegExp('^package:dice_party/games/[^/]+/domain/').hasMatch(uri);
  }
  return !uri.startsWith('package:') && !uri.contains(':');
}

String? _gameOf(String s) => RegExp('games/([^/]+)/').firstMatch(s)?.group(1);

void main() {
  final imports = _imports().toList();

  test('lib uses package imports for its own files', () {
    final relative = [
      for (final (file, uri) in imports)
        if (uri.startsWith('../')) '$file → $uri',
    ];
    expect(relative, isEmpty);
  });

  test('game domains stay pure Dart', () {
    final bad = [
      for (final (file, uri) in imports)
        if (_isDomain(file) && !_domainMayImport(uri)) '$file → $uri',
    ];
    expect(bad, isEmpty);
  });

  test('games never import each other', () {
    final bad = [
      for (final (file, uri) in imports)
        if (_gameOf(file) case final g?)
          if (_gameOf(uri) case final other? when other != g) '$file → $uri',
    ];
    expect(bad, isEmpty);
  });

  test('platform never imports shell or games', () {
    final bad = [
      for (final (file, uri) in imports)
        if (file.startsWith('lib/platform/') &&
            (uri.startsWith('package:dice_party/shell/') ||
                uri.startsWith('package:dice_party/games/')))
          '$file → $uri',
    ];
    expect(bad, isEmpty);
  });

  test('shell never imports games', () {
    final bad = [
      for (final (file, uri) in imports)
        if (file.startsWith('lib/shell/') &&
            uri.startsWith('package:dice_party/games/'))
          '$file → $uri',
    ];
    expect(bad, isEmpty);
  });

  test('core imports nothing above it', () {
    final bad = [
      for (final (file, uri) in imports)
        if (file.startsWith('lib/core/') &&
            uri.startsWith('package:dice_party/') &&
            !uri.startsWith('package:dice_party/core/'))
          '$file → $uri',
    ];
    expect(bad, isEmpty);
  });
}
