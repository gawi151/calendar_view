import 'package:calendar_widget/date_time/week_of_year.dart';
import 'date_time_extensions.dart';

class YearMonth {
  final int year;
  final int month;

  List<WeekOfYear> _weeks = [];

  YearMonth._(this.year, this.month);

  YearMonth.from(DateTime date) : this._(date.year, date.month);

  List<WeekOfYear> get weeks {
    if (_weeks.isEmpty) {
      var date = atStartOfMonth().atFirstDayOfWeek();
      do {
        _weeks.add(WeekOfYear.from(date));
        date = date.addWeeks(1);
      } while (date.yearMonth == this);
    }
    return _weeks;
  }

  DateTime atStartOfMonth() => DateTime(year, month);

  DateTime atEndOfMonth() => DateTime(year, month).atEndOfMonth();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YearMonth &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month;

  @override
  int get hashCode => year.hashCode ^ month.hashCode;

  @override
  String toString() {
    return 'YearMonth{year: $year, month: $month}';
  }
}
