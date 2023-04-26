// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/products_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../model/controller_arg_addProductCart.dart';
import '../../../model/controller_arg_product.dart';
import '../../../model/controller_toppigs.dart';
import '../../../provider/cart_shop_provider.dart';
import '../../../responsive/Color.dart';
import '../../widgets/alert_dialog.dart';
import '../../widgets/button_back_widget.dart';
import '../../widgets/elevated_botton_cancel.dart';
import '../../widgets/loading_indicator.dart';

class GroceryProductDetails extends StatefulWidget {
  const GroceryProductDetails({
    Key? key,
    @required this.product,
  }) : super(key: key);

  final dynamic product;

  @override
  State<GroceryProductDetails> createState() => _GroceryProductDetailsState();
}

final prefs = PreferenciasUsuario();
String usuario = prefs.usuario;
List toppingsAdicionados = [];
List toppingsCarrito = [];
dynamic listaProductosCarrito = [];
int listaProductosCarritoNumero = 0;
dynamic productosCarrito = [];
String restauranteEnElCarrito = "";
String restauranteAEvaluar = "";

class _GroceryProductDetailsState extends State<GroceryProductDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<ToppingsModel> toppingsInfo = [];
  bool cargoToppings = false;
  String heroTag = '';
  final productService = ProductsService();
  bool isCheck = false;
  List checkList = [];
  dynamic product;
  CarritoComprasProvider? carritoCompras;
  @override
  void initState() {
    traerInfoToppings();
    toppingsInfo = [];
    cargoToppings = false;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    productosCarrito = [];
    checkList = [];
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('producto perfecto${widget.product}');
    carritoCompras = Provider.of<CarritoComprasProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            fondoImagen(),
            _body(context),
          ],
        ),
      ),
    );
  }

  Widget fondoImagen() {
    Image imgae = Image.network(
      '${Env.currentEnv['serverUrl']}/imagenProducto/traerImagen?id='
      '${widget.product["idImagen"]}',
    );
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: imgae.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Container(
        width: Adapt.wp(90),
        child: Column(
          children: [
            _bodyParteUno(),
            SizedBox(
              height: Adapt.hp(17),
            ),
            productDetail(context),
          ],
        ),
      ),
    );
  }

  Widget _bodyParteUno() {
    Image image = Image.asset(
      'assets/botones/BotonFavoritos.png',
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
          const ButtonBackWidget(),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    //añadir favorito
                  },
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: image.image),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void traerInfoToppings() async {
    print('producto perfecto${widget.product}');
    if (widget.product['toppings'] != null) {
      for (var i = 0; i < widget.product['toppings'].length; i++) {
        ToppingsModel respuesta =
            await productService.obtenerTopping(widget.product['toppings'][i]);
        toppingsInfo.add(respuesta);
        checkList.add(false);
      }

      setState(() {
        cargoToppings = true;
      });
    } else {
      toppingsInfo = [];
      checkList = [];
    }
  }

  void agregarProductoAlCarrito(context) {
    final snackBar = SnackBar(
      content: Text(AppLocalizations.of(context)!.seAgrego,
          style: const TextStyle(color: Colors.black)),
      backgroundColor: ColorSelect.primaryColorVaco,
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.ir,
        textColor: const Color.fromARGB(255, 10, 10, 10),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/cart');
        },
      ),
    );

    List<ToppingsModel> finalToppings = [];
    carritoCompras!.restaurantePrincipal =
        widget.product['idRestauranteCreador'];
    for (var i = 0; i < checkList.length; i++) {
      if (checkList[i]) {
        finalToppings.add(toppingsInfo[i]);
      }
    }
    print('final toppings ${finalToppings}');

    AddProductCartController _productoParaCarrito = AddProductCartController(
      idProducto: widget.product['id'],
      esCajita: false,
      toppings: finalToppings,
    );

    carritoCompras!.listaProductosCarrito.add(_productoParaCarrito);
    ProductModel _producto = ProductModel.fromJson(widget.product);

    carritoCompras!.listaProductosCompletosCarrito.add(_producto);

    carritoCompras!.obtenerListaPreciosToppingsProductosCarrito();
    carritoCompras!.obtenerInfoRestaurante();
    carritoCompras!.cantidadproductosCarrito();
    carritoCompras!.obtenerListaProductos2();

    setState(() {});
    // Scaffold.of(context).hideCurrentSnackBar();
    //  Scaffold.of(context).showSnackBar(snackBar);
  }

  Widget productDetail(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: Adapt.wp(90),
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: Adapt.hp(3)),
                    Text(
                      widget.product['nombre'],
                      style: TextStyle(
                          fontSize: Adapt.px(35),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat-ExtraBold',
                          color: Colors.black),
                    ),
                    SizedBox(height: Adapt.hp(1)),
                    Container(
                      width: Adapt.wp(100),
                      height: Adapt.hp(10),
                      child: Text(
                        widget.product['descripcion'],
                        style: TextStyle(
                            fontSize: Adapt.px(22), color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: Adapt.hp(1)),
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          '\$${widget.product['precio']}',
                          style: TextStyle(
                              fontSize: Adapt.px(35),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat-ExtraBold',
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: Adapt.hp(1)),
                    Text(
                      AppLocalizations.of(context)!.adicionales,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'Montserrat-ExtraBold',
                      ),
                    ),
                    SizedBox(height: Adapt.hp(1)),
                    Container(
                      height: Adapt.hp(24),
                      child: widget.product['toppings'] == null ||
                              widget.product['toppings'].length == 0
                          ? Text('no hay toppings')
                          : cargoToppings
                              ? ListView.builder(
                                  itemCount: widget.product['toppings'].length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    try {
                                      return Container(
                                        alignment: Alignment.center,
                                        child: Theme(
                                          data: ThemeData(
                                              unselectedWidgetColor:
                                                  const Color.fromARGB(
                                                      255, 26, 25, 25)),
                                          child: StatefulBuilder(
                                              builder: (context, setState) {
                                            return CheckboxListTile(
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              activeColor: const Color.fromARGB(
                                                  255, 197, 254, 37),
                                              checkColor:
                                                  ColorSelect.primaryColorVaco,
                                              dense: true,
                                              title: Container(
                                                alignment: Alignment.centerLeft,
                                                height: Adapt.hp(5),
                                                child: Text(
                                                  '${toppingsInfo[index].nombre}',
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    fontSize: Adapt.px(20),
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Montserrat-Regular',
                                                  ),
                                                ),
                                              ),
                                              value: checkList[index],
                                              onChanged: (val) {
                                                checkList[index] = val;
                                                setState(() {});
                                              },
                                              secondary: Text(
                                                "\$${toppingsInfo[index].precio}",
                                                style: TextStyle(
                                                  fontSize: Adapt.px(20),
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'Montserrat-Regular',
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      );
                                    } catch (e) {
                                      return LoadingIndicatorW();
                                    }
                                  },
                                )
                              : LoadingIndicatorW(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Adapt.hp(1),
              ),
              SizedBox(
                height: Adapt.hp(6),
                width: Adapt.wp(60),
                child: GestureDetector(
                  child: Container(
                    color: ColorSelect.primaryColorVaco,
                    //shape: RoundedRectangleBorder(
                    //borderRadius: BorderRadius.circular(25),
                    //),
                    padding: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        AppLocalizations.of(context)!.agregarCarrito,
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat-ExtraBold',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //onPressed: () async {
                    //carritoCompras!.restaurantePrincipal ==
                    //       widget.product['idRestauranteCreador'] ||
                    //     carritoCompras!.restaurantePrincipal == ''
                    //   ? agregarProductoAlCarrito(context)
                    //     : alertAddCart(context);
                    // },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
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
}
