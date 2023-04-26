import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/responsive/Adapt.dart';
import 'package:prueba_vaco_app/service/favorite_products_service.dart';

class AllergyAlertImage extends StatefulWidget {
  AllergyAlertImage({Key? key, required this.idAlergia}) : super(key: key);

  @override
  State<AllergyAlertImage> createState() => _iconAlertState();
  List idAlergia = [];
}

class _iconAlertState extends State<AllergyAlertImage> {
  bool mostrarAlertaAlergia = false;
  List listAlergiaCliente = [];
  @override
  void initState() {
    traerAlergiaCliente();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < listAlergiaCliente.length; i++) {
      for (var j = 0; j < widget.idAlergia.length; j++) {
        //print('${listAlergiaCliente[i]} == ${widget.idAlergia[j]}');
        if ('${listAlergiaCliente[i]}' == widget.idAlergia[j]) {
          mostrarAlertaAlergia = true;
          setState(() {});
        }
      }
    }

    return Visibility(
      visible: mostrarAlertaAlergia,
      child: Container(
        //alignment: Alignment.bottomRight,
        child: ClipRRect(
          child: Image.asset(
            "assets/alertAlergyIcon/alertAlergyIcon.png",
            height: Adapt.hp(5),
            width: Adapt.wp(35),
          ),
        ),
      ),
    );
  }

  void traerAlergiaCliente() async {
    final traerUsuario = FavoriteProductsService();
    dynamic respuesta = await traerUsuario.traer();
    try {
      if (respuesta is Map) {
        listAlergiaCliente = respuesta["idAlergias"];
      }
    } catch (e) {
      print("Error: en linea 671 grocery porducts " + e.toString());
    }
    setState(() {});
  }
}
