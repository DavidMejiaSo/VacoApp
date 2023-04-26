import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/model/controller_arg%20_notifications.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/widgets/appBar.dart';

import '../backgrouds_widgets/backgroundShop.dart';
import '../responsive/Color.dart';
import '../service/notifications_service.dart';

class notificationHome extends StatefulWidget {
  const notificationHome({Key? key}) : super(key: key);

  @override
  State<notificationHome> createState() => _notificationHomeState();
}

class _notificationHomeState extends State<notificationHome> {
  final notificacionService = notificationService();
  List tituloNotificacion = [];
  List descripcionNotificacion = [];
  List notificacionesLeidas = [];
  List imagenesNotificacion = [];
  String nombreNotificacion = ""; //Para el banner emergente
  String descripcionTextoNotificacion = ""; //Para el abnner emergente
  String imagenNotificacion = ""; //Para el banner emergente

  String? id;
  String? nombre;
  String? descripcion;
  String? entrega;
  List? perfiles;
  List? medios;
  @override
  void initState() {
    informacionDatos();

    // TODO: implement initState
    super.initState();
  }

  List items = [];
  bool abrioNotificacion = false;
  @override
  Widget build(BuildContext context) {
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
              child: Column(
            children: [
              Container(
                width: size.width,
                height: size.height + 45,
                child: Stack(
                  children: [
                    const BackgroundShop(),
                    SizedBox.expand(child: allNotifications()),
                    abrioNotificacion ? notificationAdver() : Container(),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  void informacionDatos() async {
    //Para pasarlas a la vista de las notificaciones
    final datosActualizados = await notificacionService.mostrar();
    print(datosActualizados);
    for (var i = 0; i < datosActualizados!.length; i++) {
      tituloNotificacion.add(datosActualizados[i].nombre);
      descripcionNotificacion.add(datosActualizados[i].descripcion);
      imagenesNotificacion.add(datosActualizados[i].idImagen);
    }
    setState(() {});
  }

  Widget allNotifications() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Nuevas",
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
          notificationsList(),
          //Text(
          //  "Leidas",
          //  style: TextStyle(
          //    shadows: const <Shadow>[
          //      Shadow(
          //        offset: Offset(0.5, 0.5),
          //        blurRadius: 1.0,
          //        color: Color.fromARGB(255, 126, 126, 126),
          //      ),
          //    ],
          //    fontSize: 24,
          //    fontWeight: FontWeight.bold,
          //    color: ColorSelect.primaryColorVaco,
          //  ),
          //),
          //notificationRead(),
        ],
      ),
    );
  }

  Widget notificationRead() {
    //Widiget donde van todas las notificaciones leidas
    return Container(
      height: Adapt.hp(80),
      width: Adapt.wp(100),
      color: Color.fromARGB(255, 180, 176, 176),
      child: ListView.builder(
        itemCount: notificacionesLeidas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notificacionesLeidas[index]),

            //subtitle: Text(items[index]['descripcion']),
          );
        },
      ),
    );
  }

  Widget cerrarCajaNotificacion() {
    Image imageCerrar = Image.asset(
      'assets/botones/BotonCerrar.png',
      fit: BoxFit.cover,
    );
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Transform.scale(
        scale: Adapt.px(1.45),
        child: GestureDetector(
          onTap: () {
            abrioNotificacion = false;
            setState(() {});
          },
          child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: imageCerrar.image),
        ),
      ),
    );
  }

  Widget notificationsList() {
    //Notificaciones principales
    return SingleChildScrollView(
      child: Container(
        width: Adapt.wp(100),
        height: Adapt.hp(100),
        //color: Colors.yellow,
        child: ListView.builder(
          itemCount: tituloNotificacion.length,
          itemBuilder: (context, index) {
            final item = tituloNotificacion[index];
            //items.add(item);
            //print(items[index]);
            return ListTile(
              title: Text(item),
              subtitle: Text(descripcionNotificacion[index]),
              trailing: Container(
                width: Adapt.wp(20),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          abrioNotificacion = true;
                          nombreNotificacion = tituloNotificacion[index];
                          descripcionTextoNotificacion =
                              descripcionNotificacion[index];

                          imagenNotificacion = imagenesNotificacion[index];
                          setState(() {});
                          //containerBotonSorpresa();
                        },
                        child: Icon(Icons.remove_red_eye_sharp)),
                    SizedBox(width: Adapt.wp(1)),
                    GestureDetector(
                        onTap: () {
                          notificacionesLeidas.add(item);
                          tituloNotificacion.remove(item);
                          print(notificacionesLeidas);
                          setState(() {});
                        },
                        child: Icon(Icons.check)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget notificationAdver() {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/notification/notification_pop.png'),
            fit: BoxFit.scaleDown,
          ),
          //color: Colors.black.withOpacity(0.5),
        ),
      ),
      Positioned(
        top: Adapt.hp(37),
        left: Adapt.wp(12),
        child: Text(nombreNotificacion,
            style: TextStyle(
              fontSize: Adapt.px(0),
              color: Color.fromARGB(255, 219, 211, 211),
              fontWeight: FontWeight.bold,
            )),
      ),
      Positioned(
        top: Adapt.hp(44),
        left: Adapt.wp(12),
        child: Text(
          descripcionTextoNotificacion,
          style: TextStyle(
            fontSize: Adapt.px(15),
            color: Color.fromARGB(255, 219, 211, 211),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Positioned(
        top: Adapt.hp(23),
        left: Adapt.wp(85),
        child: cerrarCajaNotificacion(),
      )
    ]);
  }
}
