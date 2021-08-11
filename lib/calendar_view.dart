import 'date_time/week_of_year.dart';
import 'date_time/year_month.dart';
import 'day_widget.dart';
import 'week_of_year_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'date_time/date_time_extensions.dart';

typedef DayWidgetBuilder = Widget Function(
    BuildContext context, DayDetails details);
typedef WeekNumberWidgetBuilder = Widget Function(
    BuildContext context, WeekDetails weekDetails);
typedef MonthHeaderBuilder = Widget Function(
    BuildContext context, YearMonth yearMonth);
typedef MonthFooterBuilder = Widget Function(
    BuildContext context, YearMonth yearMonth);

final _defaultWeekNumberWidgetBuilder =
    (BuildContext context, WeekDetails weekDetails) =>
        WeekOfYearWidget(weekOfYear: weekDetails.weekOfYear);

enum DayOfWeek {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday
}

typedef WeekWidgetBuilder = Widget Function(
    WeekDetails details, List<Widget> dayWidgets);

class WeekDetails {
  final WeekOfYear weekOfYear;
  final YearMonth parent;
  final int weekOfMonth; // starts from 1
  final List<DateTime> _weekDays = [];

  WeekDetails(
      {required this.parent,
      required this.weekOfYear,
      required this.weekOfMonth});

  List<DateTime> get weekDays {
    if (_weekDays.isEmpty) {
      _weekDays.addAll(List.generate(
        DateTime.daysPerWeek,
        (index) => weekOfYear.firstDateOfWeek.addDays(index),
      ));
    }
    return _weekDays;
  }
}

class CalendarConfiguration extends InheritedWidget {
  final CalendarConfigurationData calendarData;

  CalendarConfiguration({
    Key? key,
    required this.calendarData,
    required Widget child,
  }) : super(key: key, child: child);

  static CalendarConfigurationData of(BuildContext context) {
    final CalendarConfiguration? result =
        context.dependOnInheritedWidgetOfExactType<CalendarConfiguration>();
    assert(result != null,
        'No CalendarConfiguration available in context. Check tree hierarchy.');
    return result!.calendarData;
  }

  @override
  bool updateShouldNotify(CalendarConfiguration oldWidget) {
    return oldWidget.calendarData != calendarData;
  }
}

class CalendarConfigurationData {
  final bool showWeekNumbers;
  final DayOfWeek firstDayOfWeek;
  final DateTime minDate;
  final DateTime maxDate;

  CalendarConfigurationData({
    this.showWeekNumbers = false,
    this.firstDayOfWeek = DayOfWeek.Monday,
    DateTime? minDate,
    DateTime? maxDate,
  })  : this.minDate = minDate ?? DateTime(1970, 1, 1),
        this.maxDate = maxDate ?? DateTime(2099, 12, 31);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarConfigurationData &&
          runtimeType == other.runtimeType &&
          showWeekNumbers == other.showWeekNumbers &&
          firstDayOfWeek == other.firstDayOfWeek;

  @override
  int get hashCode => showWeekNumbers.hashCode ^ firstDayOfWeek.hashCode;
}

class CalendarWidget extends StatefulWidget {
  final DateTime startingDate;
  final DayWidgetBuilder dayWidgetBuilder;
  final WeekNumberWidgetBuilder weekNumberWidgetBuilder;
  final CalendarConfigurationData calendarData;

  final MonthHeaderBuilder? monthHeaderBuilder;
  final MonthFooterBuilder? monthFooterBuilder;

  CalendarWidget({
    Key? key,
    this.monthHeaderBuilder,
    this.monthFooterBuilder,
    DateTime? startingDate,
    DayWidgetBuilder? dayWidgetBuilder,
    WeekNumberWidgetBuilder? weekNumberWidgetBuilder,
    CalendarConfigurationData? calendarData,
  })  : this.dayWidgetBuilder = dayWidgetBuilder ?? _defaultDayWidgetBuilder,
        this.weekNumberWidgetBuilder =
            weekNumberWidgetBuilder ?? _defaultWeekNumberWidgetBuilder,
        this.startingDate = startingDate ?? DateTime.now(),
        this.calendarData = calendarData ?? CalendarConfigurationData(),
        super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

final _defaultDayWidgetBuilder =
    (BuildContext context, DayDetails details) => DayWidget(data: details);

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = widget.startingDate;
  }

  @override
  Widget build(BuildContext context) {
    return CalendarConfiguration(
      calendarData: widget.calendarData,
      child: PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          final currentMonth = currentDate.addMonths(index);
          final currentYearMonth = currentMonth.yearMonth;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.monthHeaderBuilder != null)
                widget.monthHeaderBuilder!(context, currentYearMonth),
              _buildMonth(context, currentYearMonth),
              if (widget.monthFooterBuilder != null)
                widget.monthFooterBuilder!(context, currentYearMonth),
            ],
          );
        },
        pageSnapping: true,
        allowImplicitScrolling: true,
        controller: PageController(),
        physics: PageScrollPhysics(),
      ),
    );
  }

  Widget _buildMonth(BuildContext context, YearMonth yearMonth) {
    int columnsCount = DateTime.daysPerWeek;
    if (CalendarConfiguration.of(context).showWeekNumbers) {
      columnsCount++;
    }
    final days = yearMonth.weeks
        .asMap()
        .map((index, weekOfYear) {
          final weekWidgets = _buildWeek(
            context,
            WeekDetails(
                parent: yearMonth,
                weekOfYear: weekOfYear,
                weekOfMonth: index + 1),
          );
          assert(weekWidgets.length == columnsCount);
          return MapEntry(index, weekWidgets);
        })
        .values
        .expand((element) => element)
        .toList(growable: false);

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: columnsCount,
      children: days,
    );
  }

  List<Widget> _buildWeek(BuildContext context, WeekDetails weekDetails) {
    final weekDaysWidgets = <Widget>[];
    if (CalendarConfiguration.of(context).showWeekNumbers) {
      final weekNumberWidget =
          widget.weekNumberWidgetBuilder(context, weekDetails);
      weekDaysWidgets.add(weekNumberWidget);
    }

    for (var date in weekDetails.weekDays) {
      final dayWidget = widget.dayWidgetBuilder(
        context,
        DayDetails(parentMonth: weekDetails.parent, dateTime: date),
      );
      weekDaysWidgets.add(dayWidget);
    }

    return weekDaysWidgets;
  }
}
