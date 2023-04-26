import 'package:flutter/material.dart';

import '../responsive/Adapt.dart';
import '../responsive/Color.dart';

class ElevatedButtonCustom extends StatefulWidget {
  ElevatedButtonCustom({
    Key? key,
    required this.textButton,
    required this.onPressedAction,
  }) : super(key: key);

  @override
  State<ElevatedButtonCustom> createState() => _ElevatedButtonCustomState();
  String textButton;
  VoidCallback onPressedAction;
}

class _ElevatedButtonCustomState extends State<ElevatedButtonCustom> {
  final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      //padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      primary: ColorSelect.primaryColorVaco,
      textStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Adapt.wp(45),
      child: ElevatedButton(
        style: style,
        child: Text(
          widget.textButton.toUpperCase(),
          style: const TextStyle(
              fontFamily: 'Montserrat-ExtraBold',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        onPressed: widget.onPressedAction,
      ),
    );
  }
}
