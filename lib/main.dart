import 'package:calendar_widget/calendar_widget.dart';
import 'package:flutter/material.dart';

import 'date_time/week_of_year.dart';
import 'date_time/year_month.dart';
import 'day_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: SafeArea(
          child: CalendarWidget(
            startingDate: DateTime(2021, 1),
            weekNumberWidgetBuilder:
                (BuildContext context, WeekDetails weekDetails) {
              final BorderRadius borderRadius;
              if (weekDetails.weekOfMonth == 1) {
                borderRadius = BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8));
              } else if (weekDetails.weekOfMonth ==
                  weekDetails.parent.weeks.length) {
                borderRadius = BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8));
              } else {
                borderRadius = BorderRadius.zero;
              }

              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[500], borderRadius: borderRadius),
                child: Text(
                  "${weekDetails.weekOfYear.weekNumber}",
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
            monthHeaderBuilder: (BuildContext context, YearMonth yearMonth) {
              return Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Text("$yearMonth"),
              );
            },
            dayWidgetBuilder: (BuildContext context, DayDetails details) {
              return Container(child: DayWidget(data: details));
            },
            calendarData: CalendarConfigurationData(showWeekNumbers: true),
          ),
        ),
      ),
    );
  }
}
