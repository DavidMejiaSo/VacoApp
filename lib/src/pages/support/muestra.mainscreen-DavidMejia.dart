//import 'package:curved_navigation_bar/curved_navigation_bar.dart';
//import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:provider/provider.dart';
//import 'package:prueba_vaco_app/provider/notificationListener_provider.dart';
//import 'package:prueba_vaco_app/src/pages/location/search_restaurant_with_map.//dart';
//import 'package:prueba_vaco_app/src/pages/products/favorite_products.dart';
//import 'package:prueba_vaco_app/src/pages/profile/profile.dart';
//import 'package:prueba_vaco_app/src/pages/ratings/rating_vaco_page.dart';
//import 'package:prueba_vaco_app/src/pages/restaurant/home_shop.dart';
//import 'package:prueba_vaco_app/widgets/loadingIndicator.dart';
//import '../../../notifications/notificationPage.dart';
//import '../../../responsive/Adapt.dart';
//import '../../../responsive/Color.dart';
//import '../cart/grocery_store_cart_detail.dart';
//import '../orders/order_history_detail.dart';
//
////import '../../notifications/notificationPage.dart';
////import '../../provider/cart_provider.dart';
////import 'cart/grocery_store_cart_detail.dart';
////import 'orders/order_history_detail.dart';
////
//class MainScreenPrueba extends StatefulWidget {
//  const MainScreenPrueba({Key? key}) : super(key: key);
//
//  @override
//  State<MainScreenPrueba> createState() => _MainScreenState();
//}
//
//class Prueba extends StatelessWidget {
//  const Prueba({Key? key}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return const LoadingIndicatorW();
//  }
//}
//
//class _MainScreenState extends State<MainScreenPrueba> {
//  int selectedIndex = 2;
//  int selectedIndexDrawer = 0;
//  final _navigationKey = GlobalKey<CurvedNavigationBarState>();
//  final _scaffoldKey = GlobalKey<ScaffoldState>();
//  final PageController _pageController = PageController(initialPage: 2);
//  bool prueba = false;
//  dynamic notificationProvider;
//  dynamic activaNotificaion;
//  List<Widget> _items = [];
//
//  final _tiemsDrawe = const [
//    Prueba(),
//    ProfilePage(),
//    CartDetail(),
//    RatingVacoAsUser(),
//    OrderHistoryDetail(),
//  ];
//  @override
//  void initState() {
//    // TODO: implement initState
//    notificationProvider =
//        Provider.of<NotificationListenProvider>(context, listen: true);
//    activaNotificaion = notificationProvider.notificationNew
//        ? const ImageIcon(
//            AssetImage('assets/navigationBarIcons/campanaSiNoti.png'),
//            color: Colors.green)
//        : ImageIcon(AssetImage('assets/navigationBarIcons/campanaNoNoti.png'));
//
//    _items = [
//      const ImageIcon(
//        AssetImage('assets/navigationBarIcons/iconoMenu.png'),
//      ),
//      activaNotificaion,
//      //const ImageIcon(
//      //    AssetImage('assets/navigationBarIcons/campanaNoNoti.png')),
//      const ImageIcon(
//          AssetImage('assets/navigationBarIcons/campanaSiNoti.png')),
//      const ImageIcon(
//          AssetImage('assets/navigationBarIcons/iconoFavoritos.png')),
//    ];
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Scaffold(
//        key: _scaffoldKey,
//        body: PageView(
//            scrollDirection: Axis.horizontal,
//            controller: _pageController,
//            onPageChanged: (index) {
//              setState(() {
//                selectedIndex = index;
//              });
//            },
//            children: [
//              _tiemsDrawe[selectedIndexDrawer],
//              const notificationHome(),
//              const HomeShop(),
//              const SearchRestaurantWithMap(),
//              const FavoriteProducts(),
//            ]),
//        bottomNavigationBar: CurvedNavigationBar(
//          key: _navigationKey,
//          index: selectedIndex,
//          height: Adapt.hp(7),
//          items: _items,
//          color: Colors.white,
//          buttonBackgroundColor: Colors.white,
//          backgroundColor: ColorSelect.primaryColorVaco,
//          animationCurve: Curves.ease,
//          animationDuration: const Duration(milliseconds: 500),
//          onTap: (index) {
//            selectedIndexDrawer = 0;
//            if (index != 0) {}
//            setState(() {
//              _pageController.animateToPage(index,
//                  duration: const Duration(milliseconds: 500),
//                  curve: Curves.fastOutSlowIn);
//            });
//            if (index == 0) {
//              _scaffoldKey.currentState?.openDrawer();
//            }
//          },
//        ),
//        drawer: Drawer(
//          elevation: 0,
//          // shape:
//          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular//(20)),
//          backgroundColor: Colors.transparent,
//          child: ListView(
//            padding: EdgeInsets.zero,
//            children: <Widget>[
//              DrawerHeader(
//                curve: Curves.fastOutSlowIn,
//                child: const Text(
//                  'Ajustes',
//                  style: TextStyle(color: Colors.black, fontSize: 35),
//                ),
//                decoration: BoxDecoration(
//                  color: ColorSelect.primaryColorVaco,
//                  borderRadius: const BorderRadius.only(
//                      topRight: Radius.circular(30),
//                      bottomRight: Radius.circular(0)),
//                ),
//              ),
//              Container(
//                color: Colors.white,
//                child: ListTile(
//                  textColor: Colors.black,
//                  leading: const Icon(Icons.person, color: Colors.black),
//                  trailing:
//                      const Icon(Icons.arrow_forward, color: Colors.black),
//                  title: const Text('Mi perfil'),
//                  onTap: () {
//                    selectedIndexDrawer = 1;
//                    setState(() {});
//                    Navigator.pop(context);
//                  },
//                ),
//              ),
//              ListTile(
//                textColor: Colors.black,
//                leading: const Icon(Icons.settings, color: Colors.black),
//                trailing: const Icon(Icons.arrow_forward, color: Colors.black),
//                title: const Text('Ajustes de Notificaciones'),
//                onTap: () {
//                  selectedIndexDrawer = 2;
//                  setState(() {});
//                  Navigator.pop(context);
//                },
//              ),
//              ListTile(
//                textColor: Colors.black,
//                leading: const Icon(FontAwesomeIcons.locationDot,
//                    color: Colors.black),
//                trailing: const Icon(Icons.arrow_forward, color: Colors.black),
//                title: const Text('Direcciones'),
//                onTap: () {
//                  selectedIndexDrawer = 3;
//                  setState(() {});
//                  Navigator.pop(context);
//                },
//              ),
//              ListTile(
//                textColor: Colors.black,
//                leading:
//                    const Icon(FontAwesomeIcons.fileLines, color: Colors.//black),
//                trailing: const Icon(Icons.arrow_forward, color: Colors.black),
//                title: const Text('Terminos y condiciones'),
//                onTap: () {
//                  selectedIndexDrawer = 4;
//                  setState(() {});
//                  Navigator.pop(context);
//                },
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
//