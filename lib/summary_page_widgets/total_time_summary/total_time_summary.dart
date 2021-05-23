import 'package:flutter/material.dart';
import 'package:laziless/summary_page_widgets/total_time_summary/total_time_donut_chart.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/summary_page_widgets/total_time_summary/total_time_text.dart';

class TotalTimeSummary extends StatelessWidget {
  const TotalTimeSummary({Key key, this.goals}) : super(key: key);
  final List<Goal> goals;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TotalTimePieChart(
              goals: goals,
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: TotalTimeText(
              goals: goals,
            ))
      ],
    );
  }
}
