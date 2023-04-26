class productoProm {
  String? id;
  String? idProducto;
  List? restaurantes;
  String? descuento;
  String? numeroDias;
  bool? habilitar;

  productoProm({
    this.id,
    this.idProducto,
    this.restaurantes,
    this.descuento,
    this.numeroDias,
    this.habilitar,
  });

  productoProm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idProducto = json['idProducto'];
    restaurantes = json['restaurantes'];
    descuento = json['descuento'];
    numeroDias = json['numeroDias'];
    habilitar = json['habilitar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['idProducto'] = idProducto;
    data['restaurantes'] = restaurantes;
    data['descuento'] = descuento;
    data['numeroDias'] = numeroDias;
    data['habilitar'] = habilitar;

    return data;
  }
}
