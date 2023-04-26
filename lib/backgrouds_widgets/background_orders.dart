import 'package:flutter/material.dart';

class BackgroundOrder extends StatefulWidget {
  const BackgroundOrder({Key? key}) : super(key: key);

  @override
  State<BackgroundOrder> createState() => _BackgroundOrderState();
}

class _BackgroundOrderState extends State<BackgroundOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/backgrounds/FondoShop.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}