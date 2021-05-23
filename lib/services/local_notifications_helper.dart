import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'get_date.dart';

NotificationDetails get ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: true,
    autoCancel: false,
  );
  final iosChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
}

void showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  @required int id,
}) {
  notifications.show(id, title, body, type);
}

void showOngoingNotification(FlutterLocalNotificationsPlugin notifications,
    {@required String title, @required String body, @required int id}) {
  showNotification(notifications,
      title: title, body: body, type: ongoing, id: id);
}

// Scheduling notifications

// Daily Notification
NotificationDetails get daily {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'repeatDailyAtTime channel id',
    'repeatDailyAtTime channel name',
    'repeatDailyAtTime description',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: false,
    autoCancel: true,
  );
  final iosChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
}

void showDailyNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  @required Time time,
  @required int id,
}) {
  notifications.showDailyAtTime(id, title, body, time, type);
}

void scheduleDailyNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required Time time,
  @required int id,
}) {
  showDailyNotification(notifications,
      title: title, body: body, time: time, type: daily, id: id);
}

// Weekly Notification
NotificationDetails get weekly {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'show weekly channel id',
    'show weekly channel name',
    'show weekly description',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: false,
    autoCancel: true,
  );
  final iosChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
}

void showWeeklyNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  @required Time time,
  @required Day day,
  @required int id,
}) {
  notifications.showWeeklyAtDayAndTime(id, title, body, day, time, type);
}

void scheduleWeeklyNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required Time time,
  @required Day day,
  @required int id,
}) {
  showWeeklyNotification(notifications,
      title: title, body: body, day: day, time: time, type: daily, id: id);
}

setNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    {@required Time formattedTime,
    @required String frequency,
    @required int goalID,
    @required bool notificationsOn,
    @required String goalName,
    @required List reminderDays}) {
  String timeString = timeText(
      TimeOfDay(hour: formattedTime.hour, minute: formattedTime.minute));

  if (frequency == "Daily") {
    cancelNotifications(flutterLocalNotificationsPlugin, id: goalID);

    scheduleDailyNotification(flutterLocalNotificationsPlugin,
        title: "Time to $goalName!",
        body: "Here's your daily $timeString reminder",
        id: (goalID * 7) + 1,
        time: formattedTime);
  } else if (frequency == "Custom") {
    cancelNotifications(flutterLocalNotificationsPlugin, id: goalID);

    reminderDays.forEach((dayInt) {
      scheduleWeeklyNotification(flutterLocalNotificationsPlugin,
          title: "Time to $goalName!",
          body: "Here's your ${getWeekDay(dayInt)} $timeString reminder",
          day: Day(dayInt),
          id: (goalID * 7) + dayInt,
          time: formattedTime);
    });
  }
  if (!notificationsOn) {
    cancelNotifications(flutterLocalNotificationsPlugin, id: goalID);
  }
}

cancelNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    {@required int id}) {
  for (var i = 1; i < 8; i++) {
    flutterLocalNotificationsPlugin.cancel(id * 7 + i);
  }
}

timeText(TimeOfDay time) {
  String amOrPm = "AM";
  String hour = time.hour.toString().padLeft(2, "0");
  if (time.hour > 12) {
    hour = (time.hour - 12).toString().padLeft(2, "0");
    amOrPm = "PM";
  }
  String minute = time.minute.toString().padLeft(2, "0");

  return "$hour:$minute $amOrPm";
}

Time formatNotificationTimeString(String notificationTime) {
  int hour = int.parse(notificationTime.substring(0, 2));
  int minute = int.parse(notificationTime.substring(3, 5));

  return Time(hour, minute, 0);
}
