// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/model/controller_arg_bag.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/bag_service.dart';
import 'package:prueba_vaco_app/service/cart_service.dart';
import 'package:prueba_vaco_app/service/products_service.dart';
import 'package:prueba_vaco_app/src/pages/cart/grocery_store_cart_detail.dart';
import 'package:prueba_vaco_app/backgrouds_widgets/background_sopresa.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/controller_arg_addProductCart.dart';
import '../../../model/controller_arg_product.dart';
import '../../../model/controller_toppigs.dart';
import '../../../provider/cart_shop_provider.dart';
import '../../../responsive/Color.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/elevated_botton_cancel.dart';
import '../../widgets/loading_indicator.dart';

class BagDetail extends StatefulWidget {
  const BagDetail({Key? key}) : super(key: key);

  @override
  State<BagDetail> createState() => _BagDetailState();
}

final bagService = BagService();
final productosService = ProductsService();
final carritoService = CartSevice();
List restaurantes = [];
List productos = [];
List toppingsCarrito = [];
bool evaluados = false;
String usuario = prefs.usuario;
String idBolsa = "";

class _BagDetailState extends State<BagDetail> {
  get restaurante => ModalRoute.of(context)!.settings.arguments as ArgumentsBag;

  void agregarBolsaCarrito() async {
    try {
      final carritoService = CartSevice();

      await carritoService.agregarACarrito(usuario, idBolsa, toppingsCarrito);
      print("agreganda la bolsa");
    } catch (e) {
      print("este es el error $e");
    }
  }

  @override
  void initState() {
    evaluados = true;
    super.initState();
  }

