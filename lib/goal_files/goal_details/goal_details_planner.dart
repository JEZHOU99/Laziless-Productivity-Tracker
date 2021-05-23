import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/goal_files/goal_details/goal_details_notifications.dart';
import 'package:laziless/goal_files/goal_details/goal_widgets/goal_planner/planner.dart';

class GoalDetailsPlanner extends StatelessWidget {
  const GoalDetailsPlanner({Key key, this.goal}) : super(key: key);
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: GoalPlanner(
                goal: goal,
              ),
            )),
        Expanded(
          flex: 5,
          child: Center(child: GoalDetailsNotifications(goal: goal)),
        ),
      ],
    );
  }
}
