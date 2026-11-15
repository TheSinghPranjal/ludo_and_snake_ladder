import 'package:dice_party/platform/animation/token_motion.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:flutter/material.dart';

/// One token drawn on a board.
@immutable
class TokenSprite {
  /// Creates a sprite.
  const TokenSprite({
    required this.id,
    required this.color,
    required this.position,
    required this.label,
    this.state = 'idle',
    this.onTap,
    this.motion,
  });

  /// Stable id, e.g. `p0` or `p0.2`.
  final String id;

  /// Token colour.
  final PlayerColor color;

  /// Resting centre in board-normalised coordinates.
  final Offset position;

  /// Semantics label, e.g. "Red token, square 42".
  final String label;

  /// Art state: idle, active, movable, selected.
  final String state;

  /// Called on tap; null when the token cannot be moved now.
  final VoidCallback? onTap;

  /// Path to animate along before resting at [position], if any.
  final TokenMotion? motion;
}

/// Lays out [tokens] over a square board of edge [size].
class TokenLayer extends StatelessWidget {
  /// Creates the layer.
  const TokenLayer({
    required this.size,
    required this.tokens,
    required this.tokenSize,
    super.key,
  });

  /// Board edge in logical pixels.
  final double size;

  /// Tokens, drawn in order.
  final List<TokenSprite> tokens;

  /// Token edge in logical pixels.
  final double tokenSize;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        for (final t in tokens)
          _AnimatedToken(
            key: ValueKey(t.id),
            sprite: t,
            boardSize: size,
            tokenSize: tokenSize,
          ),
      ],
    ),
  );
}

class _AnimatedToken extends StatefulWidget {
  const _AnimatedToken({
    required this.sprite,
    required this.boardSize,
    required this.tokenSize,
    super.key,
  });

  final TokenSprite sprite;
  final double boardSize;
  final double tokenSize;

  @override
  State<_AnimatedToken> createState() => _AnimatedTokenState();
}

class _AnimatedTokenState extends State<_AnimatedToken>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this);
  TokenMotion? _motion;

  @override
  void initState() {
    super.initState();
    _start(widget.sprite.motion);
  }

  @override
  void didUpdateWidget(_AnimatedToken old) {
    super.didUpdateWidget(old);
    if (!identical(widget.sprite.motion, _motion)) {
      _start(widget.sprite.motion);
    }
  }

  void _start(TokenMotion? m) {
    _motion = m;
    _ctrl.stop();
    if (m == null || m.total == Duration.zero) {
      _ctrl.value = 1;
      return;
    }
    _ctrl
      ..duration = m.total
      ..value = 0;
    _ctrl.forward().ignore();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.sprite;
    final b = Theme.of(context).brightness;
    final image = Image.asset(
      SharedAssets.token(s.color, s.state, b),
      width: widget.tokenSize,
      height: widget.tokenSize,
      gaplessPlayback: true,
      excludeFromSemantics: true,
    );
    final tap = widget.tokenSize < 48 ? 48.0 : widget.tokenSize;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final m = _motion;
        final p = m == null || _ctrl.value >= 1
            ? s.position
            : m.at(m.total * _ctrl.value);
        return Positioned(
          left: p.dx * widget.boardSize - tap / 2,
          top: p.dy * widget.boardSize - tap / 2,
          width: tap,
          height: tap,
          child: child!,
        );
      },
      child: Semantics(
        container: true,
        button: s.onTap != null,
        label: s.label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: s.onTap,
          child: Center(child: image),
        ),
      ),
    );
  }
}
