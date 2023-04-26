import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../preferences/preferences_user.dart';

class FavoriteProductsService {
  final prefs = PreferenciasUsuario();
  Future<dynamic> traer() async {
    String usuario = prefs.usuario;
    String url = '${Env.currentEnv['serverUrl']}/usuario?usuario=$usuario';

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );
    dynamic respuesta = json.decode(res.body);
    if (respuesta is Map) {
      return respuesta;
    } else {
      return respuesta;
    }
  }

  Future<dynamic> traerIdProductosFavoritos() async {
    String usuario = prefs.usuario;
    String url = '${Env.currentEnv['serverUrl']}/usuario?usuario=$usuario';

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );
    dynamic respuesta = json.decode(res.body);
    if (respuesta is Map) {
      List listaProductosFavoritos = [];
      listaProductosFavoritos = respuesta["idListaProductosFavoritos"];
      return listaProductosFavoritos;
    } else {
      return respuesta;
    }
  }

  Future<dynamic> addFavoriteProduct(
    idUsuario,
    idProducto,
  ) async {
    final url =
        '${Env.currentEnv['serverUrl']}/usuarios/agregarProductosFavoritos?usuario=$idUsuario&producto=$idProducto';

    final res = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );

    final respuesta = json.decode(res.body);

    return respuesta;
  }

  Future<dynamic> deleteFavoriteProduct(
    idUsuario,
    idProducto,
  ) async {
    final url =
        '${Env.currentEnv['serverUrl']}/usuarios/eliminarProductosFavoritos?usuario=$idUsuario&producto=$idProducto';

    final res = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );

    final respuesta = json.decode(res.body);

    return respuesta;
  }
}
