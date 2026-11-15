import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/persistence/game_stats.dart';
import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lifetime statistics, one tab per game.
class StatsScreen extends ConsumerWidget {
  /// Creates the screen.
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games =
        ref.watch(gameCatalogProvider).value?.games ??
        const <GamePresentation>[];
    return DefaultTabController(
      length: games.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stats'),
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const AppIcon('back'),
          ),
          bottom: TabBar(
            tabs: [for (final g in games) Tab(text: g.module.displayName)],
          ),
        ),
        body: TabBarView(
          children: [for (final g in games) _GameStatsTab(game: g)],
        ),
      ),
    );
  }
}

class _GameStatsTab extends ConsumerWidget {
  const _GameStatsTab({required this.game});

  final GamePresentation game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats =
        ref.watch(statsControllerProvider)[game.type] ?? const GameStats();
    String value(StatSpec s) {
      final v = stats.values[s.key];
      return v == null ? '–' : '${v.round()}';
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Space.maxContent),
        child: ListView(
          padding: const EdgeInsets.all(Space.l),
          children: [
            _Row('Games played', '${stats.played}', big: true),
            _Row('Wins', '${stats.totalWins}', big: true),
            _Row('  Local', '${stats.winsIn(GameMode.local)}'),
            _Row('  vs AI', '${stats.winsIn(GameMode.ai)}'),
            _Row('  Wi-Fi', '${stats.winsIn(GameMode.online)}'),
            const Divider(height: Space.xl),
            for (final s in game.statSpecs) _Row(s.label, value(s)),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.big = false});

  final String label;
  final String value;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Space.s),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: big ? t.titleMedium : t.bodyLarge),
            ),
            Text(value, style: big ? t.headlineSmall : t.titleMedium),
          ],
        ),
      ),
    );
  }
}
