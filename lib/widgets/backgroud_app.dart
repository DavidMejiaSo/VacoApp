import 'package:flutter/material.dart';

class BackgroundApp extends StatefulWidget {
  BackgroundApp({Key? key}) : super(key: key);

  @override
  State<BackgroundApp> createState() => _BackgroundAppState();
}

class _BackgroundAppState extends State<BackgroundApp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/backgrounds/FondoApp.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
