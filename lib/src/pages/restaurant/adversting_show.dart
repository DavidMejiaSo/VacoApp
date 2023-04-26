import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/src/pages/advertising/adversiting_home.dart';

class AdverstingShow extends StatefulWidget {
  const AdverstingShow({Key? key}) : super(key: key);

  @override
  State<AdverstingShow> createState() => _AdverstingShowState();
}

class _AdverstingShowState extends State<AdverstingShow> {
  @override
  Widget build(BuildContext context) {
    return const AdverstingHome();
  }
}