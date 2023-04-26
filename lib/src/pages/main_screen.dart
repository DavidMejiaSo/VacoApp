import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/src/pages/location/search_restaurant_with_map.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prueba_vaco_app/src/pages/products/favorite_products.dart';
import 'package:prueba_vaco_app/src/pages/profile/profile.dart';
import 'package:prueba_vaco_app/src/pages/ratings/rating_vaco_page.dart';
import 'package:prueba_vaco_app/src/pages/register/register_with_facebook_page.dart';
import 'package:prueba_vaco_app/src/pages/restaurant/home_shop.dart';
import 'package:prueba_vaco_app/src/pages/support/frequent_questions_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';

import '../../provider/global_provider.dart';
import '../widgets/loading_indicator.dart';
import 'notifications/notification_page.dart';
import 'orders/order_hisotorial.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  int selectedIndex = 2;
  int selectedIndexDrawer = 0;
  final _navigationKey = GlobalKey<CurvedNavigationBarState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _items = const [
    ImageIcon(
      AssetImage('assets/navigationBarIcons/iconoMenu.png'),
    ),
    ImageIcon(
      AssetImage(
          'assets/navigationBarIcons/iconoCampanaNotificacionActiva.png'),
    ),
    ImageIcon(AssetImage('assets/navigationBarIcons/iconoHome.png')),
    ImageIcon(AssetImage('assets/navigationBarIcons/iconoLocacion.png')),
    ImageIcon(AssetImage('assets/navigationBarIcons/iconoFavoritos.png')),
  ];

  final _tiemsDrawe = const [
    LoadingIndicatorW(),
    ProfilePage(),
    OrderHistory(),
    RatingVacoAsUser(),
    FrequentQuestionsPage(),
  ];
  final lineaDivisoria = Container(
    height: Adapt.px(1.5),
    color: Colors.grey,
  );
  final listViewBody = const [
    HomeShop(),
    NotificacionHome(),
    HomeShop(),
    SearchRestaurantWithMap(),
    FavoriteProducts(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        body: _connectionStatus.toString() != 'ConnectivityResult.none'
            ? selectedIndex == 0
                ? _tiemsDrawe[selectedIndexDrawer]
                : listViewBody[selectedIndex]
            : Stack(
                children: [
                  SafeArea(
                      child: Container(
                          height: Adapt.screenH(),
                          width: Adapt.screenW(),
                          child: Center(
                            child: Text(
                              'No tienes conexión a Internet',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Adapt.px(50),
                                fontWeight: FontWeight.bold,
                                color: ColorSelect.primaryColorVaco,
                                fontFamily: 'Montserrat-SemiBoldItalic',
                              ),
                            ),
                          ))),
                ],
              ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _navigationKey,
          index: selectedIndex,
          height: Adapt.hp(7),
          items: _items,
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: ColorSelect.primaryColorVaco,
          animationCurve: Curves.ease,
          animationDuration: const Duration(milliseconds: 500),
          onTap: (index) {
            selectedIndex = index;
            if (index != 0) {
              selectedIndexDrawer = 0;
            }
            if (index == 0) {
              _scaffoldKey.currentState?.openDrawer();
            }
            setState(() {});
          },
        ),
        drawer: Stack(
          children: [
            Container(
              height: Adapt.screenH(),
              width: Adapt.screenW(),
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.closeDrawer();
                  if (selectedIndexDrawer == 0) {
                    selectedIndex = 2;
                    selectedIndexDrawer = 0;
                  }

                  setState(() {});
                },
              ),
            ),
            Drawer(
              elevation: 10,
              width: Adapt.wp(80),
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(30))),
              backgroundColor: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    curve: Curves.fastOutSlowIn,
                    child: Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!.saludo,
                                style: TextStyle(
                                  fontFamily: 'Montserrat-ExtraBold',
                                  color: Colors.black,
                                  fontSize: Adapt.px(60),
                                ),
                              ),
                            ),
                            Container(
                              height: Adapt.px(2),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ' ${prefs.nombreUsuario}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Adapt.px(40),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: ColorSelect.primaryColorVaco,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(0)),
                    ),
                  ),
                  ListTile(
                    textColor: Colors.black,
                    leading: const Icon(Icons.person, color: Colors.black),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.black),
                    title: Text(
                      AppLocalizations.of(context)!.perfil,
                    ),
                    onTap: () {
                      selectedIndexDrawer = 1;
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                  lineaDivisoria,
                  ListTile(
                    textColor: Colors.black,
                    leading: const Icon(FontAwesomeIcons.fileLines,
                        color: Colors.black),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.black),
                    title: const Text('Historial de pedidos'),
                    onTap: () {
                      selectedIndexDrawer = 2;
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                  lineaDivisoria,
                  ListTile(
                    textColor: Colors.black,
                    leading: const Icon(Icons.star, color: Colors.black),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.black),
                    title: const Text('Calificanos'),
                    onTap: () {
                      selectedIndexDrawer = 3;
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                  lineaDivisoria,
                  ListTile(
                    textColor: Colors.black,
                    leading: const Icon(FontAwesomeIcons.fileLines,
                        color: Colors.black),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.black),
                    title: const Text('ver Publicidad'),
                    onTap: () async {
                      final globalProvider =
                          Provider.of<GlobalProvider>(context, listen: false);

                      globalProvider.esPublicidad = true;
                      _scaffoldKey.currentState?.closeDrawer();

                      selectedIndex = 2;
                      selectedIndexDrawer = 0;

                      setState(() {});
                    },
                  ),
                  lineaDivisoria,
                  ListTile(
                    textColor: Colors.black,
                    leading:
                        const Icon(FontAwesomeIcons.list, color: Colors.black),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.black),
                    title: const Text('Pregutas frecuentes'),
                    onTap: () {
                      selectedIndexDrawer = 4;
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),

                  lineaDivisoria,
                  ListTile(
                    textColor: Colors.black,
                    leading:
                        Image.asset('assets/industriaYComercio/industria.png'),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.black),
                    onTap: () async {
                      final Uri _url = Uri.parse('https://www.sic.gov.co/');
                      await launchUrl(
                        _url,
                      );
                    },
                  ),
                  ListTile(
                    textColor: Colors.black,
                    leading:
                        const Icon(FontAwesomeIcons.list, color: Colors.black),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.black),
                    title: const Text('Politicas de privacidad'),
                    onTap: () async {
                      final Uri _url = Uri.parse(
                          'https://vacofood.com/user/politicasPrivacidad');
                      await launchUrl(
                        _url,
                      );
                    },
                  ),
                  ListTile(
                    textColor: Colors.black,
                    leading:
                        const Icon(FontAwesomeIcons.list, color: Colors.black),
                    trailing:
                        const Icon(Icons.arrow_forward, color: Colors.black),
                    title: const Text('Terminos y condiciones'),
                    onTap: () async {
                      final Uri _url = Uri.parse(
                          'https://vacofood.com/user/terminosCondiciones');
                      await launchUrl(
                        _url,
                      );
                    },
                  ),
                  lineaDivisoria,
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: Adapt.wp(85),
                      height: Adapt.hp(6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            padding: EdgeInsets.all(0),
                            primary: const Color.fromARGB(255, 255, 0, 0),
                            textStyle: TextStyle(
                                fontSize: Adapt.px(25),
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (Route<dynamic> route) => false);

                          prefs.limpiar();
                        },
                        child: Text(AppLocalizations.of(context)!.cerrarSesion,
                            style: TextStyle(
                                fontSize: Adapt.px(30),
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ), // lineaDivisoria,
                ],
              ),
            ),
          ],
        ),
        onDrawerChanged: (value) {
          if (!value && selectedIndexDrawer == 0) {
            selectedIndex = 2;

            setState(() {});
          }
        },
      ),
      onWillPop: () {
        exit(0);
      },
    ));
  }
}
