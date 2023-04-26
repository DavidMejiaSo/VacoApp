import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      primary: const Color.fromARGB(255, 197, 254, 37),
      textStyle: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black));
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        body: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/FondoPantallaBienvenido.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(children: [
          Expanded(
              child: Column(
            children: [
              myCard(),
            ],
          )),
        ]),
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
      ),
    )));
  }

  Card myCard() {
    final size = MediaQuery.of(context).size;
    const spaceBetween = SizedBox(height: 30);
    return Card(
      // Con esta propiedad modificamos la forma de nuestro card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      // Con esta propiedad agregamos margen a nuestro Card
      // El margen es la separación entre widgets o entre los bordes del widget padre e hijo
      margin: const EdgeInsets.all(15),
      // Con esta propiedad agregamos elevación a nuestro card
      // La sombra que tiene el Card aumentará
      elevation: 10,

      // La propiedad child anida un widget en su interior
      // Usamos columna para ordenar un ListTile y una fila con botones
      child: Container(
        child: Column(
          children: <Widget>[
            // Usamos ListTile para ordenar la información del card como titulo, subtitulo e icono
            Container(
              child: const Image(
                  image: AssetImage('assets/logos/LogoVacoNegro.png')),
              margin: const EdgeInsets.only(bottom: 3),
            ),

            // Usamos una fila para ordenar los botones del card
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                    child: Text(AppLocalizations.of(context)!.saludo,
                        style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 197, 254, 37)))),
                spaceBetween,
                Center(child: Text(AppLocalizations.of(context)!.segundaLinea)),
                spaceBetween,
                Center(child: Text(AppLocalizations.of(context)!.cuartaLinea)),
                Center(child: Text(AppLocalizations.of(context)!.quintaLinea)),
                Center(child: Text(AppLocalizations.of(context)!.sextaLinea)),
                spaceBetween,
                Center(child: Text(AppLocalizations.of(context)!.septimaLinea)),
                Center(child: Text(AppLocalizations.of(context)!.octavaLinea)),
                Center(child: Text(AppLocalizations.of(context)!.novenaLinea)),
                Center(child: Text(AppLocalizations.of(context)!.decimaLinea)),
                Center(
                    child: Text(AppLocalizations.of(context)!.undecimaLinea)),
                Center(
                    child:
                        Text(AppLocalizations.of(context)!.decimaSegundaLinea)),
                spaceBetween,
                Center(
                    child:
                        Text(AppLocalizations.of(context)!.decimaTerceraLinea)),
                Center(
                    child:
                        Text(AppLocalizations.of(context)!.decimaCuartaLinea)),
                spaceBetween,
                ElevatedButton(
                  style: style,
                  child: Text(AppLocalizations.of(context)!.unete,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0))),
                  onPressed: () =>
                      {Navigator.pushReplacementNamed(context, '/login')},
                ),
                Center(
                    child:
                        Text(AppLocalizations.of(context)!.decimaQuintaLinea)),
                Center(
                    child:
                        Text(AppLocalizations.of(context)!.decimaSextaLinea)),
              ],
            )
          ],
        ),
        height: size.height * 0.77,
        width: size.width * 0.7,
      ),
    );
  }
}

//Card que contiene la bienvenida de la apliación

