import 'dart:async';

import 'package:dice_party/core/logger.dart';

const _log = Logger('Audio');

/// Sound effects, named after their files in `assets/audio/`.
enum Sfx {
  /// Dice starts tumbling.
  diceRoll('dice_roll'),

  /// Dice lands.
  diceLand('dice_land'),

  /// A token hop.
  step('step'),

  /// Another roll was granted.
  extraRoll('extra_roll'),

  /// Last seconds of the turn timer.
  timerTick('timer_tick'),

  /// Someone won.
  win('win'),

  /// A button was tapped.
  uiTap('ui_tap'),

  /// S&L: climbing a ladder.
  ladderClimb('ladder_climb'),

  /// S&L: sliding down a snake.
  snakeSlide('snake_slide'),

  /// S&L: the snake swallows the token.
  snakeGulp('snake_gulp'),

  /// S&L: the move was blocked.
  blocked('blocked'),

  /// Ludo: a token leaves base.
  leaveBase('leave_base'),

  /// Ludo: a capture.
  capture('capture'),

  /// Ludo: a token reaches HOME.
  home('home')
  ;

  const Sfx(this.file);

  /// File name without extension.
  final String file;
}

/// Music loops.
enum MusicTrack {
  /// Hub and menus.
  hub('music_hub'),

  /// Snakes & Ladders games.
  snakes('music_snakes'),

  /// Ludo games.
  ludo('music_ludo')
  ;

  const MusicTrack(this.file);

  /// File name without extension.
  final String file;
}

/// Plays audio files. Implemented with `flame_audio` in the app.
abstract interface class AudioBackend {
  /// Plays [file] once.
  Future<void> playSfx(String file);

  /// Loops [file] as music, replacing any current loop.
  Future<void> playLoop(String file);

  /// Stops the music loop.
  Future<void> stopLoop();
}

/// The app's audio, obeying the Sound and Music settings.
///
/// While Sound is off, `play` does nothing. While Music is off no loop
/// plays; turning it back on resumes the track of the current screen.
class AudioService {
  /// Creates the service. [extension] is `ogg` or `m4a`.
  AudioService(this._backend, {required this.extension});

  final AudioBackend _backend;

  /// File extension used for every sound.
  final String extension;

  final List<MusicTrack> _tracks = [];
  MusicTrack? _playing;
  bool _sound = true;
  bool _music = true;
  bool _suspended = false;

  /// Whether sound effects play.
  bool get soundEnabled => _sound;

  /// Whether music plays.
  bool get musicEnabled => _music;

  /// The loop that is playing now, or null.
  MusicTrack? get playing => _playing;

  /// Applies the Sound and Music settings.
  void configure({required bool sound, required bool music}) {
    _sound = sound;
    _music = music;
    _syncMusic();
  }

  /// Plays [sfx] unless Sound is off.
  void play(Sfx sfx) {
    if (!_sound) return;
    _guard(_backend.playSfx('${sfx.file}.$extension'));
  }

  /// Makes [track] the music of the screen that just opened.
  void pushMusic(MusicTrack track) {
    _tracks.add(track);
    _syncMusic();
  }

  /// Removes [track] when its screen closes, resuming the one below.
  void popMusic(MusicTrack track) {
    final i = _tracks.lastIndexOf(track);
    if (i >= 0) _tracks.removeAt(i);
    _syncMusic();
  }

  /// Pauses music while the app is in the background.
  void suspend({required bool suspended}) {
    _suspended = suspended;
    _syncMusic();
  }

  void _syncMusic() {
    final want = _music && !_suspended && _tracks.isNotEmpty
        ? _tracks.last
        : null;
    if (want == _playing) return;
    _playing = want;
    _guard(
      want == null
          ? _backend.stopLoop()
          : _backend.playLoop('${want.file}.$extension'),
    );
  }

  void _guard(Future<void> f) {
    unawaited(
      f.catchError((Object e) {
        _log.log(LogLevel.warning, 'audio failed', e);
      }),
    );
  }
}
