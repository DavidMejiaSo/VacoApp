import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/notifications/Notifications.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/routes/routes.dart';

void main() async {
  final prefs = PreferenciasUsuario();
  WidgetsFlutterBinding();
  WidgetsFlutterBinding.ensureInitialized();
  await prefs.iniciarPreferencias();
  await PushNotificationService.initializeApp();

  //activar al  generar una nueva apk
  //prefs.token = "";

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    PushNotificationService.streamController.listen((message) {
      print("My app: $message");
    });
  }

  Widget build(BuildContext context) {
    return const Routes();
  }
}
