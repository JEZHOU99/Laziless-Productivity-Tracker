/// Vertical bar chart with bar label renderer example.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/get_date.dart';

class WeekChart extends StatelessWidget {
  const WeekChart({Key key, this.goal}) : super(key: key);
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: generateWeek(context),
        ),
        Flexible(
          child: VerticalBarLabelChart(
            _convertRecordToData(goal),
            animate: true,
          ),
        ),
      ],
    );
  }

  static List<charts.Series<WeekData, String>> _convertRecordToData(Goal goal) {
    DateTime startDate = getstartDate(0);
    List<WeekData> goalData = [];
    List<WeekData> plannedData = [];

    // Real recording goal data
    for (int i = 0; i < 7; i++) {
      List<String> dayList = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      String dateString =
          DateFormat("MM-dd-yyyy").format(startDate.add(Duration(days: i)));
      Map dayRecord = goal.recordHistory[dateString];

      if (dayRecord != null && dayRecord["Plan"] != null) {
        int plannedSeconds = dayRecord["Plan"] ?? 0;
        int daySeconds = dayRecord["Seconds"] ?? 0;

        if (plannedSeconds > daySeconds) {
          plannedData
              .add(WeekData(dayList[i], (plannedSeconds - daySeconds) / 3600));
        } else if (plannedSeconds <= daySeconds) {
          plannedData.add(WeekData(dayList[i], 0));
        }
      } else {
        plannedData.add(WeekData(dayList[i], 0));
      }

      if (dayRecord != null && dayRecord["Seconds"] != null) {
        goalData.add(WeekData(dayList[i], dayRecord["Seconds"] / 3600));
      } else {
        goalData.add(WeekData(dayList[i], 0));
      }
    }

    return [
      new charts.Series<WeekData, String>(
        id: 'planned hours',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Colors.grey.withOpacity(0.2)),
        domainFn: (WeekData hours, _) => hours.day,
        measureFn: (WeekData hours, _) => hours.hours,
        data: plannedData,
      ),
      new charts.Series<WeekData, String>(
        id: 'hours',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Color(goal.color).withOpacity(0.4)),
        domainFn: (WeekData hours, _) => hours.day,
        measureFn: (WeekData hours, _) => hours.hours,
        data: goalData,
      ),
    ];
  }
}

class VerticalBarLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  VerticalBarLabelChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.stacked,

      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                // size in Pts.
                color: charts.ColorUtil.fromDartColor(
                    Theme.of(context).textSelectionColor),
              ),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                color: charts.ColorUtil.fromDartColor(
                    Theme.of(context).textSelectionColor),
              ))),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(

              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                color: charts.ColorUtil.fromDartColor(
                    Theme.of(context).textSelectionColor),
              ),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                color: charts.ColorUtil.fromDartColor(
                    Theme.of(context).textSelectionColor),
              ))),
    );
  }
}

/// Sample ordinal data type.
class WeekData {
  final String day;
  final double hours;

  WeekData(this.day, this.hours);
}

generateWeek(context) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          DateFormat("dd/MM").format(getstartDate(0)),
          style: TextStyle(
              color: Theme.of(context).textSelectionColor, fontSize: 12),
        ),
        Text(
          DateFormat("dd/MM").format(getendDate(0)),
          style: TextStyle(
              color: Theme.of(context).textSelectionColor, fontSize: 12),
        )
      ]);
}
