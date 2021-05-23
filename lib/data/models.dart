import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String photoUrl;
  final String name;
  final bool isAnonymous;
  final bool emailVerified;
  final String email;
  final String phoneNumber;

  User(
      {this.uid,
      this.photoUrl,
      this.name,
      this.isAnonymous,
      this.email,
      this.phoneNumber,
      this.emailVerified});
}

class Goal {
  int id;
  String name;
  int color;
  int seconds;
  bool currentlyRecording;
  Timestamp startTime;
  Map recordHistory;
  int dailySeconds;
  int weeklySeconds;
  int weeklyPlan;
  Timestamp startDate;
  List<dynamic> notificationDays = [];
  String notificationFrequency = "";
  String notificationTime = "";
  bool notificationOn = false;

  Goal(
      {this.id,
      this.name,
      this.color,
      this.seconds,
      this.currentlyRecording,
      this.startTime,
      this.dailySeconds,
      this.weeklySeconds,
      this.startDate,
      this.weeklyPlan,
      this.notificationDays,
      this.notificationFrequency,
      this.notificationTime,
      this.notificationOn});
}

class RecordData {
  String name;
  int seconds;
  DateTime date;
  int colorHex;
  RecordData({this.name, this.seconds, this.date, this.colorHex});
}

class Settings {
  bool onboardingComplete;
  bool firstLaunch;
  Settings({this.onboardingComplete, this.firstLaunch});
}

class NotificationData {
  String name;
  List<dynamic> notificationDays;
  String notificationFrequency;
  String notificationTime;
  bool notificationOn;

  NotificationData(
      {this.name,
      this.notificationDays,
      this.notificationFrequency,
      this.notificationTime,
      this.notificationOn});
}
