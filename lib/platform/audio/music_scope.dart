import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:flutter/widgets.dart';

/// Plays [track] while this widget is mounted, then restores the music of
/// the screen below.
class MusicScope extends StatefulWidget {
  /// Creates a scope.
  const MusicScope({
    required this.audio,
    required this.track,
    required this.child,
    super.key,
  });

  /// The audio service.
  final AudioService audio;

  /// Music for this screen.
  final MusicTrack track;

  /// The screen.
  final Widget child;

  @override
  State<MusicScope> createState() => _MusicScopeState();
}

class _MusicScopeState extends State<MusicScope> {
  @override
  void initState() {
    super.initState();
    widget.audio.pushMusic(widget.track);
  }

  @override
  void dispose() {
    widget.audio.popMusic(widget.track);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
