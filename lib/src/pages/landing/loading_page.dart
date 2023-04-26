import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../preferences/preferences_user.dart';
import '../../../provider/promotions_provider.dart';
import '../../../responsive/Color.dart';
import '../../../service/login_service.dart';
import '../main_screen.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class PantallaCarga extends StatefulWidget {
  const PantallaCarga({Key? key}) : super(key: key);

  @override
  State<PantallaCarga> createState() => _PantallaCargaState();
}

final prefs = PreferenciasUsuario();

class _PantallaCargaState extends State<PantallaCarga> {
  final loginService = LoginService();
  dynamic recargarToken;
  String validaToken = "";
  dynamic r;
  bool validarTokken = false;
  @override
  void initState() {
    validarToken();
    super.initState();
  }

  void validarToken() async {
    validaToken = await loginService.checkToken();

    if (validaToken.contains('token is expired')) {
      _recargarToken();
    } else {
      promocionesProvider.cargarPromociones();

      validarTokken = true;
      setState(() {});
    }
  }

  void _recargarToken() async {
    try {
      recargarToken = await loginService.reloadToken();
      Future.delayed(const Duration(seconds: 1), () {});
      setState(() {
        prefs.token;
        prefs.usuario;
        validarTokken = true;
        print(
            'ln 51 loading page token: ${prefs.token} usuario ${prefs.usuario} ');
        promocionesProvider.cargarPromociones();
      });
    } catch (e) {
      print('error refrescando el token $e');
    }
  }

  dynamic promocionesProvider;

  @override
  Widget build(BuildContext context) {
    promocionesProvider =
        Provider.of<PromotionsProvider>(context, listen: true);

    return validarTokken == false
        ? AnimatedSplashScreen(
            splash: 'assets/logos/LogoVaco.png',
            nextScreen: const MainScreen(),
            splashTransition: SplashTransition.scaleTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: ColorSelect.primaryColorVaco,
          )
        : const MainScreen();
  }
}
