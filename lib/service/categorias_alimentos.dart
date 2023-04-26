import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/model/controller_arg_productos.dart';

import '../preferences/preferences_user.dart';

class ProductoCategoriaService {
  final prefs = PreferenciasUsuario();
  Future<List<categoriasProductos>>? mostrar(String idSocio) async {
    List<categoriasProductos>? listaCategoriaProductos = [];
    String url = '${Env.currentEnv['serverUrl']}/categoria/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );
    List respuesta = json.decode(res.body);
    List respuestaFiltrada = [];
    for (var i = 0; i < respuesta.length; i++) {
      if (respuesta[i]['idUsuarioCreador'] == idSocio) {
        respuestaFiltrada.add(respuesta[i]);
      }
    }
    for (var i = 0; i < respuestaFiltrada.length; i++) {
      categoriasProductos categoriaProducto = categoriasProductos.fromJson(
        respuestaFiltrada[i],
      );
      listaCategoriaProductos.add(categoriaProducto);
    }
    return listaCategoriaProductos;
  }
}
