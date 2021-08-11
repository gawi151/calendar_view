import 'date_time_extensions.dart';

class WeekOfYear {
  final int weekNumber;
  final int year;
  final DateTime firstDateOfWeek;

  WeekOfYear.from(DateTime date)
      : weekNumber = date.weekOfYearNumber,
        year = date.year,
        firstDateOfWeek = date.atFirstDayOfWeek();
}
