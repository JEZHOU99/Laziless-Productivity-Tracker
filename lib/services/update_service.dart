import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/local_notifications_helper.dart';
import 'database.dart';
import 'package:intl/intl.dart';
import 'package:laziless/services/get_date.dart';

addGoalService(
    FirebaseUser user, int goalSeconds, String activity, int colorHex) async {
  DatabaseService(uid: user.uid)
      .notificationCollection
      .document(user.uid)
      .setData({
    "$activity": {},
    "Goals": FieldValue.arrayUnion([activity])
  }, merge: true);

  final snapshot = await DatabaseService(uid: user.uid)
      .goalCollection
      .document(user.uid)
      .get();

  int goalIDS = snapshot.data["Goal IDS"] ?? 1;

  List<dynamic> deceasedIDS = snapshot.data["Deceased IDS"] ?? [];

  if (deceasedIDS.length > 0) {
    goalIDS = deceasedIDS[0];
    List<dynamic> mutableDeceasedIDS = deceasedIDS.toList();

    mutableDeceasedIDS.removeAt(0);

    DatabaseService(uid: user.uid).goalCollection.document(user.uid).setData({
      "$activity": {
        "Goal ID": goalIDS,
        "Goal Seconds": goalSeconds,
        "colorHex": colorHex,
        "Start Date": DateTime.now()
      },
      "Goals": FieldValue.arrayUnion([activity]),
      "Deceased IDS": mutableDeceasedIDS
    }, merge: true);
  } else {
    DatabaseService(uid: user.uid).goalCollection.document(user.uid).setData({
      "$activity": {
        "Goal ID": goalIDS,
        "Goal Seconds": goalSeconds,
        "colorHex": colorHex,
        "Start Date": DateTime.now()
      },
      "Goals": FieldValue.arrayUnion([activity]),
      "Goal IDS": goalIDS + 1
    }, merge: true);
  }
}

editGoalService(
    FirebaseUser user,
    String previousActivity,
    String newActivity,
    int colorHex,
    int goalSeconds,
    Goal prevGoal,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  DateTime now = DateTime.now();
  int yearint = now.year;

//Cancel notifications for this goal
  cancelNotifications(flutterLocalNotificationsPlugin, id: prevGoal.id);

//Set New Notifications under new goal name

  if (prevGoal.notificationTime != "" && prevGoal.notificationTime != null) {
    int hour = int.parse(prevGoal.notificationTime.substring(0, 2));
    int minute = int.parse(prevGoal.notificationTime.substring(3, 5));
    Time formattedTime = Time(hour, minute, 0);

    setNotifications(flutterLocalNotificationsPlugin,
        formattedTime: formattedTime,
        frequency: prevGoal.notificationFrequency,
        goalID: prevGoal.id,
        notificationsOn: prevGoal.notificationOn,
        goalName: newActivity,
        reminderDays: prevGoal.notificationDays);
  }

//updating Goal Data
  DatabaseService(uid: user.uid).goalCollection.document(user.uid).updateData({
    previousActivity: FieldValue.delete(),
    "Goals": FieldValue.arrayRemove([previousActivity]),
  });
  DatabaseService(uid: user.uid).goalCollection.document(user.uid).updateData({
    newActivity: {
      "Goal ID": prevGoal.id,
      "Goal Seconds": goalSeconds,
      "colorHex": colorHex,
      "Start Date": prevGoal.startDate,
    },
    "Goals": FieldValue.arrayUnion([newActivity]),
  });

//updating Notification Data
  Map newNotificationData = {
    "Notification Frequency": prevGoal.notificationFrequency,
    "Notification Time": prevGoal.notificationTime,
    "Notification Days": prevGoal.notificationDays,
    "Notifications On?": prevGoal.notificationOn
  };

  DatabaseService(uid: user.uid)
      .notificationCollection
      .document(user.uid)
      .updateData({
    previousActivity: FieldValue.delete(),
    "Goals": FieldValue.arrayRemove([previousActivity]),
  });
  DatabaseService(uid: user.uid)
      .notificationCollection
      .document(user.uid)
      .updateData({
    newActivity: newNotificationData,
    "Goals": FieldValue.arrayUnion([newActivity]),
  });

//updating records
  final snapshot = await DatabaseService(uid: user.uid)
      .recordCollection
      .document(user.uid)
      .get();

  Map previousRecord = {};
  for (var i = 0; i < 5; i++) {
    String yearString = (yearint - i).toString();
    Map yearRecord = snapshot.data[yearString];
    if (yearRecord != null) {
      previousRecord.addAll({yearString: yearRecord});
    }
  }

  previousRecord.forEach((year, value) {
    Map yearRecord = value;
    yearRecord.forEach((date, value) {
      Map dayRecord = value;
      if (dayRecord.containsKey(previousActivity)) {
        int previousGoal = dayRecord[previousActivity + " goal"];
        int previousSeconds = dayRecord[previousActivity];
        dayRecord.remove(previousActivity);
        dayRecord.remove(previousActivity + " goal");
        dayRecord.addAll({
          newActivity: previousSeconds,
          newActivity + " goal": previousGoal
        });
      }
      yearRecord[date] = dayRecord;
    });

    DatabaseService(uid: user.uid)
        .recordCollection
        .document(user.uid)
        .updateData({
      year: yearRecord,
    });
  });

  //updating plans

  final planSnapshot = await DatabaseService(uid: user.uid)
      .planCollection
      .document(user.uid)
      .get();

  Map previousPlan = {};
  for (var i = 0; i < 5; i++) {
    String yearString = (yearint - i).toString();
    Map yearRecord = planSnapshot.data[yearString];
    if (yearRecord != null) {
      previousPlan.addAll({yearString: yearRecord});
    }
  }

  previousPlan.forEach((year, value) {
    Map yearRecord = value;
    yearRecord.forEach((date, value) {
      Map dayRecord = value;
      if (dayRecord.containsKey(previousActivity + " plan")) {
        int previousPlan = dayRecord[previousActivity + " plan"];
        dayRecord.remove(previousActivity + " plan");
        dayRecord.addAll({newActivity + " plan": previousPlan});
      }
      yearRecord[date] = dayRecord;
    });

    DatabaseService(uid: user.uid)
        .planCollection
        .document(user.uid)
        .updateData({
      year: yearRecord,
    });
  });
}

