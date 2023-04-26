import 'dart:convert';

import 'package:prueba_vaco_app/preferences/preferences_user.dart';

import '../enviroment/environment.dart';
import 'package:http/http.dart' as http;

class BagService {
  Future<dynamic> obtenerBolsa() async {
    final prefs = PreferenciasUsuario();
    String url = '${Env.currentEnv['serverUrl']}/productoSorpresa/listar';
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

  Future<dynamic> obtenerBolsaPorRestaurante(String idRestaurante) async {
    final prefs = PreferenciasUsuario();
    String url =
        '${Env.currentEnv['serverUrl']}/productoSorpresaRestaurante/restaurante/listar/habilitados?idRestaurante=$idRestaurante';
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
  Future<dynamic> buscarBolsaPorRestaurante(String idBolsa) async {
    final prefs = PreferenciasUsuario();
    String url =
        '${Env.currentEnv['serverUrl']}/productoSorpresaRestaurante/buscar?id=$idBolsa';
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
