import 'package:laziless/services/display_ad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laziless/services/auth.dart';
import 'package:laziless/services/dark_theme.dart';
import 'package:provider/provider.dart';
import 'package:laziless/login/wrapper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>().restartApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();

    getCurrentAppTheme();

    Ads.initialize();

    initializeNotifications();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider<FlutterLocalNotificationsPlugin>(
        create: (BuildContext context) {
          return flutterLocalNotificationsPlugin;
        },
        child: ChangeNotifierProvider(
          create: (_) {
            return themeChangeProvider;
          },
          child: Consumer<DarkThemeProvider>(
              builder: (BuildContext context, value, Widget child) {
            return StreamProvider.value(
              value: AuthService().user,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                routes: <String, WidgetBuilder>{
                  "/Main": (BuildContext context) => Wrapper(),
                },
                theme: Styles.themeData(themeChangeProvider.darkTheme, context),
                home: Wrapper(),
              ),
            );
          }),
        ));
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  void initializeNotifications() {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
}
