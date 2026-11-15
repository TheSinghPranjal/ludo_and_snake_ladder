import 'package:dice_party/platform/settings/app_settings.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/ui/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Appearance picker, shared by Settings and the Pause menu.
class AppearancePicker extends ConsumerWidget {
  /// Creates the picker.
  const AppearancePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(settingsControllerProvider).appearance;
    return SegmentedButton<AppearanceMode>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(
          value: AppearanceMode.system,
          label: Text('System'),
          icon: AppIcon('auto', size: 18),
        ),
        ButtonSegment(
          value: AppearanceMode.light,
          label: Text('Light'),
          icon: AppIcon('sun', size: 18),
        ),
        ButtonSegment(
          value: AppearanceMode.dark,
          label: Text('Dark'),
          icon: AppIcon('moon', size: 18),
        ),
      ],
      selected: {mode},
      onSelectionChanged: (v) => ref
          .read(settingsControllerProvider.notifier)
          .update((s) => s.copyWith(appearance: v.first)),
    );
  }
}

/// Sound, Music and Haptics switches, shared by Settings and Pause.
class SoundToggles extends ConsumerWidget {
  /// Creates the switches.
  const SoundToggles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider);
    final ctrl = ref.read(settingsControllerProvider.notifier);
    return Column(
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: AppIcon(s.sound ? 'sound_on' : 'sound_off'),
          title: const Text('Sound effects'),
          value: s.sound,
          onChanged: (v) => ctrl.update((s) => s.copyWith(sound: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: AppIcon(s.music ? 'music_on' : 'music_off'),
          title: const Text('Music'),
          value: s.music,
          onChanged: (v) => ctrl.update((s) => s.copyWith(music: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const AppIcon('haptics'),
          title: const Text('Haptics'),
          value: s.haptics,
          onChanged: (v) => ctrl.update((s) => s.copyWith(haptics: v)),
        ),
      ],
    );
  }
}
