import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../preferences/preferences_user.dart';

class SearchRestaurantByIDService {
  final prefs = PreferenciasUsuario();
  Future<dynamic> getRestaurant(restaurant) async {
    String url =
        '${Env.currentEnv['serverUrl']}/restaurante/buscar?ID=$restaurant';
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
