import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../model/controller_arg_notifications.dart';
import '../preferences/preferences_user.dart';

class notificationService {
  final prefs = PreferenciasUsuario();
  Future<List<infoNotificaciones>>? mostrar() async {
    List<infoNotificaciones>? listNotification = [];
    String url = '${Env.currentEnv['serverUrl']}/notificacion/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    List respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    for (var i = 0; i < respuesta.length; i++) {
      infoNotificaciones infoNotifications = infoNotificaciones.fromJson(
        respuesta[i],
      );
      listNotification.add(infoNotifications);
    }
    return listNotification;
  }

  Future<dynamic>? obtenerNotificaciones() async {
    String url = '${Env.currentEnv['serverUrl']}/notificacion/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    return respuesta;
  }
}
