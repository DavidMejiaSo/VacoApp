import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class CartSevice {
  final prefs = PreferenciasUsuario();
  Future<dynamic> listarCarrito() async {
    String usuario = prefs.usuario;
    print(usuario);
    String url =
        '${Env.currentEnv['serverUrl']}/carrito/usuario/listar?idUsuario=$usuario';

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

  Future<dynamic> agregarACarrito(
    String idUsuario,
    String idProducto,
    List listaAdicionales,
  ) async {
    String url = '${Env.currentEnv['serverUrl']}/carrito/crear';

    final data = {
      "idUsuario": idUsuario,
      "idProducto": idProducto,
      "listTopping": listaAdicionales,
    };
    var datadecode = json.encode(data);
    final res = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${prefs.token}',
        },
        body: datadecode);
    print("status en la creacion del carrito ${res.statusCode}");
    dynamic respuesta = json.decode(res.body);
    return respuesta;
  }

  Future<dynamic> limpiarCarrito(
    idUsuario,
  ) async {
    final url =
        '${Env.currentEnv['serverUrl']}/carrito/eliminar?idUsuario=$idUsuario';

    final res = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );

    final respuesta = json.decode(res.body);

    return respuesta;
  }

  Future<dynamic> eliminarProducto(idProducto) async {
    final url =
        '${Env.currentEnv['serverUrl']}/carrito/eliminarProducto?id=$idProducto';

    final res = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );
    final respuesta = json.decode(res.body);

    return respuesta;
  }

  Future<dynamic> eliminarToppingCarrito(idCarrito, idTopping) async {
    final url =
        '${Env.currentEnv['serverUrl']}/carrito/eliminar/adicional?id=$idCarrito&idTopping=$idTopping';

    final res = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );
    final respuesta = json.decode(res.body);

    return respuesta;
  }

  Future<dynamic> adicionarToppingCarrito(idCarrito, idTopping) async {
    final url =
        '${Env.currentEnv['serverUrl']}/carrito/agregar/adicional?id=$idCarrito&idTopping=$idTopping';

    final res = await http.patch(
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
