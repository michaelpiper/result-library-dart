import 'package:result_library/result_library.dart';

Future<void> main() async {
  // Ensure asserts are enabled
  var assertsEnabled = false;
  assert(() {
    assertsEnabled = true;
    return true;
  }());
  if (!assertsEnabled) {
    print('WARNING: asserts disabled. Run with: dart run --enable-asserts');
  }

  // Base results
  final ok = ResultBuilder.ok<int, String>(10);
  final err = ResultBuilder.err<int, String>('bad');

  // when: pattern matching to produce a T
  final whenOk = ok.when(
    ok: (v) => v * 2,
    err: (e) => 0,
  );
  assert(whenOk == 20);
  print('when(ok): $whenOk');

  final whenErr = err.when(
    ok: (v) => v * 2,
    err: (e) => -1,
  );
  assert(whenErr == -1);
  print('when(err): $whenErr');

  // fold<R>: async handlers for both branches
  final foldOk = await ok.fold<String>(
    ok: (v) async => 'ok:$v',
    err: (e) async => 'err:$e',
  );
  assert(foldOk == 'ok:10');
  print('fold(ok): $foldOk');

  final foldErr = await err.fold<String>(
    ok: (v) async => 'ok:$v',
    err: (e) async => 'err:$e',
  );
  assert(foldErr == 'err:bad');
  print('fold(err): $foldErr');

  // map<RT>: transform Ok value, preserve E
  final mappedOk = ok.map((v) => 'value=$v');
  assert(mappedOk.isOk());
  assert(mappedOk.ok() == 'value=10');
  print('map(ok): ${mappedOk.ok()}');

  final mappedErr = err.map((v) => 'value=$v');
  assert(mappedErr.isErr());
  assert(mappedErr.err() == 'bad');
  print('map(err): ${mappedErr.err()}');

  // Optional: mapErr to transform Err value
  final mappedErrValue = err.mapErr((e) => e.length);
  assert(mappedErrValue.isErr());
  assert(mappedErrValue.err() == 3);
  print('mapErr(err): ${mappedErrValue.err()}');

  print('Example assertions passed.');
}
