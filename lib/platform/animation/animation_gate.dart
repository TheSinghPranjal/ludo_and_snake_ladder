import 'dart:async';

/// Futures that tell the authority when a batch of events has been shown.
class PresentationHandle {
  /// Creates a handle.
  const PresentationHandle({required this.diceLanded, required this.drained});

  /// A handle whose futures are already complete.
  PresentationHandle.immediate()
    : diceLanded = Future<void>.value(),
      drained = Future<void>.value();

  /// Completes when the dice animation of the batch has landed.
  final Future<void> diceLanded;

  /// Completes when every animation of the batch has finished.
  final Future<void> drained;
}

/// Where the authority hands each accepted batch of events for display.
///
/// Automatic actions wait on the returned futures, so they never fire before
/// the player has seen the dice land.
abstract interface class AnimationGate {
  /// Starts presenting [events] and reports when they land and drain.
  PresentationHandle present(List<Object?> events);
}

/// A gate for headless sessions and tests: everything completes at once.
class ImmediateGate implements AnimationGate {
  /// Creates the gate.
  const ImmediateGate();

  @override
  PresentationHandle present(List<Object?> events) =>
      PresentationHandle.immediate();
}
