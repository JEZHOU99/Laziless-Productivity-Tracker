import 'package:flutter/material.dart';
import 'package:laziless/summary_page_widgets/calender.dart';
import 'package:laziless/summary_page_widgets/daily_average_summary/daily_average_summary.dart';
import 'package:laziless/summary_page_widgets/total_time_summary/total_time_summary.dart';
import 'package:provider/provider.dart';
import 'package:laziless/services/update_service.dart';
import 'package:laziless/data/models.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:laziless/services/loading_spinner.dart';

class MainSummaryPage extends StatefulWidget {
  MainSummaryPage({Key key}) : super(key: key);

  @override
  _MainSummaryPageState createState() => _MainSummaryPageState();
}

class _MainSummaryPageState extends State<MainSummaryPage> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    final goals = Provider.of<List<Goal>>(context);
    final records = Provider.of<Map>(context);

    if (goals != null && records != null) {
      combineRecordAndGoal(goals, records);
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            offset: Offset(0, 2),
                            blurRadius: 2,
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: (goals == null || records == null)
                          ? Center(child: LoadingSpinner())
                          : Column(
                              children: <Widget>[
                                Expanded(
                                  flex: 8,
                                  child: PageView(
                                    controller: _pageController,
                                    onPageChanged: (int index) {
                                      _currentPageNotifier.value = index;
                                    },
                                    physics: BouncingScrollPhysics(),
                                    children: <Widget>[
                                      DailyAverageSummary(goals: goals),
                                      TotalTimeSummary(
                                        goals: goals,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 1, child: _buildCircleIndicator())
                              ],
                            )),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              offset: Offset(0, 2),
                              blurRadius: 2,
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: (goals == null || records == null)
                            ? Center(child: LoadingSpinner())
                            : Calendar(
                                records: records,
                                goals: goals,
                              )),
                  )),
              SizedBox(
                height: 20,
              )
            ],
          )
        ],
      ),
    );
  }

  _buildCircleIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CirclePageIndicator(
        itemCount: 2,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
