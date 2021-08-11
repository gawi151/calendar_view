import 'package:flutter_test/flutter_test.dart';
import 'package:calendar_view/date_time/date_time_extensions.dart';

void main() {
  group('isLeapYear should return true for', () {
    final leapYears = [2020, 2000, 1600, 2400, 2004];

    leapYears.forEach((input) {
      test("$input", () {
        expect(true, DateTime(input).isLeapYear);
      });
    });
  });

  group('isLeapYear should return false for', () {
    final notLeapYears = [2021, 2001, 1601, 2401, 2005];

    notLeapYears.forEach((input) {
      test("$input", () {
        expect(false, DateTime(input).isLeapYear);
      });
    });
  });
}
