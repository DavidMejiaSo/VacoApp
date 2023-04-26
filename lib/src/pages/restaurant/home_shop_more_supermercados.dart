import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/restaurant_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prueba_vaco_app/backgrouds_widgets/background_restaurant.dart';
import '../../../enviroment/environment.dart';
import '../../../model/controller_arg_restaurantes.dart';
import '../../../preferences/preferences_user.dart';
import '../../../provider/promotions_provider.dart';
import '../../../service/supermercado_service.dart';
import '../../widgets/alert_dialog_restaurante_cerrado.dart';
import '../../widgets/loading_indicator.dart';

import '../../../responsive/Color.dart';

class HomeShopMoreSuper extends StatefulWidget {
  const HomeShopMoreSuper({Key? key}) : super(key: key);

  @override
  _HomeShopMoreSupermercadosState createState() =>
      _HomeShopMoreSupermercadosState();
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

class _HomeShopMoreSupermercadosState extends State<HomeShopMoreSuper> {
  final restaurantService = RestaurantService();

  int indexOfCategoriasRestaurantes = 0;
  final supermercadoService = SupermercadoService();
  final prefs = PreferenciasUsuario();

  bool mostrarPromociones = false;
  @override
  void initState() {
    indexOfCategoriasRestaurantes = 0;

    mostrarPromociones = false;
    super.initState();
  }

  late List<dynamic> _future = [
    supermercadoService.listarSupermercadosAprobados(),
    supermercadoService.listarSupermercadosPorPedidos(),
    supermercadoService.listarSupermercadosPorCalificacion(),
  ];

  PromotionsProvider? promocionesProvider;
  Widget build(BuildContext context) {
    promocionesProvider =
        Provider.of<PromotionsProvider>(context, listen: true);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(children: [
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
        ]),
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
        _ordenBy(),
        _topText(size),
        mostrarPromociones
            ? promocionesProvider!.promocionesSupermercados.isEmpty
                ? imagenError()
                : _listSupermercadosPromocion()
            : _listSupermercados(),
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
          'Ups, no hay promocioens disponibles en el momento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: Adapt.hp(15),
        ),
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
              width: Adapt.wp(1),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
              width: Adapt.wp(1),
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
                      listaProductosCarritoNumero.toString(),
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

  Widget _ordenBy() {
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
                            color: indexOfCategoriasRestaurantes == 0
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
                    indexOfCategoriasRestaurantes = 0;
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
                            color: indexOfCategoriasRestaurantes == 1
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
                    indexOfCategoriasRestaurantes = 1;
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
                            color: indexOfCategoriasRestaurantes == 2
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
                    indexOfCategoriasRestaurantes = 2;
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
        loadingBuilder: (BuildContext context) {
          return Center(
              child:
                  Container(height: Adapt.hp(10), child: LoadingIndicatorW()));
        },
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
        suggestionsCallback: SupermercadoService.buscarSupermercado,
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
              "SUPERMERCADOS PARA TI",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 73, 73, 72),
                fontFamily: 'Montserrat-ExtraBold',
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

