import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

String _nombre = " ";
String _apellidos = " ";
String _email = " ";
String _telefono = " ";
bool _mostrarPassword = true;
String _password = " ";

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _inputFieldDateController =
      TextEditingController();
  static const spaceBetween = SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    const spaceBetweenWidth = SizedBox(width: 20);
    final ButtonStyle style = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        primary: const Color.fromARGB(255, 197, 254, 37),
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
    final ButtonStyle style2 = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        primary: const Color.fromARGB(255, 254, 37, 37),
        textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.only(top: 100.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(39, 206, 215, 218), spreadRadius: 3),
            ],
          ),
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: <Widget>[
              nombreInput(context),
              spaceBetween,
              apellidosInput(context),
              spaceBetween,
              emailInput(context),
              spaceBetween,
              telefonoInput(context),
              spaceBetween,
              passwordInput(context),
              spaceBetween,
              ConfirmpasswordInput(context),
              spaceBetween,
              Container(
                padding: const EdgeInsets.only(top: 30, left: 45, right: 50),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: style,
                      child: Text(AppLocalizations.of(context)!.registrate,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0))),
                      onPressed: () => {},
                    ),
                    spaceBetweenWidth,
                    ElevatedButton(
                      style: style2,
                      child: Text(AppLocalizations.of(context)!.cancelar,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0))),
                      onPressed: () =>
                          {Navigator.pushReplacementNamed(context, '/login')},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/FondoLogin.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ));
  }
}

Widget nombreInput(BuildContext context) {
  return TextFormField(
    //keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        label: Text(AppLocalizations.of(context)!.nombreUsuario),
        suffixIcon: const Icon(
          Icons.account_circle,
        )),
    onChanged: (value) {
      _nombre = value;
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

Widget apellidosInput(context) {
  return TextFormField(
    //keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        label: Text(AppLocalizations.of(context)!.apellidoUsuario),
        suffixIcon: const Icon(
          Icons.account_circle,
        )),
    onChanged: (value) {
      _apellidos = value;
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

Widget emailInput(context) {
  return TextFormField(
    //keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        label: Text(AppLocalizations.of(context)!.correo),
        suffixIcon: const Icon(
          Icons.email,
        )),
    onChanged: (value) {
      _email = value;
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

Widget telefonoInput(context) {
  return TextFormField(
    //keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        label: Text(AppLocalizations.of(context)!.telefono),
        suffixIcon: const Icon(
          Icons.phone,
        )),
    onChanged: (value) {
      _telefono = value;
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

Widget passwordInput(context) {
  return TextFormField(
    obscureText: _mostrarPassword == true ? true : false,
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        label: Text(AppLocalizations.of(context)!.clave),
        suffixIcon: InkWell(
          onTap: () {
            _mostrarPassword = !_mostrarPassword;
            //setState(() {});
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

Widget ConfirmpasswordInput(context) {
  return TextFormField(
    obscureText: _mostrarPassword == true ? true : false,
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        label: Text(AppLocalizations.of(context)!.confirmarClave),
        suffixIcon: InkWell(
          onTap: () {
            _mostrarPassword = !_mostrarPassword;
            //setState(() {});
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
