import 'dart:io';

import 'package:dice_party/games/ludo/presentation/theme/board_palette.dart';
import 'package:dice_party/games/snakes/presentation/theme/board_palette.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:dice_party/platform/theme/contrast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_harness.dart';

/// Files allowed to hold colour literals.
const _paletteFiles = {
  'lib/platform/theme/app_colors.dart',
  'lib/games/ludo/presentation/theme/board_palette.dart',
};

void main() {
  for (final mode in Brightness.values) {
    final c = mode == Brightness.dark ? AppColors.dark : AppColors.light;
    group('AA contrast, ${mode.name}', () {
      void check(String what, Color fg, Color bg, double need) {
        final r = contrastRatio(fg, bg);
        expect(
          r,
          greaterThanOrEqualTo(need),
          reason: '$what: ${r.toStringAsFixed(2)}:1 < $need:1',
        );
      }

      test('text 4.5:1', () {
        for (final bg in [c.background, c.surface, c.surfaceAlt]) {
          check('text', c.text, bg, 4.5);
          check('muted text', c.textMuted, bg, 4.5);
        }
        check('label on accent', c.onAccent, c.accent, 4.5);
      });

      test('large labels and icons 3:1', () {
        check('label on primary', c.onPrimary, c.primary, 3);
        check('label on danger', c.onDanger, c.danger, 3);
        for (final bg in [c.background, c.surface]) {
          check('primary icon', c.primary, bg, 3);
          check('danger icon', c.danger, bg, 3);
        }
      });

      test('token edges stand out from the Ludo board 3:1', () {
        final board = mode == Brightness.dark
            ? LudoBoardPalette.dark
            : LudoBoardPalette.light;
        check('token rim', c.tokenRim, board.base, 3);
        check('star outline', board.star, board.cell, 3);
      });

      test('S&L numbers on every tile 3:1 (large numbers)', () async {
        final catalog = await testCatalog();
        final ext = catalog.themeExtensions(mode).whereType<SnakesPalettes>();
        for (final e in ext.single.byTheme.entries) {
          for (final tile in [e.value.tileA, e.value.tileB]) {
            check('${e.key} number', e.value.number, tile, 3);
          }
        }
      });
    });
  }

  test('player colours keep their hue in dark mode', () {
    for (final p in PlayerColor.values) {
      final l = HSLColor.fromColor(AppColors.light.player(p));
      final d = HSLColor.fromColor(AppColors.dark.player(p));
      expect((l.hue - d.hue).abs(), lessThan(4), reason: p.name);
      expect(d.saturation, lessThan(l.saturation), reason: p.name);
    }
  });

  test('the theme carries AppColors for both modes', () {
    expect(
      buildAppTheme(Brightness.dark).extension<AppColors>(),
      AppColors.dark,
    );
    expect(
      buildAppTheme(Brightness.light).extension<AppColors>(),
      AppColors.light,
    );
  });

  test('no colour literals outside the palette files', () {
    final literal = RegExp(
      r'Color\(0x|\bColors\.|Color\.fromARGB|Color\.fromRGBO',
    );
    final bad = <String>[];
    for (final f in Directory(
      'lib',
    ).listSync(recursive: true).whereType<File>()) {
      final path = f.path.replaceAll(r'\', '/');
      if (!path.endsWith('.dart') || _paletteFiles.contains(path)) continue;
      final lines = f.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (literal.hasMatch(lines[i])) bad.add('$path:${i + 1}');
      }
    }
    expect(bad, isEmpty);
  });
}
