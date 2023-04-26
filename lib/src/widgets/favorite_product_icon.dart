import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/preferences/preferences_user.dart';
import 'package:prueba_vaco_app/service/favorite_products_service.dart';

import '/responsive/Adapt.dart';

class FavoriteProductButton extends StatefulWidget {
  const FavoriteProductButton({
    Key? key,
    required this.numberid,
  });

  @override
  State<FavoriteProductButton> createState() => _FavoritoState();
  final String numberid;
}

class _FavoritoState extends State<FavoriteProductButton> {
  final favoriteProducService = FavoriteProductsService();
  bool estadoBotonLike = false;
  final prefs = PreferenciasUsuario();

  List productosFavoritos = [];

  List posiblesAlergiasRestaurante = [];
  @override
  void initState() {
    super.initState();
    traerlistadefavoritos();
  }

  @override
  Widget build(BuildContext context) {
    Image imageFavorito = Image.asset(
      'assets/botones/BotonFavoritos.png',
      fit: BoxFit.cover,
    );
    Image imagenNoFavorito = Image.asset(
      'assets/botones/BotonNoFavoritos.png',
      fit: BoxFit.cover,
    );
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          if (estadoBotonLike == false) {
            setState(() {
              agregarProducto();

              estadoBotonLike = !estadoBotonLike;
            });
          } else {
            setState(() {
              eliminarProducto();
              estadoBotonLike = !estadoBotonLike;
            });
          }
        },
        child: Container(
          width: Adapt.wp(12),
          child: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: estadoBotonLike
                  ? imageFavorito.image
                  : imagenNoFavorito.image),
        ),
      ),
    );
  }

  void traerlistadefavoritos() async {
    dynamic respuesta = await favoriteProducService.traer();

    if (respuesta is Map) {
      productosFavoritos = (respuesta["idListaProductosFavoritos"]);
      for (var i = 0; i < productosFavoritos.length; i++) {
        if (widget.numberid == productosFavoritos[i]) {
          estadoBotonLike = true;
        }
      }
    }

    setState(() {});
  }

  void agregarProducto() async {
    await favoriteProducService.addFavoriteProduct(
      prefs.usuario,
      widget.numberid,
    );
    setState(() {});
  }

  void eliminarProducto() async {
    await favoriteProducService.deleteFavoriteProduct(
      prefs.usuario,
      widget.numberid,
    );
    setState(() {});
  }
}
