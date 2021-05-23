import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laziless/services/update_service.dart';
import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/goal_files/goal_details/goal_details_main.dart';
import 'package:laziless/services/check_internet.dart';
import 'package:laziless/services/database.dart';
import 'package:laziless/services/fade_in_animation.dart';
import 'package:laziless/tools/timer_text.dart';
import 'package:intl/intl.dart';
import 'package:laziless/services/get_date.dart';
import 'package:flutter/services.dart';
import 'package:laziless/services/local_notifications_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoalTile extends StatefulWidget {
  GoalTile({Key key, this.week, this.goal}) : super(key: key);
  final int week;
  final Goal goal;

  @override
  _GoalTileState createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    String hours = (widget.goal.seconds / 3600).toStringAsFixed(1);
    int weeklySeconds = _getWeeklySeconds();
    double percentage =
        widget.goal.seconds == 0 ? 0 : weeklySeconds / widget.goal.seconds;

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        Provider.of<FlutterLocalNotificationsPlugin>(context);
    final FirebaseUser user = Provider.of<FirebaseUser>(context);
    final notificationList = Provider.of<List<NotificationData>>(context);
    combineGoalAndNotification(widget.goal, notificationList);

    if (widget.goal.notificationOn == true) {
      initialiseGoalNotification(widget.goal, flutterLocalNotificationsPlugin);
    }
    return FadeIn(
      delay: 0.2,
      child: Stack(
        children: <Widget>[
          Container(
            height: 80,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  width: 2,
                  color: widget.week == 0
                      ? Color(widget.goal.color).withOpacity(0.5)
                      : Colors.grey.withOpacity(0.4)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Container(
                        height: 50,
                        child: Text(
                          "Hold to record",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      duration: Duration(seconds: 2),
                    ));
                  },
                  onLongPress: () async {
                    HapticFeedback.vibrate();

                    updateCurrentActivity(
                        user, widget.goal.name, widget.goal.currentlyRecording);

                    if (widget.goal.currentlyRecording) {
                      int duration = (Timestamp.now().millisecondsSinceEpoch -
                              widget.goal.startTime.millisecondsSinceEpoch +
                              1000) ~/
                          1000;

                      updateRecordService(user, duration, widget.goal.name,
                          widget.goal.seconds);
                    } else {
                      dynamic result = await checkInternet();
                      print("have internet?: $result");
                      if (result == false) {
                        Scaffold.of(context).hideCurrentSnackBar();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Container(
                            height: 50,
                            child: Text(
                              "Recording will start when connected to internet",
                            ),
                          ),
                          duration: Duration(seconds: 4),
                        ));
                      }
                    }

                    widget.goal.currentlyRecording
                        ? flutterLocalNotificationsPlugin.cancelAll()
                        : showOngoingNotification(
                            flutterLocalNotificationsPlugin,
                            title: "Currently Recording",
                            body: "${widget.goal.name}",
                            id: 0);
                  },
                  child: Stack(alignment: Alignment.center, children: <Widget>[
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
                          height: 80,
                          width: (screenWidth - 56) * percentage,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(widget.goal.color).withOpacity(0.3)),
                        ),
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ListTile(
                            leading: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(widget.goal.color)),
                            ),
                            title: Text(
                              widget.goal.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(widget.goal.color),
                                  fontSize: 20),
                            ),
                            trailing: Container(
                              width: 80,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                              onTap: () {
                                _openGoalDetails(context, widget.goal, user);
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  alignment: Alignment.centerRight,
                                  width: (screenWidth / 2) - 50,
                                  height: 80,
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 25),
                                      child: _trailingView(
                                          hours, weeklySeconds)))),
                        )
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _trailingView(String hours, int weeklySeconds) {
    String percentageString =
        (weeklySeconds * 100 / widget.goal.seconds).toStringAsFixed(1);
    String weeklyHours = (weeklySeconds / 3600).toStringAsFixed(1);
    if (widget.goal.currentlyRecording == true) {
      return TimerText(
        styling: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(widget.goal.color)),
        startTime: widget.goal.startTime,
        timerStarted: widget.goal.currentlyRecording,
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          widget.goal.seconds == 0
              ? Text(
                  "No Goal",
                  style: TextStyle(
                      color: widget.week == 0
                          ? Color(widget.goal.color)
                          : Colors.grey,
                      fontSize: 18),
                )
              : Text(
                  "$percentageString%",
                  style: TextStyle(
                      color: widget.week == 0
                          ? Color(widget.goal.color)
                          : Colors.grey,
                      fontSize: 18),
                ),
          hours == "1.0"
              ? Text(
                  "$weeklyHours / ${hours[0]} hr",
                  style: TextStyle(
                      color: widget.week == 0
                          ? Color(widget.goal.color)
                          : Colors.grey,
                      fontSize: 14),
                )
              : Text(
                  "$weeklyHours / $hours hrs",
                  style: TextStyle(
                      color: widget.week == 0
                          ? Color(widget.goal.color)
                          : Colors.grey,
                      fontSize: 14),
                )
        ],
      );
    }
  }

  _getWeeklySeconds() {
    DateTime startDate = getstartDate(widget.week);
    int weeklySeconds = 0;
    for (var i = 0; i < 7; i++) {
      String date =
          DateFormat("MM-dd-yyyy").format(startDate.add(Duration(days: i)));
      Map dailyMap = widget.goal.recordHistory[date] ?? {};
      int dailySeconds = dailyMap["Seconds"] ?? 0;
      weeklySeconds += dailySeconds;
    }
    return weeklySeconds;
  }

  _openGoalDetails(context, Goal goal, FirebaseUser user) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: StreamProvider<List<NotificationData>>.value(
                initialData: [],
                value: DatabaseService(uid: user.uid).notificationStream,
                child: StreamProvider<Map>.value(
                  initialData: {},
                  value: DatabaseService(uid: user.uid).planStream,
                  child: GoalDetails(
                    user: user,
                    goal: goal,
                  ),
                ),
              ));
        });
  }
}
