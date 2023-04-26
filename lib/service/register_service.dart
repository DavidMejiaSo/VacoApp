import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

import '../preferences/preferences_user.dart';

class RegisterService {
  final prefs = PreferenciasUsuario();
  Future<dynamic> register(
    String name,
    lastName,
    email,
    password,
    documentType,
    document,
    bornDate,
    genderSelect,
    phone,
    departamentID,
    municipioID,
    List idListaProductosFavoritos,
    idAlergias,
  ) async {
    String url =
        "${Env.currentEnv['serverUrl']}/auth/registro?url=http://vacoweb.s3-website-us-east-1.amazonaws.com/user/activation";

    final data = {
      "nombre": name,
      "apellido": lastName,
      "username": email,
      "password": password,
      "tipoDocumento": documentType,
      "documento": document,
      "fechaNacimiento": bornDate,
      "genero": genderSelect,
      "direccion": "",
      "telefono": phone,
      "celular": phone,
      "idDepartamento": departamentID,
      "idMunicipio": municipioID,
      "idListaProductosFavoritos": idListaProductosFavoritos,
      "idAlergias": idAlergias,
    };
    var datadecode = json.encode(data);

    final res = await http.post(Uri.parse(url), body: datadecode);

    dynamic registrar = json.decode(res.body);
    print(registrar);
    return registrar;
  }

  Future<dynamic> registerFacebook(
    String firstName,
    lastName,
    email,
    password,
    documentType,
    document,
    genderSelect,
    phone,
    idAlergias,
  ) async {
    String url = "${Env.currentEnv['serverUrl']}/auth/registroFacebook";

    final data = {
      "nombre": firstName,
      "apellido": lastName,
      "username": email,
      "password": password,
      "tipoDocumento": documentType,
      "documento": document,
      "genero": genderSelect,
      "telefono": phone,
      "celular": phone,
      "idAlergias": idAlergias,
    };
    var datadecode = json.encode(data);

    final res = await http.post(Uri.parse(url), body: datadecode);

    dynamic registrar = json.decode(res.body);
    print(registrar);
    return registrar;
  }

  Future<dynamic> registerGoogle(
    String fullName,
    email,
    password,
    documentType,
    document,
    genderSelect,
    phone,
    idAlergias,
  ) async {
    String url = "${Env.currentEnv['serverUrl']}/auth/registroGoogle";

    final data = {
      "nombre": fullName.split(' ')[0],
      "apellido": fullName.split(' ')[1],
      "username": email,
      "password": password,
      "tipoDocumento": documentType,
      "documento": document,
      "genero": genderSelect,
      "telefono": phone,
      "celular": phone,
      "idAlergias": idAlergias,
    };
    var datadecode = json.encode(data);

    final res = await http.post(Uri.parse(url), body: datadecode);

    dynamic registrar = json.decode(res.body);
    print(registrar);
    return registrar;
  }

  Future<List> getDepartamentos() async {
    String url = '${Env.currentEnv['serverUrl']}/ubicacion/departamentos';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Accept-Charset': 'utf-8',
      },
    );

    List obtenerDepartamentos = json.decode(utf8.decode(res.bodyBytes));

    return obtenerDepartamentos;
  }

  Future<List> getMunicipio(numero) async {
    String url =
        '${Env.currentEnv['serverUrl']}/ubicacion/municipios?departamento=$numero';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Accept-Charset': 'utf-8',
        'Authorization': 'Bearer ${prefs.token}',
      },
    );

    List obtenerMunicipio = json.decode(utf8.decode(res.bodyBytes));

    return obtenerMunicipio;
  }

  Future<List> getAlergias() async {
    String url = '${Env.currentEnv['serverUrl']}/alergia/listar';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${prefs.token}',
      },
    );

    var getAlergias = json.decode(res.body);

    return getAlergias;
  }
}
