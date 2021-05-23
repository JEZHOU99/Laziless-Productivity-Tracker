import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/get_date.dart';
import 'package:intl/intl.dart';

class TotalTimeText extends StatelessWidget {
  const TotalTimeText({Key key, this.goals}) : super(key: key);
  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    goals.sort((a, b) => b.weeklySeconds.compareTo(a.weeklySeconds));

    Text totalTime = _getStatTextWidgets(goals)["Current Total Time"];
    Text previousTotalTime = _getStatTextWidgets(goals)["Previous Total Time"];
    Row percentageChange = _getStatTextWidgets(goals)["Percentage Change"];
    ListView goalOverview = _getStatTextWidgets(goals)["Goal Overview"];

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              "Weekly Stats",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        totalTime,
                        percentageChange,
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Last Week",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade400),
                        ),
                        previousTotalTime
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Center(child: goalOverview),
              ))
        ],
      ),
    );
  }

  _getStatTextWidgets(List<Goal> goals) {
    //Current Week Total Time
    int currentWeekTotal = _getWeekTotalTime(
      goals,
      0,
    );

    int currentHours = currentWeekTotal ~/ 3600;
    int currentMinutes = (currentWeekTotal ~/ 60) % 60;

    Text currentWeekTextWidget = Text("$currentHours hrs $currentMinutes mins",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey));

    //Previous Week Total Time
    int previousWeekTotal = _getWeekTotalTime(
      goals,
      1,
    );

    int previousHours = previousWeekTotal ~/ 3600;
    int previousMinutes = (previousWeekTotal ~/ 60) % 60;

    Text previousWeekTextWidget = Text(
        "$previousHours hrs $previousMinutes mins",
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade400));

    //Percentage Change
    double percentageChange = (currentWeekTotal / previousWeekTotal) - 1;
    Row percentageChangeWidget = Row(
      children: <Widget>[
        Icon(
          Icons.arrow_upward,
          size: 16,
          color: Colors.green,
        ),
        Text("${percentageChange.toStringAsFixed(1)}%",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.green))
      ],
    );

    if (percentageChange < 0) {
      percentageChangeWidget = Row(
        children: <Widget>[
          Icon(
            Icons.arrow_downward,
            size: 16,
            color: Colors.red,
          ),
          Text("${(percentageChange * -1).toStringAsFixed(1)}%",
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w400, color: Colors.red))
        ],
      );
    }

    // Percentage ListView
    ListView goalOverview = new ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: goals.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(goals[index].color)),
                ),
                SizedBox(width: 4),
                _timeText(goals[index], currentWeekTotal)
              ],
            ),
          );
        });

    return {
      "Current Total Time": currentWeekTextWidget,
      "Previous Total Time": previousWeekTextWidget,
      "Percentage Change": percentageChangeWidget,
      "Goal Overview": goalOverview
    };
  }

  _timeText(Goal goal, int currentWeekTotal) {
    int seconds = goal.weeklySeconds;
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    double percentageOfWeeklyTotal = (seconds / currentWeekTotal) * 100;

    if (hours == 0 && minutes == 0) {
      return Text(
        "${goal.name} - ${seconds}s (${percentageOfWeeklyTotal.toStringAsFixed(1)}%)",
        style: TextStyle(
          color: Color(goal.color),
        ),
      );
    } else if (hours == 0 && minutes != 0) {
      return Text(
        "${goal.name} - ${minutes}m (${percentageOfWeeklyTotal.toStringAsFixed(1)}%)",
        style: TextStyle(
          color: Color(goal.color),
        ),
      );
    }

    return Text(
      "${goal.name} - ${hours}h ${minutes}m (${percentageOfWeeklyTotal.toStringAsFixed(1)}%)",
      style: TextStyle(color: Color(goal.color)),
    );
  }

  //need this to calculate previous week too
  _getWeekTotalTime(List<Goal> goals, int week) {
    DateTime startDate = getstartDate(week);
    int totalSeconds = 0;
    goals.forEach((goal) {
      Map goalRecord = goal.recordHistory;

      for (int i = 0; i < 7; i++) {
        String dateString =
            DateFormat("MM-dd-yyyy").format(startDate.add(Duration(days: i)));
        Map dayRecord = goalRecord[dateString] ?? {};
        int daySeconds = dayRecord["Seconds"] ?? 0;
        totalSeconds += daySeconds;
      }
    });
    return totalSeconds;
  }
}
