import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:prueba_vaco_app/model/controller_arg_calificacion.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/calificacion_service.dart';
import 'package:prueba_vaco_app/src/pages/orders/order_status.dart';
import 'dart:convert' show utf8;

import '../../../enviroment/environment.dart';
import '../../../widgets/alerDialog.dart';
import '../../../widgets/appBar.dart';
import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../../widgets/loadingIndicator.dart';

class CalificacionCliente extends StatefulWidget {
  const CalificacionCliente({Key? key}) : super(key: key);

  @override
  State<CalificacionCliente> createState() => _CalificacionClienteState();
}

class _CalificacionClienteState extends State<CalificacionCliente> {
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

  @override
  Widget build(BuildContext context) {
    final argumentos = ModalRoute.of(context)!.settings.arguments as dynamic;
    nombreRestaurante = argumentos["nombreRestaurante"];
    idRestaurante = argumentos["idRestaurante"];
    idImagenProducto = argumentos["idImagenProducto"];

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Adapt.px(100)),
          child: AppBarW(
            bottonBack: "",
            textoLabel: 'CALIFICANOS',
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
        child: Column(
          children: [
            Column(children: [
              infoRestauranteTotal(),
              infoCalificacion(),
              opcionesCalificacion(),
              cajaComentario(),
            ]),
            Container(
              height: Adapt.hp(1),
            ),
            botonEnviar(context)
          ],
        ),
      ),
    );
  }

  Widget infoCalificacion() {
    //alojadas las estrellas
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
                    "¿Cuántas estrellas al restaurante?",
                    style:
                        TextStyle(color: Colors.black, fontSize: Adapt.px(30)),
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
                  initialRating: 2,
                  allowHalfRating: false,
                  minRating: 1,
                  maxRating: 5,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Color.fromARGB(255, 197, 254, 37),
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
                    style:
                        TextStyle(color: Colors.black, fontSize: Adapt.px(25)),
                  ),
                )))
      ],
    );
  }

  Widget opcionesCalificacion() {
    return SizedBox(
      width: Adapt.wp(96),
      height: Adapt.hp(48),
      child: FutureBuilder(
        future: CalificarService().mostrar(),
        builder: (BuildContext context,
            AsyncSnapshot<List<OrganizacionCalificacion>> snapshot) {
          if (snapshot.hasData) {
            evaluado = snapshot.data![0].evaluado;
            evaluador = snapshot.data![0].evaluador;
            idIdentificador = snapshot.data![0].id;
            valoresSeleccionados = snapshot.data![0].opciones;

            return ListView.builder(
              itemCount: snapshot.data![0].opciones!.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.hasData) {
                  valoracion.add(false);

                  return Column(
                    //Lista de opciones
                    children: [
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: Colors.black,
                        ),
                        child: CheckboxListTile(
                          selectedTileColor: Color.fromARGB(255, 253, 253, 253),
                          checkColor: Color.fromARGB(255, 15, 15, 15),
                          activeColor: Color.fromARGB(255, 126, 219, 3),
                          title: Text(
                              snapshot.data![0].opciones![index].toString(),
                              style: TextStyle(color: Colors.black)),
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
                  return Container();
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
                    fontSize: Adapt.px(30),
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
    return GestureDetector(
      onTap: () async {
        if (comentario != "" && calificacionEstrella != 0) {
          Navigator.pushNamed(context, '/homeShop');
          List auxSeleccionados = [];
          for (int i = 0; i < valoracion.length; i++) {
            if (valoracion[i]) {
              //Valores internos para mandar
              auxSeleccionados.add(valoresSeleccionados![i]);
            }
          }
          Map datosEnviar = {
            "Comentarios": comentario,
            "IdRestaurante": idRestaurante,
            "IdCuestionario": idIdentificador,
            "Calificacion": calificacionEstrella,
            "Evaluado": evaluado,
            "Opciones": auxSeleccionados,
            "Evaluador": evaluador,
            "IdEvaluador": prefs.usuario,
          };

          Map respuestaBack = await CalificarService().envioDatos(datosEnviar);
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
      },
      child: Container(
        child: const Text('Enviar', style: TextStyle(fontSize: 20)),
        color: const Color.fromARGB(255, 87, 240, 92),
      ),
    );
  }

  ///Esta parte contiene los widgets donde se almacenan l aimagen del restaruante,descriciòn entre otros
  Widget infoRestauranteTotal() {
    return Row(children: [
      SizedBox(
        width: Adapt.wp(1),
      ),
      imagenRestaurante(),
      SizedBox(
        width: Adapt.wp(1),
      ),
      informacionRestaurante()
    ]);
  }

  Widget imagenRestaurante() {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(10)),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          height: Adapt.hp(15),
          width: Adapt.wp(40),
          child: idImagenProducto == ""
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    'https://www.alqueria.com.co/sites/default/files/styles/1327_612/public/hamburguesa-con-amigos-y-salsa-de-champinones_0.jpg?h=2dfa7a18&itok=hLxehdIa',
                    fit: BoxFit.cover,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(
                    '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                    '$idImagenProducto',
                    height: Adapt.hp(60),
                    width: Adapt.wp(35),
                    fit: BoxFit.cover,
                  ),
                )),
    );
  }

  Widget informacionRestaurante() {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Column(
        children: [
          Container(
            height: Adapt.hp(2),
          ),
          Container(
            child: Text(nombreRestaurante.toUpperCase(),
                style: TextStyle(fontSize: Adapt.px(35), color: Colors.black)),
          ),
          Container(
            height: Adapt.hp(0.1),
          ),
          Container(
            child: Text("Descripcion...",
                style: TextStyle(
                    fontSize: Adapt.px(30),
                    color: Color.fromARGB(255, 44, 43, 43))),
          ),
          Container(
            height: Adapt.hp(0.1),
          ),
          starWalkyNombres(),
          Container(
            height: Adapt.hp(2),
          ),
        ],
      ),
    );
  }

  // Widget ContainerNombreDescripcion() {
  //   return Container(child: ColumnaInformacionRestaurante()); //child:
  // }

  Widget starWalkyNombres() {
    return Wrap(
      children: [
        Container(
          child: const Icon(
            Icons.star,
            color: Color.fromARGB(255, 231, 247, 7),
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
              color: Color.fromARGB(255, 0, 0, 0),
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
            bodyText: '⭐Gracias por calificar⭐',
            bottonAcept: 'false',
            bottonCancel: Container(),
          );
        });
  }
}
