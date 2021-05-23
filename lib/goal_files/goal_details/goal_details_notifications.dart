import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/fade_in_animation.dart';
import 'package:laziless/services/local_notifications_helper.dart';
import 'package:laziless/services/update_service.dart';
import 'package:provider/provider.dart';

class GoalDetailsNotifications extends StatefulWidget {
  const GoalDetailsNotifications({Key key, this.goal}) : super(key: key);
  final Goal goal;

  @override
  _GoalDetailsNotificationsState createState() =>
      _GoalDetailsNotificationsState();
}

class _GoalDetailsNotificationsState extends State<GoalDetailsNotifications> {
  String frequency = "";
  List<dynamic> reminderDays = [];
  bool notificationsOn = false;
  TimeOfDay time;

  @override
  void initState() {
    super.initState();

    frequency = widget.goal.notificationFrequency;
    if (widget.goal.notificationDays != null) {
      reminderDays = widget.goal.notificationDays.toList();
    }

    if (widget.goal.notificationOn != null) {
      notificationsOn = widget.goal.notificationOn;
    }

    if (widget.goal.notificationTime == "" ||
        widget.goal.notificationTime == null) {
      time = TimeOfDay.now();
    } else {
      int hour = int.parse(widget.goal.notificationTime.substring(0, 2));
      int minute = int.parse(widget.goal.notificationTime.substring(3, 5));
      time = TimeOfDay(hour: hour, minute: minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    var formattedTime = Time(time.hour, time.minute, 0);

    final FirebaseUser user = Provider.of<FirebaseUser>(context);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        Provider.of<FlutterLocalNotificationsPlugin>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Remind Me",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(widget.goal.color)),
              ),
              Switch.adaptive(
                  value: notificationsOn,
                  onChanged: (bool newValue) {
                    setState(() {
                      notificationsOn = newValue;
                      updateNotficationService(
                          user,
                          frequency,
                          widget.goal,
                          "${time.hour.toString().padLeft(2, "0")}:${time.minute.toString().padLeft(2, "0")}",
                          notificationsOn,
                          notificationDays: reminderDays);

                      setNotifications(flutterLocalNotificationsPlugin,
                          formattedTime: formattedTime,
                          frequency: frequency,
                          goalID: widget.goal.id,
                          notificationsOn: notificationsOn,
                          goalName: widget.goal.name,
                          reminderDays: reminderDays);
                    });
                  })
            ],
          ),
          Container(
            alignment: Alignment.center,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                frequencySelection("Daily"),
                saveButton(
                    user, flutterLocalNotificationsPlugin, formattedTime),
                frequencySelection("Custom")
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: weekdayPicker(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 36,
                  child: InkWell(
                    onTap: notificationsOn
                        ? () {
                            _pickTime();
                          }
                        : () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("At",
                            style: notificationsOn
                                ? TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  )
                                : TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w800,
                                  )),
                        Text(timeText(time),
                            style: notificationsOn
                                ? TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(widget.goal.color))
                                : TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  frequencySelection(String text) {
    if (notificationsOn) {
      return GestureDetector(
        onTap: () {
          setState(() {
            frequency = text;
          });
        },
        child: Container(
          alignment: Alignment.center,
          height: 40,
          width: 80,
          decoration: BoxDecoration(
              border: text == frequency
                  ? Border.all(color: Color(widget.goal.color), width: 3)
                  : Border.all(
                      color: Theme.of(context).textSelectionColor, width: 2),
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            text,
            style: text == frequency
                ? TextStyle(
                    color: Color(widget.goal.color),
                    fontSize: 16,
                    fontWeight: FontWeight.w500)
                : TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: 80,
      decoration: BoxDecoration(
          border: text == frequency
              ? Border.all(color: Colors.grey, width: 3)
              : Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: text == frequency
            ? TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500)
            : TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  weekdayPicker() {
    if (frequency == "Custom") {
      return OpacityIn(
        delay: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            weekdayTiles("Mon", 1),
            weekdayTiles("Tue", 2),
            weekdayTiles("Wed", 3),
            weekdayTiles("Thu", 4),
            weekdayTiles("Fri", 5),
            weekdayTiles("Sat", 6),
            weekdayTiles("Sun", 7)
          ],
        ),
      );
    }
    return Container(
      height: 0,
    );
  }

  weekdayTiles(String day, int dayInt) {
    if (notificationsOn) {
      return GestureDetector(
        onTap: () {
          setState(() {
            if (reminderDays.contains(dayInt)) {
              reminderDays.remove(dayInt);
              reminderDays.sort();
            } else {
              reminderDays.add(dayInt);
              reminderDays.sort();
            }
          });
        },
        child: Container(
            alignment: Alignment.center,
            height: 28,
            width: 36,
            decoration: reminderDays.contains(dayInt)
                ? BoxDecoration(
                    border:
                        Border.all(color: Color(widget.goal.color), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  )
                : BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(12)),
            child: Text(
              day,
              style: reminderDays.contains(dayInt)
                  ? TextStyle(
                      color: Color(widget.goal.color),
                      fontWeight: FontWeight.w600,
                      fontSize: 14)
                  : TextStyle(fontSize: 14),
            )),
      );
    }
    return Container(
      alignment: Alignment.center,
      height: 28,
      width: 36,
      decoration: reminderDays.contains(day)
          ? BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(12),
            )
          : BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(12)),
      child: Text(day,
          style: reminderDays.contains(day)
              ? TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 14)
              : TextStyle(color: Colors.grey, fontSize: 14)),
    );
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        time = t;
      });
  }

  saveButton(
    FirebaseUser user,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    Time formattedTime,
  ) {
    if (differentFromData()) {
      return OpacityIn(
        delay: 0.4,
        child: ButtonTheme(
          minWidth: 80,
          height: 40,
          child: RaisedButton(
            onPressed: () {
              updateNotficationService(
                  user,
                  frequency,
                  widget.goal,
                  "${time.hour.toString().padLeft(2, "0")}:${time.minute.toString().padLeft(2, "0")}",
                  notificationsOn,
                  notificationDays: reminderDays);

              if (notificationsOn) {
                setNotifications(flutterLocalNotificationsPlugin,
                    formattedTime: formattedTime,
                    frequency: frequency,
                    goalID: widget.goal.id,
                    notificationsOn: notificationsOn,
                    goalName: widget.goal.name,
                    reminderDays: reminderDays);
              }
            },
            color: Color(widget.goal.color),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  differentFromData() {
    TimeOfDay previousTime;

    if (widget.goal.notificationTime == "" ||
        widget.goal.notificationTime == null) {
      previousTime = TimeOfDay.now();
    } else {
      int hour = int.parse(widget.goal.notificationTime.substring(0, 2));
      int minute = int.parse(widget.goal.notificationTime.substring(3, 5));
      previousTime = TimeOfDay(hour: hour, minute: minute);
    }

    bool listequal = listEquals(
        widget.goal.notificationDays.toList(), reminderDays.toList());

    if (!listequal ||
        widget.goal.notificationFrequency != frequency ||
        previousTime != time) {
      return true;
    }
    return false;
  }
}
