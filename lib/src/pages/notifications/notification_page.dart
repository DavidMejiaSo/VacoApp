import 'package:flutter/material.dart';

import 'package:prueba_vaco_app/responsive/Adapt.dart';

import 'package:timezone/data/latest.dart' as tz;

import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../../responsive/Color.dart';
import '../../../service/notifications_service.dart';
import '../../../service/notification_local_service.dart';

class NotificacionHome extends StatefulWidget {
  const NotificacionHome({Key? key}) : super(key: key);

  @override
  State<NotificacionHome> createState() => _NotificacionHomeState();
}

class _NotificacionHomeState extends State<NotificacionHome> {
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
    tz.initializeTimeZones();

    super.initState();
  }

  List items = [];
  bool abrioNotificacion = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
      if (datosActualizados[i].idImagen != null) {
        imagenesNotificacion.add(datosActualizados[i].idImagen);
      }
    }
    setState(() {});
  }

  Widget allNotifications() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: Adapt.px(50),
          ),
          notificationsList(),
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
              backgroundColor: Color.fromARGB(255, 250, 250, 250),
              backgroundImage: imageCerrar.image),
        ),
      ),
    );
  }

  Widget notificationsList() {
    //Notificaciones principales
    return SingleChildScrollView(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: tituloNotificacion.length,
        itemBuilder: (context, index) {
          final item = tituloNotificacion[index];
          //items.add(item);
          //print(items[index]);
          return Padding(
            padding: EdgeInsets.only(left: Adapt.px(10), right: Adapt.px(10)),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: Adapt.px(20), vertical: Adapt.px(10)),
                  margin: EdgeInsets.symmetric(
                      horizontal: Adapt.px(30), vertical: Adapt.px(7)),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Adapt.px(10)),
                          color: Color.fromARGB(255, 246, 243, 243),
                        ),
                        height: Adapt.hp(8),
                        width: Adapt.wp(18),
                        child: Image.asset("assets/logos/LogoVacoBlanco.png"),
                      ),
                      SizedBox(
                        width: Adapt.wp(5),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: Adapt.wp(45),
                              child: Text(
                                item,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-ExtraBold',
                                    fontSize: Adapt.px(25)),
                              ),
                            ),
                            Container(
                                width: Adapt.wp(30),
                                child: Text(descripcionNotificacion[index])),
                            SizedBox(
                              height: Adapt.hp(2),
                            ),
                            _botondetail(index, item),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          );
        },
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
            image: AssetImage('assets/notification/popUpNotification.png'),
            fit: BoxFit.scaleDown,
          ),
          //color: Colors.black.withOpacity(0.5),
        ),
      ),
      Positioned(
        top: Adapt.hp(37),
        left: Adapt.wp(12),
        child: Container(
          width: Adapt.wp(50),
          child: Text(nombreNotificacion,
              style: TextStyle(
                shadows: const <Shadow>[
                  Shadow(
                    offset: Offset(0.5, 0.5),
                    blurRadius: 1.0,
                    color: Color.fromARGB(255, 126, 126, 126),
                  ),
                ],
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: ColorSelect.primaryColorVaco,
              )),
        ),
      ),
      Positioned(
        top: Adapt.hp(37),
        left: Adapt.wp(12),
        child: Container(
          height: Adapt.wp(20),
          width: Adapt.wp(10),
          child: Container(
              //child: Image.network(),
              ),
        ),
      ),
      Positioned(
        top: Adapt.hp(55),
        left: Adapt.wp(12),
        child: Container(
          width: Adapt.wp(26),
          child: Text(
            descripcionTextoNotificacion,
            style: TextStyle(
              fontSize: Adapt.px(26),
              color: Color.fromARGB(255, 219, 211, 211),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Positioned(
        top: Adapt.hp(35),
        left: Adapt.wp(85),
        child: cerrarCajaNotificacion(),
      )
    ]);
  }

  Widget _botondetail(index, item) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        primary: Color.fromARGB(255, 207, 205, 205),
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
    return SizedBox(
      width: Adapt.wp(50),
      child: ElevatedButton(
          style: style,
          child: Text(
            "Ver detalle".toUpperCase(),
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          onPressed: () {
            abrioNotificacion = true;
            nombreNotificacion = tituloNotificacion[index];
            descripcionTextoNotificacion = descripcionNotificacion[index];
            NotificationService().showNotification(
                1, nombreNotificacion, descripcionTextoNotificacion, 2);

            imagenNotificacion = imagenesNotificacion[index];
            notificacionesLeidas.add(item);
            tituloNotificacion.remove(item);

            setState(() {});
          } //'/homeShopSupermercado')},
          ),
    );
  }
}
