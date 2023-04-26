class infoNotificaciones {
  String? id;
  String? nombre;
  String? descripcion;
  String? entrega;
  String? idImagen;

  List? perfiles;
  List? medios;
  String? fechaCreacion;
  String? fechaActualizacion;

  infoNotificaciones({
    this.id = "",
    this.nombre = "",
    this.descripcion = "",
    this.entrega = "",
    this.idImagen = "",
    this.perfiles,
    this.medios,
    this.fechaCreacion = "",
    this.fechaActualizacion = "",
  });

  infoNotificaciones.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    descripcion = json['descripcion'];
    entrega = json['entrega'];
    idImagen = json['idImagen'];
    perfiles = json['perfiles'];
    medios = json['medios'];
    fechaCreacion = json['fechaCreacion'];
    fechaActualizacion = json['fechaActualizacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['nombre'] = nombre;
    data['descripcion'] = descripcion;
    data['entrega'] = entrega;
    data['idImagen'] = idImagen;
    data['perfiles'] = perfiles;
    data['medios'] = medios;
    data['fechaCreacion'] = fechaCreacion;
    data['fechaActualizacion'] = fechaActualizacion;

    return data;
  }
}
