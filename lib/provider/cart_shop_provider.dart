import 'package:flutter/material.dart';

import '../model/controller_arg_addCart.dart';
import '../model/controller_arg_addProductCart.dart';
import '../model/controller_arg_product.dart';
import '../model/controller_arg_restaurantes.dart';
import '../service/restaurant_service.dart';

class CarritoComprasProvider extends ChangeNotifier {
  String _restaurantePrincipal = '';

  String get restaurantePrincipal => _restaurantePrincipal;

  set restaurantePrincipal(String value) {
    _restaurantePrincipal = value;
    notifyListeners();
  }

  int _totalPrecioCarrito = 0;

  int get totalPrecioCarrito => _totalPrecioCarrito;

  set totalPrecioCarrito(int value) {
    _totalPrecioCarrito = value;
    notifyListeners();
  }

  late CartList? _cartList;

  CartList? get cartList => _cartList;

  set cartList(CartList? valor) {
    _cartList = valor;
    notifyListeners();
  }

  late OrganizacionRestaurantes? _organizadorRestaurante;

  OrganizacionRestaurantes? get organizadorRestaurante =>
      _organizadorRestaurante;

  set organizadorRestaurante(OrganizacionRestaurantes? value) {
    _organizadorRestaurante = value;
    notifyListeners();
  }

  List<AddProductCartController> _listaProductosCarrito = [];

  List<AddProductCartController> get listaProductosCarrito =>
      _listaProductosCarrito;

  set listaProductosCarrito(List<AddProductCartController> valor) {
    _listaProductosCarrito = valor;

    notifyListeners();
  }

  List<String> _listaProductosCarritoFinal = [];

  List<String> get listaProductosCarritoFinal => _listaProductosCarritoFinal;

  set listaProductosCarritoFinal(List<String> valor) {
    _listaProductosCarritoFinal = valor;

    notifyListeners();
  }

  List<String> _listaIdCajasCarrito = [];

  List<String> get listaIdCajasCarrito => _listaIdCajasCarrito;

  set listaIdCajasCarrito(List<String> valor) {
    _listaIdCajasCarrito = valor;

    notifyListeners();
  }

  void obtenerListaProductos2() {
    listaProductosCarritoFinal.clear();
    for (var i = 0; i < listaProductosCarrito.length; i++) {
      if (listaProductosCarrito[i].esCajita == false) {
        listaProductosCarritoFinal
            .add(listaProductosCarrito[i].idProducto.toString());
      }
    }
  }

  List<int> _listaPreciosToppingsProductosCarrito = [];

  List<int> get listaPreciosToppingsProductosCarrito =>
      _listaPreciosToppingsProductosCarrito;

  set listaPreciosToppingsProductosCarrito(List<int> valor) {
    _listaPreciosToppingsProductosCarrito = valor;

    notifyListeners();
  }

  List<String> _listaToppingsProductosCarrito = [];

  List<String> get listaToppingsProductosCarrito =>
      _listaToppingsProductosCarrito;

  set listaToppingsProductosCarrito(List<String> valor) {
    _listaToppingsProductosCarrito = valor;

    notifyListeners();
  }

  void obtenerListaPreciosToppingsProductosCarrito() {
    listaPreciosToppingsProductosCarrito = [];
    listaToppingsProductosCarrito = [];
    for (var i = 0; i < listaProductosCarrito.length; i++) {
      int valorAux = 0;
      for (var j = 0; j < listaProductosCarrito[i].toppings!.length; j++) {
        valorAux += int.parse(listaProductosCarrito[i].toppings![j].precio!);
        listaToppingsProductosCarrito
            .add(listaProductosCarrito[i].toppings![j].id!);
      }
      listaPreciosToppingsProductosCarrito.add(valorAux);
    }
  }

  List<ProductModel> _listaProductosCompletosCarrito = [];

  List<ProductModel> get listaProductosCompletosCarrito =>
      _listaProductosCompletosCarrito;

  set listaProductosCompletosCarrito(List<ProductModel> valor) {
    _listaProductosCompletosCarrito = valor;

    notifyListeners();
  }

  void obtenerInfoRestaurante() async {
    final productsService = RestaurantService();
    dynamic respuesta =
        await productsService.obtenerRestaurante(restaurantePrincipal);

    organizadorRestaurante = OrganizacionRestaurantes.fromJson(respuesta);
  }

  void limpiarCarrito() {
    listaProductosCarrito.clear();
    listaProductosCompletosCarrito.clear();
    listaPreciosToppingsProductosCarrito.clear();
    listaIdCajasCarrito.clear();

    restaurantePrincipal = '';
    totalPrecioCarrito = 0;
    print('limpados!!!!!');
  }

  void cantidadproductosCarrito() {
    int cantidadToppings = 0;
    int cantidadProductos = 0;

    for (var i = 0; i < listaProductosCarrito.length; i++) {
      for (var k = 0; k < listaProductosCarrito[i].toppings!.length; k++) {
        cantidadToppings +=
            int.parse(listaProductosCarrito[i].toppings![k].precio!);
      }
    }
    for (var i = 0; i < listaProductosCompletosCarrito.length; i++) {
      cantidadProductos += int.parse(listaProductosCompletosCarrito[i].precio);
    }
    totalPrecioCarrito = cantidadProductos + cantidadToppings;
    print('precio total toppongs ${listaPreciosToppingsProductosCarrito}');
    print('precio total productos ${cantidadProductos}');
    print('precio total $listaToppingsProductosCarrito');
    print('------------------------------------------');
  }
}
