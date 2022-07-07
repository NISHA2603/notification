import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification/models/pushnotification_model.dart';
import 'package:notification/screens/notification_badge.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FirebaseMessaging _messaging;
  late int _totalNotificationCount;
  PushNotificationModel? _notificationInfo;

  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.instance.getToken().then((value) {
      print("================FCM=================== > " + value.toString());
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted the permission");
    } else {
      print("permission declined by user");
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      PushNotificationModel notification = PushNotificationModel(
        title: message.notification!.title,
        body: message.notification!.body,
        dataBody: message.data['body'],
        dataTitle: message.data['title'],
      );
      setState(() {
        _totalNotificationCount++;
        _notificationInfo = notification;
      });

      if (notification != null) {
        showSimpleNotification(
          Text(_notificationInfo!.title!),
          leading: NotificationBadge(totalNotication: _totalNotificationCount),
          subtitle: Text(_notificationInfo!.body!),
          background: Colors.cyan.shade700,
          duration: Duration(minutes: 2),
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotificationModel notification = PushNotificationModel(
        title: message.notification!.title,
        body: message.notification!.body,
        dataBody: message.data['body'],
        dataTitle: message.data['title'],
      );
      setState(() {
        _totalNotificationCount++;
        _notificationInfo = notification;
      });
    });

    registerNotification();
    _totalNotificationCount = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Push Notification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "FlutterPushNotification",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            NotificationBadge(totalNotication: _totalNotificationCount),
            _notificationInfo != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "TITLE : ${_notificationInfo!.dataTitle ?? _notificationInfo!.title}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Text(
                        "TITLE : ${_notificationInfo!.dataBody ?? _notificationInfo!.body}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
