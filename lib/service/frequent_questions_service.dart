import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PreguntasFrecuentesService {
  final prefs = PreferenciasUsuario();
  Future<dynamic> obtenerPreguntas() async {
    String url = '${Env.currentEnv['serverUrl']}/preguntasFrecuentes/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
        'Accept-Charset': 'utf-8',
      },
    );
    dynamic respuesta = jsonDecode(utf8.decode(res.bodyBytes));
    print('========== ln 19');
    print(respuesta);

    return respuesta;
  }

  Future<List> obtenerCategoriasPreguntas() async {
    String url = '${Env.currentEnv['serverUrl']}/listar/categoria/preguntas';
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

  Future<List> obtenerCategoriasPreguntasPorID(idCategoria) async {
    String url =
        '${Env.currentEnv['serverUrl']}/preguntasFrecuentes/listar/categoria?id=$idCategoria';
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
}
