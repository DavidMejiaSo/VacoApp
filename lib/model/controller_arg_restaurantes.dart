class OrganizacionRestaurantes {
  String? id;
  String? nombre;
  String? idDepartamento;
  String? idMunicipio;
  String? direccion;
  dynamic latitud;
  dynamic longitud;
  String? telefono;
  String? celular;
  String? tiempoEstimadoEntregaMinimo;
  String? tiempoEstimadoEntregaMaximo;
  String? idCategoriaRestaurante;
  dynamic categorias;
  dynamic estado;
  String? fechaCreacion;
  String? fechaActualizacion;
  dynamic archivos;
  String? idUsuarioModificador;
  String? idImagen;
  String? idSocio;
  dynamic calificacionPromedio;
  bool? abierto;

  OrganizacionRestaurantes(
    this.id,
    this.nombre,
    this.idDepartamento,
    this.idMunicipio,
    this.direccion,
    this.longitud,
    this.latitud,
    this.telefono,
    this.celular,
    this.tiempoEstimadoEntregaMinimo,
    this.tiempoEstimadoEntregaMaximo,
    this.idCategoriaRestaurante,
    this.categorias,
    this.estado,
    this.fechaCreacion,
    this.fechaActualizacion,
    this.archivos,
    this.idUsuarioModificador,
    this.idImagen,
    this.idSocio,
    this.calificacionPromedio,
    this.abierto,
  );

  OrganizacionRestaurantes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    idDepartamento = json['idDepartamento'];
    idMunicipio = json['idMunicipio'];
    direccion = json['direccion'];
    longitud = json['longitud'];
    latitud = json['latitud'];
    telefono = json['telefono'];
    celular = json['celular'];
    tiempoEstimadoEntregaMinimo = json['tiempoEstimadoEntregaMinimo'];
    tiempoEstimadoEntregaMaximo = json['tiempoEstimadoEntregaMaximo'];
    idCategoriaRestaurante = json['idCategoriaRestaurante'];
    categorias = json['categorias'];
    estado = json['estado'];
    fechaCreacion = json['fechaCreacion'];
    fechaActualizacion = json['fechaActualizacion'];
    archivos = json['archivos'];
    idUsuarioModificador = json['idUsuarioModificador'];
    idImagen = json['idImagen'];
    idSocio = json['idSocio'];
    calificacionPromedio = json['calificacionPromedio'];
    abierto = json['abierto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['nombre'] = nombre;
    data['idDepartamento'] = idDepartamento;
    data['idMunicipio'] = idMunicipio;
    data['direccion'] = direccion;
    data['longitud'] = longitud;
    data['latitud'] = latitud;
    data['telefono'] = telefono;
    data['celular'] = celular;
    data['tiempoEstimadoEntregaMinimo'] = tiempoEstimadoEntregaMinimo;
    data['tiempoEstimadoEntregaMaximo'] = tiempoEstimadoEntregaMaximo;
    data['idCategoriaRestaurante'] = idCategoriaRestaurante;
    data['categorias'] = categorias;
    data['estado'] = estado;
    data['fechaCreacion'] = fechaCreacion;
    data['fechaActualizacion'] = fechaActualizacion;
    data['archivos'] = archivos;
    data['idUsuarioModificador'] = idUsuarioModificador;
    data['idImagen'] = idImagen;
    data['idSocio'] = idSocio;
    data['calificacionPromedio'] = calificacionPromedio;
    data['abierto'] = abierto;

    return data;
  }
}
