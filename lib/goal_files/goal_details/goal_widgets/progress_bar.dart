import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key key, this.goal}) : super(key: key);
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double percentage =
        goal.seconds == 0 ? 0 : goal.weeklySeconds / goal.seconds;
    String completedHours = (goal.weeklySeconds / 3600).toStringAsFixed(1);
    String goalHours = (goal.seconds / 3600).toStringAsFixed(1);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "$completedHours / $goalHours hrs",
          style: TextStyle(color: Color(goal.color)),
        ),
        SizedBox(
          height: 4,
        ),
        Flexible(
          child: Container(
            height: (screenHeight * 0.33) + 2,
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                      height: percentage > 0.05
                          ? (screenHeight * 0.33 * percentage) - 2
                          : (screenHeight * 0.33 * percentage),
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(goal.color).withOpacity(0.4))),
                  Container(
                    height: screenHeight * 0.33,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).textSelectionColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 1,
                              color: Theme.of(context).textSelectionColor,
                              width: 12,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "75%",
                              style: TextStyle(
                                  color: Theme.of(context).textSelectionColor),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 1,
                              color: Theme.of(context).textSelectionColor,
                              width: 12,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "50%",
                              style: TextStyle(
                                  color: Theme.of(context).textSelectionColor),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height: 1,
                              color: Theme.of(context).textSelectionColor,
                              width: 12,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "25%",
                              style: TextStyle(
                                  color: Theme.of(context).textSelectionColor),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
