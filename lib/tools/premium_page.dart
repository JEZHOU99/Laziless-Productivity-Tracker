import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laziless/services/display_ad.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({Key key}) : super(key: key);

  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  @override
  void initState() {
    Ads.hideBannerAd();
    super.initState();
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Color(0xFF8E2DE2),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 120,
                            color: Colors.transparent,
                            child: Text(
                              "Maybe Later",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 16),
                            )),
                      )),
                )),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Container(
                          height: 70,
                          width: 70,
                          child: Image.asset("assets/images/logo_no_back.png")),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Trial Laziless Pro for 7 free days",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade200),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: 181,
                    child: Column(
                      children: <Widget>[
                        featureTile(Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.bullseye,
                              size: 36,
                              color: Colors.grey.shade200,
                            ),
                            SizedBox(width: 18),
                            Text(
                              "Unlimited Goals",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 18),
                            ),
                          ],
                        )),
                        featureTile(Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.calendarCheck,
                              size: 36,
                              color: Colors.grey.shade200,
                            ),
                            SizedBox(width: 18),
                            Text(
                              "Plan your Week",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 18),
                            ),
                          ],
                        )),
                        featureTile(Row(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.ad,
                                  size: 25,
                                  color: Colors.grey.shade200,
                                ),
                                Icon(
                                  FontAwesomeIcons.ban,
                                  size: 36,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            SizedBox(width: 18),
                            Text(
                              "No Ads",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 18),
                            ),
                          ],
                        )),
                        featureTile(Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child:
                                          Container(color: Color(0xFF262626)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 18),
                            Text("Dark Mode",
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 18)),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /*Text("Be laziless for \$4.99",
                          style: TextStyle(
                              color: Colors.grey.shade300, fontSize: 16)),*/
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            onPressed: () async {},
                            child: Container(
                              alignment: Alignment.center,
                              height: 60,
                              width: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Sounds Good!",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Start my 7 day free trial",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  featureTile(Row row) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 12), child: row);
  }
}
