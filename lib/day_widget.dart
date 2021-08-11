import 'package:calendar_widget/date_time/month_day.dart';
import 'package:calendar_widget/date_time/year_month.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'date_time/date_time_extensions.dart';

class DayDetails {
  final YearMonth parentMonth;
  final DateTime dateTime;
  final MonthDay monthDay;

  DayDetails({
    required this.parentMonth,
    required this.dateTime,
  }) : monthDay = MonthDay.from(dateTime);
}

class DayWidget extends StatelessWidget {
  final DayDetails data;

  DayWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "${data.dateTime.day}",
        style: TextStyle(color: getColor()),
      ),
    );
  }

  Color? getColor() {
    final isSameMonthAsParent = data.parentMonth.month == data.dateTime.month;
    if (isSameMonthAsParent) {
      return data.dateTime.isWeekend ? Colors.red : null;
    } else {
      return Colors.grey;
    }
  }
}
