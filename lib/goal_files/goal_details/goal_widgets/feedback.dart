import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';

class FeedBack extends StatelessWidget {
  const FeedBack({Key key, this.goal}) : super(key: key);
  final Goal goal;

  @override
  Widget build(BuildContext context) {
    double percentage = (goal.weeklySeconds / goal.seconds) * 100;
    _getFeedback(goal);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        percentage > 100
            ? Text(
                "Done!",
                style: TextStyle(
                    color: Color(goal.color),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              )
            : Text(
                "${percentage.toStringAsFixed(1)}%",
                style: TextStyle(
                    color: Color(goal.color),
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
        SizedBox(height: 12),
        Flexible(
          child: Container(
            height: 160,
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Scrollbar(
                    child: ListView(
                      physics: ClampingScrollPhysics(),
                      children: <Widget>[
                        Text(
                          _getFeedback(goal),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  _getFeedback(Goal goal) {
    int daysLeft = 7 - DateTime.now().weekday + 1;
    double percentage = (goal.weeklySeconds / goal.seconds) * 100;

    if (goal.seconds == 0) {
      return "No weekly target set";
    }

    //days left = 7
    if (percentage < 20 && daysLeft == 7) {
      return "You have the whole week ahead of you so there is plenty of time to work on this goal. Good Luck!";
    } else if (percentage >= 20 && percentage < 40 && daysLeft == 7) {
      return "You are set up nicely to achieve your goal. Keep up the good work";
    } else if (percentage >= 40 && percentage < 60 && daysLeft == 7) {
      return "Great work you have cut of a significant portion of your goal today! Fantastic first day of the week.";
    } else if (percentage >= 60 && percentage < 80 && daysLeft == 7) {
      return "WOW you have completed the majority of your goal already and it’s only the first day. Keep up the excellent work";
    } else if (percentage >= 80 && percentage < 100 && daysLeft == 7) {
      return "Unbelievable job for almost finishing your goal on the first day of the week! You have a comfortable week ahead of you.";
    } else if (percentage >= 100 && daysLeft == 7) {
      return "Finished! In a day! Eenjoy the week off and don’t forget to work on your other goals if you have any";
    }
    //days left = 6
    else if (percentage < 20 && daysLeft == 6) {
      return "Still early on in the week but try set some time aside to work on this goal";
    } else if (percentage >= 20 && percentage < 40 && daysLeft == 6) {
      return "Keep up the steady pace and you will smash your goal in no time! Keep being consistent you are doing great.";
    } else if (percentage >= 40 && percentage < 60 && daysLeft == 6) {
      return "You are doing great so far! Keep up the good work and make sure you are resting properly.";
    } else if (percentage >= 60 && percentage < 80 && daysLeft == 6) {
      return "You are smashing this goal! Great work just a few more sessions until you complete your goal.";
    } else if (percentage >= 80 && percentage < 100 && daysLeft == 6) {
      return "Wow that was fast! You killed it this week! Remember to spend some time on your other goals if you have any.";
    } else if (percentage >= 100 && daysLeft == 6) {
      return "You finished this goal so early in the week! Take the rest of the week to reset and try tackle a bigger goal next week";
    }
    //days left = 4,5
    else if (percentage < 20 && (daysLeft == 5 || daysLeft == 4)) {
      return "Half the week is almost over so you should probably try make some progress today to make the next few days easier";
    } else if (percentage >= 20 &&
        percentage < 40 &&
        (daysLeft == 5 || daysLeft == 4)) {
      return "Keep up the pace from the past few days and you’ll find yourself close to achieving your goal at the end of the week.";
    } else if (percentage >= 40 &&
        percentage < 60 &&
        (daysLeft == 5 || daysLeft == 4)) {
      return "You are ahead of schedule good job! Keep doing what you’ve been doing and you’ll reach your goal in no time.";
    } else if (percentage >= 60 &&
        percentage < 80 &&
        (daysLeft == 5 || daysLeft == 4)) {
      return "Almost there! Not much longer to go! Take some time to relax you earned it.";
    } else if (percentage >= 80 &&
        percentage < 100 &&
        (daysLeft == 5 || daysLeft == 4)) {
      return "You are pretty much already done! If you are finding this goal too easy consider pushing yourself and increasing the goal!";
    } else if (percentage >= 100 && (daysLeft == 5 || daysLeft == 4)) {
      return "Congratulations! This goal might be a bit too easy for a high-quality specimen like yourself so consider raising it.";
    }
    //days left = 3
    else if (percentage < 20 && daysLeft == 3) {
      return "Not much time left in the week. The weekend is a perfect time to catch up though.";
    } else if (percentage >= 20 && percentage < 40 && daysLeft == 3) {
      return "Looks like you are a little bit behind on your goal this week. You got this!";
    } else if (percentage >= 40 && percentage < 60 && daysLeft == 3) {
      return "You have about half of your goal left to get through. Keep it coming during the weekend";
    } else if (percentage >= 60 && percentage < 80 && daysLeft == 3) {
      return "Nearly there! Hopefully your awesome weekend plans will leave you with some time to finish off this goal.";
    } else if (percentage >= 80 && percentage < 100 && daysLeft == 3) {
      return "In the home stretch now. Not too much longer to go until you complete your goal. Awesome job this week.";
    } else if (percentage >= 100) {
      return "Congratulations on completing your goal before the weekend starts. Take some time to refresh and prepare yourself for next week";
    }
    //days left = 2
    else if (percentage < 20 && daysLeft == 2) {
      return "No worries everyone has these kinds of weeks. It might be better to refresh yourself for a better next week.";
    } else if (percentage >= 20 && percentage < 40 && daysLeft == 2) {
      return "There is no time like the weekend to spend some quality time working towards our goals.";
    } else if (percentage >= 40 && percentage < 60 && daysLeft == 2) {
      return "At the halfway mark here. Squeeze in some more time in over the weekend to finish this goal off!";
    } else if (percentage >= 60 && percentage < 80 && daysLeft == 2) {
      return "Almost done here. Enjoy your weekend but don’t forget to fit in some time to complete this goal. You got this!";
    } else if (percentage >= 80 && percentage < 100 && daysLeft == 2) {
      return "Pretty much done with this one. Its okay to relax but don forget to allocate some of your time to finish off your goal.";
    } else if (percentage >= 100 && daysLeft == 2) {
      return "Nice! Have a good weekend and prepare yourself for a great next week!";
    }
    //days left = 1
    else if (percentage < 20 && daysLeft == 1) {
      return "Its probably too difficult to finish off your goal here. Think about reducing your goal and take today off to refocus";
    } else if (percentage >= 20 && percentage < 40 && daysLeft == 1) {
      return "There still quite a bit of work to do here. It might be better to take the rest of the day off to set yourself up to succeed next week.";
    } else if (percentage >= 40 && percentage < 60 && daysLeft == 1) {
      return "At around the halfway point with this goal. Think about whether it would be better to try smash this out today or rest up to prepare for next week.";
    } else if (percentage >= 60 && percentage < 80 && daysLeft == 1) {
      return "Not too much longer left with this goal. Try to finish it off today if you can! We believe in you!";
    } else if (percentage >= 80 && percentage < 100 && daysLeft == 1) {
      return "So close to the goal! Try do a bit more today! If not then congratulations on making it to this point, we have faith you can get to 100% next week.";
    } else if (percentage >= 100 && daysLeft == 1) {
      return "Good job on completing your goal, give yourself a pat on the back. Now get ready to do it all again tomorow.";
    }
    return "";
  }
}
