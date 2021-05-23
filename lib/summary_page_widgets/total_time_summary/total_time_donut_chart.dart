/// Vertical bar chart with bar label renderer example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/get_date.dart';

class TotalTimePieChart extends StatelessWidget {
  const TotalTimePieChart({Key key, this.goals}) : super(key: key);
  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: DonutPieChart(
            _convertRecordToData(goals),
            animate: true,
          ),
        ),
      ],
    );
  }

  static List<charts.Series<WeekData, String>> _convertRecordToData(
      List<Goal> goals) {
    DateTime startDate = getstartDate(0);
    List<WeekData> data = [];

    goals.forEach((goal) {
      Map goalRecord = goal.recordHistory;
      int totalSeconds = 0;
      for (int i = 0; i < 7; i++) {
        String dateString =
            DateFormat("MM-dd-yyyy").format(startDate.add(Duration(days: i)));
        Map dayRecord = goalRecord[dateString] ?? {};
        int daySeconds = dayRecord["Seconds"] ?? 0;
        totalSeconds += daySeconds;
      }
      data.add(WeekData(goal.name, totalSeconds / 3600, goal.color));
    });

    return [
      new charts.Series<WeekData, String>(
        id: 'Weekly Profress',
        colorFn: (WeekData week, __) =>
            charts.ColorUtil.fromDartColor(Color(week.colorHex)),
        domainFn: (WeekData week, _) => week.name,
        measureFn: (WeekData week, _) => week.hours,
        data: data,
      )
    ];
  }
}

class DonutPieChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DonutPieChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
    );
  }
}

/// Sample ordinal data type.
class WeekData {
  final String name;
  final double hours;
  final int colorHex;

  WeekData(this.name, this.hours, this.colorHex);
}