deleteGoalService(FirebaseUser user, Goal goal,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  DateTime now = DateTime.now();
  int yearint = now.year;
  String activity = goal.name;

//Cancel notifications for this goal
  cancelNotifications(flutterLocalNotificationsPlugin, id: goal.id);

  DatabaseService(uid: user.uid).goalCollection.document(user.uid).updateData({
    "Goals": FieldValue.arrayRemove([activity]),
    "Deceased IDS": FieldValue.arrayUnion([goal.id]),
    activity: FieldValue.delete(),
  });

// Deleting goal from records
  final snapshot = await DatabaseService(uid: user.uid)
      .recordCollection
      .document(user.uid)
      .get();

  Map previousRecord = {};
  for (var i = 0; i < 5; i++) {
    String yearString = (yearint - i).toString();
    Map yearRecord = snapshot.data[yearString];
    if (yearRecord != null) {
      previousRecord.addAll({yearString: yearRecord});
    }
  }

  previousRecord.forEach((year, value) {
    Map yearRecord = value;
    yearRecord.forEach((date, value) {
      Map dayRecord = value;
      if (dayRecord.containsKey(activity)) {
        dayRecord.remove(activity);
        dayRecord.remove(activity + " goal");
      }
      yearRecord[date] = dayRecord;
    });

    DatabaseService(uid: user.uid)
        .recordCollection
        .document(user.uid)
        .updateData({
      year: yearRecord,
    });
  });

// Deleting goal from Plan
  final planSnapshot = await DatabaseService(uid: user.uid)
      .planCollection
      .document(user.uid)
      .get();

  Map previousPlan = {};
  for (var i = 0; i < 5; i++) {
    String yearString = (yearint - i).toString();
    Map yearRecord = planSnapshot.data[yearString];
    if (yearRecord != null) {
      previousPlan.addAll({yearString: yearRecord});
    }
  }

  previousPlan.forEach((year, value) {
    Map yearRecord = value;
    yearRecord.forEach((date, value) {
      Map dayRecord = value;
      if (dayRecord.containsKey(activity + " plan")) {
        dayRecord.remove(activity + " plan");
      }
      yearRecord[date] = dayRecord;
    });

    DatabaseService(uid: user.uid)
        .planCollection
        .document(user.uid)
        .updateData({
      year: yearRecord,
    });
  });

  //remove goal from Main Goal document
  DatabaseService(uid: user.uid)
      .notificationCollection
      .document(user.uid)
      .updateData({
    "Goals": FieldValue.arrayRemove([activity]),
    activity: FieldValue.delete(),
  });
}

