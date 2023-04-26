import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:prueba_vaco_app/model/controller_arg_calificacion.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/calificacion_service.dart';
import 'package:prueba_vaco_app/src/pages/orders/order_status.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../backgrouds_widgets/background_restaurant.dart';
import '../../../responsive/Color.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/loading_indicator.dart';

class RatingVacoAsUser extends StatefulWidget {
  const RatingVacoAsUser({Key? key}) : super(key: key);

  @override
  State<RatingVacoAsUser> createState() => _CalificacionClienteState();
}

class _CalificacionClienteState extends State<RatingVacoAsUser> {
  String nombreRestaurante = "";
  String idRestaurante = "";
  String idImagenProducto = "";
  List<bool> valoracion = []; //Variable para los checkbox
  String comentario = "";
  int calificacionEstrella = 0;
  List? valoresSeleccionados = [];
  String? evaluador = "";
  String? evaluado = "";
  String? idIdentificador = "";
  final ButtonStyle styleOK = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      primary: ColorSelect.primaryColorVaco,
      textStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Form(
        child: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            width: size.width,
            height: Adapt.hp(88),
            child: Stack(
              children: [
                _body(size, context),
                const BackgroundRestaurant(),
                Container(
                  height: Adapt.hp(5),
                  alignment: Alignment.center,
                  child: Text('CALIFICANOS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat-ExtraBold',
                        fontSize: Adapt.px(50),
                        fontWeight: FontWeight.bold,
                      )),
                ),
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
        child: Column(
          children: [
            Column(children: [
              Container(
                height: Adapt.hp(7),
              ),
              imagenRestaurante(),
              infoCalificacion(),
              opcionesCalificacion(),
              cajaComentario(),
            ]),
            Container(
              height: Adapt.hp(1),
            ),
            botonEnviar(context),
            Container(
              height: Adapt.hp(5),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoCalificacion() {
    return Column(
      children: [
        SizedBox(
            width: Adapt.wp(90),
            height: Adapt.hp(5),
            child: Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "¿Cuántas estrellas nos das?",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat-ExtraBold',
                      fontSize: Adapt.px(30),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))),
        SizedBox(
            width: Adapt.wp(96),
            height: Adapt.hp(5),
            child: Align(
              alignment: Alignment.center,
              child: Theme(
                data: ThemeData(unselectedWidgetColor: Colors.black),
                child: RatingBar.builder(
                  glowColor: Colors.white,
                  initialRating: 0,
                  allowHalfRating: false,
                  minRating: 1,
                  maxRating: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: ColorSelect.primaryColorVaco,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      calificacionEstrella = rating.toInt();
                    });
                  },
                ),
              ),
            )),
        SizedBox(
            width: Adapt.wp(96),
            height: Adapt.hp(5),
            child: Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "¿Por qué esta calificación?",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat-ExtraBold',
                        fontWeight: FontWeight.bold,
                        fontSize: Adapt.px(25)),
                  ),
                )))
      ],
    );
  }

  Widget opcionesCalificacion() {
    return SizedBox(
      width: Adapt.wp(96),
      child: FutureBuilder(
        future: CalificarService().mostrar2(),
        builder: (BuildContext context,
            AsyncSnapshot<List<OrganizacionCalificacion>> snapshot) {
          if (snapshot.hasData) {
            evaluado = snapshot.data![0].evaluado;
            evaluador = snapshot.data![0].evaluador;
            idIdentificador = snapshot.data![0].id;
            valoresSeleccionados = snapshot.data![0].opciones;
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data![0].opciones!.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.hasData) {
                  valoracion.add(false);
                  return Column(
                    children: [
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: ColorSelect.primaryColorVaco,
                        ),
                        child: CheckboxListTile(
                          checkColor: ColorSelect.primaryColorVaco,
                          activeColor: ColorSelect.primaryColorVaco,
                          title: Text(
                              snapshot.data![0].opciones![index].toString(),
                              style: TextStyle(
                                fontSize: Adapt.wp(5),
                                color: Colors.black,
                                fontFamily: 'Montserrat-Regular',
                              )),
                          value: valoracion[index],
                          onChanged: (bool? value) {
                            setState(() {
                              valoracion[index] = value!;
                            });
                          },
                        ),
                      )
                    ],
                  );
                } else {
                  return const LoadingIndicatorW();
                }
              },
            );
          } else {
            return const LoadingIndicatorW();
          }
        },
      ),
    );
  }

  Widget cajaComentario() {
    //Caja de comentario
    return Padding(
        padding: EdgeInsets.all(Adapt.px(20)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: Color.fromARGB(255, 128, 128, 128), width: 1),
          ),
          height: Adapt.hp(15),
          width: Adapt.wp(100),
          child: Center(
            child: TextField(
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: Adapt.px(30), color: Colors.black),
              maxLines: 3,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Escribe tu comentario",
                hintStyle: TextStyle(
                    fontSize: Adapt.px(25),
                    color: Color.fromARGB(255, 99, 99, 99)),
              ),
              onChanged: (String value) {
                setState(() {
                  comentario = value;
                });
              },
            ),
          ),
        ));
  }

  Widget botonEnviar(context) {
    //boton de enviar calificacion
    return Container(
      width: Adapt.wp(40),
      height: Adapt.hp(5),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              primary: ColorSelect.primaryColorVaco,
              textStyle: TextStyle(
                  fontSize: Adapt.px(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          child: Text(AppLocalizations.of(context)!.enviar,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
          onPressed: () async {
            if (comentario != "" && calificacionEstrella != 0) {
              List auxSeleccionados = [];
              for (int i = 0; i < valoracion.length; i++) {
                if (valoracion[i]) {
                  //Valores internos para mandar
                  auxSeleccionados.add(valoresSeleccionados![i]);
                }
              }
              Map datosEnviar = {
                "Comentarios": comentario,
                "IdCuestionario": idIdentificador,
                "Calificacion": calificacionEstrella,
                "Evaluado": evaluado,
                "Opciones": auxSeleccionados,
                "Evaluador": evaluador,
                "IdEvaluador": prefs.usuario,
              };

              Map respuestaBack =
                  await CalificarService().envioDatos(datosEnviar);
              print(respuestaBack);
              _showAlertDialog(context);
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogCustom(
                      bodyText:
                          '*NO LO OLVIDES:Selecciona una calificación,Calificanos y  escribe un comentario',
                      bottonAcept: 'false',
                      bottonCancel: Container(),
                    );
                  });
            }
          }),
    );
  }

  Widget imagenRestaurante() {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(10)),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          height: Adapt.hp(15),
          width: Adapt.wp(40),
          child: const Image(
            image: AssetImage('assets/logos/LogoVacoBlanco.png'),
          )),
    );
  }

  Widget starWalkyNombres() {
    return Wrap(
      children: [
        Container(
          child: Icon(
            Icons.star,
            color: ColorSelect.primaryColorVaco,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: const Text(
            "4.5",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          child: const Icon(
            Icons.directions_walk,
            color: Colors.black,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: const Text(
            "1.5 km",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  void _showAlertDialog(context) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialogCustom(
            bodyText: AppLocalizations.of(context)!.graciasCalificar,
            bottonAcept: ElevatedButton(
                style: styleOK,
                child: Text(
                  AppLocalizations.of(context)!.aceptar,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/orderHistory');
                }),
            bottonCancel: Container(),
          );
        });
  }
}
