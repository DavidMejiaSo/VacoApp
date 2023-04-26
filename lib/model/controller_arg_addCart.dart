class CartList {
  String? idCliente;
  String? idRestaurante;
  int? precio;
  String? metodoPago;
  List? productos;
  List? productosSorpresa;
  List? toppings;
  String? observaciones;

  CartList(
    this.idCliente,
    this.idRestaurante,
    this.precio,
    this.metodoPago,
    this.productos,
    this.productosSorpresa,
    this.toppings,
    this.observaciones,
  );

  CartList.fromJson(Map<String, dynamic> json) {
    idCliente = json['idUsuario'];
    idRestaurante = json['idRestaurante'];
    precio = json['precio'];
    metodoPago = json['metodoPago'];
    productos = json['productos'];
    productosSorpresa = json['productosSorpresa'];
    toppings = json['toppings'];
    observaciones = json['observaciones'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['idUsuario'] = idRestaurante;
    data['idRestaurante'] = idRestaurante;
    data['precio'] = precio;
    data['metodoPago'] = metodoPago;
    data['productos'] = productos;
    data['productosSorpresa'] = productosSorpresa;
    data['toppings'] = toppings;
    data['observaciones'] = observaciones;

    return data;
  }
}
