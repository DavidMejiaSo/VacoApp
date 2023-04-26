import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/enviroment/environment.dart';
import '../../../responsive/Adapt.dart';
import '../../../service/order_history_user_service.dart';
import '../../../service/products_service.dart';
import '../../../service/seach_restaurante_by_id_service.dart';
import '../../widgets/appBar.dart';
import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../widgets/loading_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  bool cargo = false;
  bool verDetalles = false;
  final orderHistoryService = OrderHistoryIngoService();
  final searchRestaurant = SearchRestaurantByIDService();
  final searchProduct = ProductsService();
  List orderHistoryInfo = [],
      pedidosPendiente = [],
      pedidosAceptado = [],
      pedidosParaentregar = [],
      pedidosEntregado = [],
      pedidosPaila = [],
      pedidosNoEfectivo = [],
      pedidosTotales = [],
      infoRestaurante = [],
      infoProductos = [];

  @override
  void initState() {
    super.initState();
    getInfoPedido();
  }

  void getInfoPedido() async {
    orderHistoryInfo = [];
    dynamic respuesta = await orderHistoryService.getInfo();
    orderHistoryInfo = respuesta;
//asignacion de orden de los diferentes pedidos realizados de acuerdo al estado
    for (var i = 0; i < orderHistoryInfo.length; i++) {
      if (orderHistoryInfo[i]['estado'] == 'Pendiente') {
        pedidosPendiente.add(orderHistoryInfo[i]);
      } else if (orderHistoryInfo[i]['estado'] == 'En preparación') {
        pedidosAceptado.add(orderHistoryInfo[i]);
      } else if (orderHistoryInfo[i]['estado'] == 'Para entregar' ||
          orderHistoryInfo[i]['estado'] == 'Recoger pedido') {
        pedidosParaentregar.add(orderHistoryInfo[i]);
      } else if (orderHistoryInfo[i]['estado'] == 'Entregado') {
        pedidosEntregado.add(orderHistoryInfo[i]);
      } else {
        pedidosPaila.add(orderHistoryInfo[i]);
      }

      getInfoRestaurant(orderHistoryInfo[i]['idRestaurante']);
    }

    pedidosTotales.addAll(pedidosPendiente);
    pedidosTotales.addAll(pedidosAceptado);
    pedidosTotales.addAll(pedidosParaentregar);
    pedidosTotales.addAll(pedidosEntregado);
    pedidosTotales.addAll(pedidosPaila);

    if (infoRestaurante.isNotEmpty) {
      setState(() {
        cargo = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Adapt.px(100)),
          child: AppBarW(
            bottonBack: "false",
            textoLabel: AppLocalizations.of(context)!.misPedidosYServicios,
            anotherButton: Container(),
            bottonBackAction: () {},
          ),
        ),
        body: Stack(
          children: [const BackgroundShop(), _body()],
        ),
      ),
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: Adapt.hp(15),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.textHistorialOrden,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Adapt.px(20),
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Flexible(child: _showOrderHistoryUser(pedidosTotales))
        ],
      ),
    );
  }

  Widget _showOrderHistoryUser(pedidosTotales) {
    if (cargo = true) {
      return SizedBox(
        height: Adapt.hp(80),
        width: Adapt.wp(99),
        child: ListView.custom(
          padding: EdgeInsets.zero,
          childrenDelegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              try {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: Adapt.hp(19),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: SizedBox(
                                width: Adapt.wp(25.27),
                                height: Adapt.hp(11.67),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                      '${Env.currentEnv['serverUrl']}/imagenRestaurante/traerImagen?id=${infoRestaurante[index]['idImagen']}',
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            showOrderPart1(index)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } catch (e) {
                return const LoadingIndicatorW();
              }
            },
            childCount: pedidosTotales.length,
          ),
        ),
      );
    } else {
      return const LoadingIndicatorW();
    }
  }

  Widget showOrderPart1(index) {
    return Column(
      children: [
        Container(
          width: Adapt.wp(32),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: infoRestaurante[index]['id'] ==
                      pedidosTotales[index]["idRestaurante"]
                  ? Text(
                      "${infoRestaurante[index]['nombre']}".toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: Adapt.px(25),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat-ExtraBold',
                          color: Color.fromARGB(255, 105, 105, 105)),
                    )
                  : Text(
                      "${infoRestaurante[index]['nombre']}".toUpperCase(),
                      style: TextStyle(
                          fontFamily: 'Montserrat-ExtraBold',
                          fontSize: Adapt.px(25),
                          color: Color.fromARGB(255, 105, 105, 105)),
                    ),
            ),
          ),
        ),
        Container(
          height: Adapt.hp(6),
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/ratingRestaurant',
                    arguments: {
                      "nombreRestaurante": infoRestaurante[index]['nombre'],
                      "idRestaurante": infoRestaurante[index]['id'],
                      "idImagenProducto": infoRestaurante[index]['idImagen'],
                    },
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.calificaPedido,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: Adapt.wp(3),
              ),
              Container(
                width: Adapt.wp(19),
                height: Adapt.hp(4.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    child: verDetalles == true
                        ? Text(
                            AppLocalizations.of(context)!.verMenos,
                            style: TextStyle(
                              fontSize: Adapt.px(20),
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.verMasOrden,
                            style: TextStyle(
                              fontSize: Adapt.px(20),
                              color: Colors.black,
                            ),
                          ),
                  ),
                  onTap: () {
                    verDetalles = !verDetalles;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          width: Adapt.wp(61),
          height: Adapt.hp(0.2),
          color: const Color.fromARGB(255, 124, 124, 124),
        ),
        verDetalles == true
            ? InkWell(
                child: Padding(
                  padding: EdgeInsets.only(top: Adapt.px(5)),
                  child: Container(
                    width: Adapt.wp(58),
                    height: Adapt.hp(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(73, 105, 105, 105),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          AppLocalizations.of(context)!.detalle,
                          style: TextStyle(
                            fontSize: Adapt.px(20),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/orderHistoryDetail',
                    arguments: {
                      'infoPedido': pedidosTotales[index],
                      'infoRestaurante': infoRestaurante,
                      'index': index,
                      'listaProductos': pedidosTotales[index]['productos'],
                    },
                  );
                },
              )
            : Container(),
      ],
    );
  }

  void getInfoRestaurant(idRestaurante) async {
    dynamic respuesta = await searchRestaurant.getRestaurant(idRestaurante);
    infoRestaurante.add(respuesta);

    setState(() {});
  }
}
