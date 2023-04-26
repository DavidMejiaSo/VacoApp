import 'package:flutter/material.dart';

import '../../../enviroment/environment.dart';
import '../../../model/controller_toppigs.dart';
import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';
import '../../../service/bag_service.dart';
import '../../../service/products_service.dart';
import '../../widgets/appBar.dart';
import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../widgets/loading_indicator.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderHistoryDetail extends StatefulWidget {
  const OrderHistoryDetail({Key? key}) : super(key: key);

  @override
  State<OrderHistoryDetail> createState() => _OrderHistoryDetailState();
}

class _OrderHistoryDetailState extends State<OrderHistoryDetail> {
  final searchProduct = ProductsService();
  final bagService = BagService();
  int index = 0;
  List infoRestaurante = [];
  List infoProductos = [];
  List cajasSorpresas = [];
  List<Map> detallesProductos = [];
  List<Map> detallesBolsaSorpresa = [];
  List<ToppingsModel> detallesToppings = [];
  Map infoPedido = {};

  bool cargodatos = false;
  @override
  void initState() {
    infoProductos = [];
    cajasSorpresas = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final infoOrderDetail =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    index = infoOrderDetail['index'];
    infoRestaurante = infoOrderDetail['infoRestaurante'];

    infoPedido = infoOrderDetail['infoPedido'];
    infoProductos = infoOrderDetail['listaProductos'] != null
        ? infoOrderDetail['listaProductos']
        : [];
    cajasSorpresas = infoOrderDetail['infoPedido']['productosSorpresa'] != null
        ? infoOrderDetail['infoPedido']['productosSorpresa']
        : [];
    !cargodatos ? geInfoProducsAndToppings() : const LoadingIndicatorW();

    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Adapt.px(100)),
          child: AppBarW(
            bottonBack: "",
            textoLabel: AppLocalizations.of(context)!.detalleDeOrder,
            anotherButton: Container(
              width: Adapt.wp(12),
            ),
            bottonBackAction: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [const BackgroundShop(), _body(size)],
        ),
      ),
    );
  }

  Widget _body(size) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: Adapt.hp(10)),
          SizedBox(
            height: Adapt.hp(75),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _infoPedido(size),
                  estadoPedido(),
                  SizedBox(height: Adapt.hp(1)),
                  textDeInformacion(
                    AppLocalizations.of(context)!.infoRestaurante,
                  ),
                  _infoRestaurante(),
                  textDeInformacion(
                    AppLocalizations.of(context)!.productos,
                  ),
                  _infoProductos(),
                  _infoProductoSorpresa(),
                  detallesToppings.isNotEmpty
                      ? textDeInformacion(
                          AppLocalizations.of(context)!.adicionales,
                        )
                      : Container(),
                  detallesToppings.isNotEmpty ? _infoToppings() : Container(),
                  textDeInformacion(
                    AppLocalizations.of(context)!.comentarios,
                  ),
                  _infoComentarios(size),
                  _metodoPago(),
                  SizedBox(height: Adapt.hp(1)),
                  infoPedido["estado"] == 'No efectivo' ||
                          infoPedido["estado"] == 'Entregado'
                      ? Container(
                          width: Adapt.wp(50),
                          height: Adapt.hp(5),
                          child: ElevatedButton(
                            child: Text(
                              '${AppLocalizations.of(context)!.calificanos}'
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontSize: Adapt.px(20),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat-ExtraBold',
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                //padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                                primary: ColorSelect.primaryColorVaco,
                                textStyle: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat-ExtraBold',
                                    color: Color.fromARGB(255, 0, 0, 0))),
                            onPressed: () {
                              Navigator.pushNamed(context, '/ratingRestaurant',
                                  arguments: {
                                    "nombreRestaurante": infoRestaurante[index]
                                        ['nombre'],
                                    "idRestaurante": infoRestaurante[index]
                                        ['id'],
                                    "idImagenProducto": infoRestaurante[index]
                                        ['idImagen'],
                                  });
                            },
                          ),
                        )
                      : Container(),
                  SizedBox(height: Adapt.hp(2)),
                ],
              ),
            ),
          ),
          _totalPrice(),
          SizedBox(height: Adapt.hp(1)),
        ],
      ),
    );
  }

  Widget textDeInformacion(textInfo) {
    return Padding(
      padding: EdgeInsets.all(Adapt.px(15)),
      child: Align(
        alignment: Alignment.topLeft,
        child: FittedBox(
          child: Text(
            textInfo.toUpperCase(),
            style: TextStyle(
                fontSize: Adapt.px(30),
                color: const Color.fromARGB(255, 105, 105, 105)),
          ),
        ),
      ),
    );
  }

  Widget estadoPedido() {
    dynamic a = Colors.red;

    if (infoPedido['estado'] == 'No efectivo' ||
        infoPedido['estado'] == 'Cancelado' ||
        infoPedido['estado'] == 'Pendiente') {
      a = Colors.red;
    } else if (infoPedido['estado'] == 'En preparación' ||
        infoPedido['estado'] == 'Para entregar') {
      a = const Color.fromARGB(255, 255, 123, 0);
    } else if (infoPedido['estado'] == 'Entregado') {
      a = Colors.green;
    }

    return Padding(
      padding: EdgeInsets.all(Adapt.px(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: a,
        ),
        width: Adapt.wp(65),
        height: Adapt.hp(5),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${infoPedido['estado'].toUpperCase()}',
              style: TextStyle(fontSize: Adapt.px(40), color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoPedido(size) {
    if (cargodatos == true) {
      return Padding(
        padding: EdgeInsets.all(Adapt.px(10)),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(Adapt.px(10)),
              child: SizedBox(
                width: Adapt.wp(35),
                height: Adapt.hp(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      '${Env.currentEnv['serverUrl']}/imagenRestaurante/traerImagen?id=${infoRestaurante[index]['idImagen']}',
                      fit: BoxFit.cover),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  width: Adapt.wp(55),
                  child: FittedBox(
                    child: Text(
                      "${infoRestaurante[index]['nombre']}".toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'Montserrat-ExtraBold',
                          fontSize: Adapt.px(45),
                          color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: Adapt.hp(0.5),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: Adapt.wp(55),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${AppLocalizations.of(context)!.pedido} #${infoPedido['numeroPedido']}",
                      style: TextStyle(
                          fontSize: Adapt.px(20), color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: Adapt.wp(55),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${AppLocalizations.of(context)!.fechaPedido}${infoPedido["fechaCreacion"].split("-")[2].split("T")[0]}-${infoPedido["fechaCreacion"].split("-")[1]}-${infoPedido["fechaCreacion"].split("-")[0]}",
                      style: TextStyle(
                          fontSize: Adapt.px(22), color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  width: Adapt.wp(55),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${AppLocalizations.of(context)!.hora}: ${infoPedido["fechaCreacion"].split("T")[1].split(":")[0]}:${infoPedido["fechaCreacion"].split("T")[1].split(":")[1]}",
                      style: TextStyle(
                          fontSize: Adapt.px(22), color: Colors.black),
                    ),
                  ),
                ),
                infoPedido["estado"] == 'No efectivo' ||
                        infoPedido["estado"] == 'Cancelado' ||
                        infoPedido["estado"] == 'Entregado'
                    ? Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            width: Adapt.wp(55),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "${AppLocalizations.of(context)!.fechaFinalizacion}${infoPedido["fechaFinalizacion"].split("-")[2].split("T")[0]}-${infoPedido["fechaFinalizacion"].split("-")[1]}-${infoPedido["fechaFinalizacion"].split("-")[0]}",
                                style: TextStyle(
                                    fontSize: Adapt.px(20),
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            width: Adapt.wp(55),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "${AppLocalizations.of(context)!.hora}: ${infoPedido["fechaFinalizacion"].split("T")[1].split(":")[0]}:${infoPedido["fechaFinalizacion"].split("T")[1].split(":")[1]}",
                                style: TextStyle(
                                    fontSize: Adapt.px(20),
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _infoRestaurante() {
    if (cargodatos == true) {
      return SizedBox(
        width: Adapt.wp(99),
        height: Adapt.hp(12),
        child: Padding(
          padding: EdgeInsets.all(Adapt.px(10)),
          child: Column(
            children: [
              Container(
                height: Adapt.hp(6),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: Adapt.px(30),
                      color: ColorSelect.primaryColorVaco,
                    ),
                    Container(
                      width: Adapt.wp(1),
                    ),
                    Container(
                      width: Adapt.wp(85),
                      child: Text(
                        "${AppLocalizations.of(context)!.direccion}: ${infoRestaurante[index]['direccion']}",
                        style: TextStyle(
                            fontSize: Adapt.px(25), color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: Adapt.hp(1),
              ),
              Container(
                height: Adapt.hp(3),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: Adapt.px(30),
                      color: ColorSelect.primaryColorVaco,
                    ),
                    Container(
                      width: Adapt.wp(1),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      width: Adapt.wp(60),
                      child: Text(
                        "${AppLocalizations.of(context)!.telefono}: ${infoRestaurante[index]['telefono']}",
                        style: TextStyle(
                            fontSize: Adapt.px(25), color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _infoProductos() {
    if (cargodatos == true) {
      return Center(
        child: Padding(
            padding: EdgeInsets.all(Adapt.px(10)),
            child: Column(
              children: List.generate(detallesProductos.length, (index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color.fromARGB(255, 128, 128, 128),
                                width: 1),
                          ),
                          width: Adapt.wp(30),
                          height: Adapt.hp(15),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              '${Env.currentEnv['serverUrl']}/imagenProducto/traerImagen?id='
                              '${detallesProductos[index]["idImagen"]}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Adapt.px(15)),
                          child: Container(
                            alignment: Alignment.topLeft,
                            width: Adapt.wp(60),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${detallesProductos[index]["nombre"]}',
                                style: TextStyle(
                                    fontSize: Adapt.px(30),
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Adapt.px(10)),
                  ],
                );
              }),
            )),
      );
    } else {
      return const LoadingIndicatorW();
    }
  }

  Widget _infoProductoSorpresa() {
    if (cargodatos == true) {
      return detallesBolsaSorpresa.length != 0
          ? Center(
              child: Padding(
                  padding: EdgeInsets.all(Adapt.px(10)),
                  child: Column(
                    children:
                        List.generate(detallesBolsaSorpresa.length, (index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 128, 128, 128),
                                      width: 1),
                                ),
                                width: Adapt.wp(30),
                                height: Adapt.hp(15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'assets/products/Bolsa.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: Adapt.px(15)),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  width: Adapt.wp(60),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${detallesBolsaSorpresa[index]["nombre"]}',
                                      style: TextStyle(
                                          fontSize: Adapt.px(30),
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Adapt.px(10)),
                        ],
                      );
                    }),
                  )),
            )
          : Container();
    } else {
      return const LoadingIndicatorW();
    }
  }

  Widget _infoToppings() {
    if (cargodatos == true) {
      return Center(
        child: Padding(
            padding: EdgeInsets.all(Adapt.px(10)),
            child: Column(
              children: List.generate(detallesToppings.length, (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${detallesToppings[index].nombre}',
                        style: TextStyle(
                            fontSize: Adapt.px(30), color: Colors.black)),
                    Text(
                      '\$${detallesToppings[index].precio}',
                      style: TextStyle(
                          fontSize: Adapt.px(20), color: Colors.black),
                    ),
                  ],
                );
              }),
            )),
      );
    } else {
      return Container();
    }
  }

  Widget _infoComentarios(size) {
    if (cargodatos == true) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(Adapt.px(10)),
          child: infoPedido["justificacionCancelacion"] == ''
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color.fromARGB(255, 128, 128, 128),
                        width: 1),
                  ),
                  height: Adapt.hp(10),
                  width: Adapt.wp(100),
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.noComentarios,
                        style: TextStyle(
                            fontSize: Adapt.px(20), color: Colors.black)),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color.fromARGB(255, 128, 128, 128),
                        width: 1),
                  ),
                  height: Adapt.hp(10),
                  width: Adapt.wp(100),
                  child: Center(
                    child: Text('${infoPedido["justificacionCancelacion"]}',
                        style: TextStyle(
                            fontSize: Adapt.px(20), color: Colors.black)),
                  ),
                ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _metodoPago() {
    return Column(
      children: [
        textDeInformacion(
          AppLocalizations.of(context)!.metodoPago,
        ),
        SizedBox(width: Adapt.wp(10)),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(Adapt.px(10)),
              child: Icon(Icons.payment,
                  color: infoPedido["metodoPago"] == 'Efectivo'
                      ? ColorSelect.primaryColorVaco
                      : Colors.black),
            ),
            Padding(
              padding: EdgeInsets.all(Adapt.px(10)),
              child: Text(
                AppLocalizations.of(context)!.efectivo,
                style: TextStyle(fontSize: Adapt.px(20), color: Colors.black),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(Adapt.px(10)),
              child: Icon(Icons.payment,
                  color: infoPedido["metodoPago"] == 'Tarjeta debito'
                      ? ColorSelect.primaryColorVaco
                      : Colors.black),
            ),
            Padding(
              padding: EdgeInsets.all(Adapt.px(10)),
              child: Text(
                AppLocalizations.of(context)!.tarjetaDebito,
                style: TextStyle(fontSize: Adapt.px(20), color: Colors.black),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(Adapt.px(10)),
              child: Icon(Icons.payment,
                  color: infoPedido["metodoPago"] == 'Tarjeta credito'
                      ? ColorSelect.primaryColorVaco
                      : Colors.black),
            ),
            Padding(
              padding: EdgeInsets.all(Adapt.px(10)),
              child: Text(
                AppLocalizations.of(context)!.tarjetaCredito,
                style: TextStyle(fontSize: Adapt.px(20), color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void geInfoProducsAndToppings() async {
    for (var i = 0; i < infoProductos.length; i++) {
      Map respuesta =
          await searchProduct.obtenerProductoDelRestaurante(infoProductos[i]);
      detallesProductos.add(respuesta);
    }
    print(cajasSorpresas.length);
    for (var i = 0; i < cajasSorpresas.length; i++) {
      Map respuesta =
          await bagService.buscarBolsaPorRestaurante(cajasSorpresas[i]);
      print(respuesta);
      detallesBolsaSorpresa.add(respuesta);
    }
    for (var j = 0; j < infoPedido['toppings'].length; j++) {
      ToppingsModel respuesta =
          await searchProduct.obtenerTopping(infoPedido['toppings'][j]);
      detallesToppings.add(respuesta);
    }

    setState(() {
      cargodatos = true;
    });
  }

  Widget _totalPrice() {
    return Container(
      height: Adapt.hp(6),
      width: Adapt.wp(90),
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 56, 56, 56), width: 0.2),
        color: ColorSelect.primaryColorVaco,
        borderRadius: const BorderRadius.all(
          Radius.circular(45),
        ),
      ),
      child: Center(
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: Adapt.px(30)),
              child: Text(
                'TOTAL',
                style: TextStyle(
                  fontSize: Adapt.px(20),
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: Adapt.wp(38)),
            Padding(
              padding: EdgeInsets.all(Adapt.px(10)),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                width: Adapt.wp(30),
                height: Adapt.hp(6.5),
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: Adapt.px(25)),
                    child: Text(
                      '\$${infoPedido["precio"]}',
                      style: TextStyle(
                        fontSize: Adapt.px(20),
                        color: Colors.black,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
