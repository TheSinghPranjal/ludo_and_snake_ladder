import 'dart:convert';

import 'package:dice_party/core/result.dart';
import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/games/snakes/domain/board/validator.dart';

/// Parses and validates board JSON. Never throws.
abstract final class BoardLoader {
  /// Parses [source] and runs the validator at every snake count.
  static Result<BoardDef, List<String>> parse(String source) {
    final BoardDef board;
    try {
      final json = jsonDecode(source);
      if (json is! Map<String, dynamic>) {
        return const Err(['board JSON is not an object']);
      }
      board = BoardDef.fromJson(json);
    } on Object catch (e) {
      return Err(['board JSON is malformed: ${e.runtimeType}']);
    }
    final issues = BoardValidator.validate(board);
    if (issues.isNotEmpty) {
      return Err([for (final i in issues) i.toString()]);
    }
    return Ok(board);
  }
}
