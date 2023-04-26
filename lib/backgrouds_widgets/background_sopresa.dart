import 'package:flutter/material.dart';

import '../responsive/Adapt.dart';

class BackgroundSorpresa extends StatelessWidget {
  const BackgroundSorpresa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Adapt.hp(25),
      width: Adapt.wp(100),
      decoration: const BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage("assets/backgrounds/Sopresa.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
