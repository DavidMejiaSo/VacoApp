import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../responsive/Adapt.dart';
import '../responsive/Color.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

int selectedIndex = 2;

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: selectedIndex,
      height: Adapt.hp(7),
      items: [
        Icon(
          Icons.menu,
          size: Adapt.px(35),
          color: ColorSelect.greyColor,
        ),
        Icon(
          Icons.chat,
          size: Adapt.px(35),
          color: ColorSelect.greyColor,
        ),
        Icon(
          Icons.home,
          size: Adapt.px(35),
          color: ColorSelect.greyColor,
        ),
        Stack(
          children: [
            Icon(
              Icons.location_on,
              size: Adapt.px(35),
              color: ColorSelect.greyColor,
            ),
            Icon(
              Icons.circle,
              size: Adapt.px(15),
              color: Colors.amber,
            ),
          ],
        ),
        Icon(
          FontAwesomeIcons.heart,
          size: Adapt.px(35),
          color: ColorSelect.greyColor,
        ),
      ],
      color: Colors.white,
      buttonBackgroundColor: Colors.white,
      backgroundColor: ColorSelect.primaryColorVaco,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(seconds: 1),
      onTap: onItemTapped,
    );
  }

  void onItemTapped(int index) {
    final snackBar = SnackBar(
      content: const Text("Tienes una opinion de Vaco? ¡Házla saber!",
          style: TextStyle(color: Colors.black)),
      backgroundColor: ColorSelect.primaryColorVaco,
      action: SnackBarAction(
        label: "Aquí",
        textColor: const Color.fromARGB(255, 10, 10, 10),
        onPressed: () {
          Navigator.pushNamed(context, '/ratingVaco');
        },
      ),
    );
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/searchRestaurantWithMap');
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }

    if (index == 1) {
      Navigator.pushNamed(context, '/orderHistory');
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    if (index == 2) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/homeShop', (Route<dynamic> route) => false);

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }

    if (index == 3) {
      Navigator.pushReplacementNamed(context, '/favoriteProducts');
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }

    if (index == 4) {
      Navigator.pushReplacementNamed(context, '/profile');

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }

    setState(() {
      selectedIndex = index;
    });
  }
}
