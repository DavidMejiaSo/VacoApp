import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../responsive/Adapt.dart';
import '../../responsive/Color.dart';

class AlertaRestauranteCerrado extends StatelessWidget {
  const AlertaRestauranteCerrado({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 20,
      backgroundColor: Colors.white,
      title: Center(
          child: Text(
        AppLocalizations.of(context)!.saludo,
        style: TextStyle(fontSize: 36, color: ColorSelect.primaryColorVaco),
      )),
      content: SizedBox(
        height: Adapt.hp(6),
        child: Center(
          child: Text(
            'Comercio cerrado',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
            maxLines: 15,
          ),
        ),
      ),
      actions: [
        Center(
          child: SizedBox(
              height: Adapt.hp(7),
              width: Adapt.wp(55),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      primary: ColorSelect.primaryColorVaco,
                      textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  child: Text(
                    AppLocalizations.of(context)!.aceptar,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })),
        ),
        SizedBox(
          height: Adapt.hp(1),
        )
      ],
    );
  }
}
