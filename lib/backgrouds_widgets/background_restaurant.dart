import 'package:flutter/material.dart';

import '../responsive/Adapt.dart';

class BackgroundRestaurant extends StatelessWidget {
  const BackgroundRestaurant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Adapt.hp(10),
      width: Adapt.wp(100),
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/backgrounds/FondoDirecciones.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
