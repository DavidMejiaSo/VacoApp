import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/model/controller_toppigs.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/service/login_service.dart';

import '../preferences/preferences_user.dart';

class ProductsService {
  final LoginService login = LoginService();
  final prefs = PreferenciasUsuario();

  Future<List>? mostrar() async {
    final prefs = PreferenciasUsuario();
    String url = '${Env.currentEnv['serverUrl']}/producto/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    List respuesta = json.decode(res.body);

    return respuesta;
  }

  Future<dynamic> obtenerProducto(idProducto) async {
    String url =
        '${Env.currentEnv['serverUrl']}/productoRestaurante/buscar?id=$idProducto';

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = jsonDecode(utf8.decode(res.bodyBytes));

    if (res.statusCode == 200) {
      return respuesta;
    }
  }

  Future<List>? obtenerProductoPorRestaurante(idProducto) async {
    String url =
        '${Env.currentEnv['serverUrl']}/productoRestaurante/restaurante/listar/habilitados?idRestaurante=$idProducto';

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

  Future<List>? obtenerProductoPorRestauranteSegunID(
      idRestaurante, idProductos) async {
    String url =
        '${Env.currentEnv['serverUrl']}/productoRestaurante/restaurante/listar/habilitados?idRestaurante=$idRestaurante';

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );

    dynamic respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    List ListaProductosEnPromocion = [];
    for (var i = 0; i < respuesta.length; i++) {
      for (var j = 0; j < idProductos.length; j++) {
        if (respuesta[i]['id'] == idProductos[j]) {
          ListaProductosEnPromocion.add(respuesta[i]);
        } else {}
      }
    }

    return ListaProductosEnPromocion;
  }

  Future<Map> obtenerProductoDelRestaurante(idProducto) async {
    dynamic respuesta;
    String url =
        '${Env.currentEnv['serverUrl']}/productoRestaurante/buscar?id=$idProducto';

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    if (res.statusCode == 500) {
      respuesta = {"respuesta": "mongo: no douments in result"};
    } else {
      respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    }
    return respuesta;
  }

  Future<dynamic> obtenerTopping(idTopping) async {
    String url = '${Env.currentEnv['serverUrl']}/topping/buscar?id=$idTopping';

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = jsonDecode(utf8.decode(res.bodyBytes));

    ToppingsModel _toppingsModel = ToppingsModel.fromJson(respuesta);

    return _toppingsModel;
  }

  Future<List>? obtenerToppings() async {
    String url = '${Env.currentEnv['serverUrl']}/topping/listar';

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    List arreglo = [];

    dynamic respuesta = json.decode(res.body);
    arreglo.add(respuesta);
    return arreglo;
  }
}
