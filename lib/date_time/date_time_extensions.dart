import 'dart:math';

import 'package:calendar_widget/date_time/week_of_year.dart';

import 'month_day.dart';
import 'year_month.dart';

extension DateTimeExtensions on DateTime {
  DateTime copy(
      {int? year,
      int? month,
      int? day,
      int? hour,
      int? minute,
      int? second,
      int? millisecond,
      int? microsecond}) {
    if (isUtc) {
      return DateTime.utc(
          year ?? this.year,
          month ?? this.month,
          day ?? this.day,
          hour ?? this.hour,
          minute ?? this.minute,
          second ?? this.second,
          millisecond ?? this.millisecond,
          microsecond ?? this.microsecond);
    } else {
      return DateTime(
          year ?? this.year,
          month ?? this.month,
          day ?? this.day,
          hour ?? this.hour,
          minute ?? this.minute,
          second ?? this.second,
          millisecond ?? this.millisecond,
          microsecond ?? this.microsecond);
    }
  }
}

extension WeekExtensions on DateTime {
  // https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int get weeksCount {
    bool isLongYear =
        _dayOfLastWeekOfYear(year) == 4 || _dayOfLastWeekOfYear(year - 1) == 3;
    int additionalWeek = isLongYear ? 1 : 0;
    return 52 + additionalWeek;
  }

  // https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int _dayOfLastWeekOfYear(int year) {
    return (year +
            (year / 4).floor() -
            (year / 100).floor() +
            (year / 400).floor()) %
        7;
  }

  // https://en.wikipedia.org/wiki/ISO_week_date#Calculating_the_week_number_from_a_month_and_day_of_the_month_or_ordinal_date
  int get weekOfYearNumber {
    int woy = (10 + dayOfYear - dayOfWeek) ~/ 7;
    if (woy < 1) {
      woy = DateTime(year - 1).weeksCount;
    } else if (woy > weeksCount) {
      woy = 1;
    }
    return woy;
  }

  DateTime addWeeks(int value) =>
      add(Duration(days: DateTime.daysPerWeek * value));

  DateTime minusWeeks(int value) =>
      subtract(Duration(days: DateTime.daysPerWeek * value));

  bool get isWeekend =>
      weekday == DateTime.sunday || weekday == DateTime.saturday;
}

extension DaysExtension on DateTime {
  int get dayOfYear => 1 + this.difference(DateTime(year)).inDays;

  int get dayOfWeek => this.weekday;

  // DateTime(2021, 3, 4) Thur -> DateTime(2021, 3, 1) Mon,
  DateTime atFirstDayOfWeek() => subtract(Duration(days: weekday - 1));

  DateTime addDays(int value) => add(Duration(days: value));
}

extension YearsExtension on DateTime {
  bool get isLeapYear => _isLeapYear(year);
}

extension YearMonthExtensions on DateTime {
  YearMonth get yearMonth => YearMonth.from(this);
}

extension MonthDayExtensions on DateTime {
  MonthDay get monthDay => MonthDay.from(this);
}

extension WeekOfYearExtensions on DateTime {
  WeekOfYear get weekOfYear => WeekOfYear.from(this);
}

extension MonthExtensions on DateTime {
  DateTime addMonths(int value) {
    final r = value % 12;
    final q = (value - r) ~/ 12;
    var newYear = year + q;
    var newMonth = month + r;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    final newDay = min(day, daysInMonth(newYear, newMonth));
    return copy(year: newYear, month: newMonth, day: newDay);
  }

  DateTime minusMonths(int value) => addMonths(-value);

  DateTime nextMonth() => addMonths(1);

  DateTime previousMonth() => addMonths(-1);

  DateTime atStartOfMonth() => copy(day: 1);

  DateTime atEndOfMonth() => copy(day: daysCount);

  int get daysCount => daysInMonth(year, month);
}

int daysInMonth(int year, int month) {
  assert(month >= 1 && month <= 12);
  int value = _daysInMonthMap[month]!;
  if (month == DateTime.february && _isLeapYear(year)) value++;
  return value;
}

const _daysInMonthMap = {
  DateTime.january: 31,
  DateTime.february: 28,
  DateTime.march: 31,
  DateTime.april: 30,
  DateTime.may: 31,
  DateTime.june: 30,
  DateTime.july: 31,
  DateTime.august: 31,
  DateTime.september: 30,
  DateTime.october: 31,
  DateTime.november: 30,
  DateTime.december: 31,
};

bool _isLeapYear(int year) =>
    (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
