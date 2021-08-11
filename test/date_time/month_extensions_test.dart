import 'package:flutter_test/flutter_test.dart';
import 'package:calendar_widget/date_time/date_time_extensions.dart';

void main() {
  final testData = [
    TestData(
        initialDate: DateTime(2020, 1, 1),
        inputMonths: 1,
        expectedDate: DateTime(2020, 2, 1)),
    TestData(
        initialDate: DateTime(2020, 1, 20),
        inputMonths: 1,
        expectedDate: DateTime(2020, 2, 20)),
    TestData(
        initialDate: DateTime(2020, 1, 31),
        inputMonths: 1,
        expectedDate: DateTime(2020, 2, 29)),
    TestData(
        initialDate: DateTime(2020, 12, 31),
        inputMonths: 1,
        expectedDate: DateTime(2021, 1, 31)),
    TestData(
        initialDate: DateTime(2020, 2, 29),
        inputMonths: 1,
        expectedDate: DateTime(2020, 3, 29)),
    TestData(
        initialDate: DateTime(2020, 2, 29),
        inputMonths: -1,
        expectedDate: DateTime(2020, 1, 29)),
    TestData(
        initialDate: DateTime(2020, 2, 29),
        inputMonths: 12,
        expectedDate: DateTime(2021, 2, 28)),
    TestData(
        initialDate: DateTime(2019, 2, 28),
        inputMonths: 12,
        expectedDate: DateTime(2020, 2, 28)),
    TestData(
        initialDate: DateTime(2019, 11, 30),
        inputMonths: 3,
        expectedDate: DateTime(2020, 2, 29)),
  ];

  testData.forEach((data) {
    final testDescription =
        "addMonths(${data.inputMonths}) to ${data.initialDate} should return ${data.expectedDate}";
    test(testDescription, () {
      final actualDate = data.initialDate.addMonths(data.inputMonths);
      expect(actualDate, data.expectedDate);
    });
  });
}

class TestData {
  final DateTime initialDate;
  final int inputMonths;
  final DateTime expectedDate;

  TestData({
    required this.initialDate,
    required this.inputMonths,
    required this.expectedDate,
  });
}
