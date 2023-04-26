import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';

import '../preferences/preferences_user.dart';

class PromocionesService {
  final prefs = PreferenciasUsuario();

  Future<dynamic> obtenerPromocionesRestaurante() async {
    final prefs = PreferenciasUsuario();
    String url =
        '${Env.currentEnv['serverUrl']}/productoPromocionPorRestaurante/restaurantes';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = json.decode(res.body);
    if (respuesta == null) {
      return [];
    } else {
      return respuesta;
    }
  }

  Future<dynamic> obtenerPromocionesSupermercados() async {
    final prefs = PreferenciasUsuario();
    String url =
        '${Env.currentEnv['serverUrl']}/productoPromocionPorRestaurante/supermercados';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = json.decode(res.body);
    if (respuesta == null) {
      return [];
    } else {
      return respuesta;
    }
  }

  Future<dynamic> obtenerPromocionesProductos() async {
    final prefs = PreferenciasUsuario();
    String url =
        '${Env.currentEnv['serverUrl']}/productoPromocionPorRestaurante/listar/activos';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = json.decode(res.body);

    return respuesta;
  }
}
