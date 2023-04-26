import 'controller_toppigs.dart';

class AddProductCartController {
  String? idProducto;
  bool? esCajita;
  List<ToppingsModel>? toppings;

  AddProductCartController({
    this.idProducto,
    this.toppings,
    this.esCajita,
  });
}
