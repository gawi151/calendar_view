import 'calendar_view.dart';
import 'day_widget.dart';
import 'week_of_year_widget.dart';
import 'package:flutter/widgets.dart';

class WeekWidget extends StatelessWidget {
  final WeekDetails data;

  WeekWidget({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _createWeekDays(context),
    );
  }

  List<Widget> _createWeekDays(BuildContext context) {
    final dayWidgets = data.weekDays
        .map(
          (date) => Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: DayWidget(
                data: DayDetails(parentMonth: data.parent, dateTime: date),
              ),
            ),
          ),
        )
        .toList();
    if (CalendarConfiguration.of(context).showWeekNumbers) {
      dayWidgets.insert(
        0,
        Expanded(
          child: WeekOfYearWidget(weekOfYear: data.weekOfYear),
        ),
      );
    }

    return dayWidgets.toList(growable: false);
  }
}
