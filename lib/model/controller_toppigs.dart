class ToppingsModel {
  String? id;
  String? nombre;
  String? precio;

  ToppingsModel(this.id, this.nombre, this.precio);

  ToppingsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    precio = json['precio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['nombre'] = nombre;
    data['precio'] = precio;

    return data;
  }
}
