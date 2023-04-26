import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../model/controller_arg_restaurantes.dart';
import '../preferences/preferences_user.dart';

class SupermercadoService {
  final prefs = PreferenciasUsuario();
  Future<List> listarSupermercadosAprobados() async {
    String url = '${Env.currentEnv['serverUrl']}/supermercado/listar/aprobado';
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

  Future<List> listarSupermercadosPorCalificacion() async {
    String url =
        '${Env.currentEnv['serverUrl']}/supermercado/listar/promedio/calificacion/descendente';
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

  Future<List> listarSupermercadosPorPedidos() async {
    String url =
        '${Env.currentEnv['serverUrl']}/supermercado/listar/promedio/calificacion/descendente';
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

  static Future<List<OrganizacionRestaurantes>> buscarSupermercado(
      String query) async {
    final prefs = PreferenciasUsuario();

    String url = '${Env.currentEnv['serverUrl']}/supermercado/listar/aprobado';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );

    if (response.statusCode == 200) {
      final List listaSupermercados =
          jsonDecode(utf8.decode(response.bodyBytes));

      return listaSupermercados
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
