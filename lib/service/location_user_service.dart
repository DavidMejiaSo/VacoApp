import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../preferences/preferences_user.dart';

class LocationUserService {
  final prefs = PreferenciasUsuario();
  Future<dynamic> getLocationsByUser() async {
    String usuario = prefs.usuario;
    String url =
        '${Env.currentEnv['serverUrl']}/ubicacion/usuario/listar?idUsuario=$usuario';

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    if (respuesta is Map) {
      print('respuesta de las ubicaciones $respuesta');
      return respuesta;
    } else {
      return respuesta;
    }
  }

  Future<dynamic> setFavoriteLocation(String idLocation) async {
    String url =
        '${Env.currentEnv['serverUrl']}/ubicacion/usuario/actualizar?id=$idLocation';
    final data = {
      "porDefecto": true,
    };
    var datadecode = json.encode(data);
    final res = await http.put(
      Uri.parse(url),
      body: datadecode,
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

  Future<dynamic> unsetFavoriteLocation(String idLocation) async {
    String url =
        '${Env.currentEnv['serverUrl']}/ubicacion/usuario/actualizar?id=$idLocation';
    final data = {
      "porDefecto": false,
    };
    var datadecode = json.encode(data);
    final res = await http.put(
      Uri.parse(url),
      body: datadecode,
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

  Future<dynamic> deleteLocation(idLocation) async {
    String url =
        '${Env.currentEnv['serverUrl']}/ubicacion/usuario/eliminar?id=$idLocation';

    final res = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );
    dynamic respuesta = json.decode(res.body);
    print(respuesta);
    if (respuesta is String) {
      return respuesta;
    } else {
      return respuesta;
    }
  }

  Future<dynamic> crearteLocation(
      String direccion, departamento, municipio, latitude, longitude) async {
    String url = '${Env.currentEnv['serverUrl']}/ubicacion/usuario/crear';
    final data = {
      'direccion': direccion,
      "departamento": departamento,
      "municipio": municipio,
      "latitud": latitude.toString(),
      "longitud": longitude.toString(),
      "porDefecto": false,
      "idUsuario": prefs.usuario
    };

    var datadecode = json.encode(data);
    print(datadecode);
    final res = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
      body: datadecode,
    );

    print(res.statusCode);
    dynamic respuesta3 = json.decode(res.body);
    print(respuesta3);
    if (respuesta3 is Map) {
      return respuesta3;
    } else {
      return respuesta3;
    }
  }
}
