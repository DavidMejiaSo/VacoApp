// ignore_for_file: avoid_print, deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/order_service.dart';
import 'package:prueba_vaco_app/service/restaurant_service.dart';
import 'package:prueba_vaco_app/backgrouds_widgets/backgroundProductos.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';
import '../../widgets/elevated_botton_cancel.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/loading_indicator.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({Key? key}) : super(key: key);

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

final prefs = PreferenciasUsuario();
final orderService = OrderService();
final restauranteService = RestaurantService();
dynamic pedido;
String estadoActual = "";
String idRestaurante = "";
String nombreRestauranteObteniedo = "";
bool showCancelMessage = false;
bool showNoEfevtiveMessage = false;
bool showOrderMessage = false;
bool cancelOrden = false;
dynamic imageRestaurant;
var timer;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
const spaceBetween = SizedBox(height: 30);
final ButtonStyle style = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    primary: ColorSelect.primaryColorVaco,
    textStyle: const TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
final ButtonStyle style2 = ElevatedButton.styleFrom(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  primary: const Color.fromARGB(255, 254, 37, 37),
  textStyle: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
);

class _OrderStatusState extends State<OrderStatus> {
  void traerPedido() async {
    try {
      if ((estadoActual == "No efectiva")) {
        if (timer != null) {
          pedido['estado'] = "Cancelado";
          setState(() {});
          timer.cancel();
        }
        return;
      }
      pedido = await orderService.obtenerPedido(prefs.idOrden);
      await Future.delayed(Duration(seconds: 1));
      estadoActual = pedido['estado'];
      if (pedido['estado'] == "Cancelado" && !showCancelMessage) {
        showCancelMessage = true;
        alertOrdenCancelada();
      } else if (pedido['estado'] != "Cancelado") {
        showCancelMessage = false;
      }
      if (pedido['estado'] == "No efectivo" && !showNoEfevtiveMessage) {
        showNoEfevtiveMessage = true;
        alertOrdenNoEfectiva();
      } else if (pedido['estado'] != "No efectivo") {
        showNoEfevtiveMessage = false;
      }
      if (pedido['estado'] == "Entregado" && !showOrderMessage) {
        showOrderMessage = true;
        idRestaurante = pedido['idRestaurante'];
        obtenerRestaurante();
        alertOrdenEntregada();
      } else if (pedido['estado'] != "Entregado") {
        showOrderMessage = false;
      }

      setState(() {
        pedido;
      });
      timer = Timer(const Duration(seconds: 5), () => traerPedido());
    } catch (e) {
      print(e);
    }
  }

  /*
  Llama al servicio para poder obtener la información del restaunte
  recibe como parametro el id del restaurante
   */

  void obtenerRestaurante() async {
    dynamic respuesta =
        await restauranteService.obtenerRestaurante(idRestaurante);
    nombreRestauranteObteniedo = respuesta['nombre'];
    imageRestaurant = respuesta['idImagen'];
    setState(() {});
  }

  void cancelarPedido() async {
    await orderService.actualizarPedido(prefs.idOrden);
    setState(() {});
  }

