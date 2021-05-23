import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/dark_theme.dart';
import 'package:laziless/tools/record_delete_confirmation.dart';
import 'package:laziless/tools/record_edit.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  Calendar({this.records, this.goals});
  final Map records;
  final List<Goal> goals;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController;
  List<RecordData> _selectedEvents;
  DateTime initialDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _selectedEvents = [];
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    Map<DateTime, List<RecordData>> _events = {};
    Map records = widget.records;
    List<Goal> goals = widget.goals;

    _importEventsToCalendar(records, _events, goals);

    _selectedEvents = _events[initialDate] ?? [];
    _selectedEvents.sort((a, b) => b.seconds.compareTo(a.seconds));

    return Column(
      children: <Widget>[
        TableCalendar(
          weekendDays: [],
          availableCalendarFormats: const {
            CalendarFormat.week: 'Week',
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonShowsNext: false,
              leftChevronIcon: themeChange.darkTheme
                  ? Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    )
                  : Icon(Icons.chevron_left),
              rightChevronIcon: themeChange.darkTheme
                  ? Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    )
                  : Icon(Icons.chevron_right),
              formatButtonDecoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12))),
          initialCalendarFormat: CalendarFormat.week,
          calendarStyle: CalendarStyle(
              selectedColor: Theme.of(context).primaryColor,
              todayColor: Colors.grey,
              markersColor:
                  themeChange.darkTheme ? Colors.white : Colors.black),
          events: _events,
          calendarController: _calendarController,
          onDaySelected: (date, events) {
            setState(() {
              initialDate = DateTime(date.year, date.month, date.day);

              //_selectedEvents = events;
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _selectedEvents.length,
            itemBuilder: (context, index) {
              return CalendarTile(activity: _selectedEvents[index]);
            },
          ),
        )
      ],
    );
  }

  _importEventsToCalendar(
      Map records, Map<DateTime, List<RecordData>> _events, List<Goal> goals) {
    records.forEach((year, day) {
      Map dayData = day;
      dayData.forEach((date, records) {
        String day = date.substring(3, 5);
        String year = date.substring(6, 10);
        String month = date.substring(0, 2);
        String newDate = "$year-$month-$day";
        DateTime formattedDate = DateTime.parse(newDate);
        Map recordData = records;
        recordData.forEach((activity, seconds) {
          if (activity.length > 4 &&
              activity.substring(activity.length - 4) == "goal") {
          } else {
            int colorHex;
            goals.forEach((goal) {
              if (goal.name == activity) {
                colorHex = goal.color;
              }
            });

            if (_events[formattedDate] == null) {
              _events[formattedDate] = [
                RecordData(
                    name: activity,
                    seconds: seconds,
                    date: formattedDate,
                    colorHex: colorHex)
              ];
            } else {
              _events[formattedDate].add(RecordData(
                  name: activity,
                  seconds: seconds,
                  date: formattedDate,
                  colorHex: colorHex));
            }
          }
        });
      });
    });
  }
}

class CalendarTile extends StatefulWidget {
  const CalendarTile({Key key, this.activity}) : super(key: key);
  final RecordData activity;

  @override
  _CalendarTileState createState() => _CalendarTileState();
}

class _CalendarTileState extends State<CalendarTile> {
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseUser user = Provider.of<FirebaseUser>(context);

    return Padding(
        padding: EdgeInsets.all(8),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  spreadRadius: 0,
                )
              ],
            ),
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Stack(children: <Widget>[
              ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(widget.activity.colorHex)),
                      ),
                    ],
                  ),
                  title: Text(
                    widget.activity.name,
                    style: TextStyle(
                      color: Color(widget.activity.colorHex),
                    ),
                  ),
                  subtitle: _timeText(widget.activity),
                  trailing: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(child: child, opacity: animation);
                    },
                    child: GestureDetector(
                        key: ValueKey<bool>(showOptions),
                        onTap: () {
                          setState(() {
                            showOptions
                                ? showOptions = false
                                : showOptions = true;
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          color: Colors.transparent,
                          child: showOptions
                              ? Icon(Icons.cancel)
                              : Icon(Icons.more_vert),
                        )),
                  )),
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(child: child, opacity: animation);
                  },
                  child: showOptions
                      ? Padding(
                          padding: const EdgeInsets.only(top: 2, right: 45),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    confrimRecordDelete(
                                        context, widget.activity, user);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    width: 50,
                                    height: 25,
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    confrimRecordEdit(
                                        context, widget.activity, user);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    width: 50,
                                    height: 25,
                                    child: Text(
                                      "Edit",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container())
            ])));
  }

  _timeText(RecordData activity) {
    int seconds = activity.seconds;
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;

    if (hours == 0 && minutes == 0) {
      return Text(
        "$seconds secs",
        style: TextStyle(
          color: Color(activity.colorHex),
        ),
      );
    } else if (hours == 0 && minutes != 0) {
      return Text(
        "$minutes mins",
        style: TextStyle(
          color: Color(activity.colorHex),
        ),
      );
    } else if (hours == 1) {
      return Text(
        "$hours hr $minutes mins",
        style: TextStyle(
          color: Color(activity.colorHex),
        ),
      );
    }

    return Text(
      "$hours hrs $minutes mins",
      style: TextStyle(
        color: Color(activity.colorHex),
      ),
    );
  }
}
