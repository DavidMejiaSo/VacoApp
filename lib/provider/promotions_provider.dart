import 'package:flutter/material.dart';

import '../service/products_service.dart';
import '../service/promotions_service.dart';
import '../service/restaurant_service.dart';

class PromotionsProvider with ChangeNotifier {
  final promocionesService = PromocionesService();
  final productService = ProductsService();
  final restaurantService = RestaurantService();
  List<dynamic> _promocionesRestaurantes = [];

  List<dynamic> get promocionesRestaurantes => _promocionesRestaurantes;

  set promocionesRestaurantes(List<dynamic> valor) {
    _promocionesRestaurantes = valor;
    notifyListeners();
  }

  List<dynamic> _promocionesSupermercados = [];

  List<dynamic> get promocionesSupermercados => _promocionesSupermercados;

  set promocionesSupermercados(List<dynamic> valor) {
    _promocionesSupermercados = valor;
    notifyListeners();
  }

  List<dynamic> _promocionesProductos = [];

  List<dynamic> get promocionesProductos => _promocionesProductos;

  set promocionesProductos(List<dynamic> valor) {
    _promocionesProductos = valor;
    notifyListeners();
  }

  List<dynamic> _promocionesProductosCompleto = [];

  List<dynamic> get promocionesProductosCompleto =>
      _promocionesProductosCompleto;

  set promocionesProductosCompleto(List<dynamic> valor) {
    _promocionesProductosCompleto = valor;
    notifyListeners();
  }

  void cargarPromociones() async {
    cargarPromocionesRestaurantes();
    cargarPromocionesSupermercados();
    cargarPromocionesProductos();
  }

  void cargarPromocionesRestaurantes() async {
    promocionesRestaurantes = [];
    dynamic traerPromocionesRestaurantes =
        await promocionesService.obtenerPromocionesRestaurante();
    promocionesRestaurantes = traerPromocionesRestaurantes;
  }

  void cargarPromocionesSupermercados() async {
    promocionesSupermercados = [];
    dynamic traerPromociones =
        await promocionesService.obtenerPromocionesSupermercados();
    promocionesSupermercados = traerPromociones;
  }

  void cargarPromocionesProductos() async {
    promocionesProductos = [];
    promocionesProductosCompleto = [];
    dynamic traerPromociones =
        await promocionesService.obtenerPromocionesProductos();
    promocionesProductos = traerPromociones;

    for (var i = 0; i < traerPromociones.length; i++) {
      dynamic restauranteCompleto = await productService
          .obtenerProducto(traerPromociones[i]['idProducto']);

      promocionesProductosCompleto.add(restauranteCompleto);
    }
  }
}