  Widget _listSupermercados() {
    return FutureBuilder(
      future: _future[indexOfCategoriasRestaurantes],
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: Adapt.px(15), right: Adapt.px(15)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3.0,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: Adapt.hp(0.5),
                mainAxisExtent: Adapt.hp(15),
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                double distancia = 0.0;
                if (snapshot.data![index]['latitud'] != 0.0 ||
                    snapshot.data![index]['latitud'] != null &&
                        snapshot.data![index]['longitud'] != 0.0 ||
                    snapshot.data![index]['longitud'] != null) {
                  distancia = (Geolocator.distanceBetween(
                              prefs.latitud,
                              prefs.longitud,
                              0.0 + snapshot.data![index]['latitud'],
                              0.0 + snapshot.data![index]['longitud'])
                          .round() /
                      1000);
                }
                return snapshot.data![index]["abierto"]
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
                                    '${snapshot.data![index]["idImagen"]}',
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
                                        snapshot.data![index]["nombre"],
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
                                                '${snapshot.data![index]["tiempoEstimadoEntregaMinimo"]} - ${snapshot.data![index]["tiempoEstimadoEntregaMaximo"]} min',
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
                                                snapshot.data![index][
                                                            "calificacionPromedio"] !=
                                                        null
                                                    ? snapshot.data![index][
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
                          Navigator.pushNamed(
                            context,
                            '/vistaProducto',
                            arguments: OrganizacionRestaurantes(
                              snapshot.data![index]["id"],
                              snapshot.data![index]["nombre"],
                              snapshot.data![index]["idDepartamento"],
                              snapshot.data![index]["idMunicipio"],
                              snapshot.data![index]["direccion"],
                              snapshot.data![index]["longitud"],
                              snapshot.data![index]["latitud"],
                              snapshot.data![index]["telefono"],
                              snapshot.data![index]["celular"],
                              snapshot.data![index]
                                  ["tiempoEstimadoEntregaMinimo"],
                              snapshot.data![index]
                                  ["tiempoEstimadoEntregaMaximo"],
                              snapshot.data![index]["idCategoriaRestaurante"],
                              snapshot.data![index]["categorias"],
                              snapshot.data![index]["estado"],
                              snapshot.data![index]["fechaCreacion"],
                              snapshot.data![index]["fechaActualizacion"],
                              snapshot.data![index]["archivos"],
                              snapshot.data![index]["idUsuarioModificador"],
                              snapshot.data![index]["idImagen"],
                              snapshot.data![index]["idSocio"],
                              snapshot.data![index]["calificacionPromedio"],
                              snapshot.data![index]["abierto"],
                            ),
                          );
                        },
                      )
                    : InkWell(
                        child: Container(
                          width: Adapt.wp(95),
                          child: Row(
                            children: [
                              snapshot.data![index]["abierto"] == true
                                  ? Container(
                                      width: Adapt.wp(33),
                                      height: Adapt.hp(12),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.network(
                                          '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                                          '${snapshot.data![index]["idImagen"]}',
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
                                              '${snapshot.data![index]["idImagen"]}',
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
                                        snapshot.data![index]["nombre"],
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
                                                '${snapshot.data![index]["tiempoEstimadoEntregaMinimo"]} - ${snapshot.data![index]["tiempoEstimadoEntregaMaximo"]} min',
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
                                                snapshot.data![index][
                                                            "calificacionPromedio"] !=
                                                        null
                                                    ? snapshot.data![index][
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

  Widget _listSupermercadosPromocion() {
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: Adapt.px(15), right: Adapt.px(15)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3.0,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: Adapt.hp(0.5),
          mainAxisExtent: Adapt.hp(15),
        ),
        itemCount: promocionesProvider!.promocionesSupermercados.length,
        itemBuilder: (BuildContext context, int index) {
          double distancia = 0.0;
          if (promocionesProvider!.promocionesSupermercados[index]['latitud'] !=
                  0.0 ||
              promocionesProvider!.promocionesSupermercados[index]['latitud'] !=
                      null &&
                  promocionesProvider!.promocionesSupermercados[index]
                          ['longitud'] !=
                      0.0 ||
              promocionesProvider!.promocionesSupermercados[index]
                      ['longitud'] !=
                  null) {
            distancia = (Geolocator.distanceBetween(
                        prefs.latitud,
                        prefs.longitud,
                        0.0 +
                            promocionesProvider!.promocionesSupermercados[index]
                                ['latitud'],
                        0.0 +
                            promocionesProvider!.promocionesSupermercados[index]
                                ['longitud'])
                    .round() /
                1000);
          }
          return promocionesProvider!.promocionesSupermercados[index]["abierto"]
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
                              '${promocionesProvider!.promocionesSupermercados[index]["idImagen"]}',
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
                                  promocionesProvider!
                                          .promocionesSupermercados[index]
                                      ["nombre"],
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
                                          '${promocionesProvider!.promocionesSupermercados[index]["tiempoEstimadoEntregaMinimo"]} - ${promocionesProvider!.promocionesSupermercados[index]["tiempoEstimadoEntregaMaximo"]} min',
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
                                          promocionesProvider!.promocionesSupermercados[
                                                          index][
                                                      "calificacionPromedio"] !=
                                                  null
                                              ? promocionesProvider!
                                                  .promocionesRestaurantes[
                                                      index]
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
                    Navigator.pushNamed(
                      context,
                      '/vistaProducto',
                      arguments: OrganizacionRestaurantes(
                        promocionesProvider!.promocionesSupermercados[index]
                            ["id"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["nombre"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["idDepartamento"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["idMunicipio"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["direccion"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["longitud"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["latitud"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["telefono"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["celular"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["tiempoEstimadoEntregaMinimo"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["tiempoEstimadoEntregaMaximo"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["idCategoriaRestaurante"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["categorias"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["estado"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["fechaCreacion"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["fechaActualizacion"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["archivos"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["idUsuarioModificador"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["idImagen"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["idSocio"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["calificacionPromedio"],
                        promocionesProvider!.promocionesSupermercados[index]
                            ["abierto"],
                      ),
                    );
                  },
                )
              : InkWell(
                  child: Container(
                    width: Adapt.wp(95),
                    child: Row(
                      children: [
                        promocionesProvider!.promocionesSupermercados[index]
                                    ["abierto"] ==
                                true
                            ? Container(
                                width: Adapt.wp(33),
                                height: Adapt.hp(12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                                    '${promocionesProvider!.promocionesSupermercados[index]["idImagen"]}',
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
                                        '${promocionesProvider!.promocionesSupermercados[index]["idImagen"]}',
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
                                  promocionesProvider!
                                      .promocionesRestaurantes[index]["nombre"],
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
                                          '${promocionesProvider!.promocionesSupermercados[index]["tiempoEstimadoEntregaMinimo"]} - ${promocionesProvider!.promocionesSupermercados[index]["tiempoEstimadoEntregaMaximo"]} min',
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
                                          promocionesProvider!.promocionesSupermercados[
                                                          index][
                                                      "calificacionPromedio"] !=
                                                  null
                                              ? promocionesProvider!
                                                  .promocionesRestaurantes[
                                                      index]
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
