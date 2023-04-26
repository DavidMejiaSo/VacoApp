import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../../provider/promotions_provider.dart';
import '../../../service/login_service.dart';
import '../register/register_with_google_page.dart';

class GoogleloginButton extends StatefulWidget {
  GoogleloginButton({Key? key}) : super(key: key);

  @override
  State<GoogleloginButton> createState() => _GoogleloginButtonState();
}

class _GoogleloginButtonState extends State<GoogleloginButton> {
  Image imageGoogle = Image.asset(
    'assets/iconos/Google.png',
    fit: BoxFit.cover,
  );
  String _tokenLogin = '';
  final loginService = LoginService();
  // ignore: body_might_complete_normally_nullable
  static Future<User?> loginWithGoogle({required BuildContext context}) async {
    FirebaseAuth authenticator = FirebaseAuth.instance;
    User? user;
    GoogleSignIn googleSingIn = GoogleSignIn();
    GoogleSignInAccount? googleSingInAccount = await googleSingIn.signIn();
    if (googleSingInAccount != null) {
      GoogleSignInAuthentication? googleSingInAuthentication =
          await googleSingInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSingInAuthentication.accessToken,
        idToken: googleSingInAuthentication.idToken,
      );
      try {
        UserCredential userCredential =
            await authenticator.signInWithCredential(credential);
        user = userCredential.user;
        return user;
      } on FirebaseAuthException catch (AuthException) {
        print(AuthException);
      }
    }
  }

  Future logOut() async {
    GoogleSignIn googleSingIn = GoogleSignIn();
    await googleSingIn.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          User? user = await loginWithGoogle(context: context);

          if (user != null) {
            String tipoAcceso = "GOOGLE";
            dynamic respuestaLoginGoogle =
                await loginService.login(user.email!, user.uid, tipoAcceso);
            print(respuestaLoginGoogle);
            if (respuestaLoginGoogle ==
                "El usuario no puede ingresar con este tipo de acceso") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterWithGoogle(
                          email: user.email!,
                          uid: user.uid,
                          fullName: user.displayName!,
                        )),
              );
            } else {
              if (respuestaLoginGoogle is Map) {
                Navigator.pushReplacementNamed(context, '/mainScreen');

                _tokenLogin = respuestaLoginGoogle['token'];
                prefs.token = _tokenLogin;
                PromotionsProvider promocionesProvider =
                    Provider.of<PromotionsProvider>(context, listen: false);

                promocionesProvider.cargarPromociones();

                await logOut();
              }
            }
            // print('statussssss ${result.status}');
          }

          //logOut();
        },
        child: CircleAvatar(
            backgroundColor: Colors.white, backgroundImage: imageGoogle.image));
  }
}
