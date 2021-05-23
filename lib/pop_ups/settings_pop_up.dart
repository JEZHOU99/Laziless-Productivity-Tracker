import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laziless/services/update_service.dart';
import 'package:laziless/login/sign_up.dart';
import 'package:laziless/pop_ups/settings_pages/contact_page.dart';
import 'package:laziless/pop_ups/settings_pages/dark_mode.dart';
import 'package:laziless/pop_ups/settings_pages/privacy_policy.dart';
import 'package:laziless/services/auth.dart';
import 'package:laziless/services/display_ad.dart';
import 'package:laziless/tools/account_delete_reset.dart';
import 'package:laziless/tools/delete_confirmation.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({this.user});

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        Provider.of<FlutterLocalNotificationsPlugin>(context);

    return Scaffold(
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 110),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16, right: 8.0, bottom: 16),
                    child: Column(
                      children: <Widget>[
                        Card(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  child: profileTile(user)),
                            ],
                          ),
                        ),
                        Text("id: ${user.uid}",
                            style: TextStyle(
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          /*SettingsTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationPage()));
                              },
                              title: "Notifications"),*/
                          SettingsTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DarkMode()));
                              },
                              title: "Dark Mode"),
                          SettingsTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ContactPage(
                                              user: user,
                                            )));
                              },
                              title: "Contact Us"),
                          SettingsTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PrivacyPolicy()));
                              },
                              title: "Privacy Policy"),
                          SettingsTile(
                              onTap: () {
                                openResetDeleteConfirmation(
                                    context,
                                    "Are you sure you want to reset all your data?",
                                    Text(
                                      "This will delete all your goals and cancel all your notifications",
                                      textAlign: TextAlign.center,
                                    ), () {
                                  flutterLocalNotificationsPlugin.cancelAll();
                                  resetUserData(user);
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                });
                              },
                              title: "Reset Data"),
                          ResetPasswordTile(user: user),
                          SettingsTile(
                              onTap: () {
                                openResetDeleteConfirmation(
                                    context,
                                    "Are you sure you want to DELETE this account?",
                                    Text(
                                      "This will permantly erase all data in this account",
                                      textAlign: TextAlign.center,
                                    ), () async {
                                  await deleteUserData(user);
                                  await _auth.deleteUser();
                                  flutterLocalNotificationsPlugin.cancelAll();
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                });
                              },
                              title: "Delete Account"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 60, 50),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: logOutLogInButton(
                      user, context, flutterLocalNotificationsPlugin)),
            ),
          ],
        ),
      ),
    );
  }
}

logOutLogInButton(FirebaseUser user, context,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  if (user.isAnonymous == true) {
    return Hero(
      tag: "Sign In Out",
      child: Stack(
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen(
                                    convert: true,
                                  ))).then((value) {
                        Ads.showBannerAd();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Sign Up!",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ))),
          )
        ],
      ),
    );
  } else {
    return Hero(
      tag: "Sign In Out",
      child: Stack(
        children: <Widget>[
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      openGeneralDeleteConfirmation(
                          context,
                          "Are you sure you want to log out of this account?",
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                user.photoUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          user.photoUrl,
                                          height: 40,
                                          width: 40,
                                        ),
                                      )
                                    : Container(),
                                SizedBox(height: 8),
                                Text(user.email ?? "")
                              ],
                            ),
                          ), () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        flutterLocalNotificationsPlugin.cancelAll();
                        Ads.hideBannerAd();
                        AuthService().signOut();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Log Out",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                            user.photoUrl != null
                                ? Container(
                                    height: 40,
                                    width: 40,
                                    child: Stack(
                                      children: <Widget>[
                                        Center(
                                            child: Container(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator())),
                                        Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: FadeInImage.memoryNetwork(
                                              image: user.photoUrl,
                                              height: 30,
                                              width: 30,
                                              placeholder: kTransparentImage,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: 40,
                                    width: 40,
                                  )
                          ],
                        ),
                      ),
                    ))),
          )
        ],
      ),
    );
  }
}

profileTile(FirebaseUser user) {
  if (user.isAnonymous) {
    return ListTile(
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Icon(
              FontAwesomeIcons.userSecret,
              size: 80,
            )),
        title: Text("Anonymous"),
        subtitle: Text("Sign up to secure your progress!"));
  } else if (user.photoUrl == null && user.displayName == null) {
    return ListTile(
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Icon(
            FontAwesomeIcons.userCircle,
            size: 45,
          )),
      title: Text(user.email),
      subtitle: Text("Hi there!"),
    );
  } else {
    return ListTile(
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(user.photoUrl)),
        title: Text(user.displayName),
        subtitle: Text(user.email));
  }
}

openSettingPopUp(context, FirebaseUser user) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: SettingsPage(user: user));
      });
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({Key key, this.onTap, this.title}) : super(key: key);
  final Function onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 8, 10),
        child: Card(
          child: ListTile(
            onTap: onTap,
            title: Hero(
              tag: title,
              child: Material(
                color: Colors.transparent,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ));
  }
}

class ResetPasswordTile extends StatelessWidget {
  const ResetPasswordTile({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 8, 10),
        child: Card(
          child: ListTile(
            onTap: user.isAnonymous
                ? () {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Text(
                          "You need to be signed in before you can reset a password",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      duration: Duration(seconds: 3),
                    ));
                  }
                : () async {
                    dynamic result = await _auth.resetPassword(user.email);
                    if (result == null) {
                      final String errorMsg = _auth.errorMsg;
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Text(
                            errorMsg,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        duration: Duration(seconds: 3),
                      ));
                    } else {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Padding(
                          padding: EdgeInsets.only(bottom: 40),
                          child: Text(
                            "An email with details on how to reset your password has been sent to ${user.email}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        duration: Duration(seconds: 3),
                      ));
                    }
                  },
            title: Hero(
              tag: "Change Password",
              child: Material(
                color: Colors.transparent,
                child: Text(
                  "Change Password",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ));
  }
}
