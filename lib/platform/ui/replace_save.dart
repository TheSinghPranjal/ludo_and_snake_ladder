import 'package:dice_party/platform/session/game_presentation.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/ui/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Asks before a new game replaces the saved game of [game]. Returns true
/// when it is fine to start.
Future<bool> confirmReplaceSave(
  BuildContext context,
  WidgetRef ref,
  GamePresentation game,
) async {
  if (ref.read(savesControllerProvider)[game.type] == null) return true;
  return confirmDialog(
    context,
    title: 'Start a new game?',
    message: 'Your saved ${game.module.displayName} game will be replaced.',
    confirm: 'Start new',
    destructive: true,
  );
}
