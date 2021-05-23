import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/update_service.dart';
import 'package:laziless/tools/pop_up_close.dart';

class RecordEditConfirmation extends StatefulWidget {
  const RecordEditConfirmation({Key key, this.record, this.user})
      : super(key: key);

  final RecordData record;
  final FirebaseUser user;

  @override
  _RecordEditConfirmationState createState() => _RecordEditConfirmationState();
}

class _RecordEditConfirmationState extends State<RecordEditConfirmation> {
  Duration timer;

  @override
  void initState() {
    super.initState();

    if (widget.record.seconds > 86399) {
      timer = Duration(minutes: (((86100 / 60) / 5).round()) * 5);
    } else {
      timer = new Duration(
          minutes: (((widget.record.seconds / 60) / 5).round()) * 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> daysOfTheWeek = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];

    String dayName = daysOfTheWeek[widget.record.date.weekday - 1];
    String date = DateFormat("dd/MM/yyyy").format(widget.record.date);

    return Container(
      height: 360,
      width: 300,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                PopUpClose(),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      "What do you want to edit this record to?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  "$dayName",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600),
                                ),
                                Text(
                                  "$date",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            _recordPreview(),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 20, top: 10),
                              child: Center(
                                child: Container(height: 110, child: time()),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        color: Color(widget.record.colorHex),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          editDayRecord(widget.record.name, widget.record.date,
                              widget.user, timer.inSeconds);
                        },
                        child: Text("Save",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget time() {
    return CupertinoTimerPicker(
      alignment: Alignment.center,
      mode: CupertinoTimerPickerMode.hm,
      minuteInterval: 5,
      initialTimerDuration: timer,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      onTimerDurationChanged: (Duration changedtimer) {
        setState(() {
          timer = changedtimer;
        });
      },
    );
  }

  _recordPreview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 120,
          child: Text(
            widget.record.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 18,
              color: Color(widget.record.colorHex),
            ),
          ),
        ),
      ],
    );
  }
}

confrimRecordEdit(context, record, FirebaseUser user) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: RecordEditConfirmation(
              record: record,
              user: user,
            ));
      });
}
