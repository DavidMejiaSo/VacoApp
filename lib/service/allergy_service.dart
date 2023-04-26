import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../preferences/preferences_user.dart';

class getListAllergyUserService {
  final prefs = PreferenciasUsuario();
  Future<List> getAllergy() async {
    final url = '${Env.currentEnv['serverUrl']}/alergia/listar';

    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );

    List respuesta = json.decode(res.body);

    return respuesta;
  }

  Future<dynamic> addAllergy(alergia) async {
    final url =
        '${Env.currentEnv['serverUrl']}/usuarios/agregarAlergia?usuario=${prefs.usuario}&alergia=$alergia';

    final res = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );

    dynamic respuesta = json.decode(res.body);

    return respuesta;
  }

  Future<dynamic> deleteAllergy(alergia) async {
    final url =
        '${Env.currentEnv['serverUrl']}/usuarios/eliminarAlergia?usuario=${prefs.usuario}&alergia=$alergia';

    final res = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );

    dynamic respuesta = json.decode(res.body);

    return respuesta;
  }
}
