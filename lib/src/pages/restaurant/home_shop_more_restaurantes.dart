import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/model/controller_arg_tipos_restaurantes.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/categoria_restaurantes.dart';
import 'package:prueba_vaco_app/service/restaurant_service.dart';
import 'package:prueba_vaco_app/backgrouds_widgets/background_restaurant.dart';

import '../../../enviroment/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../model/controller_arg_restaurantes.dart';
import '../../../provider/cart_shop_provider.dart';
import '../../../provider/promotions_provider.dart';
import '../../../responsive/Color.dart';
import '../../widgets/alert_dialog_restaurante_cerrado.dart';
import '../../widgets/loading_indicator.dart';

class HomeShopMore extends StatefulWidget {
  const HomeShopMore({Key? key}) : super(key: key);

  @override
  _HomeShopMoreState createState() => _HomeShopMoreState();
}

dynamic productosCarrito = [];
List<bool> seleccionadores = [];
List<String> filtroTiposDeRestaurante = [];
String? categoriaNombreRest = "";
String? categoriaRest = "";
String? categoriaIDRest = "";
String? imagenCatRest = "";
dynamic listaProductosCarrito = [];
int listaProductosCarritoNumero = 0;
String? productosSeleccionados = "";

class _HomeShopMoreState extends State<HomeShopMore> {
  final restaurantService = RestaurantService();
  PromotionsProvider? promocionesProvider;
  CarritoComprasProvider? carritoCompras;
  List listaProductosPromocion = [];
  int indexClasificacionRestaurantes = 0;
  final prefs = PreferenciasUsuario();
  late List<dynamic> _future = [
    restaurantService.listarRestaurantesAprobados(),
    restaurantService.listarRestaurantesPorPedidos(),
    restaurantService.listarRestaurantesPorCalificacion(),
  ];
  bool mostrarPromociones = false;
  @override
  void initState() {
    indexClasificacionRestaurantes = 0;
    filtroTiposDeRestaurante = [];
    productosSeleccionados = "";

    mostrarPromociones = false;
    super.initState();
  }

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
            SingleChildScrollView(child: Container(child: _body())),
            const BackgroundRestaurant(),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: Adapt.hp(0.01),
                  ),
                  _bodyParteUno(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: Adapt.hp(11),
        ),
        _barSearch(),
        SizedBox(
          height: Adapt.hp(1),
        ),
        _ordenBy(size),
        SizedBox(
          height: Adapt.hp(1),
        ),
        imagenesRapidaYGourmet(),
        _topText(size),
        mostrarPromociones
            ? _listRestaurantsPromocion()
            : _listRestaurants(size),
      ],
    );
  }

  Widget _bodyParteUno() {
    Image imageCompras = Image.asset(
      'assets/products/BotonCompras.png',
      fit: BoxFit.cover,
    );
    Image imageRegreso = Image.asset(
      'assets/botones/BotonRegresar.png',
      fit: BoxFit.cover,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: Adapt.wp(0.05),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/mainScreen');
              },
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: imageRegreso.image),
            ),
            SizedBox(
              width: Adapt.wp(1),
            ),
            _menuDirection(),
            SizedBox(
              width: Adapt.wp(0.5),
            ),
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                  child: Hero(
                    tag: 'cart',
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: imageCompras.image),
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
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: Adapt.wp(0.05),
            ),
          ],
        ),
      ),
    );
  }

  final categoriaRestaurante = CategoriaRestauranteService();
  Widget imagenesRapidaYGourmet() {
    return Container(
      height: Adapt.hp(16),
      width: Adapt.wp(95),
      child: FutureBuilder(
        future: categoriaRestaurante.mostrar(),
        builder: (BuildContext context,
            AsyncSnapshot<List<categoriasRestaurantes>> snapshot) {
          if (snapshot.hasData) {
            categoriaNombreRest = snapshot.data![0].nombre;
            categoriaIDRest = snapshot.data![0].id;

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                //seleccionadores.add(false);
                return Container(
                  decoration:
                      (snapshot.data![index].id == productosSeleccionados)
                          ? BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ColorSelect.primaryColorVaco,
                                  width: Adapt.wp(0.40)))
                          : const BoxDecoration(),
                  margin:
                      EdgeInsets.only(right: Adapt.wp(2), left: Adapt.wp(2)),
                  child: GestureDetector(
                    onTap: () {
                      if (productosSeleccionados == snapshot.data![index].id) {
                        productosSeleccionados = "ERROR";
                      } else {
                        productosSeleccionados = snapshot.data![index].id;
                      }
                      if (filtroTiposDeRestaurante
                          .contains(snapshot.data![index].id.toString())) {
                        filtroTiposDeRestaurante
                            .remove(snapshot.data![index].id.toString());
                      } else {
                        filtroTiposDeRestaurante
                            .add(snapshot.data![index].id.toString());
                      }
                      setState(() {});
                      //print("texto melito $filtroTiposDeRestaurante");
                    },
                    child: Column(
                      //Lista de opciones
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            '${Env.currentEnv['serverUrl']}/imagenCategoriaRestaurante/traerImagen?id='
                            '${snapshot.data![index].imagen}',
                            height: Adapt.hp(11),
                            width: Adapt.wp(24.5),
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
                        Container(
                          height: Adapt.hp(0.5),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: Adapt.hp(4),
                          width: Adapt.wp(20),
                          child: Text(snapshot.data![index].nombre.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Adapt.px(18),
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return LoadingIndicatorW();
          }
        },
      ),
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
          'Ups, no hay restaurantes para esta categoria.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: Adapt.hp(15),
        ),
      ],
    );
  }

  Widget imagenErrorPromociones() {
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
          'Ups, no hay restaurantes para esta categoria.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: Adapt.hp(15),
        ),
      ],
    );
  }

  Widget _ordenBy(size) {
    return SizedBox(
      width: Adapt.wp(95),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.all(Adapt.px(5)),
          child: SizedBox(
            height: Adapt.hp(6),
            child: Row(
              children: [
                InkWell(
                  child: Container(
                    height: Adapt.hp(5),
                    width: Adapt.wp(35),
                    decoration: mostrarPromociones
                        ? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color.fromARGB(255, 90, 90, 90),
                              width: 1,
                            ),
                          )
                        : BoxDecoration(
                            color: indexClasificacionRestaurantes == 0
                                ? ColorSelect.primaryColorVaco
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color.fromARGB(255, 90, 90, 90),
                              width: 1,
                            ),
                          ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Restaurantes",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 48, 47, 47),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    mostrarPromociones = false;
                    indexClasificacionRestaurantes = 0;
                    setState(() {});
                  },
                ),
                SizedBox(width: Adapt.wp(1)),
                InkWell(
                  child: Container(
                    height: Adapt.hp(5),
                    width: Adapt.wp(35),
                    decoration: mostrarPromociones
                        ? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color.fromARGB(255, 90, 90, 90),
                              width: 1,
                            ),
                          )
                        : BoxDecoration(
                            color: indexClasificacionRestaurantes == 1
                                ? ColorSelect.primaryColorVaco
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color.fromARGB(255, 90, 90, 90),
                              width: 1,
                            ),
                          ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Populares",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 48, 47, 47),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    mostrarPromociones = false;
                    indexClasificacionRestaurantes = 1;
                    setState(() {});
                  },
                ),
                SizedBox(width: Adapt.wp(1)),
                InkWell(
                  child: Container(
                    height: Adapt.hp(5),
                    width: Adapt.wp(38),
                    decoration: mostrarPromociones
                        ? BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color.fromARGB(255, 90, 90, 90),
                              width: 1,
                            ),
                          )
                        : BoxDecoration(
                            color: indexClasificacionRestaurantes == 2
                                ? ColorSelect.primaryColorVaco
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: const Color.fromARGB(255, 90, 90, 90),
                              width: 1,
                            ),
                          ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Mejor valorados",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 48, 47, 47),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    mostrarPromociones = false;
                    indexClasificacionRestaurantes = 2;
                    setState(() {});
                  },
                ),
                SizedBox(width: Adapt.wp(0.86)),
                InkWell(
                  child: Container(
                    height: Adapt.hp(5),
                    width: Adapt.wp(35),
                    decoration: BoxDecoration(
                      color: mostrarPromociones
                          ? ColorSelect.primaryColorVaco
                          : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color.fromARGB(255, 90, 90, 90),
                        width: 1,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Promociones",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 48, 47, 47),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    mostrarPromociones = true;
                    setState(() {});
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _barSearch() {
    const borderr = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 148, 148, 148),
      ),
    );
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: Adapt.wp(100),
      height: Adapt.hp(5),
      child: TypeAheadField<OrganizacionRestaurantes?>(
        minCharsForSuggestions: 2,
        animationStart: 0.1,
        hideSuggestionsOnKeyboardHide: true,
        textFieldConfiguration: TextFieldConfiguration(
          style: const TextStyle(color: Colors.black),
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.buscar,
            hintStyle: const TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
            suffixIcon: Icon(
              Icons.search,
              color: ColorSelect.primaryColorVaco,
            ),
            enabledBorder: borderr,
            disabledBorder: borderr,
            focusedBorder: borderr,
          ),
        ),
        suggestionsCallback: RestaurantService.buscarRestaurante,
        itemBuilder: (context, OrganizacionRestaurantes? suggestion) {
          final restaurant = suggestion!;
          return Container(
            color: Colors.white,
            child: ListTile(
                selectedTileColor: Colors.white,
                textColor: Colors.black,
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                    '${restaurant.idImagen}',
                  ),
                ),
                title: Text(
                  restaurant.nombre!,
                )),
          );
        },
        noItemsFoundBuilder: (context) => Container(
          color: Colors.white,
          height: 40,
          child: const Center(
            child: Text(
              'No se encontraron restaurantes',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
        ),
        onSuggestionSelected: (OrganizacionRestaurantes? suggestion) {
          if (suggestion!.abierto == true) {
            Navigator.pushNamed(context, '/vistaProducto',
                arguments: suggestion);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertaRestauranteCerrado();
              },
            );
          }
        },
      ),
    );
  }

  Widget _topText(size) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.01,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              AppLocalizations.of(context)!.restaurantesParaTi,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 73, 73, 72),
              ),
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
      ],
    );
  }

  Widget _menuDirection() {
    return Center(
      child: InkWell(
        child: Container(
          height: Adapt.hp(5),
          width: Adapt.wp(66),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            children: [
              SizedBox(
                width: Adapt.wp(1),
              ),
              SizedBox(
                width: Adapt.wp(5),
                child: Icon(
                  FontAwesomeIcons.locationDot,
                  size: Adapt.px(30),
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: Adapt.wp(1),
              ),
              SizedBox(
                width: Adapt.wp(55),
                child: Padding(
                  padding: EdgeInsets.all(Adapt.px(5)),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      prefs.defaultLocation == ''
                          ? 'Ingrese nueva dirección'
                          : prefs.defaultLocation,
                      style: TextStyle(
                          fontSize: Adapt.px(20), color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/listLocations');
        },
      ),
    );
  }

  Widget _listRestaurants(size) {
    return FutureBuilder(
      future: _future[indexClasificacionRestaurantes],
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          List? auxSnapshot = [];
          List? auxListaRestaurantes = [];
          for (var i = 0; i < snapshot.data!.length; i++) {
            if (snapshot.data![i]["idCategoriaRestaurante"] == "" ||
                snapshot.data![i]["idCategoriaRestaurante"] ==
                    "62b8f1a77c14f421d5bedb6b") {
              continue;
            } else {
              auxListaRestaurantes.add(snapshot.data![i]);
            }
          }

          if (filtroTiposDeRestaurante.isEmpty) {
            auxSnapshot = auxListaRestaurantes;
          } else {
            for (var restaurante in filtroTiposDeRestaurante) {
              auxSnapshot.addAll(snapshot.data!.where((element) {
                return element["idCategoriaRestaurante"] == restaurante;
              }));
            }
          }
          if (auxSnapshot.isEmpty) {
            return imagenError();
          }

          return Container(
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: Adapt.px(15), right: Adapt.px(15)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3.0,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: Adapt.hp(1),
                mainAxisExtent: Adapt.hp(15),
              ),
              itemCount: auxSnapshot.length,
              itemBuilder: (BuildContext context, int index) {
                double distancia = 0.0;
                if (auxSnapshot?[index]['latitud'] != 0.0 ||
                    auxSnapshot?[index]['latitud'] != null &&
                        auxSnapshot?[index]['longitud'] != 0.0 ||
                    auxSnapshot?[index]['longitud'] != null) {
                  distancia = (Geolocator.distanceBetween(
                              prefs.latitud,
                              prefs.longitud,
                              0.0 + auxSnapshot?[index]['latitud'],
                              0.0 + auxSnapshot?[index]['longitud'])
                          .round() /
                      1000);
                }
                return auxSnapshot?[index]["abierto"]
                    ? InkWell(
                        child: Container(
                          width: Adapt.wp(95),
                          child: Row(
                            children: [
                              Container(
                                width: Adapt.wp(33),
                                height: Adapt.hp(12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                                    '${auxSnapshot?[index]["idImagen"]}',
                                    height: Adapt.hp(20),
                                    width: Adapt.wp(25),
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
                              ),
                              SizedBox(
                                width: Adapt.wp(1),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: Adapt.wp(59),
                                height: Adapt.hp(13),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      height: Adapt.hp(5),
                                      width: Adapt.wp(55),
                                      child: Text(
                                        auxSnapshot?[index]["nombre"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: Adapt.px(27),
                                          color: Colors.black,
                                          fontFamily: 'Montserrat-ExtraBold',
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Adapt.hp(1)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: Adapt.px(10)),
                                      child: Container(
                                        height: Adapt.hp(2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Icon(
                                                FontAwesomeIcons.clock,
                                                color: ColorSelect
                                                    .primaryColorVaco,
                                                size: Adapt.px(25),
                                              ),
                                            ),
                                            SizedBox(width: Adapt.wp(2)),
                                            Container(
                                              child: Text(
                                                '${auxSnapshot?[index]["tiempoEstimadoEntregaMinimo"]} - ${auxSnapshot?[index]["tiempoEstimadoEntregaMaximo"]} min',
                                                style: TextStyle(
                                                  fontSize: Adapt.px(20),
                                                  color: Color.fromARGB(
                                                      255, 65, 65, 65),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Adapt.hp(1)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: Adapt.px(10)),
                                      child: Container(
                                        height: Adapt.hp(2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Icon(
                                                FontAwesomeIcons.solidStar,
                                                color: ColorSelect
                                                    .primaryColorVaco,
                                                size: Adapt.px(25),
                                              ),
                                            ),
                                            SizedBox(width: Adapt.wp(2)),
                                            Container(
                                              child: Text(
                                                auxSnapshot?[index][
                                                            "calificacionPromedio"] !=
                                                        null
                                                    ? auxSnapshot![index][
                                                            "calificacionPromedio"]
                                                        .toStringAsFixed(1)
                                                    : "0",
                                                style: TextStyle(
                                                  fontSize: Adapt.px(20),
                                                  color: Color.fromARGB(
                                                      255, 65, 65, 65),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: Adapt.wp(2)),
                                            Center(
                                              child: Icon(
                                                FontAwesomeIcons.personWalking,
                                                color: ColorSelect
                                                    .primaryColorVaco,
                                                size: Adapt.px(25),
                                              ),
                                            ),
                                            SizedBox(width: Adapt.wp(2)),
                                            Container(
                                              child: Text(
                                                "$distancia",
                                                style: TextStyle(
                                                  fontSize: Adapt.px(20),
                                                  color: Color.fromARGB(
                                                      255, 65, 65, 65),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/vistaProducto',
                            arguments: OrganizacionRestaurantes(
                              auxSnapshot?[index]["id"],
                              auxSnapshot?[index]["nombre"],
                              auxSnapshot?[index]["idDepartamento"],
                              auxSnapshot?[index]["idMunicipio"],
                              auxSnapshot?[index]["direccion"],
                              auxSnapshot?[index]["longitud"],
                              auxSnapshot?[index]["latitud"],
                              auxSnapshot?[index]["telefono"],
                              auxSnapshot?[index]["celular"],
                              auxSnapshot?[index]
                                  ["tiempoEstimadoEntregaMinimo"],
                              auxSnapshot?[index]
                                  ["tiempoEstimadoEntregaMaximo"],
                              auxSnapshot?[index]["idCategoriaRestaurante"],
                              auxSnapshot?[index]["categorias"],
                              auxSnapshot?[index]["estado"],
                              auxSnapshot?[index]["fechaCreacion"],
                              auxSnapshot?[index]["fechaActualizacion"],
                              auxSnapshot?[index]["archivos"],
                              auxSnapshot?[index]["idUsuarioModificador"],
                              auxSnapshot?[index]["idImagen"],
                              auxSnapshot?[index]["idSocio"],
                              auxSnapshot?[index]["calificacionPromedio"],
                              auxSnapshot?[index]["abierto"],
                            ),
                          );
                        },
                      )
                    : InkWell(
                        child: Container(
                          width: Adapt.wp(95),
                          child: Row(
                            children: [
                              auxSnapshot?[index]["abierto"] == true
                                  ? Container(
                                      width: Adapt.wp(33),
                                      height: Adapt.hp(12),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.network(
                                          '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                                          '${auxSnapshot?[index]["idImagen"]}',
                                          height: Adapt.hp(9),
                                          width: Adapt.wp(20),
                                          fit: BoxFit.cover,
                                          errorBuilder:
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
                                          },
                                        ),
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          width: Adapt.wp(33),
                                          height: Adapt.hp(12),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.network(
                                              '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                                              '${auxSnapshot?[index]["idImagen"]}',
                                              height: Adapt.hp(9),
                                              width: Adapt.wp(20),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
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
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Color.fromARGB(150, 0, 0, 0),
                                          ),
                                          width: Adapt.wp(33),
                                          height: Adapt.hp(12),
                                        )
                                      ],
                                    ),
                              SizedBox(
                                width: Adapt.wp(1),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: Adapt.wp(59),
                                height: Adapt.hp(13),
                                child: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      height: Adapt.hp(5),
                                      width: Adapt.wp(55),
                                      child: Text(
                                        auxSnapshot?[index]["nombre"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: Adapt.px(27),
                                          color: Colors.black,
                                          fontFamily: 'Montserrat-ExtraBold',
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Adapt.hp(1)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: Adapt.px(10)),
                                      child: Container(
                                        height: Adapt.hp(2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Icon(
                                                FontAwesomeIcons.clock,
                                                color: ColorSelect
                                                    .primaryColorVaco,
                                                size: Adapt.px(25),
                                              ),
                                            ),
                                            SizedBox(width: Adapt.wp(2)),
                                            Container(
                                              child: Text(
                                                '${auxSnapshot?[index]["tiempoEstimadoEntregaMinimo"]} - ${auxSnapshot?[index]["tiempoEstimadoEntregaMaximo"]} min',
                                                style: TextStyle(
                                                  fontSize: Adapt.px(20),
                                                  color: Color.fromARGB(
                                                      255, 65, 65, 65),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Adapt.hp(1)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: Adapt.px(10)),
                                      child: Container(
                                        height: Adapt.hp(2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Icon(
                                                FontAwesomeIcons.solidStar,
                                                color: ColorSelect
                                                    .primaryColorVaco,
                                                size: Adapt.px(25),
                                              ),
                                            ),
                                            SizedBox(width: Adapt.wp(2)),
                                            Container(
                                              child: Text(
                                                auxSnapshot?[index][
                                                            "calificacionPromedio"] !=
                                                        null
                                                    ? auxSnapshot![index][
                                                            "calificacionPromedio"]
                                                        .toStringAsFixed(1)
                                                    : "0",
                                                style: TextStyle(
                                                  fontSize: Adapt.px(20),
                                                  color: Color.fromARGB(
                                                      255, 65, 65, 65),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: Adapt.wp(2)),
                                            Center(
                                              child: Icon(
                                                FontAwesomeIcons.personWalking,
                                                color: ColorSelect
                                                    .primaryColorVaco,
                                                size: Adapt.px(25),
                                              ),
                                            ),
                                            SizedBox(width: Adapt.wp(2)),
                                            Container(
                                              child: Text(
                                                "$distancia",
                                                style: TextStyle(
                                                  fontSize: Adapt.px(20),
                                                  color: Color.fromARGB(
                                                      255, 65, 65, 65),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertaRestauranteCerrado();
                            },
                          );
                        },
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

  Widget _listRestaurantsPromocion() {
    List? auxSnapshot = [];
    List? auxListaRestaurantes = [];
    for (var i = 0;
        i < promocionesProvider!.promocionesRestaurantes.length;
        i++) {
      if (promocionesProvider!.promocionesRestaurantes[i]
                  ["idCategoriaRestaurante"] ==
              "" ||
          promocionesProvider!.promocionesRestaurantes[i]
                  ["idCategoriaRestaurante"] ==
              "62b8f1a77c14f421d5bedb6b") {
        continue;
      } else {
        auxListaRestaurantes
            .add(promocionesProvider!.promocionesRestaurantes[i]);
      }
    }

    if (filtroTiposDeRestaurante.isEmpty) {
      auxSnapshot = auxListaRestaurantes;
    } else {
      for (var restaurante in filtroTiposDeRestaurante) {
        auxSnapshot.addAll(
            promocionesProvider!.promocionesRestaurantes.where((element) {
          return element["idCategoriaRestaurante"] == restaurante;
        }));
      }
    }
    if (auxSnapshot.isEmpty) {
      return imagenErrorPromociones();
    }
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: Adapt.px(15), right: Adapt.px(15)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3.0,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: Adapt.hp(1),
          mainAxisExtent: Adapt.hp(15),
        ),
        itemCount: auxSnapshot.length,
        itemBuilder: (BuildContext context, int index) {
          double distancia = 0.0;
          if (auxSnapshot?[index]['latitud'] != 0.0 ||
              auxSnapshot?[index]['latitud'] != null &&
                  auxSnapshot?[index]['longitud'] != 0.0 ||
              auxSnapshot?[index]['longitud'] != null) {
            distancia = (Geolocator.distanceBetween(
                        prefs.latitud,
                        prefs.longitud,
                        0.0 + auxSnapshot?[index]['latitud'],
                        0.0 + auxSnapshot?[index]['longitud'])
                    .round() /
                1000);
          }
          return auxSnapshot?[index]["abierto"]
              ? InkWell(
                  child: Container(
                    width: Adapt.wp(95),
                    child: Row(
                      children: [
                        Container(
                          width: Adapt.wp(33),
                          height: Adapt.hp(12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                              '${auxSnapshot?[index]["idImagen"]}',
                              height: Adapt.hp(20),
                              width: Adapt.wp(25),
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
                        ),
                        SizedBox(
                          width: Adapt.wp(1),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: Adapt.wp(59),
                          height: Adapt.hp(13),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                height: Adapt.hp(5),
                                width: Adapt.wp(55),
                                child: Text(
                                  auxSnapshot?[index]["nombre"],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: Adapt.px(27),
                                    color: Colors.black,
                                    fontFamily: 'Montserrat-ExtraBold',
                                  ),
                                ),
                              ),
                              SizedBox(height: Adapt.hp(1)),
                              Padding(
                                padding: EdgeInsets.only(left: Adapt.px(10)),
                                child: Container(
                                  height: Adapt.hp(2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Icon(
                                          FontAwesomeIcons.clock,
                                          color: ColorSelect.primaryColorVaco,
                                          size: Adapt.px(25),
                                        ),
                                      ),
                                      SizedBox(width: Adapt.wp(2)),
                                      Container(
                                        child: Text(
                                          '${auxSnapshot?[index]["tiempoEstimadoEntregaMinimo"]} - ${auxSnapshot?[index]["tiempoEstimadoEntregaMaximo"]} min',
                                          style: TextStyle(
                                            fontSize: Adapt.px(20),
                                            color:
                                                Color.fromARGB(255, 65, 65, 65),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: Adapt.hp(1)),
                              Padding(
                                padding: EdgeInsets.only(left: Adapt.px(10)),
                                child: Container(
                                  height: Adapt.hp(2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Icon(
                                          FontAwesomeIcons.solidStar,
                                          color: ColorSelect.primaryColorVaco,
                                          size: Adapt.px(25),
                                        ),
                                      ),
                                      SizedBox(width: Adapt.wp(2)),
                                      Container(
                                        child: Text(
                                          auxSnapshot?[index][
                                                      "calificacionPromedio"] !=
                                                  null
                                              ? auxSnapshot![index]
                                                      ["calificacionPromedio"]
                                                  .toStringAsFixed(1)
                                              : "0",
                                          style: TextStyle(
                                            fontSize: Adapt.px(20),
                                            color:
                                                Color.fromARGB(255, 65, 65, 65),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: Adapt.wp(2)),
                                      Center(
                                        child: Icon(
                                          FontAwesomeIcons.personWalking,
                                          color: ColorSelect.primaryColorVaco,
                                          size: Adapt.px(25),
                                        ),
                                      ),
                                      SizedBox(width: Adapt.wp(2)),
                                      Container(
                                        child: Text(
                                          "$distancia",
                                          style: TextStyle(
                                            fontSize: Adapt.px(20),
                                            color:
                                                Color.fromARGB(255, 65, 65, 65),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    print(auxSnapshot?[index]["id"]);
                    Navigator.pushNamed(
                      context,
                      '/vistaProducto',
                      arguments: OrganizacionRestaurantes(
                        auxSnapshot?[index]["id"],
                        auxSnapshot?[index]["nombre"],
                        auxSnapshot?[index]["idDepartamento"],
                        auxSnapshot?[index]["idMunicipio"],
                        auxSnapshot?[index]["direccion"],
                        auxSnapshot?[index]["longitud"],
                        auxSnapshot?[index]["latitud"],
                        auxSnapshot?[index]["telefono"],
                        auxSnapshot?[index]["celular"],
                        auxSnapshot?[index]["tiempoEstimadoEntregaMinimo"],
                        auxSnapshot?[index]["tiempoEstimadoEntregaMaximo"],
                        auxSnapshot?[index]["idCategoriaRestaurante"],
                        auxSnapshot?[index]["categorias"],
                        auxSnapshot?[index]["estado"],
                        auxSnapshot?[index]["fechaCreacion"],
                        auxSnapshot?[index]["fechaActualizacion"],
                        auxSnapshot?[index]["archivos"],
                        auxSnapshot?[index]["idUsuarioModificador"],
                        auxSnapshot?[index]["idImagen"],
                        auxSnapshot?[index]["idSocio"],
                        auxSnapshot?[index]["calificacionPromedio"],
                        auxSnapshot?[index]["abierto"],
                      ),
                    );
                  },
                )
              : InkWell(
                  child: Container(
                    width: Adapt.wp(95),
                    child: Row(
                      children: [
                        auxSnapshot?[index]["abierto"] == true
                            ? Container(
                                width: Adapt.wp(33),
                                height: Adapt.hp(12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                                    '${auxSnapshot?[index]["idImagen"]}',
                                    height: Adapt.hp(9),
                                    width: Adapt.wp(20),
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
                              )
                            : Stack(
                                children: [
                                  Container(
                                    width: Adapt.wp(33),
                                    height: Adapt.hp(12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.network(
                                        '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                                        '${auxSnapshot?[index]["idImagen"]}',
                                        height: Adapt.hp(9),
                                        width: Adapt.wp(20),
                                        fit: BoxFit.cover,
                                        errorBuilder:
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
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Color.fromARGB(150, 0, 0, 0),
                                    ),
                                    width: Adapt.wp(33),
                                    height: Adapt.hp(12),
                                  )
                                ],
                              ),
                        SizedBox(
                          width: Adapt.wp(1),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: Adapt.wp(59),
                          height: Adapt.hp(13),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                height: Adapt.hp(5),
                                width: Adapt.wp(55),
                                child: Text(
                                  auxSnapshot?[index]["nombre"],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: Adapt.px(27),
                                    color: Colors.black,
                                    fontFamily: 'Montserrat-ExtraBold',
                                  ),
                                ),
                              ),
                              SizedBox(height: Adapt.hp(1)),
                              Padding(
                                padding: EdgeInsets.only(left: Adapt.px(10)),
                                child: Container(
                                  height: Adapt.hp(2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Icon(
                                          FontAwesomeIcons.clock,
                                          color: ColorSelect.primaryColorVaco,
                                          size: Adapt.px(25),
                                        ),
                                      ),
                                      SizedBox(width: Adapt.wp(2)),
                                      Container(
                                        child: Text(
                                          '${auxSnapshot?[index]["tiempoEstimadoEntregaMinimo"]} - ${auxSnapshot?[index]["tiempoEstimadoEntregaMaximo"]} min',
                                          style: TextStyle(
                                            fontSize: Adapt.px(20),
                                            color:
                                                Color.fromARGB(255, 65, 65, 65),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: Adapt.hp(1)),
                              Padding(
                                padding: EdgeInsets.only(left: Adapt.px(10)),
                                child: Container(
                                  height: Adapt.hp(2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Icon(
                                          FontAwesomeIcons.solidStar,
                                          color: ColorSelect.primaryColorVaco,
                                          size: Adapt.px(25),
                                        ),
                                      ),
                                      SizedBox(width: Adapt.wp(2)),
                                      Container(
                                        child: Text(
                                          auxSnapshot?[index][
                                                      "calificacionPromedio"] !=
                                                  null
                                              ? auxSnapshot![index]
                                                      ["calificacionPromedio"]
                                                  .toStringAsFixed(1)
                                              : "0",
                                          style: TextStyle(
                                            fontSize: Adapt.px(20),
                                            color:
                                                Color.fromARGB(255, 65, 65, 65),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: Adapt.wp(2)),
                                      Center(
                                        child: Icon(
                                          FontAwesomeIcons.personWalking,
                                          color: ColorSelect.primaryColorVaco,
                                          size: Adapt.px(25),
                                        ),
                                      ),
                                      SizedBox(width: Adapt.wp(2)),
                                      Container(
                                        child: Text(
                                          "$distancia",
                                          style: TextStyle(
                                            fontSize: Adapt.px(20),
                                            color:
                                                Color.fromARGB(255, 65, 65, 65),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertaRestauranteCerrado();
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
