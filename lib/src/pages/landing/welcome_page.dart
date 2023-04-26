import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../responsive/Adapt.dart';
import '../../../responsive/Color.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      primary: ColorSelect.primaryColorVaco,
      textStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
  //estilo del botón del "unete"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/backgrounds/FondoTexturizado.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              child: myCard(),
            ),
            alignment: Alignment.center,
          ),
        ));
  }

  Widget interativeTextB(text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: TextStyle(
          fontSize: Adapt.px(20),
          color: Colors.black,
        ),
        maxLines: 2,
      ),
    );
  }

  Widget interativeTextG(text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: TextStyle(
          fontSize: Adapt.px(20),
          fontWeight: FontWeight.bold,
          color: ColorSelect.primaryColorVaco,
          fontFamily: 'Montserrat-SemiBoldItalic',
        ),
        maxLines: 2,
      ),
    );
  }

  Widget myCard() {
    final spaceBetween = SizedBox(height: Adapt.hp(2));
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: Adapt.wp(85),
        height: Adapt.hp(85),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(220),
            bottomRight: Radius.circular(220),
          ),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            spaceBetween,
            Container(
              height: Adapt.hp(18),
              child: const Image(
                image: AssetImage('assets/logos/LogoVacoBlanco.png'),
              ),
            ),
            Center(
              child: Text(
                AppLocalizations.of(context)!.saludo,
                style: TextStyle(
                  fontSize: Adapt.wp(10),
                  color: ColorSelect.primaryColorVaco,
                  fontFamily: 'Montserrat-ExtraBold',
                ),
              ),
            ),
            spaceBetween,
            interativeTextB(AppLocalizations.of(context)!.segundaLinea),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                interativeTextB(AppLocalizations.of(context)!.paraQue),
                SizedBox(
                  width: Adapt.wp(1),
                ),
                interativeTextG(
                    "${AppLocalizations.of(context)!.todosGanemos}."),
              ],
            ),
            spaceBetween,
            interativeTextB(AppLocalizations.of(context)!.cuartaLinea),
            interativeTextG(AppLocalizations.of(context)!.deliciosaComida),
            interativeTextB(AppLocalizations.of(context)!.quintaLinea),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                interativeTextB(AppLocalizations.of(context)!.sextaLinea),
                SizedBox(
                  width: Adapt.wp(1),
                ),
                interativeTextG(
                    "${AppLocalizations.of(context)!.mejorPrecio}."),
              ],
            ),
            spaceBetween,
            interativeTextB(AppLocalizations.of(context)!.septimaLinea),
            interativeTextB(AppLocalizations.of(context)!.octavaLinea),
            interativeTextB(AppLocalizations.of(context)!.novenaLinea),
            interativeTextB(AppLocalizations.of(context)!.decimaLinea),
            interativeTextG(AppLocalizations.of(context)!.undecimaLinea),
            interativeTextG(AppLocalizations.of(context)!.decimaSegundaLinea),
            spaceBetween,
            interativeTextB(AppLocalizations.of(context)!.decimaTerceraLinea),
            interativeTextB(AppLocalizations.of(context)!.decimaCuartaLinea),
            spaceBetween,
            Container(
              width: Adapt.wp(40),
              height: Adapt.hp(6),
              child: ElevatedButton(
                style: style,
                child: Text(AppLocalizations.of(context)!.unete,
                    style: TextStyle(
                        fontSize: Adapt.px(25),
                        fontFamily: 'Montserrat-ExtraBold',
                        color: Colors.black)),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
            spaceBetween,
            interativeTextB(AppLocalizations.of(context)!.decimaQuintaLinea),
            interativeTextB(AppLocalizations.of(context)!.decimaSextaLinea),
          ],
        ),
      ),
    );
  }
}

//Card que contiene la bienvenida de la apliación

