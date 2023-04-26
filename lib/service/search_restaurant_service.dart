import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../model/controller_arg_restaurantes.dart';
import '../preferences/preferences_user.dart';

class SearchRestaurantService {
  static Future<List<OrganizacionRestaurantes>> getRestaurants(
      String query) async {
    final prefs = PreferenciasUsuario();

    String url = '${Env.currentEnv['serverUrl']}/restaurante/listar';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );

    if (response.statusCode == 200) {
      final List users = jsonDecode(utf8.decode(response.bodyBytes));

      return users
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