  @override
  void initState() {
    traerPedido();
    obtenerRestaurante();
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = const IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Background(),
            _body(context),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Adapt.hp(1)),
        _bodyParteUno(),
        _textTop(),
        SizedBox(height: Adapt.hp(11)),
        Flexible(
          child: _orderDetail(context),
        )
      ],
    );
  }

  Widget _bodyParteUno() {
    Image imageRegreso = Image.asset(
      'assets/botones/BotonRegresar.png',
      fit: BoxFit.cover,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: Adapt.wp(0.05),
          ),
          Flexible(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/mainScreen');
              },
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: imageRegreso.image),
            ),
          ),
          SizedBox(
            width: Adapt.wp(0.05),
          ),
        ],
      ),
    );
  }

  Widget _textTop() {
    try {
      return SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.tuOrden,
              style: TextStyle(
                fontSize: Adapt.px(40),
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Montserrat-ExtraBold',
              ),
            ),
            Text(
              "${AppLocalizations.of(context)!.tiempoEstimado}: ${pedido['tiempoEntrega']} ${AppLocalizations.of(context)!.minutos}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: Adapt.wp(1),
            ),
          ],
        ),
      );
    } catch (e) {
      return const LoadingIndicatorW();
    }
  }

  Widget _orderDetail(BuildContext context) {
    try {
      return Align(
        alignment: Alignment.center,
        child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  pedido['estado'] == "Pendiente"
                      ? Column(
                          children: [
                            fondoConfirmacion(),
                            Text(
                              AppLocalizations.of(context)!
                                  .pendienteConfirmacion,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      : pedido['estado'] == "En preparación"
                          ? Column(
                              children: [
                                fondoPreparacion(),
                                Text(
                                  AppLocalizations.of(context)!
                                      .pedidoPreparacion,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                          : pedido['estado'] == "Para entregar"
                              ? Column(
                                  children: [
                                    fondoRecoger(),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .listoEntregar,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                )
                              : pedido['estado'] == "Entregado"
                                  ? Column(
                                      children: [
                                        fondoEntregado(),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .entregado,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    )
                                  : pedido['estado'] == "No efectivo" ||
                                          pedido['estado'] == "Cancelado"
                                      ? Column(
                                          children: [
                                            fondoConfirmacion(),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .cancelado,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ],
                                        )
                                      : const LoadingIndicatorW(),
                  SizedBox(height: Adapt.hp(4)),
                  Row(
                    children: [
                      botonOrden(),
                      const Spacer(
                        flex: 1,
                      ),
                      pedido['estado'] == "Entregado"
                          ? botonCalificarII()
                          : pedido['estado'] == "Pendiente"
                              ? botonCancelar()
                              : Center(
                                  child: Text(AppLocalizations.of(context)!
                                      .pedidoProceso),
                                ),
                    ],
                  )
                ],
              ),
            )),
      );
    } catch (e) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noPedidoProceso),
      );
    }
  }

  showNotificationPendiente() async {
    var android = const AndroidNotificationDetails('channel id', 'channel NAME',
        priority: Priority.high, importance: Importance.max);
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, 'Tu pedido ha sido enviado',
        'pendiente de ser confirmado por el restaurante', platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  showNotificationPreparacion() async {
    var android = const AndroidNotificationDetails('channel id', 'channel NAME',
        priority: Priority.high, importance: Importance.max);
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Tu pedido ha sido confirmado',
        'Esta siendo preparado por el restaurante',
        platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  showNotificationRecogerPedido() async {
    var android = const AndroidNotificationDetails('channel id', 'channel NAME',
        priority: Priority.high, importance: Importance.max);
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, 'Tu pedido esta listo',
        'Ya puedes pasar por el resaurante a recoger tu pedido ', platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  showNotificationEntregado() async {
    var android = const AndroidNotificationDetails('channel id', 'channel NAME',
        priority: Priority.high, importance: Importance.max);
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Tu pedido ya ha sido entregado',
        'El restaurante ya entrego tu pedido, calificalo',
        platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  showNotificationCancelado() async {
    var android = const AndroidNotificationDetails('channel id', 'channel NAME',
        priority: Priority.high, importance: Importance.max);
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Tu pedido ha sido cancelado', 'Cancelaste tu pedido', platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  Widget fondoConfirmacion() {
    Image imagenConfirmacion = Image.asset(
      'assets/carga/EnConfirmacion.gif',
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: imagenConfirmacion.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget fondoPreparacion() {
    Image imagenConfirmacion = Image.asset(
      'assets/carga/Preparacion.png',
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: imagenConfirmacion.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget fondoRecoger() {
    Image imagenConfirmacion = Image.asset(
      'assets/carga/Recoger.png',
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: imagenConfirmacion.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget fondoEntregado() {
    Image imagenConfirmacion = Image.asset(
      'assets/carga/Entregado.png',
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: imagenConfirmacion.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget fondoCancelado() {
    Image imagenConfirmacion = Image.asset(
      'assets/carga/Entregado.png',
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: imagenConfirmacion.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget estadoPedido() {
    return const Expanded(
      child: CircleAvatar(
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget botonCalificarII() {
    return SizedBox(
      width: Adapt.wp(35),
      child: ElevatedButton(
        style: style,
        child: Text(
          AppLocalizations.of(context)!.calificar,
          style: TextStyle(
            fontSize: Adapt.px(22),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/ratingRestaurant', arguments: {
            "nombreRestaurante": nombreRestauranteObteniedo,
            "idRestaurante": idRestaurante,
            "idImagenProducto": imageRestaurant,
          });
        },
      ),
    );
  }

  Widget botonCancelar() {
    return SizedBox(
      width: Adapt.wp(40),
      child: ElevatedButton(
        style: style2,
        child: Text(
          AppLocalizations.of(context)!.cancelar,
          style: TextStyle(
            fontSize: Adapt.px(22),
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 253, 253),
          ),
        ),
        onPressed: () {
          alertCancelarOrden();
          setState(() {});
        },
      ),
    );
  }

  Widget botonOrden() {
    return SizedBox(
      width: Adapt.wp(40),
      child: ElevatedButton(
        style: style,
        child: Text(
          AppLocalizations.of(context)!.verDetalles,
          style: TextStyle(
            fontSize: Adapt.px(22),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/mainScreen');
        },
      ),
    );
  }

  void alertOrdenCancelada() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        primary: ColorSelect.primaryColorVaco,
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogCustom(
          bodyText:
              'Lo sentimos \n su orden ha sido cancelada \n puede consultarla desde su historial de ordenes',
          bottonAcept: ElevatedButton(
            style: style,
            child: const Text("Ir al historial",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            onPressed: () {
              Navigator.pushNamed(context, '/orderHistory');
            },
          ),
          bottonCancel: ElevatedButtonCancelCustom(),
        );
      },
    );
  }

  void alertOrdenNoEfectiva() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        primary: ColorSelect.primaryColorVaco,
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogCustom(
          bodyText:
              'Lo sentimos, su orden se registró como no efectiva ya que no se presentó a recoger los productos.\n Consulte los detalles en su historial de ordenes',
          bottonAcept: ElevatedButton(
            style: style,
            child: const Text("Ir al historial",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            onPressed: () {
              Navigator.pushNamed(context, '/orderHistory');
            },
          ),
          bottonCancel: ElevatedButtonCancelCustom(),
        );
      },
    );
  }

  void alertOrdenEntregada() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        primary: ColorSelect.primaryColorVaco,
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogCustom(
            bodyText:
                'Su orden ha sido entregada  \n Puede consultarla desde su historial de ordenes',
            bottonAcept: ElevatedButton(
              style: style,
              child: const Text("Ir al historial",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              onPressed: () {
                Navigator.pushNamed(context, '/orderHistory');
              },
            ),
            bottonCancel: ElevatedButtonCancelCustom());
      },
    );
  }

  void alertCancelarOrden() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        primary: ColorSelect.primaryColorVaco,
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));

    final ButtonStyle style2 = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        primary: const Color.fromARGB(255, 255, 0, 0),
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogCustom(
          bodyText: '¿Quieres cancelar la orden?',
          bottonAcept: ElevatedButton(
            style: style2,
            child: Text(AppLocalizations.of(context)!.aceptar,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            onPressed: () {
              cancelarPedido();
              Navigator.pop(context);
            },
          ),
          bottonCancel: ElevatedButton(
            style: style,
            child: const Text('CANCELAR',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
