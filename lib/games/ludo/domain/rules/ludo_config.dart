import 'package:freezed_annotation/freezed_annotation.dart';

part 'ludo_config.freezed.dart';
part 'ludo_config.g.dart';

/// Configuration of a Ludo game.
///
/// The rules are fixed, so this carries no options yet. It exists so Ludo
/// fits the shared setup, save and lobby flow.
@freezed
abstract class LudoConfig with _$LudoConfig {
  /// Creates a configuration.
  const factory LudoConfig() = _LudoConfig;

  /// Reads a configuration from JSON.
  factory LudoConfig.fromJson(Map<String, dynamic> json) =>
      _$LudoConfigFromJson(json);
}
