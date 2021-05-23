import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';

class PlannedProgress extends StatelessWidget {
  const PlannedProgress({Key key, this.goal}) : super(key: key);
  final Goal goal;
  @override
  Widget build(BuildContext context) {
    double percentage = goal.weeklyPlan / goal.seconds;
    int difference = (goal.seconds - goal.weeklyPlan);
    int hours = difference < 0 ? (difference * -1) ~/ 3600 : difference ~/ 3600;
    int mins = difference < 0
        ? ((difference * -1) % 3600) ~/ 60
        : (difference % 3600) ~/ 60;

    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    difference < 0
                        ? Text(
                            "Extra",
                            style: TextStyle(
                                color: Color(goal.color),
                                fontWeight: FontWeight.w600),
                          )
                        : Text(
                            "Unplanned",
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600),
                          ),
                    Text(
                      "$hours hrs $mins mins",
                      style: TextStyle(
                          fontSize: 14,
                          color: difference < 0
                              ? Color(goal.color)
                              : Colors.grey.shade700),
                    )
                  ],
                ),
                Text(
                  "${(percentage * 100).toStringAsFixed(1)}%",
                  style: TextStyle(
                      color: percentage < 1
                          ? Colors.grey.shade700
                          : Color(goal.color),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: <Widget>[
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(child: child, opacity: animation);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      key: ValueKey<double>(percentage),
                      child: Container(
                          height: 60,
                          width: 250 * percentage,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(goal.color).withOpacity(0.2))),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(goal.color)),
                    ),
                    child: Text(
                      "${(goal.weeklyPlan / 3600).toStringAsFixed(1)} / ${(goal.seconds / 3600).toStringAsFixed(1)} h",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(goal.color)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
