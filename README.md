## Author

This package was created by **Michael Piper**. You can reach out via email at [pipermichael@aol.com](mailto:pipermichael@aol.com)

# Result Library

[![pub package](https://img.shields.io/pub/v/result_library.svg)](https://pub.dev/packages/result_library)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A robust `Result<T, E>` type implementation for handling success and error states in Flutter and Dart applications. Inspired by functional programming paradigms, this library provides a clean and type-safe way to manage operations that may succeed or fail.

## Why Use This Package?

- **Type-Safe Error Handling**: Avoid runtime errors by explicitly handling success (`Ok`) and failure (`Err`) cases.
- **Functional Programming Style**: Encourages immutability and composability, making your code more predictable and easier to debug.
- **Flutter-Friendly**: Designed with Flutter in mind, this library integrates seamlessly into your app's architecture.
- **Comprehensive API**: Includes methods like `isOk`, `isErr`, `unwrap`, and `unwrapErr` for flexible error handling.

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  result_library: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Example

```dart
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
```

### Advanced Example

```dart
import 'package:result_library/result_library.dart';

Result<int, String> divide(int a, int b) {
  if (b == 0) {
    return Err('Division by zero');
  }
  return Ok(a ~/ b);
}

void main() {
  var result = divide(10, 2);

  if (result.isOk()) {
    print('Result: ${result.unwrap()}'); // Result: 5
  } else {
    print('Error: ${result.unwrapErr()}'); // Handles division by zero
  }
}
```

To expand the use cases of the `result_library` package, we can cover a variety of scenarios such as API calls, file operations, and more complex error handling. Below are additional examples that demonstrate how the `Result<T, E>` type can be used in different contexts.

---

### 1. **API Call Example**
This example demonstrates how to handle API responses using the `Result<T, E>` type. It simulates fetching data from an API and handling success or failure cases.

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:result_library/result_library.dart';

Future<Result<Map<String, dynamic>, String>> fetchUserData(String userId) async {
  final url = Uri.parse('https://api.example.com/users/$userId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = json.decode(response.body);
      return Ok(data);
    } else {
      // Handle HTTP errors
      return Err('Failed to fetch user data: ${response.statusCode}');
    }
  } catch (e) {
    // Handle network or parsing errors
    return Err('An error occurred: $e');
  }
}

void main() async {
  final result = await fetchUserData('123');

  if (result.isOk()) {
    print('User Data: ${result.unwrap()}');
  } else {
    print('Error: ${result.unwrapErr()}');
  }
}
```

**Explanation**:
- The `fetchUserData` function returns a `Result<Map<String, dynamic>, String>`.
- If the API call succeeds, it returns an `Ok` with the parsed JSON data.
- If the API call fails (e.g., due to network issues or invalid status code), it returns an `Err` with an error message.

---

### 2. **File Operations Example**
This example demonstrates how to handle file reading operations using the `Result<T, E>` type.

```dart
import 'dart:io';
import 'package:result_library/result_library.dart';

Result<String, String> readFile(String filePath) {
  try {
    final file = File(filePath);
    if (!file.existsSync()) {
      return Err('File not found: $filePath');
    }

    final content = file.readAsStringSync();
    return Ok(content);
  } catch (e) {
    return Err('Error reading file: $e');
  }
}

void main() {
  final result = readFile('example.txt');

  if (result.isOk()) {
    print('File Content: ${result.unwrap()}');
  } else {
    print('Error: ${result.unwrapErr()}');
  }
}
```

**Explanation**:
- The `readFile` function attempts to read the contents of a file.
- If the file exists and is successfully read, it returns an `Ok` with the file content.
- If the file does not exist or an error occurs, it returns an `Err` with an appropriate error message.

---

### 3. **Validation Example**
This example demonstrates how to validate user input using the `Result<T, E>` type.

```dart
import 'package:result_library/result_library.dart';

Result<int, String> validateAge(String input) {
  final age = int.tryParse(input);

  if (age == null) {
    return Err('Invalid input: Age must be a number');
  }

  if (age < 0 || age > 120) {
    return Err('Invalid age: Must be between 0 and 120');
  }

  return Ok(age);
}

void main() {
  final inputs = ['25', '-5', 'abc'];

  for (final input in inputs) {
    final result = validateAge(input);

    if (result.isOk()) {
      print('Valid age: ${result.unwrap()}');
    } else {
      print('Error: ${result.unwrapErr()}');
    }
  }
}
```

**Explanation**:
- The `validateAge` function checks if the input is a valid integer and falls within a reasonable range.
- If the input is valid, it returns an `Ok` with the parsed age.
- If the input is invalid, it returns an `Err` with an appropriate error message.

---

### 4. **Chained Operations Example**
This example demonstrates how to chain multiple operations using the `Result<T, E>` type.

```dart
import 'package:result_library/result_library.dart';

Result<int, String> calculateSquare(int value) {
  if (value < 0) {
    return Err('Value cannot be negative');
  }
  return Ok(value * value);
}

Result<int, String> addTen(int value) {
  return Ok(value + 10);
}

void main() {
  final input = 5;

  final result = calculateSquare(input)
      .map((square) => addTen(square).unwrap());

  if (result.isOk()) {
    print('Final Result: ${result.unwrap()}');
  } else {
    print('Error: ${result.unwrapErr()}');
  }
}
```

**Explanation**:
- The `calculateSquare` function squares the input value if it's non-negative.
- The `addTen` function adds 10 to the input value.
- The operations are chained using `.map`, which allows you to transform the success value while propagating errors.

---

### 5. **Complex Error Handling Example**
This example demonstrates how to handle multiple error types and provide detailed error messages.

```dart
import 'package:result_library/result_library.dart';

enum DivisionError { divisionByZero, invalidInput }

Result<int, DivisionError> safeDivide(int a, int b) {
  if (b == 0) {
    return Err(DivisionError.divisionByZero);
  }
  if (a < 0 || b < 0) {
    return Err(DivisionError.invalidInput);
  }
  return Ok(a ~/ b);
}

void main() {
  final result = safeDivide(10, 0);

  if (result.isOk()) {
    print('Result: ${result.unwrap()}');
  } else {
    switch (result.unwrapErr()) {
      case DivisionError.divisionByZero:
        print('Error: Division by zero');
        break;
      case DivisionError.invalidInput:
        print('Error: Invalid input');
        break;
    }
  }
}
```

**Explanation**:
- The `safeDivide` function handles two types of errors: division by zero and invalid input.
- The error type is represented as an `enum`, making it easy to handle different error cases.

---

### 6. **Combining Multiple Results**
This example demonstrates how to combine multiple `Result` values into a single result.

```dart
import 'package:result_library/result_library.dart';

Result<int, String> multiply(int a, int b) {
  if (a < 0 || b < 0) {
    return Err('Inputs must be non-negative');
  }
  return Ok(a * b);
}

Result<int, String> add(int a, int b) {
  return Ok(a + b);
}

void main() {
  final result1 = multiply(3, 4);
  final result2 = add(5, 7);

  if (result1.isOk() && result2.isOk()) {
    final combinedResult = result1.unwrap() + result2.unwrap();
    print('Combined Result: $combinedResult');
  } else {
    print('Error: ${result1.isErr() ? result1.unwrapErr() : result2.unwrapErr()}');
  }
}
```

**Explanation**:
- Two operations (`multiply` and `add`) are performed independently.
- Their results are combined only if both succeed. Otherwise, the first error encountered is reported.

---

### Conclusion

These examples showcase the versatility of the `Result<T, E>` type in handling various scenarios such as API calls, file operations, validation, chaining, and error handling. By using this pattern, you can write robust, type-safe, and maintainable Dart code that gracefully handles success and failure cases.

You can include these examples in your package's documentation or `README.md` to help users understand how to use the library effectively.

## API Reference

- `Result<T, E>`: Represents either a successful value (`Ok`) or an error (`Err`).
- `isOk()`: Returns `true` if the result is `Ok`.
- `isErr()`: Returns `true` if the result is `Err`.
- `ok()`: Retrieves the success value. Throws an exception if called on an `Err`.
- `err()`: Retrieves the error value. Throws an exception if called on an `Ok`.
- `unwrap()`: Unwraps the success value. Throws an exception if the result is `Err`.
- `unwrapErr()`: Unwraps the error value. Throws an exception if the result is `Ok`.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

MIT License
---

# result-library-dart
# result-library-dart
