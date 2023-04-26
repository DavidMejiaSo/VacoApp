import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/provider/global_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prueba_vaco_app/src/pages/main_screen.dart';
import 'package:prueba_vaco_app/src/pages/restaurant/home_shop_more_supermercados.dart';
import 'package:prueba_vaco_app/src/pages/cart/grocery_store_cart_detail.dart';

import 'package:prueba_vaco_app/src/pages/ratings/rating_restaurant_page.dart';
import 'package:prueba_vaco_app/src/pages/login/login_page.dart';
import 'package:prueba_vaco_app/src/pages/landing/recovery_password.dart';
import 'package:prueba_vaco_app/src/pages/register/register_page.dart';
import 'package:prueba_vaco_app/src/pages/landing/welcome_page.dart';
import 'package:prueba_vaco_app/src/pages/orders/order_status.dart';
import 'package:prueba_vaco_app/src/pages/products/bag_detail.dart';
import 'package:prueba_vaco_app/src/pages/products/favorite_products.dart';
import 'package:prueba_vaco_app/src/pages/products/grocery_product_cart_edit.dart';
import 'package:prueba_vaco_app/src/pages/restaurant/home_shop.dart';
import 'package:prueba_vaco_app/src/pages/restaurant/home_shop_more_restaurantes.dart';
import '../provider/cart_shop_provider.dart';
import '../provider/location_provider.dart';
import '../provider/promotions_provider.dart';
import '../responsive/Color.dart';
import '../src/pages/cart/payment_method.dart';
import '../src/pages/location/home_list_location.dart';
import '../src/pages/location/search_restaurant_with_map.dart';
import '../src/pages/location/add_new_location_detail.dart';
import '../src/pages/location/add_new_location_map.dart';
import '../src/pages/landing/loading_page.dart';
import '../src/pages/notifications/notification_page.dart';
import '../src/pages/orders/order_hisotorial.dart';
import '../src/pages/orders/order_history_detail.dart';
import '../src/pages/products/grocery_products_list.dart';
import '../src/pages/profile/profile.dart';
import '../src/pages/ratings/rating_vaco_page.dart';
import '../src/pages/support/support_page.dart';

class Routes extends StatefulWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  final prefs = PreferenciasUsuario();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    print("Este es el token ${prefs.token}");

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = const IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings);
    super.initState();
  }

  showNotification() async {
    var android = const AndroidNotificationDetails('channel id', 'channel NAME',
        priority: Priority.high, importance: Importance.max);
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'New Video is out', 'Flutter Local Notification', platform,
        payload: 'Nitish Kumar Singh is part time Youtuber');
  }

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  ///

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<PromotionsProvider>(
            create: (_) => PromotionsProvider(),
          ),
          ChangeNotifierProvider<GlobalProvider>(
            create: (_) => GlobalProvider(),
          ),
          ChangeNotifierProvider<LocationProvider>(
            create: (_) => LocationProvider(),
          ),
          ChangeNotifierProvider<CarritoComprasProvider>(
            create: (_) => CarritoComprasProvider(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', ''), // Spanish, no country code
            Locale('en', ''), // English, no country code
          ],
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor: ColorSelect.primaryColorVaco,
            // Define the default font family.
            fontFamily: 'Montserrat-Regular',
            // Define the default TextTheme. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 43.0, fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 24.0),
              bodyText2:
                  TextStyle(fontSize: 14.0, fontFamily: 'Montserrat-Regular'),
            ),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: ColorSelect.primaryColorVaco),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: prefs.token == "" ? '/' : '/pantallaCarga',
          routes: {
            '/': (context) => const WelcomePage(),
            '/login': (context) => const LoginPage(),
            '/recoveryPassword': (context) => const RecoveryPassword(),
            '/mainScreen': (context) => const MainScreen(),
            '/selectPayment': (context) => const PaymentMethod(),
            // registro
            '/register': (context) => const RegisterPage(),
            // fin registro

            // vista principal de la tienda
            '/homeShop': (context) => const HomeShop(),
            '/homeShopMore': (context) => const HomeShopMore(),
            '/homeShopSupermercado': (context) => const HomeShopMoreSuper(),
            // fin vista principal de la tienda

            // productos
            '/favoriteProducts': (context) => const FavoriteProducts(),
            '/vistaProducto': (context) => const GroceryProductsList(),
            '/editProduct': (context) => const ProductEditCart(),
            '/cart': (context) => const CartDetail(),
            // fin productos

            '/profile': (context) => const ProfilePage(),
            '/ratingRestaurant': (context) => const RatingRestaurantAsUser(),
            '/ratingVaco': (context) => const RatingVacoAsUser(),
            '/detailOrder': (context) => const OrderStatus(),
            '/orderHistory': (context) => const OrderHistory(),
            '/orderHistoryDetail': (context) => const OrderHistoryDetail(),

            // ubicaciones
            '/listLocations': (context) => const HomeListLocation(),
            '/newLocationDetails': (context) => NewLocationDetail(),
            '/addNewLocationMap': (context) => const AddNewLocationMap(),
            '/searchRestaurantWithMap': (context) =>
                const SearchRestaurantWithMap(),

            //notificaciones
            '/notificationPage': (context) => const NotificacionHome(),

            // fin ubicaciones

            '/pantallaCarga': (context) => const PantallaCarga(),
            '/bagDetail': (context) => const BagDetail(),

            '/supportPage': (context) => const SupportPage(),
          },
        ));
  }
}
