import 'package:dice_party/games/snakes/domain/board/board_def.dart';
import 'package:dice_party/games/snakes/presentation/snakes_presentation.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/app_icon.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/page_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Carousel of boards. Locked boards show how to unlock them.
class BoardSelectScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const BoardSelectScreen({
    required this.presentation,
    this.selected,
    super.key,
  });

  /// The game.
  final SnakesPresentation presentation;

  /// Board chosen so far.
  final String? selected;

  @override
  ConsumerState<BoardSelectScreen> createState() => _BoardSelectScreenState();
}

class _BoardSelectScreenState extends ConsumerState<BoardSelectScreen> {
  late final List<BoardDef> _boards = widget.presentation.content.boards;
  late final PageController _pages = PageController(
    viewportFraction: 0.78,
    initialPage: _boards
        .indexWhere((b) => b.id == widget.selected)
        .clamp(0, _boards.length - 1),
  );
  late int _index = _pages.initialPage;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unlocks = ref.watch(unlocksControllerProvider);
    final stats = ref.watch(statsControllerProvider)[widget.presentation.type];
    final b = Theme.of(context).brightness;
    final c = AppColors.of(context);
    bool open(BoardDef d) =>
        stats != null && widget.presentation.isUnlocked(d, unlocks, stats);
    final current = _boards[_index];
    final hint = current.unlock.count == 1
        ? 'Win 1 Snakes & Ladders game to unlock'
        : 'Win ${current.unlock.count} Snakes & Ladders games to unlock';
    return PageFrame(
      title: 'Choose a board',
      scroll: false,
      bottom: FilledButton(
        onPressed: open(current)
            ? () => Navigator.of(context).pop(current.id)
            : null,
        child: Text(open(current) ? 'Play ${current.name}' : 'Locked'),
      ),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pages,
              itemCount: _boards.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final d = _boards[i];
                final unlocked = open(d);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.s,
                    vertical: Space.l,
                  ),
                  child: Semantics(
                    label: unlocked ? d.name : '${d.name}, locked',
                    selected: d.id == widget.selected,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          SharedAssets.themed(
                            'assets/games/snakes/board_select/board_card_${d.id}',
                            b,
                          ),
                          fit: BoxFit.contain,
                          excludeFromSemantics: true,
                        ),
                        if (!unlocked)
                          Image.asset(
                            SharedAssets.themed(
                              'assets/games/snakes/board_select/board_card_locked',
                              b,
                            ),
                            fit: BoxFit.contain,
                            excludeFromSemantics: true,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Text(current.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Space.xs),
          SizedBox(
            height: 48,
            child: open(current)
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcon('lock', size: 18, color: c.textMuted),
                      const SizedBox(width: Space.xs),
                      Flexible(
                        child: Text(
                          hint,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: c.textMuted),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
