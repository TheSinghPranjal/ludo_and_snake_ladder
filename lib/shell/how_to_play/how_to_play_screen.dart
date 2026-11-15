import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/page_frame.dart';
import 'package:flutter/material.dart';

/// Illustrated rules of one game, one page per idea.
class HowToPlayScreen extends StatefulWidget {
  /// Creates the screen for [game].
  const HowToPlayScreen({required this.game, super.key});

  /// The game.
  final GamePresentation game;

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  final PageController _pages = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.game.howToPlay;
    final b = Theme.of(context).brightness;
    final c = AppColors.of(context);
    final last = _index == pages.length - 1;
    return PageFrame(
      title: 'How to Play',
      scroll: false,
      bottom: Row(
        children: [
          for (var i = 0; i < pages.length; i++)
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _index ? c.primary : c.outline,
              ),
            ),
          const Spacer(),
          FilledButton(
            onPressed: () => last
                ? Navigator.of(context).maybePop()
                : _pages.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  ),
            child: Text(last ? 'Done' : 'Next'),
          ),
        ],
      ),
      child: PageView(
        controller: _pages,
        onPageChanged: (i) => setState(() => _index = i),
        children: [
          for (final p in pages)
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: Space.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Space.radius),
                    child: AspectRatio(
                      aspectRatio: 320 / 200,
                      child: Image.asset(
                        SharedAssets.themed(p.image, b),
                        fit: BoxFit.cover,
                        excludeFromSemantics: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: Space.l),
                  Text(
                    p.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: Space.s),
                  Text(p.body, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
