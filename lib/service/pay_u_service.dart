import 'dart:convert';

import 'package:http/http.dart' as http;

import '../enviroment/environment_pay_u.dart';
import '../model/controller_arg_pay_u.dart';
import '../model/controller_arg_pay_u_response.dart';

class PayUService {
  Future<dynamic> buildPayment(PayUModelService payUModelService) async {
    // final datadecode = payUModelServiceToJson(payUModelService);
    final datadecode = payUModelServiceToJson(payUModelService);
    final res = await http.post(Uri.parse(EnvPayU.dev),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json"
        },
        body: datadecode);

    ResponsePayModel respuestaResponsePayModel =
        ResponsePayModel.fromJson(jsonDecode(res.body));

    return respuestaResponsePayModel;
  }
}
