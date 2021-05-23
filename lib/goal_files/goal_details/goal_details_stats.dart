import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laziless/data/models.dart';

class GoalDetailsStats extends StatelessWidget {
  const GoalDetailsStats({Key key, this.goal}) : super(key: key);
  final Goal goal;
  @override
  Widget build(BuildContext context) {
    int currentStreak = getCurrentStreak(goal.recordHistory);
    int shortestSession =
        getShortestSession(goal.recordHistory)["Shortest Session"];
    String shortestSessionDate =
        getShortestSession(goal.recordHistory)["Shortest Session Date"];
    int longestSession =
        getLongestSession(goal.recordHistory)["Longest Session"];
    String longestSessionDate =
        getLongestSession(goal.recordHistory)["Longest Session Date"];
    int bestStreak = getBestStreak(goal.recordHistory, goal)["Best Streak"];
    String bestStreakStartDate =
        getBestStreak(goal.recordHistory, goal)["Start Date"];
    String bestStreakEndDate =
        getBestStreak(goal.recordHistory, goal)["End Date"];

    getBestStreak(goal.recordHistory, goal);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
            child: Row(
              children: <Widget>[
                Text(
                  "Highlights",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(goal.color)),
                )
              ],
            ),
          ),
          Flexible(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                ListTile(
                  title: Text("Creation Date"),
                  subtitle: Text("Goal made"),
                  trailing: Text(
                    DateFormat("dd/MM/yyyy").format(goal.startDate.toDate()),
                    style: TextStyle(
                        color: Color(goal.color), fontWeight: FontWeight.w600),
                  ),
                ),
                ListTile(
                  title: Text("Current Streak"),
                  subtitle: Text("Days in a row"),
                  trailing: trailingStreak(currentStreak, goal),
                ),
                ListTile(
                  title: Text("Best Streak"),
                  subtitle: bestStreakSubtitle(
                      bestStreakStartDate, bestStreakEndDate),
                  trailing: trailingStreak(bestStreak, goal),
                ),
                ListTile(
                  title: Text("Longest Day"),
                  subtitle: Text(longestSessionDate),
                  trailing: trailingTime(longestSession, goal),
                ),
                ListTile(
                  title: Text("Shortest Day"),
                  subtitle: Text(shortestSessionDate),
                  trailing: trailingTime(shortestSession, goal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

int getCurrentStreak(Map records) {
  bool continueStreak = true;
  int currentStreak = 0;

// Getting the current streak
  while (continueStreak) {
    String date = DateFormat("MM-dd-yyyy")
        .format(DateTime.now().subtract(Duration(days: currentStreak + 1)));

    Map dayRecord = records[date] ?? {};
    if (dayRecord["Seconds"] != null) {
      currentStreak += 1;
    } else {
      continueStreak = false;
    }
  }

  if (records[DateFormat("MM-dd-yyyy").format(DateTime.now())] != null) {
    currentStreak += 1;
  }

  return currentStreak;
}

Map getShortestSession(Map records) {
  int shortestSession = 0;
  String shortestSessionDate = "None Recorded";
  records.forEach((date, record) {
    Map dayRecord = record;

    if (dayRecord.containsKey("Seconds")) {
      if (((dayRecord["Seconds"] ?? 0) < shortestSession) ||
          shortestSession == 0) {
        shortestSession = dayRecord["Seconds"];
        shortestSessionDate = date;
      }
    }
  });

  if (shortestSessionDate != "") {
    shortestSessionDate = formatDateString(shortestSessionDate);
  }

  return {
    "Shortest Session": shortestSession,
    "Shortest Session Date": shortestSessionDate
  };
}

Map getLongestSession(Map records) {
  int longestSession = 0;
  String longestSessionDate = "None Recorded";

  records.forEach((date, record) {
    Map dayRecord = record;
    if (dayRecord.containsKey("Seconds")) {
      if ((dayRecord["Seconds"] ?? 0) > longestSession) {
        longestSession = dayRecord["Seconds"];
        longestSessionDate = date;
      }
    }
  });

  if (longestSessionDate != "") {
    longestSessionDate = formatDateString(longestSessionDate);
  }

  return {
    "Longest Session": longestSession,
    "Longest Session Date": longestSessionDate
  };
}

getBestStreak(Map records, Goal goal) {
  bool continueBestStreak = true;
  int bestStreak = 0;
  String bestStreakStart = "";
  String bestStreakEnd = "";
  int testStreak = 0;
  String testStreakStart = "";
  DateTime creationDate = goal.startDate.toDate();
  int daysSinceCreation = 0;
  DateTime today = DateTime.now().add(Duration(days: 1));

  while (continueBestStreak) {
    String date = DateFormat("MM-dd-yyyy")
        .format(creationDate.add(Duration(days: daysSinceCreation)));
    Map dayRecord = records[date] ?? {};
    int daySeconds = dayRecord["Seconds"] ?? 0;

    if ((daySeconds ?? 0) > 0) {
      if (testStreak == 0) {
        testStreakStart = date;
      }
      testStreak += 1;
    } else {
      if ((testStreak ?? 0) > bestStreak) {
        bestStreak = testStreak;
        bestStreakStart = testStreakStart;
        bestStreakEnd = DateFormat("MM-dd-yyyy")
            .format(creationDate.add(Duration(days: daysSinceCreation - 1)));
      }
      testStreak = 0;
    }
    daysSinceCreation += 1;

    if (date == DateFormat("MM-dd-yyyy").format(today.add(Duration(days: 1)))) {
      continueBestStreak = false;
    }
  }

  if (bestStreakStart != "") {
    bestStreakStart = formatDateString(bestStreakStart);
  }
  if (bestStreakEnd != "") {
    bestStreakEnd = formatDateString(bestStreakEnd);
  }

  return {
    "Best Streak": bestStreak,
    "Start Date": bestStreakStart,
    "End Date": bestStreakEnd
  };
}

formatDateString(String date) {
  String day = date.substring(3, 5);
  String month = date.substring(0, 2);
  String year = date.substring(6);
  String newDate = "$day/$month/$year";

  return newDate;
}

trailingTime(seconds, Goal goal) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds ~/ 60) % 60;
  int remainingSeconds = seconds % 60;

  if ((hours ?? 0) > 0) {
    return Text(
      "$hours h $minutes m",
      style: TextStyle(color: Color(goal.color), fontWeight: FontWeight.w600),
    );
  } else {
    return Text(
      "$minutes m $remainingSeconds s",
      style: TextStyle(color: Color(goal.color), fontWeight: FontWeight.w600),
    );
  }
}

trailingStreak(days, Goal goal) {
  if (days == 0) {
    return Text(
      "0 days",
      style: TextStyle(color: Color(goal.color), fontWeight: FontWeight.w600),
    );
  } else if (days == 1) {
    return (Text(
      "1 day",
      style: TextStyle(color: Color(goal.color), fontWeight: FontWeight.w600),
    ));
  } else {
    return (Text(
      "$days days",
      style: TextStyle(color: Color(goal.color), fontWeight: FontWeight.w600),
    ));
  }
}

bestStreakSubtitle(start, end) {
  if (start == "" || end == "") {
    return Text("None Recorded");
  } else {
    return Text("$start - $end");
  }
}
