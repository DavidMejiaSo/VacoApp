import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            curve: Curves.fastOutSlowIn,
            child: Text(
              'Ajustes',
              style: TextStyle(color: Colors.black, fontSize: 35),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            textColor: Colors.black,
            leading: const Icon(Icons.person, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Mi perfil'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading: const Icon(Icons.settings, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Ajustes de Notificaciones'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading:
                const Icon(FontAwesomeIcons.locationDot, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Direcciones'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading:
                const Icon(FontAwesomeIcons.fileLines, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Terminos y condiciones'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading: const Icon(FontAwesomeIcons.c, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Cheapit Coins'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading:
                const Icon(FontAwesomeIcons.fileLines, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Politica de privacidad'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading:
                const Icon(FontAwesomeIcons.solidComments, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Idioma'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading:
                const Icon(FontAwesomeIcons.headphones, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Centro de ayuda'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading:
                const Icon(FontAwesomeIcons.dollarSign, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Promociones'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading:
                const Icon(FontAwesomeIcons.creditCard, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Metodos de pago'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading:
                const Icon(FontAwesomeIcons.rectangleList, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Historial de pedidos'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading:
                const Icon(FontAwesomeIcons.peopleGroup, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Socio'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            textColor: Colors.black,
            leading: const Icon(FontAwesomeIcons.powerOff, color: Colors.black),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            title: const Text('Cerrar sesión'),
            onTap: () {
              Navigator.restorablePushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
