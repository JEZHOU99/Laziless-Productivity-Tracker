import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laziless/services/database.dart';
import 'package:laziless/services/display_ad.dart';
import 'package:laziless/services/fade_in_animation.dart';
import 'package:laziless/services/get_date.dart';
import 'package:laziless/tools/onboarding_tutorial.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'goal_files/goal_list.dart';
import 'package:laziless/pop_ups/new_goal_pop_up.dart';
import 'data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainGoalPage extends StatefulWidget {
  MainGoalPage({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _MainGoalPageState createState() => _MainGoalPageState();
}

class _MainGoalPageState extends State<MainGoalPage> {
  int week = 0;
  Settings settings = Settings();
  bool loading = true;

  void initState() {
    super.initState();
    _onboardingCompleteCheck();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (settings.onboardingComplete != true && loading == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OnboardingTutorial()),
          ).then((value) {
            Ads.showBannerAd();
          }));
      _onboardingCompleted();
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: height,
          width: width,
          child: Column(
            children: <Widget>[
              Flexible(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(2, 4),
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ],
                        color: Theme.of(context).cardColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 6, 10, 12),
                              child: OpacityIn(
                                delay: 1.4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "${DateFormat("dd/MM").format(getstartDate(0))} - ${DateFormat("dd/MM").format(getendDate(0))}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.8)),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                OnboardingTutorial()))
                                                    .then((value) {
                                                  Ads.showBannerAd();
                                                });
                                              },
                                              child: Icon(
                                                FontAwesomeIcons.question,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            offset: Offset(0, 2),
                                            blurRadius: 2,
                                            spreadRadius: 0,
                                          )
                                        ],
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: StreamProvider<Map>.value(
                                value: DatabaseService(uid: widget.user.uid)
                                    .recordStream,
                                child: StreamProvider<List<Goal>>.value(
                                  value: DatabaseService(
                                    uid: widget.user.uid,
                                  ).goalStream,
                                  child: GoalList(
                                    week: week,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: OpacityIn(
                                delay: 1.4,
                                child: Container(
                                  height: 50,
                                  width: 175,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            openNewGoalPopUp(
                                                context, widget.user);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.add,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                "Add A Goal",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(0, 2),
                                        blurRadius: 2,
                                        spreadRadius: 0,
                                      )
                                    ],
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
              SizedBox(height: 30)
            ],
          ),
        ));
  }

  _onboardingCompleteCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      settings.onboardingComplete = prefs.getBool("Onboarding Complete");
      loading = false;
    });
  }

  _onboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      prefs.setBool("Onboarding Complete", true);
      settings.onboardingComplete = true;
    });
  }
}
