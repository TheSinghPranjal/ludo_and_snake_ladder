/// A success value or a failure, used where errors are expected input.
sealed class Result<T, E> {
  const Result();

  /// Whether this is an [Ok].
  bool get isOk => this is Ok<T, E>;

  /// The value, or null on failure.
  T? get valueOrNull => switch (this) {
    Ok<T, E>(:final value) => value,
    Err<T, E>() => null,
  };
}

/// A successful [Result].
final class Ok<T, E> extends Result<T, E> {
  /// Wraps [value].
  const Ok(this.value);

  /// The value.
  final T value;
}

/// A failed [Result].
final class Err<T, E> extends Result<T, E> {
  /// Wraps [error].
  const Err(this.error);

  /// The error.
  final E error;
}
