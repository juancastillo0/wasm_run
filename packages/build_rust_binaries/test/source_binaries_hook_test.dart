import 'package:test/test.dart';

void main() {
  group('Build Hook', () {
    // Uses An http client for checking the expected request and returns
    // payload for verifying the sha256 hash logic
    test('Build Hook fetch', () {});

    // Uses CheckoutMode similar to how the cli does,
    // but with a test runProcess that checks the expected command
    test('Build Hook checkout', () {});

    // Verifies that the hook can be used with a local path,
    // and validates the proper names
    test('Build Hook local file', () {});

    // Verifies that the hook can be used with a local path,
    // and validates the proper names
    test('Build Hook local directory', () {});
  });
}
