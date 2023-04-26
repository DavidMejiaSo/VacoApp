import 'package:flutter/material.dart';

import '../service/bag_service.dart';
import '../service/cart_service.dart';
import '../service/products_service.dart';

class CartShopProvider extends ChangeNotifier {
  int _totalCarrito = 0;
  int _totalProudctosCarrito = 0;
  int valorProductosCarrito = 0;
  int valorAdicionalesCarrito = 0;
  String restauranteEnElCarrito = "";
  List subtotalAdicionalessCarrito = [];
  List subtotalProductosCarrito = [];
  dynamic productosCarrito = [];
  dynamic adicionalesCarrito = [];
  dynamic idAdicional = [];
  dynamic listaAdicionalesCompletaCarrito = [];
  dynamic listaAdicionesCarrito = [];
  dynamic listaProductosCarrito = [];

  final prodcutService = ProductsService();

  int get totalCarrito => _totalCarrito == 0 ? 0 : _totalCarrito;
  int get totalProudctosCarrito =>
      _totalProudctosCarrito == 0 ? 0 : _totalProudctosCarrito;

  set totalCarrito(int valor) {
    _totalCarrito = valor;
    notifyListeners();
  }

  set totalProudctosCarrito(int valor) {
    _totalProudctosCarrito = valor;
    notifyListeners();
  }

  void traerProductCarrito() async {
    productosCarrito = [];
    adicionalesCarrito = [];
    idAdicional = [];
    try {
      final carritoService = CartSevice();
      dynamic respuesta = await carritoService.listarCarrito();
      for (var i = 0; i < respuesta.length; i++) {
        print(respuesta[i]);
        productosCarrito.add(respuesta[i]['idProducto']);
        idAdicional.add(respuesta[i]['listTopping']);
        adicionalesCarrito.add(respuesta[i]['listTopping']);
      }
      obtenerAdicionales();

      await Future.delayed(Duration(seconds: 1));
      traerProductosCarritoCompletos();
    } catch (e) {
      print(e);
    }
  }

  void obtenerAdicionales() async {
    listaAdicionalesCompletaCarrito = [];
    listaAdicionesCarrito = [];
    for (var i = 0; i < idAdicional.length; i++) {
      if (idAdicional[i].isNotEmpty) {
        for (var j = 0; j < idAdicional[i].length; j++) {
          dynamic respuesta;
          respuesta = await prodcutService.obtenerTopping(idAdicional[i][j]);
          listaAdicionalesCompletaCarrito.add(respuesta);
        }
      }
    }
    if (listaAdicionalesCompletaCarrito.isEmpty) {
      subtotalAdicionalessCarrito.add('0');
    }
    for (var i = 0; i < listaAdicionalesCompletaCarrito.length; i++) {
      listaAdicionesCarrito.add(listaAdicionalesCompletaCarrito[i]['nombre']);
      listaAdicionesCarrito.add(listaAdicionalesCompletaCarrito[i]['precio']);
    }
    for (var j = 0; j < listaAdicionesCarrito.length; j++) {
      if (j % 2 == 0) {
      } else {
        valorAdicionalesCarrito =
            valorAdicionalesCarrito + int.parse(listaAdicionesCarrito[j]);
        subtotalAdicionalessCarrito.add(listaAdicionesCarrito[j]);
      }
    }
  }

  void vacearBolsa() {
    totalCarrito = 0;
    totalProudctosCarrito = 0;
  }

  void traerProductosCarritoCompletos() async {
    listaProductosCarrito = [];
    valorProductosCarrito = 0;

    restauranteEnElCarrito = "";
    subtotalProductosCarrito = [];

    if (productosCarrito.isNotEmpty) {
      try {
        final listaProductos = ProductsService();
        final bagService = BagService();
        dynamic listaProductosCompleta;
        for (var i = 0; i < productosCarrito.length; i++) {
          listaProductosCompleta = await listaProductos
              .obtenerProductoDelRestaurante(productosCarrito[i]);

          if (listaProductosCompleta.containsKey("respuesta")) {
            listaProductosCompleta =
                await bagService.buscarBolsaPorRestaurante(productosCarrito[i]);

            listaProductosCarrito.add(listaProductosCompleta);
            valorProductosCarrito = valorProductosCarrito +
                int.parse(listaProductosCarrito[i]['precio']);
            subtotalProductosCarrito.add(listaProductosCarrito[i]['precio']);
            restauranteEnElCarrito =
                listaProductosCompleta['idRestauranteCreador'];
          } else {
            listaProductosCarrito.add(listaProductosCompleta);
            valorProductosCarrito = valorProductosCarrito +
                int.parse(listaProductosCarrito[i]['precio']);
            subtotalProductosCarrito.add(listaProductosCarrito[i]['precio']);
            restauranteEnElCarrito =
                listaProductosCompleta['idRestauranteCreador'];
          }
        }
        totalCarrito = 0;
        totalProudctosCarrito = 0;
        totalProudctosCarrito = listaProductosCarrito.length;

        totalCarrito = valorProductosCarrito + valorAdicionalesCarrito;
      } catch (e) {
        print(e);
      }
    } else {
      print("no hay productos para mostrar");
    }
  }
}
