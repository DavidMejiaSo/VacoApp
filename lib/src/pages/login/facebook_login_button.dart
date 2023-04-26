import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

import '../../../provider/promotions_provider.dart';
import '../../../service/login_service.dart';
import '../../widgets/alert_dialog.dart';
import '../register/register_with_facebook_page.dart';

class FacebookLoginButton extends StatefulWidget {
  FacebookLoginButton({Key? key}) : super(key: key);

  @override
  State<FacebookLoginButton> createState() => _FacebookLoginButtonState();
}

class _FacebookLoginButtonState extends State<FacebookLoginButton> {
  Image imageFacebook = Image.asset(
    'assets/iconos/Facebook.png',
    fit: BoxFit.cover,
  );
  String _tokenLogin = '';
  final loginService = LoginService();

  void _login() async {
    final LoginResult result = await FacebookAuth.instance.login(permissions: [
      'email',
      'public_profile',
      'user_birthday',
      'user_gender',
      'user_location',
      'user_hometown'
    ]);

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.instance.getUserData(
          fields:
              "email,name,id,birthday,gender,location,first_name,last_name,hometown");
      String tipoAcceso = "FACEBOOK";
      dynamic respuesta = await loginService.login(
          userData['email'], userData['id'], tipoAcceso);
      print(respuesta);
      if (respuesta == "El usuario no puede ingresar con este tipo de acceso") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegisterWithFacebook(
                    email: userData['email'],
                    id: userData['id'],
                    lastName: userData['last_name'],
                    firstName: userData['first_name'],
                    gender: userData['gender'],
                  )),
        );
      } else {
        if (respuesta is Map) {
          Navigator.pushReplacementNamed(context, '/mainScreen');

          _tokenLogin = respuesta['token'];
          prefs.token = _tokenLogin;
          PromotionsProvider promocionesProvider =
              Provider.of<PromotionsProvider>(context, listen: false);

          promocionesProvider.cargarPromociones();

          await logout();
        }
      }
      // print('statussssss ${result.status}');

    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogCustom(
            bodyText: 'Lo sentimos, falló',
            bottonAcept: 'false',
            bottonCancel: Container(),
          );
        },
      );
    }
  }

  logout() async {
    await FacebookAuth.instance.logOut();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _login,
      child: CircleAvatar(
          backgroundColor: Colors.white, backgroundImage: imageFacebook.image),
    );
  }
}