deleteDayRecord(String activity, DateTime dateTime, FirebaseUser user) async {
  String date = DateFormat("MM-dd-yyyy").format(dateTime);
  int yearint = dateTime.year;

  final snapshot = await DatabaseService(uid: user.uid)
      .recordCollection
      .document(user.uid)
      .get();

  Map previousRecord = {};
  for (var i = 0; i < 5; i++) {
    String yearString = (yearint - i).toString();
    Map yearRecord = snapshot.data[yearString];
    if (yearRecord != null) {
      previousRecord.addAll({yearString: yearRecord});
    }
  }

  previousRecord.forEach((year, value) {
    Map yearRecord = value;
    Map dayRecord = value[date];
    if (dayRecord.containsKey(activity)) {
      dayRecord.remove(activity);
      dayRecord.remove(activity + " goal");
    }
    yearRecord[date] = dayRecord;
    DatabaseService(uid: user.uid)
        .recordCollection
        .document(user.uid)
        .updateData({
      year: yearRecord,
    });
  });
}

editDayRecord(String activity, DateTime dateTime, FirebaseUser user,
    int newSeconds) async {
  String date = DateFormat("MM-dd-yyyy").format(dateTime);
  int yearint = dateTime.year;

  final snapshot = await DatabaseService(uid: user.uid)
      .recordCollection
      .document(user.uid)
      .get();

  Map previousRecord = {};
  for (var i = 0; i < 5; i++) {
    String yearString = (yearint - i).toString();
    Map yearRecord = snapshot.data[yearString];
    if (yearRecord != null) {
      previousRecord.addAll({yearString: yearRecord});
    }
  }

  previousRecord.forEach((year, value) {
    Map yearRecord = value;
    Map dayRecord = value[date];
    if (dayRecord.containsKey(activity)) {
      dayRecord.remove(activity);
      dayRecord.addAll({activity: newSeconds});
    }
    yearRecord[date] = dayRecord;
    DatabaseService(uid: user.uid)
        .recordCollection
        .document(user.uid)
        .updateData({
      year: yearRecord,
    });
  });
}

updateCurrentActivity(
  FirebaseUser user,
  String activity,
  bool currentlyRecording,
) async {
  Map<dynamic, dynamic> currentlyRecordingMap;

  DocumentSnapshot snapshot = await DatabaseService(uid: user.uid)
      .goalCollection
      .document(user.uid)
      .get();
  currentlyRecordingMap = snapshot.data["Currently Recording"];

  if (currentlyRecording == false) {
    currentlyRecordingMap.addAll({activity: FieldValue.serverTimestamp()});
  } else {
    currentlyRecordingMap.remove(activity);
  }

  DatabaseService(uid: user.uid)
      .goalCollection
      .document(user.uid)
      .updateData({"Currently Recording": currentlyRecordingMap});
}

void updateRecordService(
    FirebaseUser user, int duration, String activity, int goal) async {
  DateTime now = DateTime.now();
  String date = DateFormat("MM-dd-yyyy").format(now);
  String year = now.year.toString();

  int sessionSeconds = duration;

  final snapshot = await DatabaseService(uid: user.uid)
      .recordCollection
      .document(user.uid)
      .get();

  Map previousRecord = {};
  if (snapshot.data != null) {
    previousRecord = snapshot.data[year];
  }

  Map dayPreviousRecord = previousRecord[date] ?? {};

  int previousSeconds = dayPreviousRecord[activity] ?? 0;

  dayPreviousRecord.addAll(
      {activity: sessionSeconds + previousSeconds, "$activity goal": goal});

  previousRecord.addAll({date: dayPreviousRecord});

  DatabaseService(uid: user.uid)
      .recordCollection
      .document(user.uid)
      .setData({year: previousRecord}, merge: true);
}

updatePlanService(
    FirebaseUser user, int seconds, DateTime day, String activity) async {
  String date = DateFormat("MM-dd-yyyy").format(day);
  String year = day.year.toString();

  final snapshot = await DatabaseService(uid: user.uid)
      .planCollection
      .document(user.uid)
      .get();

  Map previousRecord = {};
  if (snapshot.data != null) {
    previousRecord = snapshot.data[year];
  }

  Map dayPreviousRecord = previousRecord[date] ?? {};

  dayPreviousRecord.addAll({"$activity plan": seconds});

  previousRecord.addAll({date: dayPreviousRecord});

  DatabaseService(uid: user.uid)
      .planCollection
      .document(user.uid)
      .setData({year: previousRecord}, merge: true);
}

