/// Example of an ordinal combo chart with two series rendered as bars, and a
/// third rendered as a line.
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/get_date.dart';

class MonthlyProgressChart extends StatelessWidget {
  const MonthlyProgressChart({Key key, this.goal}) : super(key: key);
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          "Hours per Month",
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

  static List<charts.Series<MonthData, String>> _convertRecordToData(
      Goal goal) {
    List<MonthData> monthData = [];
    List<MonthData> goalData = [];

    for (int i = 0; i < 12; i++) {
      DateTime startDate = getFirstDayOfMonth(i);
      DateTime endDate = getEndDayOfMonth(i);
      int numberOfDaysInMonth = endDate.difference(startDate).inDays + 1;

      String startDateString = DateFormat("MM").format(startDate);
      int monthlySeconds = 0;

      for (int i = 0; i < numberOfDaysInMonth; i++) {
        String dateString =
            DateFormat("MM-dd-yyyy").format(startDate.add(Duration(days: i)));
        Map dayRecord = goal.recordHistory[dateString];

        if (dayRecord != null && dayRecord["Goal"] != null) {
          monthlySeconds += dayRecord["Seconds"] ?? 0;
        }
      }

      monthData.add(MonthData(startDateString, (monthlySeconds / 3600)));
    }
    monthData = monthData.reversed.toList();

    // Generating data for Goal Line Graph
    for (int i = 0; i < 12; i++) {
      DateTime startDate = getFirstDayOfMonth(i);
      DateTime endDate = getEndDayOfMonth(i);
      int numberOfDaysInMonth = endDate.difference(startDate).inDays + 1;

      String startDateString = DateFormat("MM").format(startDate);
      int monthGoalTotal = 0;
      int numberOfDays = 0;

      for (int i = 0; i < numberOfDaysInMonth; i++) {
        String dateString =
            DateFormat("MM-dd-yyyy").format(startDate.add(Duration(days: i)));
        Map dayRecord = goal.recordHistory[dateString];

        if (dayRecord != null && dayRecord["Goal"] != null) {
          monthGoalTotal += dayRecord["Goal"] ?? 0;
          numberOfDays += 1;
        }
      }

      double monthGoalAverage = (monthGoalTotal / numberOfDays) / 3600;

      if (monthGoalAverage >= 0) {
        goalData.add(MonthData(
            startDateString, monthGoalAverage * (numberOfDaysInMonth / 7)));
      } else {
        goalData.add(MonthData(startDateString, 0));
      }
    }
    goalData = goalData.reversed.toList();

    return [
      new charts.Series<MonthData, String>(
        id: 'Monthly Hours',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Color(goal.color).withOpacity(0.2)),
        domainFn: (MonthData monthlyHours, _) => monthlyHours.startDate,
        measureFn: (MonthData monthlyHours, _) => monthlyHours.monthlyHours,
        data: monthData,
      ),
      new charts.Series<MonthData, String>(
          id: 'Goals',
          colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(goal.color)),
          domainFn: (MonthData goals, _) => goals.startDate,
          measureFn: (MonthData goals, _) => goals.monthlyHours,
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
class MonthData {
  final String startDate;
  final double monthlyHours;

  MonthData(this.startDate, this.monthlyHours);
}
