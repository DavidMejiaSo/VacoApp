import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/model/controller_arg_tipos_restaurantes.dart';

import '../preferences/preferences_user.dart';

class CategoriaRestauranteService {
  final prefs = PreferenciasUsuario();
  Future<List<categoriasRestaurantes>>? mostrar() async {
    List<categoriasRestaurantes>? listaCategoriaRestaurantes = [];
    String url =
        '${Env.currentEnv['serverUrl']}/listar/categoria/restaurante/unicos';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    for (var i = 0; i < respuesta.length; i++) {
      categoriasRestaurantes categoriaRestaurante =
          categoriasRestaurantes.fromJson(
        respuesta[i],
      );
      listaCategoriaRestaurantes.add(categoriaRestaurante);
    }
    return listaCategoriaRestaurantes;
  }

  Future<dynamic> otenerUnaCategoria(String id) async {
    String url =
        '${Env.currentEnv['serverUrl']}/buscar/categoria/restaurante?id=$id';
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
