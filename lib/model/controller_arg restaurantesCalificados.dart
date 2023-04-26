class restaurantesCalificados {
  String? id;
  String? idRestaurante;
  dynamic calificacion;

  restaurantesCalificados({
    this.id = "",
    this.idRestaurante = "",
    this.calificacion,
  });
  restaurantesCalificados.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idRestaurante = json['idRestaurante'];
    calificacion = json['calificacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['idRestaurante'] = idRestaurante;
    data['calificacion'] = calificacion;

    return data;
  }
}
