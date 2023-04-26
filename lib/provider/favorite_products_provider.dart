import 'package:flutter/material.dart';

import '../model/controller_arg_product.dart';
import '../service/favorite_products_service.dart';
import '../service/products_service.dart';

class FavoriteProductProvider extends ChangeNotifier {
  final traerProductosFavoritos = FavoriteProductsService();
  final productService = ProductsService();

  List<ProductModel> _listaProductosFavoritosCompletos = [];

  List<ProductModel> get listaProductosFavoritosCompletos =>
      _listaProductosFavoritosCompletos;

  set listaProductosFavoritosCompletos(List<ProductModel> valor) {
    _listaProductosFavoritosCompletos = valor;

    notifyListeners();
  }

  bool _cargaronProductos = true;

  bool get cargaronProductos => _cargaronProductos;

  void traerProducFavorito() async {
    listaProductosFavoritosCompletos = [];

    List listIdFavoriteProducstUser =
        await traerProductosFavoritos.traerIdProductosFavoritos();
    List listIdFavoriteProducstUserReversed =
        listIdFavoriteProducstUser.reversed.toList();

    for (var i = 0;
        i < listIdFavoriteProducstUserReversed.toList().length;
        i++) {
      dynamic listaProductosCompleta = await productService
          .obtenerProducto(listIdFavoriteProducstUserReversed[i]);
      if (listaProductosCompleta != null) {
        ProductModel _producto = ProductModel.fromJson(listaProductosCompleta);

        listaProductosFavoritosCompletos.add(_producto);
      }
    }

    _cargaronProductos = false;
    notifyListeners();
  }
}
