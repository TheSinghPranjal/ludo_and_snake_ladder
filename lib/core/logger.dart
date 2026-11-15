import 'dart:developer' as developer;

/// Severity of a log line.
enum LogLevel {
  /// Detail for development.
  debug,

  /// Normal operation.
  info,

  /// Something unexpected that was handled.
  warning,

  /// A failure.
  error,
}

/// Minimal logger writing to `dart:developer`.
///
/// Callers must never pass secrets such as reconnect tokens.
class Logger {
  /// Creates a logger tagged with [name].
  const Logger(this.name);

  /// Tag shown with each line.
  final String name;

  /// Logs [message] at [level].
  void log(LogLevel level, String message, [Object? error]) {
    developer.log(
      message,
      name: name,
      level: switch (level) {
        LogLevel.debug => 500,
        LogLevel.info => 800,
        LogLevel.warning => 900,
        LogLevel.error => 1000,
      },
      error: error,
    );
  }
}
