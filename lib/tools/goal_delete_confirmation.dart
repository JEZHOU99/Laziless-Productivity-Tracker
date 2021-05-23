import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/services/update_service.dart';
import 'package:laziless/tools/pop_up_close.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class GoalDeleteConfirmation extends StatelessWidget {
  const GoalDeleteConfirmation({
    Key key,
    this.goal,
    this.user,
  }) : super(key: key);

  final Goal goal;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        Provider.of<FlutterLocalNotificationsPlugin>(context);

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
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text(
                      "Are you sure you want to delete this Goal?",
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
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            _goalPreview(),
                          ],
                        ),
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
                          deleteGoalService(
                              user, goal, flutterLocalNotificationsPlugin);
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        width: 250,
                        foregroundColor: Theme.of(context).primaryColor,
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

  _goalPreview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(goal.color)),
        ),
        SizedBox(width: 10),
        Text(
          goal.name,
          style: TextStyle(
            fontSize: 20,
            color: Color(goal.color),
          ),
        ),
      ],
    );
  }
}

confrimGoalDelete(context, Goal goal, FirebaseUser user) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: GoalDeleteConfirmation(goal: goal, user: user));
      });
}
