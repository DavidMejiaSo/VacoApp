import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SupportService {
  final prefs = PreferenciasUsuario();
  Future<dynamic> enviarPeticion(asunto, descripcion) async {
    String url = '${Env.currentEnv['serverUrl']}/peticion/crear';
    final data = {
      "asunto": asunto,
      "correo": prefs.email,
      "descripcion": descripcion,
    };
    var datadecode = json.encode(data);

    final res = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${prefs.token}',
        },
        body: datadecode);

    dynamic respuesta = json.decode(res.body);
    if (respuesta is Map) {
      return respuesta;
    } else {
      return 'he ocurrido un error';
    }
  }
}
