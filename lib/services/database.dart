import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laziless/data/models.dart';

class DatabaseService {
  final String uid;
  final String date;
  final String photourl;

  DatabaseService({this.uid, this.date, this.photourl});

  // update user name
  Future setInitialUserData() async {
    int year = DateTime.now().year;

    goalCollection
        .document(uid)
        .setData({"Currently Recording": {}, "Goals": [], "Goal IDS": 1});
    recordCollection.document(uid).setData({year.toString(): {}});
    planCollection.document(uid).setData({year.toString(): {}});
  }

  final CollectionReference goalCollection =
      Firestore.instance.collection("UserGoals");

  List<Goal> _userGoalFromSnapshot(DocumentSnapshot snapshot) {
    List<Goal> activityList = [];

    List<dynamic> activityNames = snapshot.data["Goals"];
    activityNames.forEach((name) {
      bool currentlyRecording = false;
      if (snapshot.data["Currently Recording"][name] != null) {
        currentlyRecording = true;
      }

      activityList.add(Goal(
        id: snapshot.data[name]["Goal ID"],
        name: name,

        seconds: snapshot.data[name]["Goal Seconds"],
        color: snapshot.data[name]["colorHex"],
        startDate: snapshot.data[name]["Start Date"],
        currentlyRecording: currentlyRecording,
        startTime: snapshot.data["Currently Recording"][name],
      ));
    });

    return activityList;
  }

  Stream<List<Goal>> get goalStream {
    return goalCollection.document(uid).snapshots().map(_userGoalFromSnapshot);
  }

  final CollectionReference recordCollection =
      Firestore.instance.collection("UserRecords");

  Map _userRecordsFromSnapshot(DocumentSnapshot snapshot) {
    Map records = {};
    int yearint = DateTime.now().year;

    for (var i = 0; i < 5; i++) {
      String yearString = (yearint - i).toString();
      Map yearRecord = snapshot.data[yearString];
      if (yearRecord != null) {
        records.addAll({yearString: yearRecord});
      }
    }

    return records;
  }

  Stream<Map> get recordStream {
    return recordCollection
        .document(uid)
        .snapshots()
        .map(_userRecordsFromSnapshot);
  }

  final CollectionReference planCollection =
      Firestore.instance.collection("UserPlans");

  Map _userPlanFromSnapshot(DocumentSnapshot snapshot) {
    Map plans = {};
    int yearint = DateTime.now().year;

    for (var i = 0; i < 5; i++) {
      String yearString = (yearint - i).toString();
      Map yearRecord = snapshot.data[yearString];
      if (yearRecord != null) {
        plans.addAll({yearString: yearRecord});
      }
    }

    return plans;
  }

  Stream<Map> get planStream {
    return planCollection.document(uid).snapshots().map(_userPlanFromSnapshot);
  }

  final CollectionReference notificationCollection =
      Firestore.instance.collection("UserNotifications");

  List<NotificationData> _userNotificationFromSnapshot(
      DocumentSnapshot snapshot) {
    List<NotificationData> notificationData = [];

    List<dynamic> activityNames = snapshot.data["Goals"];

    activityNames.forEach((name) {
      notificationData.add(NotificationData(
          name: name,
          notificationDays: snapshot.data[name]["Notification Days"] ?? [],
          notificationFrequency:
              snapshot.data[name]["Notification Frequency"] ?? "",
          notificationTime: snapshot.data[name]["Notification Time"] ?? "",
          notificationOn: snapshot.data[name]["Notifications On?"] ?? false));
    });

    return notificationData;
  }

  Stream<List<NotificationData>> get notificationStream {
    return notificationCollection
        .document(uid)
        .snapshots()
        .map(_userNotificationFromSnapshot);
  }
}
