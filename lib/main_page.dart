import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laziless/main_goal_page.dart';
import 'package:laziless/pop_ups/settings_pop_up.dart';
import 'package:laziless/services/display_ad.dart';
import 'package:laziless/services/spash_page.dart';
import 'package:laziless/summary_page_widgets/main_summary_page.dart';
import 'package:provider/provider.dart';
import 'data/models.dart';
import 'package:laziless/services/database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 3);
    controller.addListener(() {
      if (controller.indexIsChanging) {
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
    Ads.showBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return user == null
        ? SplashPage()
        : WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              appBar: new PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: new SafeArea(
                    child: Column(
                      children: <Widget>[
                        Expanded(child: Container()),
                        TabBar(
                          controller: controller,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Theme.of(context).canvasColor,
                          indicator: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          tabs: <Tab>[
                            new Tab(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Icon(
                                      FontAwesomeIcons.bullseye,
                                    ),
                                  ),
                                  Text(
                                    "Goals",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                            new Tab(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Icon(
                                      FontAwesomeIcons.chartPie,
                                    ),
                                  ),
                                  Text(
                                    "Statistics",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                            new Tab(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Icon(Icons.settings),
                                  ),
                                  Text(
                                    "Settings",
                                    style: TextStyle(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: new TabBarView(
                controller: controller,
                children: <Widget>[
                  new StreamProvider<List<NotificationData>>.value(
                    initialData: [],
                    value: DatabaseService(uid: user.uid).notificationStream,
                    child: MainGoalPage(
                      user: user,
                    ),
                  ),
                  new StreamProvider<Map>.value(
                    value: DatabaseService(uid: user.uid).recordStream,
                    child: StreamProvider<List<Goal>>.value(
                        value: DatabaseService(uid: user.uid).goalStream,
                        child: MainSummaryPage()),
                  ),
                  new SettingsPage(
                    user: user,
                  )
                ],
              ),
            ));
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit Laziless'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
