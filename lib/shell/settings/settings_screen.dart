import 'package:dice_party/core/constants/app_info.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/settings/app_settings.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/confirm_dialog.dart';
import 'package:dice_party/platform/ui/page_frame.dart';
import 'package:dice_party/platform/ui/settings_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global settings.
class SettingsScreen extends ConsumerWidget {
  /// Creates the screen.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider);
    final ctrl = ref.read(settingsControllerProvider.notifier);
    final text = Theme.of(context).textTheme;
    return PageFrame(
      title: 'Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('Appearance'),
          const AppearancePicker(),
          const SectionTitle('Sound'),
          const SoundToggles(),
          const SectionTitle('Animation speed'),
          SegmentedButton<AnimationSpeed>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: AnimationSpeed.normal,
                label: Text('Normal'),
              ),
              ButtonSegment(value: AnimationSpeed.fast, label: Text('Fast')),
            ],
            selected: {s.speed},
            onSelectionChanged: (v) =>
                ctrl.update((s) => s.copyWith(speed: v.first)),
          ),
          const SectionTitle('Turn timer in local games'),
          SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: false, label: Text('Off')),
              ButtonSegment(value: true, label: Text('30 s')),
            ],
            selected: {s.localTimer},
            onSelectionChanged: (v) =>
                ctrl.update((s) => s.copyWith(localTimer: v.first)),
          ),
          const SectionTitle('Default AI difficulty'),
          SegmentedButton<AiLevel>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: AiLevel.easy, label: Text('Easy')),
              ButtonSegment(value: AiLevel.normal, label: Text('Normal')),
            ],
            selected: {s.defaultAi},
            onSelectionChanged: (v) =>
                ctrl.update((s) => s.copyWith(defaultAi: v.first)),
          ),
          const SectionTitle('Statistics'),
          OutlinedButton(
            onPressed: () async {
              final ok = await confirmDialog(
                context,
                title: 'Reset stats?',
                message:
                    'All statistics for both games will be cleared. '
                    'Unlocked boards stay unlocked.',
                confirm: 'Reset',
                destructive: true,
              );
              if (!ok) return;
              ref.read(statsControllerProvider.notifier).reset();
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Stats reset')));
              }
            },
            child: const Text('Reset stats'),
          ),
          const SectionTitle('Privacy'),
          Text(
            '${AppInfo.name} has no accounts, ads or analytics. Your profile '
            'and stats stay on this phone. Wi-Fi games talk only to phones on '
            'your local network; nothing is sent to the internet.',
            style: text.bodyMedium,
          ),
          const SizedBox(height: Space.l),
          Text(
            'Version ${AppInfo.version}',
            style: text.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
