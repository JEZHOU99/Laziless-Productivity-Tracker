import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/get_date.dart';
import 'package:laziless/services/update_service.dart';
import 'package:laziless/tools/pop_up_close.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class RecordDeleteConfirmation extends StatelessWidget {
  const RecordDeleteConfirmation({Key key, this.record, this.user})
      : super(key: key);

  final RecordData record;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    String dayName = getWeekDay(record.date.weekday);
    String date = DateFormat("dd/MM/yyyy").format(record.date);

    return Container(
      height: 350,
      width: 200,
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
                      "Are you sure you want to delete this record?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
                    child: Column(
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
                        SizedBox(height: 20),
                        _recordPreview(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      ConfirmationSlider(
                        onConfirmation: () {
                          deleteDayRecord(record.name, record.date, user);
                          Navigator.of(context).pop();
                        },
                        width: 250,
                        foregroundColor: Color(record.colorHex),
                        text: "         Slide to confirm",
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  _recordPreview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(record.colorHex)),
        ),
        SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              record.name,
              style: TextStyle(
                fontSize: 18,
                color: Color(record.colorHex),
              ),
            ),
            _timeText(record)
          ],
        ),
      ],
    );
  }

  _timeText(RecordData activity) {
    int seconds = activity.seconds;
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;

    if (hours == 0 && minutes == 0) {
      return Text(
        "$seconds secs",
        style: TextStyle(
          fontSize: 14,
          color: Color(activity.colorHex),
        ),
      );
    } else if (hours == 0 && minutes != 0) {
      return Text(
        "$minutes mins",
        style: TextStyle(
          fontSize: 14,
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
        fontSize: 14,
        color: Color(activity.colorHex),
      ),
    );
  }
}

confrimRecordDelete(context, record, FirebaseUser user) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: RecordDeleteConfirmation(
              record: record,
              user: user,
            ));
      });
}
