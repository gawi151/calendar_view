import 'date_time/week_of_year.dart';
import 'package:flutter/widgets.dart';

class WeekOfYearWidget extends StatefulWidget {
  final WeekOfYear weekOfYear;

  WeekOfYearWidget({Key? key, required this.weekOfYear}) : super(key: key);

  @override
  _WeekOfYearWidgetState createState() => _WeekOfYearWidgetState();
}

class _WeekOfYearWidgetState extends State<WeekOfYearWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "${widget.weekOfYear.weekNumber}",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
