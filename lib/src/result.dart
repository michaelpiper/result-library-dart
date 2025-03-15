class Result<T, E> {
  final bool _ok;
  final T? _artifact;
  final E? _error;

  Result._({required bool ok, T? artifact, E? error})
      : _ok = ok,
        _artifact = artifact,
        _error = error;

  bool isOk() => _ok;

  bool isErr() => !_ok;

  T ok() {
    if (_artifact == null) {
      throw Exception("Called ok() on an Err value");
    }
    return _artifact!;
  }

  E err() {
    if (_error == null) {
      throw Exception("Called err() on an Ok value");
    }
    return _error!;
  }

  T unwrap() {
    if (isErr()) {
      throw Exception("Called unwrap() on an Err value");
    }
    return ok();
  }

  E unwrapErr() {
    if (isOk()) {
      throw Exception("Called unwrapErr() on an Ok value");
    }
    return err();
  }
}

class Ok<T, E> extends Result<T, E> {
  Ok(T artifact) : super._(ok: true, artifact: artifact);
}

class Err<T, E> extends Result<T, E> {
  Err(E error) : super._(ok: false, error: error);
}

class ResultBuilder<T, E> {
  static Result<T, E> ok<T, E extends dynamic>(T result) => Ok<T, E>(result);

  static Result<T, E> err<T extends dynamic, E>(E error) => Err<T, E>(error);

  static Result<T, E> okWithErr<T, E extends dynamic>(T result, E error) =>
      Result<T, E>._(
        ok: true,
        artifact: result,
        error: error,
      );
  static Result<T, E> errWithOk<T, E extends dynamic>(T result, E error) =>
      Result<T, E>._(
        ok: false,
        artifact: result,
        error: error,
      );
}
