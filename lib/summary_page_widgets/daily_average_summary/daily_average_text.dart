import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/get_date.dart';
import 'package:intl/intl.dart';

class DailyAverageText extends StatelessWidget {
  const DailyAverageText({Key key, this.goals}) : super(key: key);
  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    goals.sort((a, b) => b.dailySeconds.compareTo(a.dailySeconds));
    Text todaysData = _getStatTextWidgets(goals)["Today's Data"];
    Text thisWeeksAverage = _getStatTextWidgets(goals)["This Week's Average"];
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
              "Today's Stats",
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
                        todaysData,
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
                          "Average Hours / Day",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade400),
                        ),
                        thisWeeksAverage
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
                child: Align(alignment: Alignment.center, child: goalOverview),
              ))
        ],
      ),
    );
  }

  _getStatTextWidgets(List<Goal> goals) {
    int daysThisWeek = DateTime.now()
        .add(Duration(seconds: 5))
        .difference(getstartDate(0))
        .inDays;
    if (daysThisWeek == 0) {
      daysThisWeek = 1;
    }

    //Today's Data
    int todaysSeconds = _getTodaysSeconds(goals);
    int todaysHours = todaysSeconds ~/ 3600;
    int todaysMinutes = (todaysSeconds ~/ 60) % 60;
    Text todaysDataWidget = Text("$todaysHours hrs $todaysMinutes mins",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey));

    //This Week's Average Hours Per Week
    int currentWeekAverage = _getWeekDataUpUntilNow(
          goals,
          0,
        ) ~/
        daysThisWeek;
    int hoursPerDay = currentWeekAverage ~/ 3600;
    int minutesPerDay = (currentWeekAverage ~/ 60) % 60;

    Text thisWeeksAverage = Text("$hoursPerDay hrs $minutesPerDay mins",
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade400));

    //Percentage Change
    double percentageChange = ((todaysSeconds / currentWeekAverage) - 1) * 100;
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
                _timeText(goals[index], todaysSeconds)
              ],
            ),
          );
        });

    return {
      "Today's Data": todaysDataWidget,
      "This Week's Average": thisWeeksAverage,
      "Percentage Change": percentageChangeWidget,
      "Goal Overview": goalOverview
    };
  }

  _timeText(Goal goal, int todaysSeconds) {
    int seconds = goal.dailySeconds;
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    double percentageOfWeeklyTotal = (seconds / todaysSeconds) * 100;

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

  _getWeekDataUpUntilNow(List<Goal> goals, int week) {
    DateTime startDate = getstartDate(week);

    int totalSeconds = 0;
    goals.forEach((goal) {
      Map goalRecord = goal.recordHistory;
      int previousDaysInWeek = DateTime.now().difference(startDate).inDays;

      for (int i = 0; i < previousDaysInWeek; i++) {
        String dateString =
            DateFormat("MM-dd-yyyy").format(startDate.add(Duration(days: i)));
        Map dayRecord = goalRecord[dateString] ?? {};
        int daySeconds = dayRecord["Seconds"] ?? 0;
        totalSeconds += daySeconds;
      }
    });

    return totalSeconds;
  }

  _getTodaysSeconds(List<Goal> goals) {
    int totalSeconds = 0;
    goals.forEach((goal) {
      totalSeconds += goal.dailySeconds;
    });

    return totalSeconds;
  }
}
