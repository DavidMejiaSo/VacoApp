// ignore_for_file: prefer_typing_uninitialized_variables, avoid_single_cascade_in_expression_statements

import 'package:flutter/material.dart';
import 'package:prueba_vaco_app/service/products_service.dart';

enum GroceyState {
  normal,
  details,
  cart,
}

class GroceryStoreBloc with ChangeNotifier {
  GroceyState groceyState = GroceyState.normal;
  Future<List>? catalog = ProductsService().mostrar();
  List<GroceryProductItem> cart = [];

  void changeToNormal() {
    groceyState = GroceyState.normal;
    notifyListeners();
  }

  void changeToCart() {
    groceyState = GroceyState.cart;
    notifyListeners();
  }

  void addProduct(dynamic product) {
    for (GroceryProductItem item in cart) {
      if (item.product['nombre'] == product['nombre']) {
        item.increment();
        notifyListeners();
        return;
      }
    }
    cart.add(GroceryProductItem(product: product));
    notifyListeners();
  }

  void addAicionales(dynamic adicionales, dynamic product) {
    print("product llego con $product");
    print(" Esto tiene adici${adicionales[0]}");
    for (GroceryProductItem item in cart) {
      if (item.product['nombre'] == product['nombre']) {
        item.increment();
        notifyListeners();
        return;
      }
    }
    cart.add(GroceryProductItem(product: product, adicionales: adicionales[0]));
    print(cart.length);
    notifyListeners();
  }

  void deleteProduct(GroceryProductItem product) {
    product.decrement();
    notifyListeners();
    if (product.quantity == 0) {
      cart.remove(product);
    }
    return;
  }

  int totalCartElements() => cart.fold<int>(
      0, (previousValue, element) => previousValue + element.quantity);
  double totalPriceElement() => cart.fold<double>(
      0.0,
      (previousValue, element) =>
          previousValue +
          element.quantity * int.parse(element.product['precio']));
}

class GroceryProductItem {
  GroceryProductItem(
      {this.quantity = 1, @required this.product, this.adicionales = const []});

  int quantity;
  final product;
  List adicionales = [];

  void increment() {
    quantity++;
  }

  void decrement() {
    quantity--;
  }
}
