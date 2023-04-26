import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../preferences/preferences_user.dart';

class ChangeUserInfoService {
  final prefs = PreferenciasUsuario();
  Future<dynamic> changeInfo(campo, valor) async {
    final url =
        '${Env.currentEnv['serverUrl']}/usuarios?usuario=${prefs.usuario}';

    final data = {
      "$campo": "$valor",
    };
    var datadecode = json.encode(data);

    final res = await http.put(
      Uri.parse(url),
      body: datadecode,
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );
    print(res.statusCode);
    print(datadecode);

    Map respuesta = json.decode(res.body);
    print(respuesta);
    return respuesta;
  }
}
