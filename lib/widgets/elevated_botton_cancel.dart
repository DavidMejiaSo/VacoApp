import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../responsive/Adapt.dart';

class ElevatedButtonCancelCustom extends StatefulWidget {
  ElevatedButtonCancelCustom({
    Key? key,
  }) : super(key: key);

  @override
  State<ElevatedButtonCancelCustom> createState() =>
      _ElevatedButtonCancelCustomState();
}

class _ElevatedButtonCancelCustomState
    extends State<ElevatedButtonCancelCustom> {
  final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      primary: const Color.fromARGB(255, 255, 0, 0),
      textStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: Adapt.hp(10),
        width: Adapt.wp(50),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                primary: const Color.fromARGB(255, 255, 0, 0),
                textStyle: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 0, 0))),
            child: Text(
              AppLocalizations.of(context)!.cancelar,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }));
  }
}
