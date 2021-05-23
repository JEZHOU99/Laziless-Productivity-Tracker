import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/goal_files/goal_details/goal_widgets/feedback.dart';
import 'package:laziless/goal_files/goal_details/goal_widgets/progress_bar.dart';
import 'package:laziless/goal_files/goal_details/goal_widgets/week_chart.dart';

class GoalDetailsOverview extends StatelessWidget {
  const GoalDetailsOverview({
    Key key,
    this.goal,
  }) : super(key: key);
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: WeekChart(
              goal: goal,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ProgressBar(goal: goal),
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FeedBack(goal: goal),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }
}