  CarritoComprasProvider? carritoCompras;
  @override
  Widget build(BuildContext context) {
    carritoCompras = Provider.of<CarritoComprasProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const BackgroundSorpresa(),
            _body(context),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        _bodyParteUno(),
        SizedBox(
          height: Adapt.hp(16),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: Adapt.hp(6),
          width: Adapt.wp(100),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.only(left: Adapt.wp(5)),
              child: Text('Bolsa sorpresa'.toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: Adapt.hp(3),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat-ExtraBold',
                      color: Colors.black)),
            ),
          ),
        ),
        Flexible(
          child: bagDetailList(context),
        ),
      ],
    );
  }

  Widget _bodyParteUno() {
    Image image = Image.asset(
      'assets/products/BotonCompras.png',
      fit: BoxFit.cover,
    );
    Image imageCerrar = Image.asset(
      'assets/botones/BotonCerrar.png',
      fit: BoxFit.cover,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.07,
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: imageCerrar.image),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                  child: Hero(
                    tag: 'cart',
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: image.image),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: ColorSelect.primaryColorVaco,
                    child: Text(
                      '${carritoCompras!.listaProductosCarrito.length}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 12, 12, 12),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bagDetailList(BuildContext context) {
    idBolsa = "";

    if (evaluados) {
      return FutureBuilder(
        future: bagService.obtenerBolsaPorRestaurante(restaurante.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                List listProducts = [];
                if (snapshot.data[index]['carbohidratos'] != "") {
                  listProducts.add(
                      'Carbohidratos ${snapshot.data[index]['carbohidratos']}');
                }
                if (snapshot.data[index]['vegetales'] != "") {
                  listProducts
                      .add('Vegetales ${snapshot.data[index]['vegetales']}');
                }
                if (snapshot.data[index]['frutas'] != "") {
                  listProducts.add('Frutas ${snapshot.data[index]['frutas']}');
                }
                if (snapshot.data[index]['postres'] != "") {
                  listProducts
                      .add('Postres ${snapshot.data[index]['postres']}');
                }
                if (snapshot.data[index]['bebidas'] != "") {
                  listProducts
                      .add('Bebidas ${snapshot.data[index]['bebidas']}');
                }

                return GestureDetector(
                  onTap: () async {
                    //print(snapshot.data[index]);
                    carritoCompras!.restaurantePrincipal ==
                                snapshot.data[index]['idRestauranteCreador'] ||
                            carritoCompras!.restaurantePrincipal == ''
                        ? agregarProductoAlCarrito(
                            context, snapshot.data[index])
                        : alertAddCart(context);
                  },
                  child: InkWell(
                    child: SizedBox(
                      height: Adapt.hp(18),
                      width: Adapt.wp(100),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(Adapt.px(5)),
                              child: Hero(
                                tag: 'list_${snapshot.data[index]['id']}',
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.asset(
                                        'assets/products/Bolsa.png',
                                        height: Adapt.hp(60),
                                        width: Adapt.wp(35),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: FittedBox(
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.only(left: 14),
                                      height: Adapt.hp(4),
                                      width: Adapt.wp(65),
                                      child: Text(
                                        snapshot.data[index]["nombre"],
                                        style: TextStyle(
                                          shadows: const <Shadow>[
                                            Shadow(
                                              offset: Offset(0.5, 0.5),
                                              blurRadius: 1.0,
                                              color: Colors.black,
                                            ),
                                          ],
                                          fontSize: Adapt.px(30),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat-ExtraBold',
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.only(left: 14),
                                      height: Adapt.hp(6),
                                      width: Adapt.wp(65),
                                      child: Text(
                                        '$listProducts',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: Adapt.px(24),
                                          color: const Color.fromARGB(
                                              255, 107, 107, 107),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: Adapt.wp(58),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: Text(
                                              '\$${snapshot.data[index]["precio"].toString()}',
                                              style: const TextStyle(
                                                shadows: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(0.5, 0.5),
                                                    blurRadius: 1.0,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              '\$${snapshot.data[index]["precioOriginal"].toString()}',
                                              style: const TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 134, 134, 134),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: LoadingIndicatorW(),
            );
          }
        },
      );
    } else {
      return const Center(
        child: LoadingIndicatorW(),
      );
    }
  }

  void alertAddCart(context) {
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
              '${AppLocalizations.of(context)!.loSentimosCarrito}  ${AppLocalizations.of(context)!.alertaCarrito}  ${AppLocalizations.of(context)!.preguntaVaciarCarrito}',
          bottonAcept: ElevatedButton(
            style: style,
            child: Text(AppLocalizations.of(context)!.aceptar,
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            onPressed: () {
              carritoCompras!.limpiarCarrito();
              Navigator.pop(context);
              setState(() {});
            },
          ),
          bottonCancel: ElevatedButtonCancelCustom(),
        );
      },
    );
  }

  void agregarProductoAlCarrito(context, idRestauranteCreador) {
    final snackBar = SnackBar(
      content: Text(AppLocalizations.of(context)!.seAgrego,
          style: const TextStyle(color: Colors.black)),
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.ir,
        textColor: const Color.fromARGB(255, 10, 10, 10),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/cart');
        },
      ),
    );
    carritoCompras!.restaurantePrincipal =
        idRestauranteCreador['idRestauranteCreador'];
    List<ToppingsModel> finalToppings = [];

    AddProductCartController _productoParaCarrito = AddProductCartController(
      idProducto: idRestauranteCreador['id'],
      esCajita: true,
      toppings: finalToppings,
    );

    carritoCompras!.listaProductosCarrito.add(_productoParaCarrito);
    ProductModel _producto = ProductModel.fromJson(idRestauranteCreador);

    carritoCompras!.listaProductosCompletosCarrito.add(_producto);
    carritoCompras!.listaIdCajasCarrito.add(idRestauranteCreador['id']);
    carritoCompras!.obtenerListaPreciosToppingsProductosCarrito();
    carritoCompras!.obtenerListaProductos2();
    carritoCompras!.obtenerInfoRestaurante();
    carritoCompras!.cantidadproductosCarrito();

    setState(() {});
    //Scaffold.of(context).hideCurrentSnackBar();
    //Scaffold.of(context).showSnackBar(snackBar);
  }
}
