import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vaco_app/enviroment/environment.dart';

class PasswordService {
  Future<String> get(_email) async {
    final url =
        '${Env.currentEnv['serverUrl']}/auth/recuperacion?url=http://vacoweb.s3-website-us-east-1.amazonaws.com&emailusuario=$_email';

    final res = await http.post(
      Uri.parse(url),
    );

    final respuesta = json.decode(res.body);

    return respuesta;
  }
}
