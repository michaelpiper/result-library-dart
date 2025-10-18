import 'package:test/test.dart';
import 'package:result_library/result_library.dart';

void main() {
  group('Example main behavior', () {
    test('when ok branch returns mapped value', () {
      final ok = ResultBuilder.ok<int, String>(10);
      final value = ok.when(ok: (v) => v * 2, err: (e) => 0);
      expect(value, 20);
    });

    test('when err branch returns fallback', () {
      final err = ResultBuilder.err<int, String>('bad');
      final value = err.when(ok: (v) => v * 2, err: (e) => -1);
      expect(value, -1);
    });

    test('fold ok branch resolves string', () async {
      final ok = ResultBuilder.ok<int, String>(10);
      final value = await ok.fold<String>(
        ok: (v) async => 'ok:$v',
        err: (e) async => 'err:$e',
      );
      expect(value, 'ok:10');
    });

    test('fold err branch resolves string', () async {
      final err = ResultBuilder.err<int, String>('bad');
      final value = await err.fold<String>(
        ok: (v) async => 'ok:$v',
        err: (e) async => 'err:$e',
      );
      expect(value, 'err:bad');
    });

    test('map ok transforms to string', () {
      final ok = ResultBuilder.ok<int, String>(10);
      final mapped = ok.map((v) => 'value=$v');
      expect(mapped.isOk(), true);
      expect(mapped.ok(), 'value=10');
    });

    test('map on err preserves error', () {
      final err = ResultBuilder.err<int, String>('bad');
      final mapped = err.map((v) => 'value=$v');
      expect(mapped.isErr(), true);
      expect(mapped.err(), 'bad');
    });

    test('mapErr transforms error type', () {
      final err = ResultBuilder.err<int, String>('bad');
      final mapped = err.mapErr((e) => e.length);
      expect(mapped.isErr(), true);
      expect(mapped.err(), 3);
    });

    test('mapOr returns mapped or default', () {
      final ok = ResultBuilder.ok<int, String>(10);
      final err = ResultBuilder.err<int, String>('bad');
      expect(ok.mapOr<String>((v) => 'v=$v', 'default'), 'v=10');
      expect(err.mapOr<String>((v) => 'v=$v', 'default'), 'default');
    });

    test('mapOrElse chooses mapper or errMapper', () {
      final ok = ResultBuilder.ok<int, String>(10);
      final err = ResultBuilder.err<int, String>('bad');
      final okResult = ok.mapOrElse<String>((v) => 'v=$v', (e) => 'e=$e');
      final errResult = err.mapOrElse<String>((v) => 'v=$v', (e) => 'e=$e');
      expect(okResult, 'v=10');
      expect(errResult, 'e=bad');
    });

    test('mapOrErr returns default or mapped error', () {
      final ok = ResultBuilder.ok<int, String>(10);
      final err = ResultBuilder.err<int, String>('bad');
      expect(ok.mapOrErr<int>((e) => e.length, 0), 0);
      expect(err.mapOrErr<int>((e) => e.length, 0), 3);
    });

    test('mapErrOr returns default or mapped error', () {
      final ok = ResultBuilder.ok<int, String>(10);
      final err = ResultBuilder.err<int, String>('bad');
      expect(ok.mapErrOr<String>((e) => 'e=$e', 'default'), 'default');
      expect(err.mapErrOr<String>((e) => 'e=$e', 'default'), 'e=bad');
    });

    test('mapErrOrElse returns default or mapped error', () {
      final ok = ResultBuilder.ok<int, String>(10);
      final err = ResultBuilder.err<int, String>('bad');
      expect(ok.mapErrOrElse<int>((e) => e.length, 0), 0);
      expect(err.mapErrOrElse<int>((e) => e.length, 0), 3);
    });
    test('mapErrOrElse returns default or mapped error', () {
      final ok = ResultBuilder.ok<int, String>(10);
      final err = ResultBuilder.err<int, String>('bad');
      expect(ok.mapErrOrElse<int>((e) => e.length, 0), 0);
      expect(err.mapErrOrElse<int>((e) => e.length, 0), 3);
    });

    test('mapErrOrElse returns default or mapped error', () {
      final ok = Ok<int, String>(10);
      final err = Err<int, String>('bad');
      expect(ok.mapErrOrElse<int>((e) => e.length, 0), 0);
      expect(err.mapErrOrElse<int>((e) => e.length, 0), 3);
    });
     // test async using OK or Err
    test('fold ok branch resolves string', () async {
      final ok = Ok<int, String>(10);
      final value = await ok.fold<String>(
        ok: (v) async => 'ok:$v',
        err: (e) async => 'err:$e',
      );
      expect(value, 'ok:10');
    });
     // test async using OK or Err
    test('fold err branch resolves string', () async {
      final err = Err<int, String>('bad');
      final value = await err.fold<String>(
        ok: (v) async => 'ok:$v',
        err: (e) async => 'err:$e',
      );
      expect(value, 'err:bad');
    });

    // test .ok branch
    test('ok branch returns artifact', () {
      final ok = Ok<int, String>(10);
      expect(ok.ok(), 10);
    });
    // test .err branch
    test('err branch returns error', () {
      final err = Err<int, String>('bad');
      expect(err.err(), 'bad');
    });
    // test .isOk branch
    test('isOk branch returns true', () {
      final ok = Ok<int, String>(10);
      expect(ok.isOk(), true);
    });
    // test .isErr branch
    test('isErr branch returns true', () {
      final err = Err<int, String>('bad');
      expect(err.isErr(), true);
    }); 
    // test .unwrap branch
    test('unwrap branch returns artifact', () {
      final ok = Ok<int, String>(10);
      expect(ok.unwrap(), 10);
    });
    // test .unwrapErr branch
    test('unwrapErr branch returns error', () {
      final err = Err<int, String>('bad');
      expect(err.unwrapErr(), 'bad');
    });

    // test .unwrapOr branch
    test('unwrapOr branch returns artifact', () {
      final ok = Ok<int, String>(10);
      expect(ok.unwrapOr(0), 10);

      final err = Err<int, String>('bad');
      expect(err.unwrapOr(0), 0);
    });
    // test .unwrapOrElse branch
    test('unwrapOrElse branch returns artifact', () {
      final ok = Ok<int, String>(10);
      expect(ok.unwrapOrElse((e) => 0), 10);

      final err = Err<int, String>('bad');
      expect(err.unwrapOrElse((e) => 0), 0);
    });
  });
}