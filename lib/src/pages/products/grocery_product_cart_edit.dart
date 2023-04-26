import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/model/controller_arg_product.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/cart_service.dart';
import 'package:prueba_vaco_app/service/products_service.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/controller_toppigs.dart';
import '../../../provider/cart_shop_provider.dart';
import '../../../responsive/Color.dart';
import '../../widgets/button_back_widget.dart';
import '../../widgets/elevated_button.dart';
import '../../widgets/loading_indicator.dart';

class ProductEditCart extends StatefulWidget {
  const ProductEditCart({Key? key, this.product, this.index}) : super(key: key);
  final ProductModel? product;
  final dynamic index;

  @override
  State<ProductEditCart> createState() => _ProductEditCartState();
}

bool cargoToppings = false;

final prodcutService = ProductsService();
final cartService = CartSevice();

class _ProductEditCartState extends State<ProductEditCart> {
  final productService = ProductsService();
  CarritoComprasProvider? carritoCompras;
  List checkList = [];
  List ingredientess = [];
  List<ToppingsModel> toppingsInfo = [];

  @override
  void initState() {
    metodoInicial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    carritoCompras = Provider.of<CarritoComprasProvider>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
              child: Stack(children: [
        body(),
        const ButtonBackWidget(),
      ]))),
    );
  }

  Widget body() {
    return Container(
      width: Adapt.wp(95),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'list_${widget.product!.nombre}',
                    child: Image.network(
                      '${Env.currentEnv['serverUrl']}/imagenProducto/traerImagen?id='
                      '${widget.product!.idImagen}',
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ),
                  SizedBox(height: Adapt.hp(1)),
                  Text(
                    widget.product!.nombre,
                    style: TextStyle(
                        fontSize: Adapt.px(40),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat-ExtraBold',
                        color: Colors.black),
                  ),
                  SizedBox(height: Adapt.hp(1)),
                  Container(
                    width: Adapt.wp(100),
                    height: Adapt.hp(6),
                    child: Text(
                      "$ingredientess",
                      style:
                          TextStyle(fontSize: Adapt.px(30), color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: Adapt.hp(1)),
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        '\$${widget.product!.precio}',
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat-ExtraBold',
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: Adapt.hp(1)),
                  Text(
                    AppLocalizations.of(context)!.adicionales,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  Container(
                    height: Adapt.hp(24),
                    child: cargoToppings
                        ? ListView.builder(
                            itemCount: widget.product!.toppings.length,
                            itemBuilder: (BuildContext context, int index) {
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
                                            ListTileControlAffinity.leading,
                                        contentPadding: const EdgeInsets.all(0),
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
                                              fontFamily: 'Montserrat-Regular',
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
                                            fontFamily: 'Montserrat-Regular',
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
          ),
          Container(
            height: Adapt.hp(5),
            child: ElevatedButtonCustom(
                textButton: AppLocalizations.of(context)!.aceptar,
                onPressedAction: () {
                  agregarProductoAlCarrito();
                  Navigator.pop(context);
                }),
          ),
          Container(
            height: Adapt.hp(1),
          )
        ],
      ),
    );
  }

  void traerInfoToppings() async {
    for (var i = 0; i < widget.product!.toppings.length; i++) {
      ToppingsModel respuesta =
          await productService.obtenerTopping(widget.product!.toppings[i]);
      toppingsInfo.add(respuesta);
      checkList.add(false);
    }
    for (var i = 0; i < toppingsInfo.length; i++) {
      for (var j = 0;
          j <
              carritoCompras!
                  .listaProductosCarrito[widget.index].toppings!.length;
          j++) {
        if (toppingsInfo[i].id ==
            carritoCompras!
                .listaProductosCarrito[widget.index].toppings![j].id) {
          checkList[i] = true;
        }
      }
    }

    setState(() {
      cargoToppings = true;
    });
  }

  void metodoInicial() {
    toppingsInfo = [];
    ingredientess = [];
    cargoToppings = false;
    for (var i = 0; i < widget.product!.ingredientes.length; i++) {
      ingredientess.add(widget.product!.ingredientes[i]);
    }
    traerInfoToppings();
  }

  void agregarProductoAlCarrito() {
    List<ToppingsModel> finalToppings = [];

    for (var i = 0; i < checkList.length; i++) {
      if (checkList[i]) {
        finalToppings.add(toppingsInfo[i]);
      }
    }
    print('final toppings ${finalToppings}');
    carritoCompras!.listaProductosCarrito[widget.index].toppings =
        finalToppings;

    carritoCompras!.obtenerListaPreciosToppingsProductosCarrito();
    carritoCompras!.obtenerInfoRestaurante();
    carritoCompras!.cantidadproductosCarrito();
    carritoCompras!.obtenerListaProductos2();
  }
}
