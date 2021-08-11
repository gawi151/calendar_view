import 'package:flutter_test/flutter_test.dart';
import 'package:calendar_view/date_time/date_time_extensions.dart';

void main() {
  group('weekOfYear should return', () {
    final inputsToExpected = {
      DateTime(2021): 53,
      DateTime(2020): 1,
      DateTime(2020, 12, 31): 53
    };

    inputsToExpected.forEach((input, expected) {
      test("$expected for $input", () {
        expect(input.weekOfYear, expected);
      });
    });
  });
}
