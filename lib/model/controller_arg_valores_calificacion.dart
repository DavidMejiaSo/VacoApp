class ValoresCalificacion {
  String? idCuestionario;
  String? idOrganizacion;
  String? idEvaluador;
  String? evaluador;
  String? evaluado;
  String? idRestaurante;
  String? calificacion;
  String? opciones;
  String? comentarios;
  ValoresCalificacion({
    this.idCuestionario,
    this.idEvaluador,
    this.evaluador,
    this.evaluado,
    this.idRestaurante,
    this.calificacion,
    this.opciones,
    this.comentarios,
  });

  ValoresCalificacion.fromJson(Map<String, dynamic> json) {
    idRestaurante = json['id'];
    idCuestionario = json['idCuestionario'];
    idEvaluador = json['idEvaluador'];
    evaluador = json['evaluador'];
    evaluado = json['evaluado'];
    calificacion = json['calificacio'];
    opciones = json['opciones'];
    comentarios = json['comentarios'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = idRestaurante;
    data['idCuestionario'] = idCuestionario;
    data['idEvaluador'] = idEvaluador;
    data['evaluador'] = evaluador;
    data['evaluado'] = evaluado;
    data['calificacion'] = calificacion;
    data['opciones'] = opciones;
    data['comentarios'] = comentarios;

    return data;
  }
}
