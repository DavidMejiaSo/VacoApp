import 'package:flutter/material.dart';

class BackgroundShop extends StatelessWidget {
  const BackgroundShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/backgrounds/FondoInicio.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
