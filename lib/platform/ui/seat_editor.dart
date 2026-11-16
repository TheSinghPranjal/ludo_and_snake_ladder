import 'package:dice_party/core/constants/app_info.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/settings/app_settings.dart';
import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/meadow/meadow_controls.dart';
import 'package:dice_party/platform/ui/meadow/meadow_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Builds the default seats of a Player Setup: the profile in seat 1, then
/// computer players.
List<SeatSpec> defaultSeats({
  required Profile profile,
  required List<PlayerColor> colors,
  required AiLevel aiLevel,
}) => [
  for (var i = 0; i < colors.length; i++)
    i == 0
        ? SeatSpec(
            name: profile.name,
            avatar: profile.avatar,
            color: colors[i],
            kind: PlayerKind.human,
          )
        : SeatSpec(
            name: 'Bot ${colorName(colors[i])}',
            avatar: (profile.avatar + i * 3) % AppInfo.avatarCount,
            color: colors[i],
            kind: PlayerKind.ai,
            aiLevel: aiLevel,
          ),
];

/// Edits one seat: colour, name, Human/AI and AI difficulty.
class SeatEditor extends StatefulWidget {
  /// Creates an editor.
  const SeatEditor({
    required this.index,
    required this.seat,
    required this.takenColors,
    required this.onChanged,
    this.colorChoices = PlayerColor.values,
    super.key,
  });

  /// Seat number from 0.
  final int index;

  /// Current value.
  final SeatSpec seat;

  /// Colours used by other seats.
  final Set<PlayerColor> takenColors;

  /// Colours this game allows.
  final List<PlayerColor> colorChoices;

  /// Receives the edited seat.
  final ValueChanged<SeatSpec> onChanged;

  @override
  State<SeatEditor> createState() => _SeatEditorState();
}

class _SeatEditorState extends State<SeatEditor> {
  late final TextEditingController _name = TextEditingController(
    text: widget.seat.name,
  );

  @override
  void didUpdateWidget(SeatEditor old) {
    super.didUpdateWidget(old);
    if (widget.seat.name != _name.text) _name.text = widget.seat.name;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _nextColor() {
    final all = widget.colorChoices;
    var i = all.indexOf(widget.seat.color);
    for (var n = 0; n < all.length; n++) {
      i = (i + 1) % all.length;
      if (!widget.takenColors.contains(all[i])) {
        widget.onChanged(widget.seat.copyWith(color: all[i]));
        return;
      }
    }
  }

  void _toggleKind() {
    final s = widget.seat;
    widget.onChanged(
      s.kind == PlayerKind.ai
          ? s.copyWith(kind: PlayerKind.human, aiLevel: null)
          : s.copyWith(
              kind: PlayerKind.ai,
              aiLevel: s.aiLevel ?? AiLevel.normal,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.seat;
    final ai = s.kind == PlayerKind.ai;
    final tint = seatTint(s.color);
    final label = 'Player ${widget.index + 1}';
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.m),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(
              Space.s,
              Space.s,
              Space.m,
              Space.m,
            ),
            decoration: BoxDecoration(
              color: tint.bg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: tint.border, width: 1.5),
              boxShadow: [
                BoxShadow(color: tint.border, offset: const Offset(0, 3)),
                const BoxShadow(
                  color: HomePalette.cardShadow,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Tooltip(
                  message: 'Change colour',
                  child: Semantics(
                    button: true,
                    label:
                        'Seat ${widget.index + 1} colour, '
                        '${colorName(s.color)}. Tap to change',
                    excludeSemantics: true,
                    child: MeadowPressable(
                      onTap: _nextColor,
                      child: SizedBox(
                        width: 60,
                        height: 64,
                        child: Image.asset(
                          SharedAssets.meadowPawn(s.color),
                          fit: BoxFit.contain,
                          excludeFromSemantics: true,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Space.s),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 48,
                        margin: const EdgeInsets.only(top: Space.l + 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Space.m + 2,
                        ),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: HomePalette.field,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: tint.border, width: 1.5),
                        ),
                        child: TextField(
                          controller: _name,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                              AppInfo.maxNameLength,
                            ),
                          ],
                          style: const TextStyle(
                            fontFamily: displayFont,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: HomePalette.meadowInk,
                          ),
                          cursorColor: HomePalette.navy,
                          decoration: InputDecoration.collapsed(
                            hintText: label,
                          ),
                          onChanged: (v) =>
                              widget.onChanged(s.copyWith(name: v)),
                        ),
                      ),
                      Positioned(
                        left: Space.xs,
                        top: 0,
                        child: ExcludeSemantics(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Space.m,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: tint.chip,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: tint.border),
                            ),
                            child: Text(
                              label,
                              style: meadowLabelStyle.copyWith(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Space.m),
                MeadowIconButton(
                  label: ai ? 'Computer, tap for human' : 'Human, tap for AI',
                  circle: true,
                  size: 50,
                  onTap: _toggleKind,
                  icon: Icon(
                    ai ? Icons.smart_toy_rounded : Icons.person_outline_rounded,
                  ),
                ),
              ],
            ),
          ),
          if (ai)
            Padding(
              padding: const EdgeInsets.only(top: Space.m),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const MeadowBurst(mirror: true, size: 18),
                  const SizedBox(width: Space.xs),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: MeadowPillChoice<AiLevel>(
                        leading: const MeadowIcon('gamepad', size: 34),
                        selected: s.aiLevel ?? AiLevel.normal,
                        onChanged: (v) =>
                            widget.onChanged(s.copyWith(aiLevel: v)),
                        segments: const [
                          MeadowSegment(AiLevel.easy, 'Easy'),
                          MeadowSegment(AiLevel.normal, 'Normal'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.xs),
                  const MeadowBurst(size: 18),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Card tints for a seat of colour [c].
SeatTint seatTint(PlayerColor c) => switch (c) {
  PlayerColor.red => HomePalette.seatRed,
  PlayerColor.blue => HomePalette.seatBlue,
  PlayerColor.green => HomePalette.seatGreen,
  PlayerColor.yellow => HomePalette.seatYellow,
};

/// Seats with blank names given a default, ready to start.
List<SeatSpec> finalizeSeats(List<SeatSpec> seats) => [
  for (var i = 0; i < seats.length; i++)
    seats[i].name.trim().isEmpty
        ? seats[i].copyWith(name: 'Player ${i + 1}')
        : seats[i].copyWith(name: seats[i].name.trim()),
];
