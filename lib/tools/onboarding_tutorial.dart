import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laziless/services/display_ad.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingTutorial extends StatefulWidget {
  final bool firstTimeOnboarding;
  OnboardingTutorial({Key key, this.firstTimeOnboarding}) : super(key: key);

  @override
  _OnboardingTutorialState createState() => _OnboardingTutorialState();
}

class _OnboardingTutorialState extends State<OnboardingTutorial> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();
    _onboardingComplete();
    Ads.hideBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.1, 0.4, 0.7, 0.9],
                  colors: [
                    Color(0xFF005A9F),
                    Color(0xFF0091A8),
                    Color(0xFF1BC6DF),
                    Color(0xFF27ABB5)
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: widget.firstTimeOnboarding == true
                            ? () {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              }
                            : () {
                                Navigator.of(context).pop();
                              },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: PageView(
                            controller: _pageController,
                            onPageChanged: (int index) {
                              setState(() {
                                _currentPageNotifier.value = index;
                              });
                            },
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage(
                                        'assets/images/add.png',
                                      ),
                                    )),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(80, 20, 80, 20),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'First things first.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 22.0,
                                        ),
                                      ),
                                      Text(
                                        'Lets add a Goal!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 22.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage(
                                        'assets/images/record.png',
                                      ),
                                    )),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(80, 20, 80, 20),
                                  child: Text(
                                    'Long press the activity to start recording',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage(
                                        'assets/images/goalStat.png',
                                      ),
                                    )),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(60, 20, 60, 20),
                                  child: Text(
                                    "Tap on a goal's percentage to see dedicated statistics",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    height: 300,
                                    width: 300,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage(
                                        'assets/images/weekStat.png',
                                      ),
                                    )),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(60, 20, 60, 20),
                                  child: Text(
                                    "Check your daily and weekly statistics",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ])),
                    _buildCircleIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 20.0,
                      ),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: _currentPageNotifier.value == 3
                            ? FlatButton(
                                onPressed: widget.firstTimeOnboarding == true
                                    ? () {
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                      }
                                    : () {
                                        Navigator.of(context).pop();
                                      },
                                child: Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  ),
                                ),
                              )
                            : FlatButton(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onboardingComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("Onboarding Complete", true);
  }

  _buildCircleIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CirclePageIndicator(
        selectedDotColor: Colors.white,
        dotColor: Colors.white.withOpacity(0.3),
        itemCount: 4,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
