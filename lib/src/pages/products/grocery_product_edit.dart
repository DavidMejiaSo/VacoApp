import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/cart_service.dart';
import 'package:prueba_vaco_app/service/products_service.dart';
import 'package:prueba_vaco_app/widgets/elevated_button.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../responsive/Color.dart';
import '../../../widgets/button_back_widget.dart';

class ProductEditCart extends StatefulWidget {
  const ProductEditCart({Key? key, this.product, this.checkBox, this.idCarrito})
      : super(key: key);
  final dynamic product;
  final dynamic checkBox;
  final dynamic idCarrito;

  @override
  State<ProductEditCart> createState() => _ProductEditCartState();
}

List toppingsAdicionados = [];
List toppings = [];
List toppingsAgregados = [];
dynamic productosCarrito = [];
dynamic idCarrito = [];
dynamic adicionalesCarrito = [];
dynamic idAdicional = [];
dynamic listaAdicionalesCompletaCarrito = [];
dynamic listaAdicionesCarrito = [];
final prodcutService = ProductsService();
final cartService = CartSevice();

class _ProductEditCartState extends State<ProductEditCart> {
  String heroTag = '';

  final productService = ProductsService();

  List checkList = [];
  List ingredientess = [];
  void metodoInicial() {
    ingredientess = [];
    for (var i = 0; i < widget.product['ingredientes'].length; i++) {
      ingredientess.add(widget.product['ingredientes'][i]);
    }

    obtenerAdicionales();
  }

  @override
  void initState() {
    metodoInicial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
              child: Stack(children: [
        newMethod(),
        const ButtonBackWidget(),
      ]))),
    );
  }

  Widget newMethod() {
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
                    tag: 'list_${widget.product['nombre']}$heroTag',
                    child: Image.network(
                      '${Env.currentEnv['serverUrl']}/imagenProducto/traerImagen?id='
                      '${widget.product["idImagen"]}',
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                  ),
                  SizedBox(height: Adapt.hp(1)),
                  Text(
                    widget.product['nombre'],
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
                        '\$${widget.product['precio']}',
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
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    height: Adapt.hp(30),
                    width: Adapt.hp(20),
                    child: ListView.builder(
                      itemCount: widget.product['toppings'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder(
                          future: productService.obtenerTopping(
                              widget.product['toppings'][index]),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            checkList.add(false);
                            if (snapshot.hasData) {
                              try {
                                toppings.add(snapshot.data);
                                toppingsAgregados = adicionalesAgregados(
                                    checkList, index, toppings);
                                for (var i = 0;
                                    i < widget.checkBox.length;
                                    i++) {
                                  if (widget.checkBox[i] ==
                                      snapshot.data['id']) {
                                    checkList[index] = true;
                                  }
                                }
                                return Container(
                                  color: Colors.white,
                                  width: Adapt.wp(100),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Theme(
                                    data: ThemeData(
                                      unselectedWidgetColor:
                                          ColorSelect.primaryColorVaco,
                                    ),
                                    child: StatefulBuilder(
                                        builder: (context, setState) {
                                      return CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
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
                                              '${snapshot.data['nombre']}',
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
                                            if (val!) {
                                              cartService
                                                  .adicionarToppingCarrito(
                                                      widget.idCarrito,
                                                      snapshot.data['id']);
                                              checkList[index] = val;
                                            } else {
                                              cartService
                                                  .eliminarToppingCarrito(
                                                      widget.idCarrito,
                                                      snapshot.data['id']);
                                              checkList[index] = val;
                                            }
                                            setState(() {});
                                          },
                                          secondary: Text(
                                            "\$${snapshot.data['precio']}",
                                            style: TextStyle(
                                              fontSize: Adapt.px(20),
                                              color: Colors.black,
                                              fontFamily: 'Montserrat-Regular',
                                            ),
                                          ));
                                    }),
                                  ),
                                );
                              } catch (e) {
                                return const Text("Cargando..");
                              }
                            } else {
                              return const Text("Cargando..");
                            }
                          },
                        );
                      },
                    ),
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

  List adicionalesAgregados(List check, int index, List toppings) {
    toppingsAdicionados = [];
    for (var i = 0; i < widget.product['toppings'].length; i++) {
      if (check[i]) {
        toppingsAdicionados.add(toppings[i]);
      }
    }
    print("toppingsAdicionados $toppingsAdicionados");
    return toppingsAdicionados;
  }

  void obtenerAdicionales() async {
    listaAdicionalesCompletaCarrito = [];
    listaAdicionesCarrito = [];
    for (var i = 0; i < widget.checkBox.length; i++) {
      dynamic respuesta;
      respuesta = await prodcutService.obtenerTopping(widget.checkBox[i]);
      listaAdicionalesCompletaCarrito.add(respuesta);
    }

    for (var i = 0; i < listaAdicionalesCompletaCarrito.length; i++) {
      listaAdicionesCarrito.add(listaAdicionalesCompletaCarrito[i]['nombre']);
    }
  }
}
