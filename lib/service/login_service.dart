// ignore_for_file: unused_element

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';

class LoginService {
  final prefs = PreferenciasUsuario();
  Future<dynamic> login(
    String usuario,
    String password,
    String tipoAcceso,
  ) async {
    final prefs = PreferenciasUsuario();

    String url = '${Env.currentEnv['serverUrl']}/auth/movil';

    final data = {
      "username": usuario,
      "password": password,
      "tipoAcceso": tipoAcceso,
    };
    prefs.tipoLogin = tipoAcceso;
    var datadecode = json.encode(data);

    final res = await http.post(Uri.parse(url), body: datadecode);

    dynamic respuesta = json.decode(res.body);

    if (respuesta is String) {
      return respuesta;
    } else {
      Map<dynamic, dynamic> respuestaTipoMap = respuesta;

      print('==================================');
      print('resputa del login $respuesta');

      print('==================================');
      prefs.usuario = respuesta['user']['id'];
      prefs.email = respuesta['user']['username'];
      prefs.nombreUsuario = respuesta['user']['nombre'];

      prefs.restaurantFavorite =
          respuesta['user']['idListaProductosFavoritos'].toString().split(',');
      if (respuestaTipoMap.containsKey('token')) {
        prefs.token = respuestaTipoMap['token'];
        print(prefs.token);

        return {"ok": true, 'token': respuestaTipoMap['token']};
      } else {
        return {"ok": false, 'mensaje': respuestaTipoMap['error_description']};
      }
    }
  }

  Future<dynamic> reloadToken() async {
    String url = '${Env.currentEnv['serverUrl']}/auth/movil';

    final data = {
      "username": prefs.email,
      "password": prefs.password,
      "tipoAcceso": prefs.tipoLogin,
    };

    print(
        'ln 69 ${prefs.tipoLogin}, usuario ${prefs.email} password ${prefs.password}');
    var datadecode = json.encode(data);

    final res = await http.post(Uri.parse(url), body: datadecode);

    dynamic respuesta = json.decode(res.body);
    print('ln 74${respuesta['token']}');
    if (respuesta is Map) {
      Map<dynamic, dynamic> respuestaTipoMap = respuesta;
      print("reRoronamos");
      prefs.usuario = respuesta['user']['id'];

      prefs.restaurantFavorite =
          respuesta['user']['idListaProductosFavoritos'].toString().split(',');

      if (respuestaTipoMap.containsKey('token')) {
        prefs.token = respuestaTipoMap['token'];
        prefs.usuario = respuesta['user']['id'];
        prefs.nombreUsuario = respuesta['user']['nombre'];
        return {"ok": true, 'token': respuestaTipoMap['token']};
      } else {
        return {"ok": false, 'mensaje': respuestaTipoMap['error_description']};
      }
    } else {
      return respuesta;
    }
  }

  Future<String> checkToken() async {
    String url = '${Env.currentEnv['serverUrl']}/restaurante/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );
    String respuesta2 = res.body;
    try {
      return respuesta2;
    } catch (e) {
      return respuesta2;
    }
  }

  String obtenerTokenLogin(Map data) {
    return data['token'];
  }
}
