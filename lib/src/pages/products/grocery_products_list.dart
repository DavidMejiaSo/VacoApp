// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/enviroment/environment.dart';
import 'package:prueba_vaco_app/model/controller_arg_bag.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/categoria_restaurantes.dart';
import 'package:prueba_vaco_app/service/categorias_alimentos.dart';
import 'package:prueba_vaco_app/src/pages/products/grocery_product_detail.dart';
import 'package:prueba_vaco_app/service/products_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../model/controller_arg_productos.dart';
import '../../../model/controller_arg_restaurantes.dart';
import '../../../model/controller_arg_restaurantes_calificados.dart';
import '../../../provider/cart_shop_provider.dart';
import '../../../provider/promotions_provider.dart';
import '../../../responsive/Color.dart';
import '../../../service/calificacionesRestaurantes_service.dart';
import '../../../service/categorias_alimentos.dart';
import '../../../service/productosEnPromocionPorRestaurante.dart';
import '../../widgets/allergy_alert_image.dart';
import '../../widgets/favorite_product_icon.dart';
import '../../widgets/loading_indicator.dart';

class GroceryProductsList extends StatefulWidget {
  const GroceryProductsList({Key? key}) : super(key: key);

  @override
  State<GroceryProductsList> createState() => _GroceryProductsListState();
}

bool promocion = false;
final prefs = PreferenciasUsuario();
final productService = ProductsService();
final categoriaRestaurante = CategoriaRestauranteService();
List<String> filtroTiposDeComida = [];

bool mostrarPublicidadCajita = true;
String idCategoria = "";
String nombreCategoria = "";
List? listaPromociones;
List<restaurantesCalificados>? listaRestaurantesCalificados;
final servicePromocion = promocionProductosService();
final serviceCalificacion = restaurantesCalificadosService();
String? valorPromocion = "";
dynamic valorPromedio;
String? idBuscadorPromocion = "";
String? idProduct = "";
String? idProductOriginal = "";

bool estadoPromocion = false;
//dynamic valorCalificacion;
String? seleccionadorCategoria = "";

class _GroceryProductsListState extends State<GroceryProductsList> {
  get infoRestaurante =>
      ModalRoute.of(context)!.settings.arguments as OrganizacionRestaurantes;

  Image imageInfo = Image.asset(
    'assets/botones/BotonInfo.png',
    fit: BoxFit.cover,
  );

  List listaProductosPromocion = [];
// se llama al provider promocionesProvider que se cargó previamente en la pantalla de carga, que trae todos los modelos de las promociones y se le filtran en la varible listaProductosPromocion por el id que lo trae infoRestaurante.id
  void obtenerIdsProductosPromocion() async {
    listaProductosPromocion = [];
    for (var i = 0; i < promocionesProvider!.promocionesProductos.length; i++) {
      if (promocionesProvider!.promocionesProductos[i]['restaurante'] ==
          infoRestaurante.id) {
        dynamic productoCompleto = await productService.obtenerProducto(
            promocionesProvider!.promocionesProductos[i]['idProducto']);
        print(productoCompleto['precio']);
        productoCompleto['precio'] = ((int.parse(productoCompleto['precio']) *
                    (100 -
                        int.parse(promocionesProvider!.promocionesProductos[i]
                            ['descuento']))) ~/
                100)
            .toString();
        print(productoCompleto['precio']);
        listaProductosPromocion.add(productoCompleto);
      }
    }

    setState(() {});
//retorna los ids de los productos en promocion listaProductosPromocion
  }

  void obtenerCategoria() async {
    dynamic respuesta = await categoriaRestaurante.otenerUnaCategoria(
        infoRestaurante.idCategoriaRestaurante == ''
            ? infoRestaurante.categorias[0].toString()
            : infoRestaurante.idCategoriaRestaurante);
    nombreCategoria = respuesta['nombre'];

    setState(() {});
  }

