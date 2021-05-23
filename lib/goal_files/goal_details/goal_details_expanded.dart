import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/goal_files/goal_details/goal_widgets/montly_progress_chart.dart';
import 'package:laziless/goal_files/goal_details/goal_widgets/weekly_progress_chart.dart';

class GoalDetailsExpanded extends StatelessWidget {
  const GoalDetailsExpanded({
    Key key,
    this.goal,
  }) : super(key: key);
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 20, 0, 12),
          child: Row(
            children: <Widget>[
              Text(
                "Progress",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(goal.color)),
              )
            ],
          ),
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: WeeklyProgressChart(
              goal: goal,
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: MonthlyProgressChart(goal: goal),
          ),
        ),
      ],
    );
  }
}
