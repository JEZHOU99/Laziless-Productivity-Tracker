import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        Provider.of<FlutterLocalNotificationsPlugin>(context);

    Future<List<PendingNotificationRequest>> notificationFuture =
        flutterLocalNotificationsPlugin.pendingNotificationRequests();

    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "Notifications",
          child: Material(
            color: Colors.transparent,
            child: Text(
              "Notifications",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 100),
        child: Column(
          children: <Widget>[
            Flexible(
              child: FutureBuilder<List<PendingNotificationRequest>>(
                future: notificationFuture,
                initialData: [],
                builder: (context, snapshot) {
                  final notificationsList = snapshot.data;
                  return ListView.builder(
                      itemCount: notificationsList.length,
                      itemBuilder: (context, index) {
                        final notification = notificationsList[index];
                        return Card(
                          child: ListTile(
                            title: Text(notification.title),
                            subtitle: Text(notification.body),
                            leading: Text(notification.id.toString()),
                          ),
                        );
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
