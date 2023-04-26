import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/model/controller_arg_productoProm.dart';

import '../preferences/preferences_user.dart';

class ProductoPromocionService {
  final prefs = PreferenciasUsuario();
  Future<List<productoProm>>? mostrar() async {
    List<productoProm>? productosPromo = [];
    String url = '${Env.currentEnv['serverUrl']}/productoPromocion/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    for (var i = 0; i < respuesta.length; i++) {
      productoProm productoPromo = productoProm.fromJson(
        respuesta[i],
      );
      productosPromo.add(productoPromo);
    }
    return productosPromo;
  }

  Future<dynamic> obtenerPromocionProducto(String id) async {
    dynamic respuesta;
    String url =
        '${Env.currentEnv['serverUrl']}/productoPromocion/buscar?id=$id';
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
}
