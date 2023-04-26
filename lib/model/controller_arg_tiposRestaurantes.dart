class categoriasRestaurantes {
  String? id;
  String? nombre;
  String? imagen;

  categoriasRestaurantes({this.id = "", this.nombre = "", this.imagen = ""});

  categoriasRestaurantes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    imagen = json['idImagen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['idImagen'] = this.imagen;

    return data;
  }
}
