import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class OrderService {
  final prefs = PreferenciasUsuario();

  Future<dynamic> crearOrden(
      String idUsuario,
      String idRestaurante,
      String total,
      String metodoPago,
      List productos,
      List idCajasSorpresas,
      List listaAdicionales,
      String observacion,
      String denominacionBillete) async {
    String url = '${Env.currentEnv['serverUrl']}/pedido/crear';

    final data = {
      "idCliente": idUsuario == '' ? '' : idUsuario,
      "idRestaurante": idRestaurante == '' ? '' : idRestaurante,
      "precio": total == '' ? '' : total,
      "metodoPago": metodoPago == '' ? '' : metodoPago,
      "productos": productos.isEmpty ? [] : productos,
      "toppings": listaAdicionales.isEmpty ? [] : listaAdicionales,
      "observaciones": observacion == '' ? '' : observacion,
      "productosSorpresa": idCajasSorpresas.isEmpty ? [] : idCajasSorpresas,
      "efectivo": denominacionBillete == '' ? '' : denominacionBillete
    };
    var datadecode = json.encode(data);
    final res = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${prefs.token}',
        },
        body: datadecode);
    print("status en la creacion del pedido ${res.statusCode}");
    dynamic respuesta = json.decode(res.body);
    return respuesta;
  }

  Future<dynamic> obtenerPedido(
    String idPedido,
  ) async {
    String url = '${Env.currentEnv['serverUrl']}/pedido/buscar?id=$idPedido';

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

  Future<dynamic> actualizarPedido(
    String idPedido,
  ) async {
    String url =
        '${Env.currentEnv['serverUrl']}/pedido/actualizar?id=$idPedido';
    final data = {"estado": "Cancelado"};
    var datadecode = json.encode(data);
    final res = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
      body: datadecode,
    );
    dynamic respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    return respuesta;
  }
}
