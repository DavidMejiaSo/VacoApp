// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/service/order_service.dart';
import 'package:prueba_vaco_app/service/products_service.dart';
import 'package:prueba_vaco_app/service/restaurant_service.dart';
import 'package:prueba_vaco_app/src/pages/cart/payment_method.dart';
import 'package:prueba_vaco_app/src/pages/products/grocery_product_cart_edit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../../model/controller_arg_pay_u.dart';
import '../../../model/controller_arg_pay_u_response.dart';
import '../../../provider/cart_shop_provider.dart';
import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';

import '../../../service/pay_u_service.dart';
import '../../widgets/appBar.dart';
import '../../widgets/loading_indicator.dart';

class CartDetail extends StatefulWidget {
  const CartDetail({Key? key}) : super(key: key);

  @override
  State<CartDetail> createState() => _CartDetailState();
}

///Variables

String usuario = prefs.usuario;
bool cartInfo = false;
String observacion = "";

///Instancias
final prodcutService = ProductsService();
final prefs = PreferenciasUsuario();
final orderService = OrderService();
final restauranteService = RestaurantService();

class _CartDetailState extends State<CartDetail> {
  String denominacionBillete = '';
  final payUService = PayUService();
  CarritoComprasProvider? carritoCompras;

  @override
  Widget build(BuildContext context) {
    carritoCompras = Provider.of<CarritoComprasProvider>(context);
    return SafeArea(
      child: Hero(
        tag: 'cart',
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(Adapt.px(100)),
            child: AppBarW(
              bottonBack: "",
              textoLabel: AppLocalizations.of(context)!.tuBolsa,
              anotherButton: Container(
                width: Adapt.wp(12),
              ),
              bottonBackAction: () {
                Navigator.pop(context);
              },
            ),
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              const BackgroundShop(),
              _body(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    try {
      return Container(
        child: Column(
          children: [
            Container(
              height: Adapt.hp(10),
            ),
            _textRestaurant(),
            Divider(
              height: Adapt.hp(2),
              color: ColorSelect.greyColor,
            ),
            Flexible(
              child: viewProductsCarrito(),
            ),
            Divider(
              color: ColorSelect.greyColor,
            ),
            cajaObservacion(context),
            Divider(
              color: ColorSelect.greyColor,
            ),
            paymentMethod(context),
            Divider(
              color: ColorSelect.greyColor,
            ),
            totalCart(),
            Container(
              height: Adapt.hp(1),
            ),
          ],
        ),
      );
    } catch (e) {
      return Container();
    }
  }

  Widget _textRestaurant() {
    try {
      if (carritoCompras!.listaProductosCarrito.isNotEmpty) {
        return Container(
          height: Adapt.hp(14),
          width: Adapt.wp(95),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Adapt.wp(1),
              ),
              Container(
                height: Adapt.hp(14),
                width: Adapt.wp(30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    '${Env.currentEnv['serverUrl']}/imagenRestaurante/traerImagen?id=${carritoCompras!.organizadorRestaurante?.idImagen}',
                    height: Adapt.hp(20),
                    width: Adapt.wp(30),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          'https://png.pngtree.com/png-vector/20210227/ourlarge/pngtree-error-404-glitch-effect-png-image_2943478.jpg',
                          height: Adapt.hp(20),
                          width: Adapt.wp(30),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                width: Adapt.wp(1),
              ),
              Container(
                height: Adapt.hp(14),
                width: Adapt.wp(60),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: Adapt.hp(6.5),
                        width: Adapt.wp(60),
                        child: Text(
                          carritoCompras!.organizadorRestaurante!.nombre
                              .toString()
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Adapt.px(50),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat-ExtraBold',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: Adapt.hp(6.5),
                      width: Adapt.wp(60),
                      child: TextButton(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Volver a la tienda",
                              style: TextStyle(
                                fontSize: Adapt.px(25),
                                color: Color.fromARGB(255, 165, 211, 0),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return SizedBox(
          height: Adapt.hp(12),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  AppLocalizations.of(context)!.tuBolsaVacia,
                  style: TextStyle(
                    fontSize: Adapt.px(35),
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
      return const LoadingIndicatorW();
    }
  }

  Widget viewProductsCarrito() {
    if (carritoCompras!.listaProductosCompletosCarrito.isNotEmpty) {
      try {
        return Container(
          height: Adapt.hp(43),
          child: GridView.builder(
            padding: const EdgeInsets.only(left: 18, right: 18),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3.0,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: Adapt.hp(0.5),
              mainAxisExtent: Adapt.hp(14),
            ),
            itemCount: carritoCompras!.listaProductosCarrito.length,
            itemBuilder: (BuildContext context, int index) {
              try {
                return Container(
                  child: Row(
                    children: [
                      carritoCompras!.listaProductosCarrito[index].esCajita ==
                              true
                          ? Flexible(
                              flex: 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(
                                  'assets/products/Bolsa.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Flexible(
                              flex: 5,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      '${Env.currentEnv['serverUrl']}/imagenProducto/traerImagen?id='
                                      '${carritoCompras!.listaProductosCompletosCarrito[index].idImagen}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 1,
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor:
                                          ColorSelect.primaryColorVaco,
                                      child: Center(
                                        child: IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: Colors.white,
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              PageRouteBuilder(
                                                pageBuilder:
                                                    (context, animation, __) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: ProductEditCart(
                                                      product: carritoCompras!
                                                              .listaProductosCompletosCarrito[
                                                          index],
                                                      index: index,
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      Flexible(
                        flex: 9,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: Adapt.wp(80),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 14),
                                height: Adapt.hp(6),
                                child: Text(
                                  carritoCompras!
                                      .listaProductosCompletosCarrito[index]
                                      .nombre,
                                  style: TextStyle(
                                    fontSize: Adapt.px(30),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                height: Adapt.hp(1),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.only(left: 14),
                                height: Adapt.hp(5),
                                child: Text(
                                  '\$${int.parse(carritoCompras!.listaProductosCompletosCarrito[index].precio) + carritoCompras!.listaPreciosToppingsProductosCarrito[index]} ',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: const Color.fromARGB(255, 145, 138, 138),
                        onPressed: () async {
                          carritoCompras!.totalPrecioCarrito -= int.parse(
                              carritoCompras!
                                  .listaProductosCompletosCarrito[index]
                                  .precio);
                          carritoCompras!.totalPrecioCarrito -= carritoCompras!
                              .listaPreciosToppingsProductosCarrito[index];
                          carritoCompras!.listaProductosCarrito.removeAt(index);

                          carritoCompras!.listaProductosCompletosCarrito
                              .removeAt(index);

                          carritoCompras!.listaPreciosToppingsProductosCarrito
                              .removeAt(index);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              } catch (e) {
                print('soy error2 $e');
                return const Center(child: LoadingIndicatorW());
              }
            },
          ),
        );
      } catch (e) {
        return LoadingIndicatorW();
      }
    } else {
      return Container(
        height: Adapt.hp(40),
        child: const Center(
          child: Text(
            "",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      );
    }
  }

  Widget totalCart() {
    return InkWell(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: Adapt.hp(8),
          width: Adapt.wp(90),
          decoration: BoxDecoration(
            color: ColorSelect.primaryColorVaco,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "  ${AppLocalizations.of(context)!.pagar}",
                  style: TextStyle(
                    fontSize: Adapt.px(25),
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Total: \$${carritoCompras!.totalPrecioCarrito}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        print('funciono gornrooasd');
        metodoPago(context);
      },
    );
  }

  Widget cajaObservacion(context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color.fromARGB(255, 128, 128, 128), width: 1),
        ),
        height: Adapt.hp(12),
        width: Adapt.wp(100),
        child: Center(
          child: TextFormField(
            style: TextStyle(fontSize: Adapt.px(30), color: Colors.black),
            maxLines: 10,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(Adapt.px(10)),
              hintText: "Observaciones",
              hintStyle: TextStyle(
                  fontSize: Adapt.px(25),
                  color: const Color.fromARGB(255, 163, 160, 160)),
            ),
            onChanged: (String value) {
              setState(() {
                observacion = value;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget paymentMethod(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: PaymentMethod()));

        //  Navigator.pushNamed(context, '/selectPayment');
      },
      child: Container(
        height: Adapt.hp(6),
        width: Adapt.screenW(),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: Adapt.px(25), right: Adapt.px(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'METODO DE PAGO',
                  style: TextStyle(
                    fontSize: Adapt.px(25),
                    color: Colors.black,
                    fontFamily: 'Montserrat-ExtraBold',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.arrow_forward_ios_sharp)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void metodoPago(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 20,
            backgroundColor: Colors.white,
            title: Center(
                child: Text(
              AppLocalizations.of(context)!.saludo,
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: ColorSelect.primaryColorVaco),
            )),
            content: SizedBox(
              height: Adapt.hp(5),
              width: Adapt.wp(95),
              child: SingleChildScrollView(
                child: Center(
                  child: Text(
                    'seleccione metodo de pago',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    maxLines: 15,
                  ),
                ),
              ),
            ),
            actions: [
              Column(
                children: [
                  InkWell(
                    child: Container(
                      height: Adapt.hp(8),
                      width: Adapt.wp(90),
                      child: Row(
                        children: [
                          Container(
                              height: Adapt.hp(6),
                              width: Adapt.wp(20),
                              child: Image.network(
                                  'https://dplnews.com/wp-content/uploads/2019/04/dplnews_efectivo_jb190419.jpg')),
                          Container(
                              alignment: Alignment.center,
                              height: Adapt.hp(6),
                              width: Adapt.wp(50),
                              child: Text(
                                'Efectivo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: Adapt.px(20),
                                    color: Colors.black),
                              )),
                        ],
                      ),
                    ),
                    onTap: () {
                      metodoPagoEfectivo();
                    },
                  ),
                  Container(
                    height: Adapt.hp(0.1),
                    color: Colors.black,
                  ),
                  InkWell(
                    child: Container(
                      height: Adapt.hp(8),
                      width: Adapt.wp(90),
                      child: Row(
                        children: [
                          Container(
                              height: Adapt.hp(6),
                              width: Adapt.wp(20),
                              child: Image.network(
                                  'https://1000marcas.net/wp-content/uploads/2021/06/Logo-PayU.jpg')),
                          Container(
                              alignment: Alignment.center,
                              height: Adapt.hp(6),
                              width: Adapt.wp(50),
                              child: Text(
                                'PayU',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: Adapt.px(20),
                                    color: Colors.black),
                              )),
                        ],
                      ),
                    ),
                    onTap: () {
                      metodoPagoPayU();
                    },
                  ),
                  Container(
                    height: Adapt.hp(1),
                  ),
                ],
              )
            ],
          );
        });
  }

  void metodoPagoEfectivo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 20,
            backgroundColor: Colors.white,
            title: Center(
                child: Text(
              'Efectivo',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 36, color: ColorSelect.primaryColorVaco),
            )),
            content: SizedBox(
              height: Adapt.hp(7),
              width: Adapt.wp(95),
              child: Center(
                child: Text(
                  'seleccione de nominación del billete',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  maxLines: 15,
                ),
              ),
            ),
            actions: [
              Container(
                height: Adapt.hp(4),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Nominación',
                    labelStyle: TextStyle(
                      fontSize: Adapt.px(20),
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (value) {
                    denominacionBillete = value;
                  },
                ),
              ),
              Container(
                height: Adapt.hp(2),
              ),
              Container(
                height: Adapt.hp(6),
                width: Adapt.wp(95),
                child: ElevatedButton(
                  child: Text('ACEPTAR',
                      style: TextStyle(
                          fontSize: Adapt.px(20),
                          color: Colors.black,
                          fontFamily: 'Montserrat-ExtraBold')),
                  onPressed: () async {
                    dynamic respuesta = await orderService.crearOrden(
                      usuario,
                      carritoCompras!.restaurantePrincipal,
                      carritoCompras!.totalPrecioCarrito.toString(),
                      'Efectivo',
                      carritoCompras!.listaProductosCarritoFinal,
                      carritoCompras!.listaIdCajasCarrito,
                      carritoCompras!.listaToppingsProductosCarrito,
                      observacion,
                      denominacionBillete,
                    );
                    Navigator.pushReplacementNamed(context, '/detailOrder');

                    prefs.idOrden = respuesta['id'];

                    carritoCompras!.limpiarCarrito();
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      primary: ColorSelect.primaryColorVaco,
                      textStyle:
                          const TextStyle(fontSize: 24, color: Colors.black)),
                ),
              )
            ],
          );
        });
  }

  void metodoPagoPayU() async {
    PayUModelService init = PayUModelService(
        language: "es",
        command: "SUBMIT_TRANSACTION",
        merchant: Merchant(
            apiKey: '4Vj8eK4rloUd272L48hsrarnUA', apiLogin: 'pRRXKOl8ikMmt9u'),
        transaction: Transaction(
          order: Order(
            accountId: "512321",
            referenceCode: "PRODUCT_TEST_2021-06-23T19:59:43.229Z",
            description: "Payment test description",
            language: "es",
            signature: "1d6c33aed575c4974ad5c0be7c6a1c87",
            notifyUrl: "http://www.payu.com/notify",
            additionalValues: AdditionalValues(
              txValue: Tx(value: 65000, currency: "COP"),
              txTax: Tx(value: 10378, currency: "COP"),
              txTaxReturnBase: Tx(value: 54622, currency: "COP"),
            ),
            buyer: Buyer(
                merchantBuyerId: "1",
                fullName: "First name and second buyer name",
                emailAddress: "buyer_test@test.com",
                contactPhone: "7563126",
                dniNumber: "123456789",
                shippingAddress: IngAddress(
                    street1: "Cr 23 No. 53-50",
                    street2: "5555487",
                    city: "Bogotá",
                    state: "Bogotá D.C.",
                    country: "CO",
                    postalCode: "000000",
                    phone: "7563126")),
            shippingAddress: IngAddress(
                street1: "Cr 23 No. 53-50",
                street2: "5555487",
                city: "Bogotá",
                state: "Bogotá D.C.",
                country: "CO",
                postalCode: "000000",
                phone: "7563126"),
          ),
          payer: Payer(
              merchantPayerId: "1",
              fullName: "First name and second payer name",
              emailAddress: "payer_test@test.com",
              contactPhone: "7563126",
              dniNumber: "5415668464654",
              billingAddress: IngAddress(
                  street1: "Cr 23 No. 53-50",
                  street2: "5555487",
                  city: "Bogotá",
                  state: "Bogotá D.C.",
                  country: "CO",
                  postalCode: "000000",
                  phone: "7563126")),
          creditCard: CreditCard(
              number: "4037997623271984",
              securityCode: "321",
              expirationDate: "2030/12",
              name: "APPROVED"),
          extraParameters: ExtraParameter(installmentsNumber: 1),
          type: "AUTHORIZATION_AND_CAPTURE",
          paymentMethod: "VISA",
          paymentCountry: "CO",
          deviceSessionId: "vghs6tvkcle931686k1900o6e1",
          ipAddress: "192.168.1.71",
          cookie: "pt1t38347bs6jc9ruv2ecpv7o2",
          userAgent:
              "Mozilla/5.0 (Windows NT 5.1; rv:18.0) Gecko/20100101 Firefox/18.0",
          threeDomainSecure: ThreeDomainSecure(
              embedded: false,
              eci: "01",
              cavv: "AOvG5rV058/iAAWhssPUAAADFA==",
              xid: "Nmp3VFdWMlEwZ05pWGN3SGo4TDA=",
              directoryServerTransactionId:
                  "00000-70000b-5cc9-0000-000000000cb"),
        ),
        test: true);
    print('soy lo mejors');
    // pruebas
    var apiKey = "4Vj8eK4rloUd272L48hsrarnUA";
    var accountId = "512321";
    var referenceCode = "PRODUCT_TEST_2021-06-23T19:59:43.229Z";
    var tx_value = "65000";
    var currency = "COP";
    // pruebas
    var dataToHash = '$apiKey~$accountId~$referenceCode~$tx_value~$currency';
    var bytesToHash = utf8.encode(dataToHash);
    String md5Digest = md5.convert(bytesToHash).toString();
    print(md5Digest);

    print(init.transaction.order.referenceCode);
    ResponsePayModel responsePayU = await payUService.buildPayment(init);
    print(responsePayModelToJson(responsePayU));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 20,
            backgroundColor: Colors.white,
            title: Center(
                child: Text(
              'PayU',
              style:
                  TextStyle(fontSize: 36, color: ColorSelect.primaryColorVaco),
            )),
            content: SizedBox(
              height: Adapt.hp(5),
              width: Adapt.wp(95),
              child: SingleChildScrollView(
                child: Center(
                  child: Text(
                    'No disponible en el momento',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    maxLines: 15,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
