// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/login_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prueba_vaco_app/src/pages/login/facebook_login_button.dart';
import '../../../backgrouds_widgets/backgroundShop.dart';
import '../../../provider/promotions_provider.dart';
import '../../../responsive/Color.dart';
import '../../widgets/alert_dialog.dart';
import 'google_login_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _check = false;
  bool _mostrarPassword = true;

  String _usuario = '';
  String _password = '';
  String _tokenLogin = '';

  int _validarUser = 0;
  int _validarPassword = 0;

  final prefs = PreferenciasUsuario();
  final loginService = LoginService();
  final formKey = GlobalKey<FormState>();
  final outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorSelect.greyColor,
    ),
    borderRadius: BorderRadius.circular(30),
  );
  final outlineInputBorderRed = OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.red),
    borderRadius: BorderRadius.circular(30),
  );
  final ButtonStyle style = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    primary: ColorSelect.primaryColorVaco,
    textStyle: const TextStyle(
      fontSize: 24,
      fontFamily: 'Montserrat-Regular',
      color: Colors.white,
    ),
  );
  @override
  void initState() {
    _usuario = prefs.usuario;
    _password = prefs.password;
    _tokenLogin = prefs.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _head(context),
      ),
    );
  }

  Widget _head(BuildContext context) {
    return Stack(
      children: [const BackgroundShop(), _logos(context), _body(context)],
    );
  }

  Widget _body(BuildContext context) {
    const spaceBetweenWidth = SizedBox(width: 20);
    const spaceBetweenHeight = SizedBox(height: 20);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(18.0),
        margin: const EdgeInsets.only(top: 170.0),
        height: Adapt.hp(75),
        width: Adapt.wp(90),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                spaceBetweenHeight,
                _usuarioText(context),
                spaceBetweenHeight,
                _passwordText(context),
                buttonRecoveryPassword(),
                _checkRecordarCredenciales(context),
                spaceBetweenHeight,
                _botonIngresaar(),
                spaceBetweenHeight,
                Text(
                  AppLocalizations.of(context)!.ingreseO,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                spaceBetweenHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FacebookLoginButton(),
                    spaceBetweenWidth,
                    GoogleloginButton(),
                    spaceBetweenWidth,
                    _botonIngresarInstagram(),
                  ],
                ),
                spaceBetweenHeight,
                spaceBetweenHeight,
                _botonRegistrarse()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _usuarioText(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      maxLength: 50,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        counterText: "",
        enabledBorder: outlineInputBorder,
        disabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        errorBorder: outlineInputBorderRed,
        focusedErrorBorder: outlineInputBorderRed,
        label: Text(
          AppLocalizations.of(context)!.usuario,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        labelStyle: const TextStyle(color: Colors.black),
      ),
      onChanged: (value) {
        _usuario = value;
        _validarUser = _usuario.indexOf('@');
      },
      validator: (valor) {
        if (valor == '') {
          return 'El campo es obligatorio *';
        } else {
          if (_validarUser < 0) {
            return 'El correo no es un correo valido*';
          } else {
            return null;
          }
        }
      },
    );
  }

  Widget _passwordText(BuildContext context) {
    return TextFormField(
      maxLength: 14,
      style: const TextStyle(color: Colors.black),
      obscureText: _mostrarPassword == true ? true : false,
      decoration: InputDecoration(
          counterText: "",
          enabledBorder: outlineInputBorder,
          disabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          errorBorder: outlineInputBorderRed,
          focusedErrorBorder: outlineInputBorderRed,
          label: Text(
            AppLocalizations.of(context)!.clave,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          suffixIcon: InkWell(
            onTap: () {
              _mostrarPassword = !_mostrarPassword;
              setState(() {});
            },
            child: Icon(
              _mostrarPassword == true ? Icons.lock : Icons.lock_open,
              color: ColorSelect.greyColor,
            ),
          )),
      onChanged: (value) {
        _password = value;
        _validarPassword = _password.length;
      },
      validator: (valor) {
        if (valor == '') {
          return 'El campo es obligatorio *';
        } else {
          if (_validarPassword < 8) {
            return 'La clave debe tener al menos 8 caracteres';
          } else {
            return null;
          }
        }
      },
    );
  }

  Widget _checkRecordarCredenciales(BuildContext context) {
    return CheckboxListTile(
        value: _check,
        side: BorderSide(color: ColorSelect.primaryColorVaco, width: 1.5),
        activeColor: ColorSelect.primaryColorVaco,
        checkColor: ColorSelect.primaryColorVaco,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(AppLocalizations.of(context)!.aceptoTerminos,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 11,
            )),
        onChanged: (valor) {
          _check = valor!;

          if (_check) {
            prefs.usuario = _usuario;
            prefs.password = _password;
            prefs.check = _check;
          } else {
            prefs.usuario = '';
            prefs.password = '';
            prefs.check = false;
          }

          setState(() {});
        });
  }

  Widget _botonIngresaar() {
    return SizedBox(
      width: Adapt.wp(50),
      child: ElevatedButton(
        style: style,
        child: Text(AppLocalizations.of(context)!.ingrese,
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Montserrat-ExtraBold',
                color: Colors.black)),
        onPressed: () => {
          if (formKey.currentState!.validate())
            {
              if (_check == true)
                {
                  _ingresar(),
                }
              else
                {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialogCustom(
                        bodyText: "Por favor acepta los terminos y condiciones",
                        bottonAcept: 'false',
                        bottonCancel: Container(),
                      );
                    },
                  ),
                }
            }
        },
      ),
    );
  }

  Widget _logos(BuildContext context) {
    const spaceBetween = SizedBox(height: 20);
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 20.0),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                child: Image(
                  height: Adapt.hp(7),
                  image: const AssetImage('assets/logos/icono.png'),
                ),
                radius: 50,
                backgroundColor: Colors.white,
              ),
              spaceBetween,
              Text(
                AppLocalizations.of(context)!.iniciarSesion,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Adapt.px(50),
                  fontFamily: 'Montserrat-ExtraBold',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonIngresarInstagram() {
    Image imageInstagram = Image.asset(
      'assets/iconos/Instagram.png',
      fit: BoxFit.cover,
    );
    return Flexible(
      flex: 1,
      child: GestureDetector(
        onTap: () {},
        child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: imageInstagram.image),
      ),
    );
  }

  Widget _botonRegistrarse() {
    return SizedBox(
      width: Adapt.wp(50),
      child: ElevatedButton(
        style: style,
        child: Text(AppLocalizations.of(context)!.registrate,
            style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Montserrat-ExtraBold',
                color: Colors.black)),
        onPressed: () => {Navigator.pushReplacementNamed(context, '/register')},
      ),
    );
  }

  Widget buttonRecoveryPassword() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/recoveryPassword');
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          AppLocalizations.of(context)!.recuperarClave,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _ingresar() async {
    String tipoAcceso = "CORREO";
    dynamic respuesta =
        await loginService.login(_usuario, _password, tipoAcceso);
    print(respuesta);
    if (respuesta == "El usuario no puede ingresar con este tipo de acceso") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogCustom(
              bodyText: AppLocalizations.of(context)!.correoClaveMala,
              bottonAcept: 'false',
              bottonCancel: Container(),
            );
          });
    } else if (respuesta == "Usuario inactivo") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialogCustom(
              bodyText:
                  "por favor ingrese a su correo electronico asosciado a la cuenta para activarla",
              bottonAcept: 'false',
              bottonCancel: Container(),
            );
          });
    } else {
      if (respuesta is Map) {
        Navigator.pushReplacementNamed(context, '/mainScreen');

        _tokenLogin = respuesta['token'];
        prefs.token = _tokenLogin;
        PromotionsProvider promocionesProvider =
            Provider.of<PromotionsProvider>(context, listen: false);

        promocionesProvider.cargarPromociones();
      }
    }
  }
}
