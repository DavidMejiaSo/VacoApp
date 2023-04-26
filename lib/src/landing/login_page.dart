import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/service/login_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  final prefs = PreferenciasUsuario();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _check = prefs.check;
    _usuario = prefs.usuario;
    _password = prefs.password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cuerpo(context),
    );
  }

  Widget _cuerpo(BuildContext context) {
    return Stack(
      children: [_fondo(), _logos(context), _login(context)],
    );
  }

  Widget _login(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(178, 15, 15, 15),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20.0),
                // boxShadow: [
                //   BoxShadow(
                //       color: Colors.grey,
                //       blurRadius: size.height * 0.003,
                //       spreadRadius: size.height * 0.001)
                // ]
              ),
              margin: const EdgeInsets.only(top: 220.0),
              height: size.height * 0.57,
              width: size.width * 0.7,
              child: _accesorios(context),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 270.0),
            //   height: size.height * 0.4,
            //   width: size.width * 0.7,
            //   child: Card(
            //     elevation: 10.0,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _accesorios(BuildContext context) {
    const spaceBetweenWidth = SizedBox(width: 20);
    const spaceBetweenHeight = SizedBox(height: 20);
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _usuarioText(context),
            const SizedBox(
              height: 10.0,
            ),
            _passwordText(context),
            const SizedBox(
              height: 10.0,
            ),
            Text(AppLocalizations.of(context)!.recuperarClave),
            _checkRecordarCredenciales(context),
            const SizedBox(
              height: 10.0,
            ),
            _botonIngresaar(),
            spaceBetweenHeight,
            Text(AppLocalizations.of(context)!.ingreseO),
            spaceBetweenHeight,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _botonIngresarGmail(),
                spaceBetweenWidth,
                _botonIngresarFacebook(),
                spaceBetweenWidth,
                _botonIngresarOutlook(),
              ],
            ),
            spaceBetweenHeight,
            _botonRegistrarse(),
          ],
        ),
      ),
    );
  }

  Widget _usuarioText(BuildContext context) {
    return TextFormField(
      //keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        label: Text(AppLocalizations.of(context)!.usuario),
      ),
      onChanged: (value) {
        _usuario = value;
      },
      validator: (valor) {
        if (valor == '') {
          return 'El campo es obligatorio *';
        } else {
          return null;
        }
      },
    );
  }

  Widget _checkRecordarCredenciales(BuildContext context) {
    return CheckboxListTile(
        title: Text(AppLocalizations.of(context)!.aceptoTerminos,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            )),
        value: _check,
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
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        primary: const Color.fromARGB(255, 197, 254, 37),
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
    return ElevatedButton(
      style: style,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          _ingresar();
        }
      },
      child: Text(AppLocalizations.of(context)!.ingrese,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0))),
    );
  }

  void _ingresar() async {
    _usuario = "hola";
    _password = "epad";
    final loginService = LoginService();

    Map<String, dynamic>? respuesta =
        await loginService.login(_usuario, _password, "prueba");

    if (_check) {
      prefs.usuario = _usuario;
      prefs.password = _password;
      prefs.check = _check;
    } else {
      prefs.usuario = '';
      prefs.password = '';
      prefs.check = false;
    }

    if (respuesta?['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      // mensaje error
    }
  }

  Widget _passwordText(BuildContext context) {
    return TextFormField(
      obscureText: _mostrarPassword == true ? true : false,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          label: Text(AppLocalizations.of(context)!.clave),
          suffixIcon: InkWell(
            onTap: () {
              _mostrarPassword = !_mostrarPassword;
              setState(() {});
            },
            child: Icon(
              _mostrarPassword == true ? Icons.lock : Icons.lock_open,
            ),
          )),
      onChanged: (value) {
        _password = value;
      },
      validator: (valor) {
        if (valor == '') {
          return 'El campo es obligatorio *';
        } else {
          return null;
        }
      },
    );
  }

  Widget _logos(BuildContext context) {
    const spaceBetween = SizedBox(height: 20);
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 5.0),
        child: Center(
          child: Column(
            children: [
              const CircleAvatar(
                  radius: 60.0,
                  backgroundImage: NetworkImage(
                      'https://i.pinimg.com/236x/e9/57/2a/e9572a70726980ed5445c02e1058760b.jpg')),
              spaceBetween,
              Text(AppLocalizations.of(context)!.crearCuenta,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _fondo() {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/backgrounds/FondoLogin.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _botonIngresarGmail() {
    final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      primary: const Color.fromARGB(255, 48, 49, 48),
    );
    return ElevatedButton(
      style: style,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          _ingresar();
        }
      },
      child: const Icon(Icons.email),
    );
  }

  Widget _botonIngresarOutlook() {
    final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      primary: const Color.fromARGB(255, 48, 49, 48),
    );
    return ElevatedButton(
      style: style,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          _ingresar();
        }
      },
      child: const Icon(Icons.outgoing_mail),
    );
  }

  Widget _botonIngresarFacebook() {
    final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      primary: const Color.fromARGB(255, 48, 49, 48),
    );
    return ElevatedButton(
      style: style,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          _ingresar();
        }
      },
      child: const Icon(Icons.facebook),
    );
  }

  Widget _botonRegistrarse() {
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        primary: const Color.fromARGB(255, 197, 254, 37),
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
    return ElevatedButton(
      style: style,
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/register');
      },
      child: Text(AppLocalizations.of(context)!.registrate,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0))),
    );
  }
}
