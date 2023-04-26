import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:prueba_vaco_app/model/controller_arg_calificacion.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/calificacion_service.dart';
import 'package:prueba_vaco_app/src/pages/orders/order_status.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../enviroment/environment.dart';
import '../../../responsive/Color.dart';
import '../../../service/calificacionesRestaurantes_service.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/appBar.dart';
import '../../widgets/loading_indicator.dart';

class RatingRestaurantAsUser extends StatefulWidget {
  const RatingRestaurantAsUser({Key? key}) : super(key: key);

  @override
  State<RatingRestaurantAsUser> createState() => _CalificacionClienteState();
}

class _CalificacionClienteState extends State<RatingRestaurantAsUser> {
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
  int promedioCalifcacion = 0;

  final serviceCalificacion = restaurantesCalificadosService();
  void promedioCalificaciones() async {
    try {
      Future.delayed(Duration(seconds: 1), () {});
      int promedioCalificacionRespuesta =
          await serviceCalificacion.obtenerPromedioRestaurante(idRestaurante);
      promedioCalifcacion = promedioCalificacionRespuesta;
      print(promedioCalifcacion);

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  String idResraunte = "";
  @override
  void initState() {
    promedioCalificaciones();
    super.initState();
  }

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
            bottonBack: '',
            textoLabel: 'CALIFICAR RESTAURANTE',
            anotherButton: Container(),
            bottonBackAction: () {
              Navigator.pop(context);
            },
          )),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Form(
        child: SafeArea(
            child: Container(
          width: size.width,
          height: size.height + 45,
          child: Stack(
            children: [
              SingleChildScrollView(child: _body(size, context)),
              Container(
                height: Adapt.hp(15),
                width: Adapt.wp(100),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/backgrounds/FondoProductos.png'),
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitWidth,
                )),
                child: infoRestauranteTotal(),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _body(size, context) {
    return Center(
      child: Column(
        children: [
          Column(children: [
            Container(
              height: Adapt.hp(15),
            ),
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
    );
  }

  Widget infoCalificacion() {
    //alojadas las estrellas
    return Column(
      children: [
        Container(
          height: Adapt.hp(1),
        ),
        SizedBox(
            width: Adapt.wp(90),
            height: Adapt.hp(8),
            child: Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "¿Cuántas estrellas al restaurante?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Adapt.px(35),
                      fontFamily: 'Montserrat-ExtraBold',
                    ),
                  ),
                ))),
        Container(
          height: Adapt.hp(1),
        ),
        SizedBox(
            width: Adapt.wp(96),
            height: Adapt.hp(5),
            child: Align(
              alignment: Alignment.center,
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: ColorSelect.primaryColorVaco,
                ),
                child: RatingBar.builder(
                  glowColor: Colors.white,
                  initialRating: 2,
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
        Container(
          height: Adapt.hp(1),
        ),
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
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat-ExtraBold',
                        fontSize: Adapt.px(30)),
                  ),
                )))
      ],
    );
  }

  Widget opcionesCalificacion() {
    return SizedBox(
      width: Adapt.wp(95),
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
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data![0].opciones!.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.hasData) {
                  valoracion.add(false);

                  return Column(
                    //Lista de opciones
                    children: [
                      Theme(
                        data: ThemeData(
                          unselectedWidgetColor: ColorSelect.primaryColorVaco,
                        ),
                        child: CheckboxListTile(
                          selectedTileColor: Colors.white,
                          checkColor: ColorSelect.primaryColorVaco,
                          activeColor: ColorSelect.primaryColorVaco,
                          title: Text(
                              snapshot.data![0].opciones![index].toString(),
                              style: TextStyle(
                                fontSize: Adapt.px(25),
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
              style: TextStyle(fontSize: Adapt.px(20), color: Colors.black),
              maxLines: 3,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Escribe tu comentario",
                hintStyle: TextStyle(
                    fontSize: Adapt.px(20),
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
                Navigator.pushNamed(context, '/mainScreen');
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
            }));
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
            width: Adapt.wp(50),
            alignment: Alignment.center,
            child: Text(nombreRestaurante.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Adapt.px(35),
                    fontFamily: 'Montserrat-ExtraBold',
                    color: Colors.black)),
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
          child: Icon(
            Icons.star,
            color: ColorSelect.primaryColorVaco,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            "$promedioCalifcacion",
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
            bottonAcept: 'false',
            bottonCancel: Container(),
          );
        });
  }
}
