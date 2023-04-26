import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:prueba_vaco_app/model/controller_arg_calificacion.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/calificacion_service.dart';
import 'package:prueba_vaco_app/src/pages/orders/order_status.dart';
import 'dart:convert' show utf8;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../enviroment/environment.dart';
import '../../../responsive/Color.dart';
import '../../../widgets/alerDialog.dart';
import '../../../widgets/appBar.dart';
import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../../widgets/loadingIndicator.dart';

class notificationPagePpal extends StatefulWidget {
  const notificationPagePpal({Key? key}) : super(key: key);

  @override
  State<notificationPagePpal> createState() => _notificationPpal();
}

class _notificationPpal extends State<notificationPagePpal> {
  //String nombreRestaurante = "";
  //String idRestaurante = "";
  //String idImagenProducto = "";
  //List<bool> valoracion = []; //Variable para los checkbox
  //String comentario = "";
  //int calificacionEstrella = 0;
  //List? valoresSeleccionados = [];
  //String? evaluador = "";
  //String? evaluado = "";
  //String? idIdentificador = "";
//
  @override
  Widget build(BuildContext context) {
    // final argumentos = ModalRoute.of(context)!.settings.arguments as dynamic;
    // nombreRestaurante = argumentos["nombreRestaurante"];
    // idRestaurante = argumentos["idRestaurante"];
    // idImagenProducto = argumentos["idImagenProducto"];
//
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Adapt.px(100)),
          child: AppBarW(
            bottonBack: '',
            textoLabel: 'NOTIFICACIONES',
            anotherButton: Container(),
            bottonBackAction: () {
              Navigator.pop(context);
            },
          )),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Form(
        child: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            width: size.width,
            height: size.height + 45,
            child: Stack(
              children: [
                const BackgroundShop(),
                _body(size, context),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget _body(size, context) {
    return Center(
      child: SingleChildScrollView(
          child: Column(children: [
        Column(children: [
          Container(
            child: Text(
              "Titulo de Notificacion",
              style: TextStyle(
                shadows: const <Shadow>[
                  Shadow(
                    offset: Offset(0.5, 0.5),
                    blurRadius: 1.0,
                    color: Color.fromARGB(255, 126, 126, 126),
                  ),
                ],
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorSelect.primaryColorVaco,
              ),
            ),
            //color: Color.fromARGB(255, 122, 216, 20),
          )
        ]),
        Container(
          width: Adapt.px(400),
          height: Adapt.px(400),
          color: Color.fromARGB(255, 122, 216, 20),
        ),
      ])),
    );
  }
}
