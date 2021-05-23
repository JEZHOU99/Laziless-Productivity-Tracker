import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/pop_ups/new_goal_pop_up.dart';
import 'package:laziless/services/loading_spinner.dart';
import 'goal_tiles.dart';
import 'package:provider/provider.dart';
import 'package:laziless/services/update_service.dart';

class GoalList extends StatefulWidget {
  GoalList({
    Key key,
    this.week,
  }) : super(key: key);
  final int week;
  @override
  GoalListState createState() => GoalListState();
}

class GoalListState extends State<GoalList> {
  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<List<Goal>>(context);
    final records = Provider.of<Map>(context);
    final user = Provider.of<FirebaseUser>(context);

    if (goals != null && records != null) {
      combineRecordAndGoal(goals, records);
      goals.sort((a, b) =>
          (b.weeklySeconds / b.seconds).compareTo(a.weeklySeconds / a.seconds));
    }

    return (goals == null || records == null)
        ? Center(child: LoadingSpinner())
        : goals.length == 0
            ? Center(
                child: GestureDetector(
                  onTap: () {
                    openNewGoalPopUp(context, user);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image(
                            image: AssetImage(
                              'assets/images/goal.png',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(60, 0, 0, 10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "Lets add some goals...",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: goals.length,
                itemBuilder: (BuildContext context, int i) {
                  return GoalTile(week: widget.week, goal: goals[i]);
                },
              );
  }
}
