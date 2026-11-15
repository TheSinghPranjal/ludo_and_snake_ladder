import 'package:dice_party/platform/audio/audio_service.dart';
import 'package:flame_audio/flame_audio.dart';

/// [AudioBackend] using `flame_audio`, reading from `assets/audio/`.
class FlameAudioBackend implements AudioBackend {
  /// Creates the backend. Call [initialize] once before use.
  FlameAudioBackend();

  /// Prepares the music player.
  Future<void> initialize() => FlameAudio.bgm.initialize();

  @override
  Future<void> playSfx(String file) async {
    await FlameAudio.play(file);
  }

  @override
  Future<void> playLoop(String file) => FlameAudio.bgm.play(file, volume: 0.6);

  @override
  Future<void> stopLoop() => FlameAudio.bgm.stop();
}
