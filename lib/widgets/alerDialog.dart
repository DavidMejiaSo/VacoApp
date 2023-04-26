import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../responsive/Adapt.dart';
import '../responsive/Color.dart';

class AlertDialogCustom extends StatefulWidget {
  AlertDialogCustom(
      {Key? key,
      // required this.titlleText,
      required this.bodyText,
      required this.bottonAcept,
      required this.bottonCancel})
      : super(key: key);

  @override
  State<AlertDialogCustom> createState() => _AlertDialogCustomState();
  String bodyText;
  dynamic bottonAcept, bottonCancel;
}

class _AlertDialogCustomState extends State<AlertDialogCustom> {
  final ButtonStyle styleOK = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      primary: ColorSelect.primaryColorVaco,
      textStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 20,
      backgroundColor: Colors.white,
      title: Center(
          child: Text(
        AppLocalizations.of(context)!.saludo,
        style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: ColorSelect.primaryColorVaco),
      )),
      content: SizedBox(
        height: widget.bodyText.length > 50 ? Adapt.hp(11) : Adapt.hp(8),
        child: SingleChildScrollView(
          child: Center(
            child: Text(
              widget.bodyText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              maxLines: 15,
            ),
          ),
        ),
      ),
      actions: [
        widget.bottonAcept == 'false'
            ? Center(
                child: SizedBox(
                    height: Adapt.hp(6),
                    width: Adapt.wp(50),
                    child: ElevatedButton(
                        style: styleOK,
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
              )
            : Center(
                child: SizedBox(
                  height: Adapt.hp(6),
                  width: Adapt.wp(50),
                  child: widget.bottonAcept,
                ),
              ),
        SizedBox(height: Adapt.wp(2)),
        Center(
          child: SizedBox(
            height: Adapt.hp(6),
            width: Adapt.wp(50),
            child: widget.bottonCancel,
          ),
        ),
        SizedBox(
          height: widget.bodyText.length > 50 ? Adapt.hp(1) : Adapt.hp(10),
        ),
      ],
    );
  }
}
