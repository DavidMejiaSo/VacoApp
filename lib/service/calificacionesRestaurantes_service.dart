import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/model/controller_arg_restaurantes_calificados.dart';

import '../preferences/preferences_user.dart';

class restaurantesCalificadosService {
  final prefs = PreferenciasUsuario();
  Future<List<restaurantesCalificados>>? mostrar() async {
    List<restaurantesCalificados>? calificacionesRestaurantes = [];
    String url = '${Env.currentEnv['serverUrl']}/valoresCalificacion/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    for (var i = 0; i < respuesta.length; i++) {
      restaurantesCalificados calificacionesRest =
          restaurantesCalificados.fromJson(
        respuesta[i],
      );
      calificacionesRestaurantes.add(calificacionesRest);
    }
    return calificacionesRestaurantes;
  }

  Future<dynamic> obtenerPromedioRestaurante(String id) async {
    String url =
        '${Env.currentEnv['serverUrl']}/valoresCalificacion/promedio/restaurante?idRestaurante=$id';
    print(id);
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );
    dynamic respuesta = json.decode(res.body);

    return respuesta;
  }

  Future<dynamic> obtenerCalificacionesRestaurante(String id) async {
    String url =
        '${Env.currentEnv['serverUrl']}/valoresCalificacion/listar/restaurante?idRestaurante=$id';

    print(id);
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
