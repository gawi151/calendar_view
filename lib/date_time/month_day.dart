class MonthDay {
  final int month;
  final int day;

  MonthDay._(this.month, this.day)
      : assert(month >= 1),
        assert(month <= DateTime.monthsPerYear),
        assert(day >= 1),
        assert(day <= 31);

  MonthDay.from(DateTime dateTime) : this._(dateTime.month, dateTime.day);
}
