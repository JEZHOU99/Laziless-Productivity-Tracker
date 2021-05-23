import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';
import 'package:intl/intl.dart';
import 'package:laziless/services/get_date.dart';
import 'package:laziless/services/update_service.dart';
import 'package:laziless/tools/pop_up_close.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class PlanPopUp extends StatefulWidget {
  const PlanPopUp({Key key, this.goal, this.day, this.seconds})
      : super(key: key);
  final Goal goal;
  final DateTime day;
  final int seconds;

  @override
  _PlanPopUpState createState() => _PlanPopUpState();
}

class _PlanPopUpState extends State<PlanPopUp> {
  Duration timer;

  @override
  void initState() {
    super.initState();
    timer = Duration(seconds: widget.seconds);
  }

  @override
  Widget build(BuildContext context) {
    int weekDayInt = widget.day.weekday;
    int seconds = timer.inSeconds;
    final user = Provider.of<FirebaseUser>(context);

    return Container(
        height: 350,
        width: 180,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                PopUpClose(),
                Text(
                  getWeekDay(weekDayInt),
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(widget.goal.color),
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  DateFormat("dd/MM").format(widget.day),
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Container(height: 150, child: time()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  color: Color(widget.goal.color),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  onPressed: () async {
                    updatePlanService(
                        user, seconds, widget.day, widget.goal.name);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Plan",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Widget time() {
    return CupertinoTimerPicker(
      alignment: Alignment.center,
      mode: CupertinoTimerPickerMode.hm,
      minuteInterval: 15,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      initialTimerDuration: timer,
      onTimerDurationChanged: (Duration changedtimer) {
        setState(() {
          timer = changedtimer;
        });
      },
    );
  }
}
