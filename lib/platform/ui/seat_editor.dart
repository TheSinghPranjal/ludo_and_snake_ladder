import 'package:dice_party/core/constants/app_info.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/settings/app_settings.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/app_icon.dart';
import 'package:dice_party/platform/ui/assets.dart';
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

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final s = widget.seat;
    final ai = s.kind == PlayerKind.ai;
    return Card(
      margin: const EdgeInsets.only(bottom: Space.s),
      child: Padding(
        padding: const EdgeInsets.all(Space.s),
        child: Column(
          children: [
            Row(
              children: [
                Tooltip(
                  message: 'Change colour',
                  child: Semantics(
                    button: true,
                    label:
                        'Seat ${widget.index + 1} colour, '
                        '${colorName(s.color)}. Tap to change',
                    excludeSemantics: true,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _nextColor,
                      child: SizedBox.square(
                        dimension: Space.tap,
                        child: Center(
                          child: Image.asset(
                            SharedAssets.token(
                              s.color,
                              'idle',
                              Theme.of(context).brightness,
                            ),
                            width: 36,
                            height: 36,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Space.s),
                Expanded(
                  child: TextField(
                    controller: _name,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(AppInfo.maxNameLength),
                    ],
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Player ${widget.index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (v) => widget.onChanged(s.copyWith(name: v)),
                  ),
                ),
                const SizedBox(width: Space.xs),
                IconButton(
                  tooltip: ai ? 'Computer, tap for human' : 'Human, tap for AI',
                  onPressed: () => widget.onChanged(
                    ai
                        ? s.copyWith(kind: PlayerKind.human, aiLevel: null)
                        : s.copyWith(
                            kind: PlayerKind.ai,
                            aiLevel: s.aiLevel ?? AiLevel.normal,
                          ),
                  ),
                  icon: AppIcon(ai ? 'ai' : 'human', color: c.text),
                ),
              ],
            ),
            if (ai)
              Padding(
                padding: const EdgeInsets.only(top: Space.s),
                child: SegmentedButton<AiLevel>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: AiLevel.easy, label: Text('Easy')),
                    ButtonSegment(value: AiLevel.normal, label: Text('Normal')),
                  ],
                  selected: {s.aiLevel ?? AiLevel.normal},
                  onSelectionChanged: (v) =>
                      widget.onChanged(s.copyWith(aiLevel: v.first)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Seats with blank names given a default, ready to start.
List<SeatSpec> finalizeSeats(List<SeatSpec> seats) => [
  for (var i = 0; i < seats.length; i++)
    seats[i].name.trim().isEmpty
        ? seats[i].copyWith(name: 'Player ${i + 1}')
        : seats[i].copyWith(name: seats[i].name.trim()),
];
