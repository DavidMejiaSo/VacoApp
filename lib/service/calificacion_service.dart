import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/model/controller_arg_calificacion.dart';

import '../preferences/preferences_user.dart';

class CalificarService {
  final prefs = PreferenciasUsuario();
  Future<List<OrganizacionCalificacion>>? mostrar() async {
    List<OrganizacionCalificacion>? listaCalificar = [];
    String url = '${Env.currentEnv['serverUrl']}/calificacion/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    List respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    //print(respuesta);
    for (var item in respuesta) {
      if (item['id'] == '628b01ee05d7764b282bf0ef') {
        listaCalificar.add(OrganizacionCalificacion.fromJson(item));
      }
    }

    print(listaCalificar);
    return listaCalificar;
  }

  Future<List<OrganizacionCalificacion>>? mostrar2() async {
    List<OrganizacionCalificacion>? listaCalificar = [];
    String url = '${Env.currentEnv['serverUrl']}/calificacion/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    List respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    //print(respuesta);
    for (var item in respuesta) {
      if (item['id'] == '62bb6f685bf10a91d55d18bb') {
        listaCalificar.add(OrganizacionCalificacion.fromJson(item));
      }
    }

    print(listaCalificar);
    return listaCalificar;
  }

  Future<Map> envioDatos(Map valoresEnviar) async {
    String url = '${Env.currentEnv['serverUrl']}/valoresCalificacion/crear';
    final res = await http.post(
      Uri.parse(url),
      headers: {
        //"content-type": "application/json",
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
      body: json.encode(valoresEnviar),
    );
    Map respuesta = jsonDecode(utf8.decode(res.bodyBytes));

    return respuesta;
  }
}
