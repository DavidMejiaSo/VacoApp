import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/provider/global_provider.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/restaurant_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prueba_vaco_app/service/supermercado_service.dart';
import 'package:prueba_vaco_app/backgrouds_widgets/background_restaurant.dart';

import '../../../enviroment/environment.dart';
import '../../../model/controller_arg_restaurantes.dart';
import '../../../preferences/preferences_user.dart';
import '../../../responsive/Color.dart';
import '../../../service/user_information_service.dart';
import '../../widgets/alert_dialog_restaurante_cerrado.dart';
import '../../widgets/loading_indicator.dart';
import '../advertising/adversiting_home.dart';
import '../location/home_list_location.dart';
import '../profile/profile.dart';

class HomeShop extends StatefulWidget {
  const HomeShop({Key? key}) : super(key: key);

  @override
  _HomeShopState createState() => _HomeShopState();
}

class _HomeShopState extends State<HomeShop> {
  final restaurantService = RestaurantService();
  final supermercadoService = SupermercadoService();
  String nombreRestaurante = "";

  final prefs = PreferenciasUsuario();

  @override
  void initState() {
    getUserData();

    defaultLocation();
    super.initState();
  }

  void getUserData() async {
    final getDataUser = GetUserInfoService();
    Map respuesta = await getDataUser.getInfo();

    String? token = "";
    await FirebaseMessaging.instance.getToken().then((value) {
      token = value;
    });
    //respuesta["idTelefono"] = token;
    if (respuesta["idTelefono"] == "") {
      print("Está vacío mi reeeey");
      changeInfoUser.changeInfo("idTelefono", token);
      //changeInfoUser.actualizarUser(respuesta);
    } else if (respuesta["idTelefono"] != token) {
      print("Es diferente de TOKEN PAI");
      changeInfoUser.changeInfo("idTelefono", token);
    }

    setState(() {});
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final globalProvider = Provider.of<GlobalProvider>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const BackgroundRestaurant(),
            _body(size),
            globalProvider.esPublicidad == true ? _publicidad() : Container()
          ],
        ),
      ),
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

  Widget _publicidad() {
    return const AdverstingHome();
  }

  Widget _body(size) {
    return Column(
      children: [
        SizedBox(
          height: Adapt.hp(2),
        ),
        // botonSupermercado(),
        _bodyParteUno(size),

        SizedBox(
          height: Adapt.hp(2),
        ),

        Expanded(child: todosEnUnoRestySupermercados(size)),
        SizedBox(
          height: Adapt.hp(1),
        ),
      ],
    );
  }

  Widget _bodyParteUno(size) {
    return Row(
      children: [
        Flexible(
          flex: 5,
          child: _menuDirection(),
        ),
      ],
    );
  }

  Widget _listRestaurants(size) {
    return FutureBuilder(
      future: restaurantService.listarRestaurantesPorPedidos(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: Adapt.wp(100),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 10, right: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: Adapt.hp(20),
                crossAxisSpacing: Adapt.wp(5),
              ),
              itemCount: snapshot.data.length <= 4 ? snapshot.data.length : 4,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    snapshot.data[index]["abierto"] == true
                        ? InkWell(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: size.height * 0.14,
                                child: snapshot.data[index]["idImagen"] == ""
                                    ? const LoadingIndicatorW()
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.network(
                                          '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                                          '${snapshot.data[index]["idImagen"]}',
                                          height: Adapt.hp(60),
                                          width: Adapt.wp(35),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image.network(
                                                'https://png.pngtree.com/png-vector/20210227/ourlarge/pngtree-error-404-glitch-effect-png-image_2943478.jpg',
                                                height: Adapt.hp(60),
                                                width: Adapt.wp(35),
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                      )),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/vistaProducto',
                                arguments: OrganizacionRestaurantes(
                                  snapshot.data[index]["id"],
                                  snapshot.data[index]["nombre"],
                                  snapshot.data[index]["idDepartamento"],
                                  snapshot.data[index]["idMunicipio"],
                                  snapshot.data[index]["direccion"],
                                  snapshot.data[index]["longitud"],
                                  snapshot.data[index]["latitud"],
                                  snapshot.data[index]["telefono"],
                                  snapshot.data[index]["celular"],
                                  snapshot.data[index]
                                      ["tiempoEstimadoEntregaMinimo"],
                                  snapshot.data[index]
                                      ["tiempoEstimadoEntregaMaximo"],
                                  snapshot.data[index]
                                      ["idCategoriaRestaurante"],
                                  snapshot.data[index]["categorias"],
                                  snapshot.data[index]["estado"],
                                  snapshot.data[index]["fechaCreacion"],
                                  snapshot.data[index]["fechaActualizacion"],
                                  snapshot.data[index]["archivos"],
                                  snapshot.data[index]["idUsuarioModificador"],
                                  snapshot.data[index]["idImagen"],
                                  snapshot.data[index]["idSocio"],
                                  snapshot.data[index]["calificacionPromedio"],
                                  snapshot.data[index]["abierto"],
                                ),
                              );
                            },
                          )
                        : InkWell(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(150, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: size.height * 0.14,
                                child: snapshot.data[index]["idImagen"] == ""
                                    ? const LoadingIndicatorW()
                                    : Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            child: Image.network(
                                              '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                                              '${snapshot.data[index]["idImagen"]}',
                                              height: Adapt.hp(60),
                                              width: Adapt.wp(35),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Image.network(
                                                    'https://png.pngtree.com/png-vector/20210227/ourlarge/pngtree-error-404-glitch-effect-png-image_2943478.jpg',
                                                    height: Adapt.hp(60),
                                                    width: Adapt.wp(35),
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color:
                                                  Color.fromARGB(150, 0, 0, 0),
                                            ),
                                            height: Adapt.hp(60),
                                            width: Adapt.wp(35),
                                          )
                                        ],
                                      )),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertaRestauranteCerrado();
                                },
                              );
                            },
                          ),
                    SizedBox(
                      height: Adapt.hp(1.5),
                    ),
                    Flexible(
                      child: Text(
                        snapshot.data[index]["nombre"],
                        style: TextStyle(
                          fontSize: Adapt.px(20),
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return const Center(
            child: LoadingIndicatorW(),
          );
        }
      },
    );
  }

  Widget _listSuperMarket(size) {
    return FutureBuilder(
      future: supermercadoService.listarSupermercadosAprobados(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Container(
            width: Adapt.wp(100),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(left: 10, right: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: Adapt.hp(20),
                crossAxisSpacing: Adapt.wp(5),
              ),
              itemCount: snapshot.data.length <= 4 ? snapshot.data.length : 4,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    snapshot.data[index]["abierto"] == true
                        ? InkWell(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: size.height * 0.14,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.network(
                                    '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                                    '${snapshot.data[index]["idImagen"]}',
                                    height: Adapt.hp(60),
                                    width: Adapt.wp(35),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          'https://png.pngtree.com/png-vector/20210227/ourlarge/pngtree-error-404-glitch-effect-png-image_2943478.jpg',
                                          height: Adapt.hp(60),
                                          width: Adapt.wp(35),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  ),
                                )),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/vistaProducto',
                                arguments: OrganizacionRestaurantes(
                                  snapshot.data[index]["id"],
                                  snapshot.data[index]["nombre"],
                                  snapshot.data[index]["idDepartamento"],
                                  snapshot.data[index]["idMunicipio"],
                                  snapshot.data[index]["direccion"],
                                  snapshot.data[index]["longitud"],
                                  snapshot.data[index]["latitud"],
                                  snapshot.data[index]["telefono"],
                                  snapshot.data[index]["celular"],
                                  snapshot.data[index]
                                      ["tiempoEstimadoEntregaMinimo"],
                                  snapshot.data[index]
                                      ["tiempoEstimadoEntregaMaximo"],
                                  snapshot.data[index]
                                      ["idCategoriaRestaurante"],
                                  snapshot.data[index]["categorias"],
                                  snapshot.data[index]["estado"],
                                  snapshot.data[index]["fechaCreacion"],
                                  snapshot.data[index]["fechaActualizacion"],
                                  snapshot.data[index]["archivos"],
                                  snapshot.data[index]["idUsuarioModificador"],
                                  snapshot.data[index]["idImagen"],
                                  snapshot.data[index]["idSocio"],
                                  snapshot.data[index]["calificacionPromedio"],
                                  snapshot.data[index]["abierto"],
                                ),
                              );
                            },
                          )
                        : InkWell(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: size.height * 0.14,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.network(
                                        '${Env.currentEnv['serverUrl']}//imagenRestaurante/traerImagen?id='
                                        '${snapshot.data[index]["idImagen"]}',
                                        height: Adapt.hp(60),
                                        width: Adapt.wp(35),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.network(
                                              'https://png.pngtree.com/png-vector/20210227/ourlarge/pngtree-error-404-glitch-effect-png-image_2943478.jpg',
                                              height: Adapt.hp(60),
                                              width: Adapt.wp(35),
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Color.fromARGB(150, 0, 0, 0),
                                      ),
                                      height: Adapt.hp(60),
                                      width: Adapt.wp(35),
                                    )
                                  ],
                                )),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertaRestauranteCerrado();
                                },
                              );
                            },
                          ),
                    SizedBox(
                      height: Adapt.hp(1.5),
                    ),
                    Flexible(
                      child: Text(
                        snapshot.data[index]["nombre"],
                        style: TextStyle(
                          fontSize: Adapt.px(20),
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        } else {
          return const Center(
            child: LoadingIndicatorW(),
          );
        }
      },
    );
  }

  Widget todosEnUnoRestySupermercados(size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Restaurantes".toUpperCase(),
            style: TextStyle(
              shadows: const <Shadow>[
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 1.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
              fontSize: 24,
              fontFamily: 'Montserrat-ExtraBold',
              color: ColorSelect.primaryColorVaco,
            ),
          ),
          SizedBox(
            height: Adapt.hp(3),
          ),
          _listRestaurants(size),
          SizedBox(
            height: Adapt.hp(1),
          ),
          _botonSeeMore(),
          SizedBox(
            height: Adapt.hp(4),
          ),
          Container(
            height: Adapt.px(1.5),
            color: Color.fromARGB(255, 179, 179, 179),
          ),
          SizedBox(
            height: Adapt.hp(3),
          ),
          Text(
            "Supermercados".toUpperCase(),
            style: TextStyle(
              shadows: const <Shadow>[
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 1.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
              fontSize: 24,
              fontFamily: 'Montserrat-ExtraBold',
              color: ColorSelect.primaryColorVaco,
            ),
          ),
          SizedBox(
            height: Adapt.hp(3),
          ),
          _listSuperMarket(size),
          SizedBox(
            height: Adapt.hp(1),
          ),
          _botonSeeMoreSupermercados(),
        ],
      ),
    );
  }

  Widget _botonSeeMore() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        //padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        primary: ColorSelect.primaryColorVaco,
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
    return SizedBox(
      width: Adapt.wp(45),
      child: ElevatedButton(
        style: style,
        child: Text(
          AppLocalizations.of(context)!.verMas,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat-ExtraBold',
              color: Colors.black),
        ),
        onPressed: () => {Navigator.pushNamed(context, '/homeShopMore')},
      ),
    );
  }

  Widget _botonSeeMoreSupermercados() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        //padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
        primary: ColorSelect.primaryColorVaco,
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
    return SizedBox(
      width: Adapt.wp(45),
      child: ElevatedButton(
          style: style,
          child: Text(
            "Ver más Supermercados".toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 11,
                fontFamily: 'Montserrat-ExtraBold',
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/homeShopSupermercado');
          }),
    );
  }

  void defaultLocation() async {
    final respuesta = await userLocations.getLocationsByUser();
    for (var i = 0; i < respuesta.length; i++) {
      if (respuesta[i]['porDefecto'] == true) {
        prefs.defaultLocation = respuesta[i]['direccion'];
      }
    }
  }
}
