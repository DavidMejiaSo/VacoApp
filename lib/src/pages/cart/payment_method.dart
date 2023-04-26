import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../../model/controller_arg_pay_u.dart';
import '../../../model/controller_arg_pay_u_response.dart';
import '../../../preferences/preferences_user.dart';
import '../../../provider/cart_shop_provider.dart';
import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';
import '../../../service/order_service.dart';
import '../../../service/pay_u_service.dart';
import '../../widgets/appBar.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

final prefs = PreferenciasUsuario();
String usuario = prefs.usuario;
String observacion = "";

class _PaymentMethodState extends State<PaymentMethod> {
  final payUService = PayUService();
  final orderService = OrderService();

  String denominacionBillete = '';

  CarritoComprasProvider? carritoCompras;
  @override
  Widget build(BuildContext context) {
    carritoCompras = Provider.of<CarritoComprasProvider>(context);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Adapt.px(100)),
          child: AppBarW(
            bottonBack: "",
            textoLabel: 'METODO DE PAGO',
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
            _body(),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      height: Adapt.hp(88),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                            fontSize: Adapt.px(20), color: Colors.black),
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
                            fontSize: Adapt.px(20), color: Colors.black),
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
      ),
    );
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
