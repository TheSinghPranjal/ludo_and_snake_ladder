import 'package:dice_party/platform/app_services.dart';
import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:dice_party/platform/session/game_module.dart';
import 'package:dice_party/platform/settings/app_settings.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/theme/app_theme.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/confirm_dialog.dart';
import 'package:dice_party/platform/ui/meadow/meadow_controls.dart';
import 'package:dice_party/platform/ui/meadow/meadow_frame.dart';
import 'package:dice_party/platform/ui/meadow/meadow_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global settings on a cream panel over the meadow: appearance, sound,
/// animation speed, local turn timer, default AI difficulty and stats.
class SettingsScreen extends ConsumerWidget {
  /// Creates the screen.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsControllerProvider);
    final ctrl = ref.read(settingsControllerProvider.notifier);
    final audio = ref.watch(appServicesProvider).audio;

    void set(AppSettings Function(AppSettings) change) {
      audio.play(Sfx.uiTap);
      ctrl.update(change);
    }

    // Toggles stay silent, so muting never plays a last tap.
    void toggle(AppSettings Function(AppSettings) change) =>
        ctrl.update(change);

    return MeadowFrame(
      title: 'Settings',
      signAsset: SharedAssets.signSettings,
      signAspect: 436 / 148,
      signWidthFactor: 0.52,
      bottomClearance: 0.1,
      child: MeadowPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MeadowHeader(icon: 'palette', title: 'Appearance'),
            MeadowSegmented<AppearanceMode>(
              selected: s.appearance,
              onChanged: (v) => set((st) => st.copyWith(appearance: v)),
              segments: const [
                MeadowSegment(
                  AppearanceMode.system,
                  'System',
                  icon: _SystemIcon(),
                ),
                MeadowSegment(
                  AppearanceMode.light,
                  'Light',
                  icon: MeadowIcon('sun', size: 26),
                ),
                MeadowSegment(
                  AppearanceMode.dark,
                  'Dark',
                  icon: MeadowIcon('moon', size: 24),
                ),
              ],
            ),
            const MeadowDivider(),

            const MeadowHeader(icon: 'sound', title: 'Sound'),
            MeadowSwitchRow(
              icon: 'sfx',
              title: 'Sound effects',
              value: s.sound,
              onChanged: (v) => toggle((st) => st.copyWith(sound: v)),
            ),
            const SizedBox(height: 7),
            MeadowSwitchRow(
              icon: 'music',
              title: 'Music',
              value: s.music,
              onChanged: (v) => toggle((st) => st.copyWith(music: v)),
            ),
            const SizedBox(height: 7),
            MeadowSwitchRow(
              icon: 'haptics',
              title: 'Haptics',
              value: s.haptics,
              onChanged: (v) => toggle((st) => st.copyWith(haptics: v)),
            ),
            const MeadowDivider(),

            const MeadowHeader(icon: 'speed', title: 'Animation speed'),
            MeadowSegmented<AnimationSpeed>(
              selected: s.speed,
              onChanged: (v) => set((st) => st.copyWith(speed: v)),
              segments: const [
                MeadowSegment(AnimationSpeed.normal, 'Normal'),
                MeadowSegment(AnimationSpeed.fast, 'Fast'),
              ],
            ),
            const MeadowDivider(),

            const MeadowHeader(
              icon: 'timer',
              title: 'Turn timer in local games',
            ),
            MeadowSegmented<bool>(
              selected: s.localTimer,
              onChanged: (v) => set((st) => st.copyWith(localTimer: v)),
              segments: const [
                MeadowSegment(false, 'Off'),
                MeadowSegment(true, '30 s'),
              ],
            ),
            const MeadowDivider(),

            const MeadowHeader(icon: 'robot', title: 'Default AI difficulty'),
            MeadowSegmented<AiLevel>(
              selected: s.defaultAi,
              onChanged: (v) => set((st) => st.copyWith(defaultAi: v)),
              segments: const [
                MeadowSegment(AiLevel.easy, 'Easy'),
                MeadowSegment(AiLevel.normal, 'Normal'),
              ],
            ),
            const MeadowDivider(),

            const MeadowHeader(icon: 'stats', title: 'Statistics'),
            _ResetStatsButton(
              onTap: () async {
                audio.play(Sfx.uiTap);
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Stats reset')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Half-filled circle shown on the System segment.
class _SystemIcon extends StatelessWidget {
  const _SystemIcon();

  @override
  Widget build(BuildContext context) => const Icon(Icons.contrast_rounded);
}

class _ResetStatsButton extends StatefulWidget {
  const _ResetStatsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_ResetStatsButton> createState() => _ResetStatsButtonState();
}

class _ResetStatsButtonState extends State<_ResetStatsButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Reset stats',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: Space.xs),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HomePalette.resetBg, HomePalette.resetBottom],
              ),
              border: Border.all(color: HomePalette.resetRed, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: HomePalette.cardShadow,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: Space.m),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.replay_rounded,
                    size: 28,
                    color: HomePalette.resetRed,
                  ),
                  SizedBox(width: Space.s),
                  Text(
                    'Reset stats',
                    style: TextStyle(
                      fontFamily: displayFont,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: HomePalette.resetRed,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
