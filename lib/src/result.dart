import 'dart:async';

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

  T when({
    required T Function(T artifact) ok,
    required T Function(E error) err,
  }) {
    return isOk() ? ok(_artifact!) : err(_error!);
  }

  FutureOr<R> fold<R>({
    required FutureOr<R> Function(T artifact) ok,
    required FutureOr<R> Function(E error) err,
  }) async {
    return isOk() ? await ok(_artifact!) : await err(_error!);
  }

  Result<RT, E> map<RT>(RT Function(T artifact) mapper) {
    return isOk() ? Ok<RT, E>(mapper(_artifact!)) : Err<RT, E>(_error!);
  }
  Result<T, RE> mapErr<RE>(RE Function(E error) mapper) {
    return isOk() ? Ok<T, RE>(_artifact!) : Err<T, RE>(mapper(_error!));
  }

  RT mapOr<RT>(RT Function(T artifact) mapper, RT defaultValue) {
    return isOk() ? mapper(_artifact!) : defaultValue;
  }
  RT mapOrElse<RT>(RT Function(T artifact) mapper, RT Function(E error) errMapper) {
    return isOk() ? mapper(_artifact!) : errMapper(_error!);
  }
  RE mapOrErr<RE>(RE Function(E error) mapper, RE defaultValue) {
    return isOk() ? defaultValue : mapper(_error!);
  }

  RT mapErrOr<RT>(RT Function(E error) mapper, RT defaultValue) {
    return isOk() ? defaultValue : mapper(_error!);
  }

  T mapErrOrElse<T>(T Function(E error) mapper, T defaultValue) {
    return isOk() ? defaultValue : mapper(_error!);
  }

  T unwrapOr(T defaultValue) {
    return isOk() ? _artifact! : defaultValue;
  }
  T unwrapOrElse(T Function(E error) defaultValue) {
    return isOk() ? _artifact! : defaultValue(_error!);
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
