import 'package:flutter/material.dart';
import 'package:laziless/summary_page_widgets/daily_average_summary/daily_average_donut_chart.dart';
import 'package:laziless/summary_page_widgets/daily_average_summary/daily_average_text.dart';
import 'package:laziless/data/models.dart';

class DailyAverageSummary extends StatelessWidget {
  const DailyAverageSummary({Key key, this.goals}) : super(key: key);
  final List<Goal> goals;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DailyAveragePieChart(goals: goals)),
        ),
        Expanded(
            flex: 1,
            child: DailyAverageText(
              goals: goals,
            ))
      ],
    );
  }
}
