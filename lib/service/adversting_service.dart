import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdverstingService {
  final prefs = PreferenciasUsuario();
  Future<List>? allAdversting() async {
    String url = '${Env.currentEnv['serverUrl']}/comprasPublicidad/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    List publicidadVisible = [];
    for (var i = 0; i < respuesta.length; i++) {
      if (respuesta[i]['visibilidad'].toString() == 'true') {
        publicidadVisible.add(respuesta[i]);
      }
    }
    return publicidadVisible;
  }
}
