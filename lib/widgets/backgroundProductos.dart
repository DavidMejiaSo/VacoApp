import 'package:flutter/material.dart';

import '../responsive/Adapt.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Adapt.hp(25),
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Adapt.hp(5)),
          bottomRight: Radius.circular(Adapt.hp(5)),
        ),
        color: Colors.white,
        image: const DecorationImage(
          image: AssetImage("assets/backgrounds/FondoProductos.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
