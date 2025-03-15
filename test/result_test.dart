import 'package:result_library/result_library.dart';
import 'package:test/test.dart';

void main() {
  group('Result Library Tests', () {
    test('Ok should return correct value', () {
      var result = ResultBuilder.ok<int, String>(42);
      expect(result.isOk(), true);
      expect(result.unwrap(), 42);
    });

    test('Err should return correct error', () {
      var result = ResultBuilder.err<int, String>('Error');
      expect(result.isErr(), true);
      expect(result.unwrapErr(), 'Error');
    });

    test('Unwrap should throw on Err', () {
      var result = ResultBuilder.err('Error');
      expect(() => result.unwrap(), throwsException);
    });
  });
}
