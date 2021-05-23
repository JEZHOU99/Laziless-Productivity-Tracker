import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/goal_files/goal_details/goal_details_expanded.dart';
import 'package:laziless/goal_files/goal_details/goal_details_overview.dart';
import 'package:laziless/goal_files/goal_details/goal_details_planner.dart';
import 'package:laziless/pop_ups/edit_goal_pop_up.dart';
import 'package:laziless/services/update_service.dart';
import 'package:laziless/tools/goal_delete_confirmation.dart';
import 'package:laziless/tools/pop_up_close.dart';
import 'package:laziless/tools/small_buttons.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';
import 'goal_details_stats.dart';

class GoalDetails extends StatelessWidget {
  GoalDetails({Key key, this.goal, this.user}) : super(key: key);
  final Goal goal;
  final FirebaseUser user;

  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final planRecords = Provider.of<Map>(context);
    combineRecordAndPlans(goal.recordHistory, planRecords, goal);

    final notificationList = Provider.of<List<NotificationData>>(context);
    combineGoalAndNotification(goal, notificationList);
    return Container(
      height: screenHeight - 120,
      width: screenWidth,
      child: Column(
        children: <Widget>[
          PopUpClose(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SmallRaisedButton(
                      text: "Edit",
                      icon: Icons.edit,
                      onpressed: () {
                        openEditGoalPopUp(context, goal, user);
                      },
                    ),
                    SmallRaisedButton(
                      text: "Delete",
                      icon: Icons.delete,
                      onpressed: () {
                        confrimGoalDelete(context, goal, user);
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(goal.color)),
                      ),
                      SizedBox(width: 12),
                      goal.name.length >= 11
                          ? Expanded(
                              child: Text(
                                goal.name,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(goal.color), fontSize: 20),
                              ),
                            )
                          : Text(
                              goal.name,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(goal.color), fontSize: 20),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 19,
              child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    _currentPageNotifier.value = index;
                  },
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    GoalDetailsOverview(goal: goal),
                    GoalDetailsPlanner(
                      goal: goal,
                    ),
                    GoalDetailsStats(goal: goal),
                    GoalDetailsExpanded(goal: goal)
                  ])),
          Expanded(flex: 1, child: _buildCircleIndicator())
        ],
      ),
    );
  }

  _buildCircleIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CirclePageIndicator(
        selectedDotColor: Color(goal.color),
        dotColor: Color(0x509E9E9E),
        itemCount: 4,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
