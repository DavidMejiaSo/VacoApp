import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../model/controller_arg_restaurantes.dart';
import '../preferences/preferences_user.dart';

class RestaurantService {
  final prefs = PreferenciasUsuario();
  Future<List> listarRestaurantesAprobados() async {
    String url = '${Env.currentEnv['serverUrl']}/restaurante/listar/aprobado';
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

  Future<List> listarRestaurantesPorPedidos() async {
    String url =
        '${Env.currentEnv['serverUrl']}/restaurante/listar/cantidad/pedidos/descendente';
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

  Future<List> listarRestaurantesPorCalificacion() async {
    String url =
        '${Env.currentEnv['serverUrl']}/restaurante/listar/promedio/calificacion/descendente';
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

  Future<dynamic>? obtenerRestaurante(String id) async {
    String url = '${Env.currentEnv['serverUrl']}/restaurante/buscar?ID=$id';
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

  Future<dynamic>? obtenerPromedio(String id) async {
    String url =
        '${Env.currentEnv['serverUrl']}/valoresCalificacion/promedio/restaurante?idRestaurante=$id';
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

  static Future<List<OrganizacionRestaurantes>> buscarRestaurante(
      String query) async {
    final prefs = PreferenciasUsuario();

    String url = '${Env.currentEnv['serverUrl']}/restaurante/listar/aprobado';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );

    if (response.statusCode == 200) {
      final List listaRestaurantes =
          jsonDecode(utf8.decode(response.bodyBytes));

      return listaRestaurantes
          .map((json) => OrganizacionRestaurantes.fromJson(json))
          .where((user) {
        final nameLower = user.nombre?.toLowerCase();
        final queryLower = query.toLowerCase();

        return nameLower!.contains(queryLower);
      }).toList();
    } else {
      throw Exception();
    }
  }
}
