/// Example of an ordinal combo chart with two series rendered as bars, and a
/// third rendered as a line.
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/get_date.dart';

class WeeklyProgressChart extends StatelessWidget {
  const WeeklyProgressChart({Key key, this.goal}) : super(key: key);
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Hours per Week",
          style: TextStyle(color: Theme.of(context).textSelectionColor),
        ),
        Flexible(
          child: OrdinalComboBarLineChart(
            _convertRecordToData(goal),
            animate: true,
          ),
        ),
      ],
    );
  }

  static List<charts.Series<WeekData, String>> _convertRecordToData(Goal goal) {
    DateTime startDate = getstartDate(0);
    List<WeekData> weekData = [];
    List<WeekData> goalData = [];

    for (int i = 0; i < 6; i++) {
      DateTime startDateCopy = startDate.subtract(Duration(days: i * 7));
      String startDateString = DateFormat("dd/MM").format(startDateCopy);
      int weeklySeconds = 0;

      for (int i = 0; i < 7; i++) {
        String dateString = DateFormat("MM-dd-yyyy")
            .format(startDateCopy.add(Duration(days: i)));
        Map dayRecord = goal.recordHistory[dateString];

        if (dayRecord != null && dayRecord["Goal"] != null) {
          weeklySeconds += dayRecord["Seconds"] ?? 0;
        }
      }

      weekData.add(WeekData(startDateString, weeklySeconds / 3600));
    }

    weekData = weekData.reversed.toList();

    // Generating data for Goal Line Graph
    for (int i = 0; i < 6; i++) {
      DateTime startDateCopy = startDate.subtract(Duration(days: i * 7));
      String startDateString = DateFormat("dd/MM").format(startDateCopy);
      int weekGoalTotal = 0;
      int numberOfDays = 0;

      for (int i = 0; i < 7; i++) {
        String dateString = DateFormat("MM-dd-yyyy")
            .format(startDateCopy.add(Duration(days: i)));
        Map dayRecord = goal.recordHistory[dateString];

        if (dayRecord != null && dayRecord["Goal"] != null) {
          weekGoalTotal += dayRecord["Goal"] ?? 0;
          numberOfDays += 1;
        }
      }

      double weekGoalAverage = (weekGoalTotal / numberOfDays) / 3600;

      if (weekGoalAverage >= 0) {
        goalData.add(WeekData(startDateString, weekGoalAverage));
      } else {
        goalData.add(WeekData(startDateString, 0));
      }
    }

    goalData = goalData.reversed.toList();

    return [
      new charts.Series<WeekData, String>(
        id: 'Weekly Hours',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Color(goal.color).withOpacity(0.2)),
        domainFn: (WeekData weeklyHours, _) => weeklyHours.mondayDate,
        measureFn: (WeekData weeklyHours, _) => weeklyHours.weeklyHours,
        data: weekData,
      ),
      new charts.Series<WeekData, String>(
          id: 'Goals',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(goal.color)),
          domainFn: (WeekData goals, _) => goals.mondayDate,
          measureFn: (WeekData goals, _) => goals.weeklyHours,
          data: goalData)
        // Configure our custom line renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }
}

class OrdinalComboBarLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  OrdinalComboBarLineChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.OrdinalComboChart(
      seriesList,
      animate: animate,
      // Configure the default renderer as a bar renderer.
      defaultRenderer: new charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped),
      // Custom renderer configuration for the line series. This will be used for
      // any series that does not define a rendererIdKey.
      customSeriesRenderers: [
        new charts.LineRendererConfig(
            // ID used to link series to this renderer.
            customRendererId: 'customLine')
      ],
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
  final String mondayDate;
  final double weeklyHours;

  WeekData(this.mondayDate, this.weeklyHours);
}
