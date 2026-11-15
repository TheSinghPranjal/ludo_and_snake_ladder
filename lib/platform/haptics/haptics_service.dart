import 'dart:async';

import 'package:flutter/services.dart';

/// Strength of a haptic pulse.
enum HapticPulse {
  /// A light tick, e.g. the dice landing.
  tick,

  /// A light impact, e.g. a ladder or capture.
  light,

  /// A medium impact, e.g. a snake or a win.
  medium,
}

/// Haptic feedback obeying the Haptics setting.
class HapticsService {
  /// Creates the service. [perform] defaults to the platform's feedback.
  HapticsService({Future<void> Function(HapticPulse)? perform})
    : _perform = perform ?? _platform;

  final Future<void> Function(HapticPulse) _perform;

  /// Whether pulses are produced.
  bool enabled = true;

  /// Produces [pulse] if haptics are on.
  void pulse(HapticPulse pulse) {
    if (!enabled) return;
    unawaited(_perform(pulse));
  }

  static Future<void> _platform(HapticPulse p) => switch (p) {
    HapticPulse.tick => HapticFeedback.selectionClick(),
    HapticPulse.light => HapticFeedback.lightImpact(),
    HapticPulse.medium => HapticFeedback.mediumImpact(),
  };
}
