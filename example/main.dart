import 'package:result_library/result_library.dart';

void main() {
  // Success case
  var success = ResultBuilder.ok<int, String>(42);
  print(success.isOk()); // true
  print(success.unwrap()); // 42

  // Error case
  var failure = ResultBuilder.err<int, String>('Something went wrong');
  print(failure.isErr()); // true
  print(failure.unwrapErr()); // Something went wrong
}
