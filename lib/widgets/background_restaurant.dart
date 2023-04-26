import 'package:flutter/material.dart';

class BackgroundRestaurant extends StatefulWidget {
  const BackgroundRestaurant({Key? key}) : super(key: key);

  @override
  State<BackgroundRestaurant> createState() => _BackgroundRestaurantState();
}

class _BackgroundRestaurantState extends State<BackgroundRestaurant> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/backgrounds/FondoRestaurantes.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}