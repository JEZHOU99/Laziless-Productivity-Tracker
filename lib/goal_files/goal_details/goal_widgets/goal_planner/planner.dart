import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/goal_files/goal_details/goal_widgets/goal_planner/planner_pop_up.dart';
import 'package:laziless/services/dark_theme.dart';
import 'package:laziless/services/fade_in_animation.dart';
import 'package:laziless/services/get_date.dart';
import 'package:provider/provider.dart';

class GoalPlanner extends StatelessWidget {
  const GoalPlanner({Key key, this.goal}) : super(key: key);
  final Goal goal;
  @override
  Widget build(BuildContext context) {
    int difference = (goal.seconds - goal.weeklyPlan);
    int hours = difference < 0 ? (difference * -1) ~/ 3600 : difference ~/ 3600;
    int mins = difference < 0
        ? ((difference * -1) % 3600) ~/ 60
        : (difference % 3600) ~/ 60;
    List<DateTime> dates = getDates();
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Plan",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(goal.color)),
              ),
              Text(
                difference < 0
                    ? "${hours}h ${mins}m over goal"
                    : "${hours}h ${mins}m until goal",
                style: TextStyle(
                    fontSize: 14,
                    color: difference < 0
                        ? Color(goal.color)
                        : Colors.grey.shade700),
              )
            ],
          ),
        ),
        DailyPlanner(
          day: dates[0],
          goal: goal,
        ),
        DailyPlanner(
          day: dates[1],
          goal: goal,
        ),
        DailyPlanner(
          goal: goal,
          day: dates[2],
        ),
        DailyPlanner(
          day: dates[3],
          goal: goal,
        ),
        DailyPlanner(
          goal: goal,
          day: dates[4],
        ),
        DailyPlanner(
          goal: goal,
          day: dates[5],
        ),
        DailyPlanner(
          goal: goal,
          day: dates[6],
        )
      ],
    );
  }
}

class DailyPlanner extends StatelessWidget {
  const DailyPlanner({Key key, this.day, this.goal}) : super(key: key);
  final DateTime day;
  final Goal goal;
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    DateTime now = DateTime.now();
    int weekDayInt = day.weekday;
    int plannedSeconds = getPlannedSeconds(day, goal);
    double percentage = plannedSeconds / goal.seconds;
    int hours = plannedSeconds ~/ 3600;
    int mins = (plannedSeconds % 3600) ~/ 60;

    return Flexible(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            OpacityIn(
              delay: 1,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(child: child, opacity: animation);
                },
                child: Align(
                  key: ValueKey<double>(percentage),
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 300 * percentage,
                    decoration: BoxDecoration(
                      color: day.isBefore(now.subtract(Duration(days: 1)))
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                openNewGoalPopUp(context, goal, day, plannedSeconds);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(getWeekDay(weekDayInt),
                              style: themeChange.darkTheme
                                  ? TextStyle(
                                      color: day.isBefore(
                                              now.subtract(Duration(days: 1)))
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade400)
                                  : TextStyle(
                                      color: day.isBefore(
                                              now.subtract(Duration(days: 1)))
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade700)),
                          Text(
                              plannedSeconds > 0
                                  ? "$hours h $mins m"
                                  : "No Plans",
                              style: themeChange.darkTheme
                                  ? TextStyle(
                                      fontSize: 12,
                                      color: day.isBefore(
                                              now.subtract(Duration(days: 1)))
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade400)
                                  : TextStyle(
                                      fontSize: 12,
                                      color: day.isBefore(
                                              now.subtract(Duration(days: 1)))
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int getPlannedSeconds(DateTime day, Goal goal) {
  String date = DateFormat("MM-dd-yyyy").format(day);
  Map records = goal.recordHistory;

  Map dayRecord = records[date] ?? {};
  int plannedSeconds = dayRecord["Plan"] ?? 0;
  return plannedSeconds;
}

getDates() {
  List<DateTime> dates = [];
  DateTime weekStart = getstartDate(0);
  for (var i = 0; i < 7; i++) {
    dates.add(weekStart.add(Duration(days: i)));
  }
  return dates;
}

openNewGoalPopUp(context, Goal goal, DateTime day, int seconds) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: PlanPopUp(
              goal: goal,
              day: day,
              seconds: seconds,
            ));
      });
}
