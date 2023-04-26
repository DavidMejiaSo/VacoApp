import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  dynamic notiProvider;

  static String? token;
  static StreamController<String> _streamController =
      new StreamController.broadcast();

  static Stream<String> get streamController => _streamController.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    //print('_backgroundHandler ${message.messageId}');
    _streamController.add(message.notification?.title ?? "No Title");

//
    //  NotificationListenProvider.notificationNew = true;
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //print('_onMessageHandler ${message.messageId}');
    _streamController.add(message.notification?.title ?? "No Title");
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //print('_onMessageOpenAppHandler ${message.messageId}');
    _streamController.add(message.notification?.title ?? "No Title");
    // dynamic notiProvider =
    //     Provider.of<NotificationListenProvider>(listen: true);
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('este es el token de la app:$token.');
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static closeStreamsb() {
    _streamController.close();
  }
}
