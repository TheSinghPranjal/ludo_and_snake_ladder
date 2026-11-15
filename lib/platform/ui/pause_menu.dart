import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/confirm_dialog.dart';
import 'package:dice_party/platform/ui/settings_controls.dart';
import 'package:flutter/material.dart';

/// What the player chose in the Pause menu.
enum PauseChoice {
  /// Keep playing.
  resume,

  /// Open How to Play.
  rules,

  /// Leave and keep the saved game for Continue.
  saveAndExit,

  /// Leave and delete the saved game (confirmed).
  quit,
}

/// Shows the shared Pause menu. Dismissing it means [PauseChoice.resume].
Future<PauseChoice> showPauseMenu(BuildContext context) async {
  final choice = await showModalBottomSheet<PauseChoice>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(Space.l, 0, Space.l, Space.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Paused',
              textAlign: TextAlign.center,
              style: Theme.of(sheet).textTheme.headlineSmall,
            ),
            const SizedBox(height: Space.m),
            FilledButton(
              onPressed: () => Navigator.of(sheet).pop(PauseChoice.resume),
              child: const Text('Resume'),
            ),
            const SizedBox(height: Space.s),
            OutlinedButton(
              onPressed: () => Navigator.of(sheet).pop(PauseChoice.rules),
              child: const Text('Rules'),
            ),
            const SizedBox(height: Space.s),
            const SoundToggles(),
            const SizedBox(height: Space.s),
            const AppearancePicker(),
            const SizedBox(height: Space.l),
            OutlinedButton(
              onPressed: () => Navigator.of(sheet).pop(PauseChoice.saveAndExit),
              child: const Text('Save and exit'),
            ),
            const SizedBox(height: Space.s),
            TextButton(
              onPressed: () async {
                final ok = await confirmDialog(
                  sheet,
                  title: 'Leave game?',
                  message: 'This game will end and its save will be deleted.',
                  confirm: 'Leave',
                  destructive: true,
                );
                if (ok && sheet.mounted) {
                  Navigator.of(sheet).pop(PauseChoice.quit);
                }
              },
              child: const Text('Leave game'),
            ),
          ],
        ),
      ),
    ),
  );
  return choice ?? PauseChoice.resume;
}
