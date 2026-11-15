import 'package:freezed_annotation/freezed_annotation.dart';

part 'jump.freezed.dart';
part 'jump.g.dart';

/// Whether a jump goes up or down.
enum JumpType {
  /// Climbs from its foot to its top.
  ladder,

  /// Slides from its head to its tail.
  snake,
}

/// A ladder or snake.
///
/// Landing exactly on [from] moves the token to [to]. Snakes carry a [rank]
/// (1–8) that decides which snakes are active at a given snake count, and a
/// [path] of 2–4 control points between head and tail, in board-normalised
/// coordinates, used both to draw the body and to animate the slide.
@freezed
abstract class Jump with _$Jump {
  /// Creates a jump.
  const factory Jump({
    required String id,
    required JumpType type,
    required int from,
    required int to,
    int? rank,
    List<List<double>>? path,
  }) = _Jump;

  const Jump._();

  /// Reads a jump from board JSON.
  factory Jump.fromJson(Map<String, dynamic> json) => _$JumpFromJson(json);

  /// Whether this is a snake.
  bool get isSnake => type == JumpType.snake;

  /// Whether this is a ladder.
  bool get isLadder => type == JumpType.ladder;
}