  double distancia = 0.0;
  void metodoInicial() async {
    await Future.delayed(const Duration(microseconds: 220));
    obtenerCategoria();
    obtenerIdsProductosPromocion();
    mostrarPublicidadCajita = true;
    promocion = false;
    infoStats = false;
    if (infoRestaurante.latitud != 0.0 ||
        infoRestaurante.latitud != null && infoRestaurante.longitud != 0.0 ||
        infoRestaurante.longitud != null) {
      distancia = (Geolocator.distanceBetween(
            prefs.latitud,
            prefs.longitud,
            infoRestaurante.latitud,
            infoRestaurante.longitud,
          ).round() /
          1000);
    }
  }

  @override
  void initState() {
    metodoInicial();
    super.initState();
  }

  PromotionsProvider? promocionesProvider;
  CarritoComprasProvider? carritoCompras;

  @override
  Widget build(BuildContext context) {
    promocionesProvider =
        Provider.of<PromotionsProvider>(context, listen: true);

    carritoCompras = Provider.of<CarritoComprasProvider>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(child: infoStats ? _bodyInfo() : _body()),
            _bodyParteUno(),
            Align(alignment: Alignment.bottomCenter, child: totalCart()),
            mostrarPublicidadCajita == true
                ? containerBotonSorpresa()
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        SizedBox(
          height: Adapt.hp(19),
        ),
        _ordenBy(),
        infoRestaurante.categorias[0].toString() != '62b8f1a77c14f421d5bedb6b'
            ? bannerBag()
            : Container(),
        SizedBox(
          height: Adapt.hp(1),
        ),
        infoRestaurante.categorias[0].toString() != '62b8f1a77c14f421d5bedb6b'
            ? sortButtons()
            : Container(),
        categoryInformation(),
        promocion == true
            ? listaProductosPromocion.isEmpty
                ? imagenError()
                : _listProductosPromocion(context)
            : _listProduct(context),
        SizedBox(height: Adapt.hp(7)),
      ],
    );
  }

  Widget _bodyInfo() {
    return Column(
      children: [
        SizedBox(
          height: Adapt.hp(19),
        ),
        SizedBox(
          height: Adapt.hp(5),
          child: Padding(
            padding: EdgeInsets.all(Adapt.px(10)),
            child: Text(
              'informacion del restaurante',
              style: TextStyle(
                fontSize: Adapt.px(30),
              ),
            ),
          ),
        ),
        SizedBox(
          height: Adapt.hp(1),
        ),
        SizedBox(
          height: Adapt.hp(5),
          child: Padding(
            padding: EdgeInsets.all(Adapt.px(10)),
            child: Text(
              'informacion del restaurante',
              style: TextStyle(
                fontSize: Adapt.px(30),
              ),
            ),
          ),
        ),
        FutureBuilder(
          future: serviceCalificacion
              .obtenerCalificacionesRestaurante(infoRestaurante.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            try {
              return Container(
                width: Adapt.wp(95),
                child: ListView.custom(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  childrenDelegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: Adapt.hp(23),
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
                              child: Column(
                                children: [
                                  Text(
                                    '${snapshot.data[index]['comentarios']}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: Adapt.px(35),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontFamily: 'Montserrat-ExtraBold'),
                                  ),
                                  SizedBox(
                                    height: Adapt.hp(2),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      '${snapshot.data[index]['opciones']}',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontSize: Adapt.px(20),
                                          color: Colors.black,
                                          fontFamily: 'Montserrat-ExtraBold'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: snapshot.data.length,
                  ),
                ),
              );
            } catch (e) {
              return const LoadingIndicatorW();
            }
          },
        )
      ],
    );
  }

  Widget imagenError() {
    return Column(
      children: [
        Container(
          width: Adapt.wp(35),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              'https://creazilla-store.fra1.digitaloceanspaces.com/emojis/49450/magnifying-glass-tilted-left-emoji-clipart-md.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Text(
          'Ups, no hay productos para esta categoria.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: Adapt.hp(15),
        ),
      ],
    );
  }

  Widget bannerBag() {
    return InkWell(
      child: Container(
        width: Adapt.wp(100),
        height: Adapt.hp(19),
        margin: EdgeInsets.only(top: Adapt.px(3), bottom: Adapt.px(3)),
        child: Image.asset("assets/bag/bannerBag.png", fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              'https://png.pngtree.com/png-vector/20210227/ourlarge/pngtree-error-404-glitch-effect-png-image_2943478.jpg',
              width: Adapt.wp(100),
              height: Adapt.hp(16),
              fit: BoxFit.cover,
            ),
          );
        }),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/bagDetail',
            arguments: ArgumentsBag(
              infoRestaurante.id,
              infoRestaurante.nombre,
            ));
        setState(() {});
      },
    );
  }

  Widget _bodyParteUno() {
    Image image = Image.asset(
      'assets/products/BotonCompras.png',
      fit: BoxFit.cover,
    );
    Image imageRegreso = Image.asset(
      'assets/botones/BotonRegresar.png',
      fit: BoxFit.cover,
    );
    return Container(
      height: Adapt.hp(19),
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/backgrounds/FondoProductos.png'),
        alignment: Alignment.topCenter,
        fit: BoxFit.cover,
      )),
      child: Column(
        children: [
          Container(
            height: Adapt.hp(6.2),
            child: Row(
              children: [
                SizedBox(
                  width: Adapt.wp(2),
                ),
                Padding(
                  padding: EdgeInsets.all(Adapt.px(10)),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: imageRegreso.image),
                  ),
                ),
                SizedBox(
                  width: Adapt.wp(65),
                ),
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: image.image),
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
                SizedBox(
                  width: Adapt.wp(2),
                ),
              ],
            ),
          ),
          _infoRestaurant(),
        ],
      ),
    );
  }

  Widget _ordenBy() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: Adapt.hp(5.5),
        width: Adapt.wp(90),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              child: Container(
                height: Adapt.hp(5),
                width: Adapt.wp(43),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color.fromARGB(255, 90, 90, 90),
                    width: 1,
                  ),
                  color:
                      promocion ? ColorSelect.primaryColorVaco : Colors.white,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Promociones",
                    style: TextStyle(
                        fontFamily: 'Montserrat-ExtraBold',
                        fontSize: Adapt.px(15),
                        color: Color.fromARGB(255, 90, 90, 90),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  promocion = true;
                });
              },
            ),
            SizedBox(
              width: Adapt.wp(2),
            ),
            InkWell(
              child: Container(
                height: Adapt.hp(5),
                width: Adapt.wp(43),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color.fromARGB(255, 90, 90, 90),
                    width: 1,
                  ),
                  color:
                      promocion ? Colors.white : ColorSelect.primaryColorVaco,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: nombreCategoria == ''
                      ? Text(
                          'Categoria',
                          style: TextStyle(
                              fontSize: Adapt.px(15),
                              fontFamily: 'Montserrat-ExtraBold',
                              color: Color.fromARGB(255, 90, 90, 90),
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          nombreCategoria,
                          style: TextStyle(
                              fontSize: Adapt.px(15),
                              fontFamily: 'Montserrat-ExtraBold',
                              color: Color.fromARGB(255, 90, 90, 90),
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              onTap: () {
                setState(() {
                  promocion = false;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  bool infoStats = false;
  Widget _infoRestaurant() {
    return Container(
      height: Adapt.hp(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Adapt.wp(4),
          ),
          SizedBox(
            height: Adapt.hp(12),
            width: Adapt.wp(26),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${Env.currentEnv['serverUrl']}/imagenRestaurante/traerImagen?id=${infoRestaurante.idImagen}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: Adapt.hp(11.5),
            width: Adapt.wp(45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: Adapt.hp(5),
                  width: Adapt.wp(45),
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      " ${infoRestaurante.nombre}".toUpperCase(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'Montserrat-ExtraBold',
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
                Container(
                  height: Adapt.hp(2),
                  width: Adapt.wp(45),
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "  ${infoRestaurante.tiempoEstimadoEntregaMinimo} - ${infoRestaurante.tiempoEstimadoEntregaMaximo} min",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      maxLines: 4,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.star,
                      color: ColorSelect.primaryColorVaco,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        infoRestaurante.calificacionPromedio! != null
                            ? infoRestaurante.calificacionPromedio
                                .toStringAsFixed(1)
                            : '0',
                        style: TextStyle(
                          fontSize: Adapt.px(20),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Adapt.wp(1),
                    ),
                    const Icon(
                      Icons.directions_walk,
                      color: Colors.black,
                    ),
                    //boton_calificarII(),
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "$distancia km",
                        style: TextStyle(
                          fontSize: Adapt.px(20),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Adapt.wp(2),
                    ),
                  ],
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              infoStats = !infoStats;
              setState(() {});
              print(infoStats);
            },
            child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: imageInfo.image),
          ),
          SizedBox(
            width: Adapt.wp(1),
          ),
        ],
      ),
    );
  }

  Widget totalCart() {
    return Hero(
      tag: 'cart',
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
        child: Container(
          height: Adapt.hp(6),
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorSelect.primaryColorVaco,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      ' ${carritoCompras!.listaProductosCarrito.length} ',
                      style: TextStyle(
                        fontSize: Adapt.px(25),
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!.verBolsa,
                    style: TextStyle(
                      fontSize: Adapt.px(25),
                      color: Colors.black,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      '\$${carritoCompras!.totalPrecioCarrito}',
                      style: TextStyle(
                        fontSize: Adapt.px(25),
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
    );
  }

  Widget categoryInformation() {
    return Padding(
      padding: EdgeInsets.only(left: Adapt.px(20), right: Adapt.px(20)),
      child: Align(
        alignment: Alignment.centerLeft,
        child: promocion
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 15),
                child: Text(
                  'Promociones',
                  style: const TextStyle(
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.5, 0.5),
                        blurRadius: 1.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat-ExtraBold',
                    color: Color.fromARGB(255, 16, 16, 16),
                  ),
                ))
            : Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 15),
                child: nombreCategoria == ''
                    ? Text(
                        'Categoria',
                        style: const TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              blurRadius: 1.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat-ExtraBold',
                          color: Color.fromARGB(255, 16, 16, 16),
                        ),
                      )
                    : Text(
                        nombreCategoria,
                        style: const TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.5, 0.5),
                              blurRadius: 1.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                          fontSize: 24,
                          fontFamily: 'Montserrat-ExtraBold',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 16, 16, 16),
                        ),
                      ),
              ),
      ),
    );
  }

  Widget _listProduct(BuildContext context) {
    return FutureBuilder(
      future: productService.obtenerProductoPorRestaurante(infoRestaurante.id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List? auxSnapshot = [];
          if (seleccionadorCategoria == "") {
            auxSnapshot = snapshot.data;
          } else {
            //for (var comida in filtroTiposDeComida) {
            auxSnapshot.addAll(snapshot.data!.where((element) {
              return element["idCategoriaProducto"] == seleccionadorCategoria;
            }));
            // }
          }
          if (auxSnapshot!.isEmpty) {
            return imagenError();
          }

          return Container(
            width: Adapt.wp(90),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: auxSnapshot.length,
              itemBuilder: (BuildContext context, index) {
                final product = auxSnapshot?[index];
                final products = [];
                List ingredientess = [];

                for (var i = 0;
                    i < auxSnapshot?[index]['ingredientes'].length;
                    i++) {
                  ingredientess.add(auxSnapshot?[index]['ingredientes'][i]);
                  prefs.restaurantFavorite.add(auxSnapshot?[index]['id']);
                }
                products.add(product);
                for (var i = 0;
                    i < promocionesProvider!.promocionesProductos.length;
                    i++) {
                  if (promocionesProvider!.promocionesProductos[i]
                          ['idProducto'] ==
                      auxSnapshot?[index]['id']) {
                    auxSnapshot?[index]['precio'] =
                        ((int.parse(auxSnapshot[index]['precio']) *
                                    (100 -
                                        int.parse(promocionesProvider!
                                                .promocionesProductos[i]
                                            ['descuento']))) ~/
                                100)
                            .toString();
                  }
                }
                return GestureDetector(
                  onTap: () async {
                    await Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, __) {
                          return FadeTransition(
                            opacity: animation,
                            child: GroceryProductDetails(
                              product: product,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    height: Adapt.hp(12),
                    width: Adapt.wp(90),
                    child: Row(
                      children: [
                        Container(
                          height: Adapt.hp(50),
                          width: Adapt.wp(30),
                          child: Hero(
                            tag: 'list_${product['nombre']}',
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    '${Env.currentEnv['serverUrl']}/imagenProducto/traerImagen?id='
                                    '${auxSnapshot?[index]["idImagen"]}',
                                    height: Adapt.hp(50),
                                    width: Adapt.wp(30),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          'https://png.pngtree.com/png-vector/20210227/ourlarge/pngtree-error-404-glitch-effect-png-image_2943478.jpg',
                                          height: Adapt.hp(9),
                                          width: Adapt.wp(20),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: AllergyAlertImage(
                                    idAlergia: auxSnapshot?[index]['alergias'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: Adapt.wp(40),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: Adapt.px(20)),
                                height: Adapt.hp(5.5),
                                width: Adapt.wp(50),
                                child: Text(
                                  auxSnapshot?[index]["nombre"],
                                  style: TextStyle(
                                    fontSize: Adapt.px(22),
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: Adapt.px(20)),
                                height: Adapt.hp(2),
                                width: Adapt.wp(45),
                                child: Text(
                                  snapshot.data[index]['descripcion'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: Adapt.px(20),
                                    color: const Color.fromARGB(
                                        255, 134, 134, 134),
                                  ),
                                ),
                              ),
                              Container(
                                //color: Color.fromARGB(255, 249, 207, 204),
                                padding: EdgeInsets.only(left: Adapt.px(15)),
                                width: Adapt.wp(50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: ColorSelect.primaryColorVaco,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, right: 5),
                                      child: Text(
                                        valorPromocion.toString(),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 65, 65, 65),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        FavoriteProductButton(
                          numberid: '${snapshot.data[index]['id']}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Text('Cargando...');
        }
      },
    );
  }

  Widget _listProductosPromocion(BuildContext context) {
    return Container(
      width: Adapt.wp(90),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listaProductosPromocion.length,
        itemBuilder: (BuildContext context, index) {
          final product = listaProductosPromocion[index];
          final products = [];
          List ingredientess = [];

          for (var i = 0;
              i < listaProductosPromocion[index]['ingredientes'].length;
              i++) {
            ingredientess
                .add(listaProductosPromocion[index]['ingredientes'][i]);
            prefs.restaurantFavorite.add(listaProductosPromocion[index]['id']);
          }
          products.add(product);
          if (listaProductosPromocion.isEmpty) {
            return imagenError();
          }
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, __) {
                    return FadeTransition(
                      opacity: animation,
                      child: GroceryProductDetails(
                        product: listaProductosPromocion[index],
                      ),
                    );
                  },
                ),
              );
            },
            child: Container(
              height: Adapt.hp(12),
              width: Adapt.wp(90),
              child: Row(
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(Adapt.px(5)),
                      child: Hero(
                        tag: 'list_${listaProductosPromocion[index]['nombre']}',
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.network(
                                '${Env.currentEnv['serverUrl']}/imagenProducto/traerImagen?id='
                                '${listaProductosPromocion[index]["idImagen"]}',
                                height: Adapt.hp(50),
                                width: Adapt.wp(30),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      'https://png.pngtree.com/png-vector/20210227/ourlarge/pngtree-error-404-glitch-effect-png-image_2943478.jpg',
                                      height: Adapt.hp(9),
                                      width: Adapt.wp(20),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              left: Adapt.wp(8),
                              child: AllergyAlertImage(
                                idAlergia: listaProductosPromocion[index]
                                    ['alergias'],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: Adapt.wp(40),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: Adapt.px(20)),
                          height: Adapt.hp(5.5),
                          width: Adapt.wp(50),
                          child: Text(
                            listaProductosPromocion[index]["nombre"],
                            style: TextStyle(
                              fontSize: Adapt.px(22),
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: Adapt.px(20)),
                          height: Adapt.hp(2),
                          width: Adapt.wp(45),
                          child: Text(
                            listaProductosPromocion[index]['descripcion'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Adapt.px(20),
                              color: const Color.fromARGB(255, 134, 134, 134),
                            ),
                          ),
                        ),
                        Container(
                          //color: Color.fromARGB(255, 249, 207, 204),
                          padding: EdgeInsets.only(left: Adapt.px(15)),
                          width: Adapt.wp(50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.star,
                                color: ColorSelect.primaryColorVaco,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 5, right: 5),
                                child: Text(
                                  valorPromocion.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 65, 65, 65),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  FavoriteProductButton(
                    numberid: '${listaProductosPromocion[index]['id']}',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget cerrarCajaSorpresa() {
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
            mostrarPublicidadCajita = false;
            setState(() {});
          },
          child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: imageCerrar.image),
        ),
      ),
    );
  }

  Widget containerBotonSorpresa() {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgrounds/BolsaSorpresa.png'),
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
      Positioned(
        top: Adapt.hp(68),
        left: Adapt.wp(10),
        child: Container(
          width: Adapt.wp(80),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                primary: ColorSelect.primaryColorVaco,
                textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            child: Text("COMPRA AQUÍ",
                style: TextStyle(
                  fontSize: Adapt.px(20),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
            onPressed: () {
              mostrarPublicidadCajita = false;
              Navigator.pushNamed(context, '/bagDetail',
                  arguments: ArgumentsBag(
                    infoRestaurante.id,
                    infoRestaurante.nombre,
                  ));
              setState(() {});
            },
          ),
        ),
      ),
      Positioned(
        top: Adapt.hp(24),
        left: Adapt.wp(85),
        child: cerrarCajaSorpresa(),
      )
    ]);
  }

  Widget sortButtons() {
    //Botones con  funcion de filtrado de botones según categoria de producto
    return Container(
      height: Adapt.hp(12),
      width: Adapt.wp(90),

      //Futuru builder donde se traen los datos necesatrios desde la web

      child: FutureBuilder(
        future: ProductoCategoriaService().mostrar(infoRestaurante.idSocio),
        builder: (BuildContext context,
            AsyncSnapshot<List<categoriasProductos>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.hasData) {
                  //seleccionadoresComidas.add(false);
                  try {
                    return GestureDetector(
                      onTap: () {
                        if (seleccionadorCategoria ==
                            snapshot.data![index].id) {
                          seleccionadorCategoria = "";
                        } else {
                          seleccionadorCategoria = snapshot.data![index].id;
                        }

                        if (filtroTiposDeComida
                            .contains(snapshot.data![index].id.toString())) {
                          filtroTiposDeComida
                              .remove(snapshot.data![index].id.toString());
                        } else {
                          filtroTiposDeComida
                              .add(snapshot.data![index].id.toString());
                        }
                        setState(() {});
                      },
                      child: Container(
                        decoration:
                            (snapshot.data![index].id == seleccionadorCategoria)
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: ColorSelect.primaryColorVaco,
                                        width: Adapt.wp(0.5)))
                                : const BoxDecoration(),
                        margin: EdgeInsets.only(
                            right: Adapt.wp(2), left: Adapt.wp(2)),
                        child: Column(
                          //Lista de opciones
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                '${Env.currentEnv['serverUrl']}/imagenCategoriaProducto/traerImagen?id=${snapshot.data![index].imagen}',
                                errorBuilder: (context, error, stackTrace) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                        'https://png.pngtree.com/png-vector/20210227/ourlarge/pngtree-error-404-glitch-effect-png-image_2943478.jpg',
                                        height: Adapt.hp(9),
                                        width: Adapt.wp(20),
                                        fit: BoxFit.cover, errorBuilder:
                                            (context, error, stackTrace) {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          'https://png.pngtree.com/png-vector/20210227/ourlarge/pngtree-error-404-glitch-effect-png-image_2943478.jpg',
                                          height: Adapt.hp(9),
                                          width: Adapt.wp(20),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }),
                                  );
                                },
                                height: Adapt.hp(9),
                                width: Adapt.wp(20),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              snapshot.data![index].nombre.toString(),
                              style: TextStyle(
                                fontSize: Adapt.px(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } catch (e) {
                    return LoadingIndicatorW();
                  }
                } else {
                  return Container();
                }
              },
            );
          } else {
            return const LoadingIndicatorW();
          }
        },
      ),
    );
  }
}
