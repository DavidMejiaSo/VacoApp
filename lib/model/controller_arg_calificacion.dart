class OrganizacionCalificacion {
  String? id;
  String? nombre;
  String? evaluador;
  String? evaluado;
  String? habilitar;
  List? opciones;
  String? fechaCreacion;
  String? fechaActualizacion;

  OrganizacionCalificacion({
    this.id = "",
    this.nombre = "",
    this.evaluador = "",
    this.evaluado = "",
    this.habilitar = "",
    this.opciones,
    this.fechaCreacion = "",
    this.fechaActualizacion = "",
  });

  OrganizacionCalificacion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    evaluador = json['evaluador'];
    evaluado = json['evaluado'];
    habilitar = json['habilitar'];
    opciones = json['opciones'];
    fechaCreacion = json['fechaCreacion'];
    fechaActualizacion = json['fechaActualizacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['nombre'] = nombre;
    data['evaluador'] = evaluador;
    data['evaluado'] = evaluado;
    data['habilitar'] = habilitar;
    data['opciones'] = opciones;
    data['fechaCreacion'] = fechaCreacion;
    data['fechaActualizacion'] = fechaActualizacion;

    return data;
  }
}
