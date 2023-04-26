import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../preferences/preferences_user.dart';

class GetUserInfoService {
  final prefs = PreferenciasUsuario();
  Future<dynamic> getInfo() async {
    final url =
        '${Env.currentEnv['serverUrl']}/usuario?usuario=${prefs.usuario}';

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
