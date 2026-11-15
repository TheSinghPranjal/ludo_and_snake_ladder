import 'dart:convert';

import 'package:dice_party/core/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _log = Logger('LocalStore');

/// JSON documents in shared preferences.
///
/// Reads never throw: a missing or unparsable document reads as null.
class LocalStore {
  /// Wraps shared preferences.
  LocalStore(this._prefs);

  final SharedPreferences _prefs;

  /// Key of the global settings.
  static const settingsKey = 'settings';

  /// Key of the profile.
  static const profileKey = 'profile';

  /// Key of the unlocked content ids.
  static const unlocksKey = 'unlocks';

  /// Key of the last host address typed or scanned.
  static const lastHostKey = 'lastHost';

  /// Key of the statistics of [game].
  static String statsKey(String game) => 'stats.$game';

  /// Key of the saved local game of [game].
  static String saveKey(String game) => 'save.$game';

  /// Key of the rule settings of [game].
  static String rulesKey(String game) => 'rules.$game';

  /// Reads the JSON object at [key], or null.
  Map<String, dynamic>? readJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      final value = jsonDecode(raw);
      if (value is Map<String, dynamic>) return value;
    } on FormatException catch (e) {
      _log.log(LogLevel.warning, 'discarding unreadable $key', e);
    }
    return null;
  }

  /// Writes [value] at [key].
  Future<void> writeJson(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  /// Reads a string list.
  List<String> readList(String key) => _prefs.getStringList(key) ?? const [];

  /// Writes a string list.
  Future<void> writeList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  /// Reads a plain string.
  String? readString(String key) => _prefs.getString(key);

  /// Writes a plain string.
  Future<void> writeString(String key, String value) =>
      _prefs.setString(key, value);

  /// Deletes [key].
  Future<void> remove(String key) => _prefs.remove(key);
}