updateNotficationService(FirebaseUser user, String notificationFrequency,
    Goal goal, String notificationTime, bool notificationOn,
    {List<dynamic> notificationDays}) async {
  String goalName = goal.name;

  Map notificationData = {
    "Notification Frequency": notificationFrequency,
    "Notification Time": notificationTime,
    "Notification Days": notificationDays,
    "Notifications On?": notificationOn
  };
  DatabaseService(uid: user.uid)
      .notificationCollection
      .document(user.uid)
      .setData({
    "$goalName": notificationData,
    "Goals": FieldValue.arrayUnion([goal.name])
  }, merge: true);
}

combineRecordAndGoal(List<Goal> goals, Map records) async {
  goals.forEach((goal) {
    //records
    Map recordHistory = {};
    String name = goal.name;

    records.forEach((year, value) {
      if (value != null) {
        Map yearRecord = value;

        yearRecord.forEach((date, value) {
          int goalSeconds = value[name + " goal"];
          int dailySeconds = value[name];

          Map dayRecord = {
            "Seconds": dailySeconds ?? 0,
            "Goal": goalSeconds ?? 0,
          };
          if (goalSeconds != null && dailySeconds != null) {
            recordHistory.addAll({date: dayRecord});
          }
        });
      }
    });
    DateTime startDate = getstartDate(0);

    int weeklySeconds = 0;
    //Seconds this Week
    for (int i = 0; i < 7; i++) {
      String dateString =
          DateFormat("MM-dd-yyyy").format(startDate.add(Duration(days: i)));
      Map dayRecord = recordHistory[dateString] ?? {};
      int daySeconds = dayRecord["Seconds"] ?? 0;
      weeklySeconds += daySeconds;
    }

    //Seconds Today
    String dateString = DateFormat("MM-dd-yyyy").format(DateTime.now());
    Map dayRecord = recordHistory[dateString] ?? {};
    int daySeconds = dayRecord["Seconds"] ?? 0;

    goal.recordHistory = recordHistory;
    goal.weeklySeconds = weeklySeconds;
    goal.dailySeconds = daySeconds;
  });
}

combineGoalAndNotification(Goal goal, List<NotificationData> notificationList) {
  if (notificationList != null) {
    notificationList.forEach((notificationData) {
      if (notificationData.name == goal.name) {
        goal.notificationDays = notificationData.notificationDays;
        goal.notificationFrequency = notificationData.notificationFrequency;
        goal.notificationOn = notificationData.notificationOn;
        goal.notificationTime = notificationData.notificationTime;
      }
    });
  }
}

initialiseGoalNotification(Goal goal,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  if (goal.notificationOn) {
    setNotifications(flutterLocalNotificationsPlugin,
        formattedTime: formatNotificationTimeString(goal.notificationTime),
        frequency: goal.notificationFrequency,
        goalID: goal.id,
        notificationsOn: goal.notificationOn,
        goalName: goal.name,
        reminderDays: goal.notificationDays);
  }
}

combineRecordAndPlans(Map records, Map plans, Goal goal) async {
  plans.forEach((year, record) {
    Map yearRecord = record;

    yearRecord.forEach((date, record) {
      Map dayRecord = record;

      dayRecord.forEach((entry, seconds) {
        String activity = entry;

        if (activity.substring(0, activity.length - 5) == goal.name) {
          Map previousRecord = records[date] ?? {};
          previousRecord.addAll({"Plan": seconds});
          records.addAll({date: previousRecord});
        }
      });
    });
  });

  int plannedSeconds = 0;
  DateTime startDate = getstartDate(0);
  for (var i = 0; i < 7; i++) {
    String dayString =
        DateFormat("MM-dd-yyyy").format(startDate.add(Duration(days: i)));

    Map dayRecord = records[dayString] ?? {};
    int dailyPlan = dayRecord["Plan"] ?? 0;
    plannedSeconds += dailyPlan;
  }

  goal.weeklyPlan = plannedSeconds;
}

resetUserData(FirebaseUser user) async {
  await DatabaseService(uid: user.uid).setInitialUserData();
}

deleteUserData(FirebaseUser user) async {
  await DatabaseService(uid: user.uid)
      .recordCollection
      .document(user.uid)
      .delete();
  await DatabaseService(uid: user.uid)
      .goalCollection
      .document(user.uid)
      .delete();
  await DatabaseService(uid: user.uid)
      .planCollection
      .document(user.uid)
      .delete();
}
