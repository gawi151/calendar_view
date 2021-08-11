import 'package:flutter_test/flutter_test.dart';
import 'package:calendar_view/date_time/date_time_extensions.dart';

void main() {
  group('Day of year should be', () {
    final dateToExpectedDayOfYear = {
      DateTime(2021, 1, 1): 1,
      DateTime(2021, 12, 31): 365,
      DateTime(2020, 12, 31): 366
    };

    dateToExpectedDayOfYear.forEach((input, expected) {
      test("$expected for $input", () {
        expect(input.dayOfYear, expected);
      });
    });
  });

  group('First day of week', () {
    final inputToExpected = {
      DateTime(2021, 3, 4): DateTime(2021, 3, 1),
      DateTime(2021, 3, 7): DateTime(2021, 3, 1),
      DateTime(2021, 3, 8): DateTime(2021, 3, 8),
      DateTime(2021, 3, 15): DateTime(2021, 3, 15),
      DateTime(2021, 3, 16): DateTime(2021, 3, 15),
    };
    inputToExpected.forEach((input, expected) {
      test("should be $expected when date is $input", () {
        expect(input.atFirstDayOfWeek(), expected);
      });
    });
  });
}
