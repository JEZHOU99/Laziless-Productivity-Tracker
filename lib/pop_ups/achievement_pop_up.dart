import 'package:flutter/material.dart';
import 'package:laziless/data/colors.dart';
import 'package:laziless/services/achievement_painter.dart';
import 'package:laziless/tools/pop_up_close.dart';

class AchievementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        height: screenHeight * 0.99,
        width: screenWidth * 0.99,
        child: Column(children: <Widget>[
          PopUpClose(),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 10),
              child: Text(
                "0 / 10",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          ),
          Flexible(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: _achivementList([])))
        ]));
  }
}

_achivementList(List<dynamic> achievements) {
  return ListView(
    physics: BouncingScrollPhysics(),
    children: <Widget>[
      _achivementCard(
          bronzeMain,
          bronzeBorder,
          1,
          achievements.contains("1hoursession"),
          "Reach a session time of 1 hour"),
      _achivementCard(
          silverMain,
          silverBorder,
          2,
          achievements.contains("2hoursession"),
          "Reach a session time of 2 hour"),
      _achivementCard(
          goldMain,
          goldBorder,
          3,
          achievements.contains("3hoursession"),
          "Reach a session time of 3 hour"),
      _achivementCard(
          diamondMain,
          diamondBorder,
          4,
          achievements.contains("4hoursession"),
          "Reach a session time of 4 hour"),
      _achivementCard(
          purpleMain,
          purpleBorder,
          5,
          achievements.contains("5hoursession"),
          "Reach a session time of 5 hour"),
      _achivementCard(
          bronzeMain,
          bronzeBorder,
          5,
          achievements.contains("5hoursperweek"),
          "Be productive for 5 hours in a week"),
      _achivementCard(
          silverMain,
          silverBorder,
          10,
          achievements.contains("10hoursperweek"),
          "Be productive for 10 hours in a week"),
      _achivementCard(
          goldMain,
          goldBorder,
          15,
          achievements.contains("15hoursperweek"),
          "Be productive for 15 hours in a week"),
      _achivementCard(
          diamondMain,
          diamondBorder,
          20,
          achievements.contains("20hoursperweek"),
          "Be productive for 20 hours in a week"),
      _achivementCard(
          purpleMain,
          purpleBorder,
          30,
          achievements.contains("30hoursperweek"),
          "Be productive for 30 hours in a week"),
    ],
  );
}

_achivementCard(Color color, borderColor, number, achieved, description) {
  return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        height: 80,
        child: Card(
          margin: EdgeInsets.fromLTRB(10, 6, 10, 0),
          child: Stack(
            children: <Widget>[
              achieved
                  ? AchievementBackground(color: color.withOpacity(0.6))
                  : Container(),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 8, 4),
                    child: _badges(color, borderColor, number, achieved),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      width: 150,
                      child: achieved
                          ? Text(
                              description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          : Text(
                              description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.5),
                            ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ));
}

_badges(color, borderColor, number, achieved) {
  return achieved
      ? Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: borderColor),
            borderRadius: BorderRadius.circular(40),
            color: color,
          ),
          child: Center(
              child: Container(
                  alignment: Alignment.center,
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white),
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                        fontSize: 30,
                        color: color,
                        fontWeight: FontWeight.w900),
                  ))),
        )
      : Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey.shade200,
          ),
          child: Center(
              child: Container(
                  alignment: Alignment.center,
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white),
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.w900),
                  ))),
        );
}

openAchievementPopUp(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: AchievementPage());
      });
}
