import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_flutternotification');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(
      int id, String? title, String? body, int seconds) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "CHANNEL_ID",
          "CHANNEL_NAME",

          //'Main channel notifications',
          importance: Importance.max,
          priority: Priority.max,
          enableVibration: true,
          //icon: '@drawable/ic_flutternotification'
        ),
        iOS: IOSNotificationDetails(
          //sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
//import 'package:prueba_vaco_app/src/pages/orders/order_status.dart';
//
//class NotificationApi {
//  static final _notifcations = flutterLocalNotificationsPlugin;
//  static Future _notificationDetails() async {
//    return NotificationDetails(
//      android: AndroidNotificationDetails('channel id', 'channel name',
//          //'channel description',
//          importance: Importance.max,
//          priority: Priority.max),
//    );
//  }
//
//  Future showNotification({
//    int id = 0,
//    String? title = '',
//    String? body = '',
//    String? payload = '',
//  }) async =>
//      _notifcations.show(
//        id,
//        title,
//        body,
//        await _notificationDetails(),
//        payload: payload,
//      );
//}
//