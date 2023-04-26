// ignore_for_file: deprecated_member_use, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/service/recovery_passsword_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';
import '../../widgets/alert_dialog.dart';
import '../../../backgrouds_widgets/backgroud_app.dart';

class RecoveryPassword extends StatefulWidget {
  static const spaceBetween = SizedBox(height: 30);

  const RecoveryPassword({Key? key}) : super(key: key);
  @override
  State<RecoveryPassword> createState() => RecoveryPasswordState();
}

class RecoveryPasswordState extends State<RecoveryPassword> {
  static const spaceBetween = SizedBox(height: 30);

  final getEmail = TextEditingController();
  String _email = '';

  final prefs = PreferenciasUsuario();

  final formKey = GlobalKey<FormState>();
  final borderOK = OutlineInputBorder(
    borderSide: BorderSide(color: ColorSelect.greyColor, width: 1.0),
    borderRadius: BorderRadius.circular(30.0),
  );
  final borderWrong = OutlineInputBorder(
    borderSide:
        const BorderSide(color: Color.fromARGB(255, 255, 0, 0), width: 1.0),
    borderRadius: BorderRadius.circular(30.0),
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            BackgroundApp(),
            _body(),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Center(
          child: Column(
        children: [
          SizedBox(height: Adapt.hp(3)),
          Row(
            children: [
              SizedBox(width: Adapt.wp(8)),
              butttonGetBack(),
              _logoVaco(),
            ],
          ),
          SizedBox(height: Adapt.hp(15)),
          Container(
            alignment: Alignment.center,
            child:
                Text(AppLocalizations.of(context)!.recuperarClave.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    )),
          ),
          SizedBox(height: Adapt.hp(5)),
          recoveryPassword(),
          SizedBox(height: Adapt.hp(5)),
          _botonRecuperar(),
        ],
      )),
    );
  }

  Widget butttonGetBack() {
    return FloatingActionButton(
        backgroundColor: ColorSelect.primaryColorVaco,
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: const Icon(Icons.arrow_back, size: 30, color: Colors.white));
  }

  Widget _logoVaco() {
    return SizedBox(
      width: Adapt.wp(50),
      child: const Image(
        image: AssetImage('assets/logos/LogoVaco.png'),
      ),
    );
  }

  Widget recoveryPassword() {
    return Container(
      width: Adapt.wp(90),
      child: TextFormField(
          controller: getEmail,
          onChanged: (valor) {
            _email = valor;
          },
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            enabledBorder: borderOK,
            disabledBorder: borderOK,
            focusedBorder: borderOK,
            errorBorder: borderWrong,
            focusedErrorBorder: borderWrong,
            label: Text(
              AppLocalizations.of(context)!.correo.toUpperCase(),
              style: const TextStyle(color: Colors.black),
            ),
            labelStyle: const TextStyle(color: Colors.black),
          )),
    );
  }

  Widget _botonRecuperar() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        primary: ColorSelect.primaryColorVaco,
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white));

    return Container(
      width: Adapt.wp(50),
      child: ElevatedButton(
        style: style,
        onPressed: () async {
          final respuesta = await PasswordService().get(_email);
          if (respuesta == "mongo: no documents in result") {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogCustom(
                    bodyText: AppLocalizations.of(context)!.emailMalo,
                    bottonAcept: 'false',
                    bottonCancel: Container(),
                  );
                });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogCustom(
                    bodyText: AppLocalizations.of(context)!.emailOk,
                    bottonAcept: ElevatedButton(
                      style: style,
                      child: Text(AppLocalizations.of(context)!.aceptar,
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      onPressed: () {
                        getEmail.text = "";
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (Route<dynamic> route) => false);
                      },
                    ),
                    bottonCancel: Container(),
                  );
                });
          }
        },
        child: Text(AppLocalizations.of(context)!.enviar.toUpperCase(),
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
    );
  }
}
