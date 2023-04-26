class ModeloPromociones {
  final String id;
  final String idProducto;
  final String idProductoOriginal;
  final String restaurante;
  final String descuento;
  final String numeroDias;
  final bool habilitar;
  final String fechaCreacion;
  final String fechaModificacion;
  final String idUsuarioCreador;
  final String idUsuarioModificador;

  ModeloPromociones(
      this.id,
      this.idProducto,
      this.idProductoOriginal,
      this.restaurante,
      this.descuento,
      this.numeroDias,
      this.habilitar,
      this.fechaCreacion,
      this.fechaModificacion,
      this.idUsuarioCreador,
      this.idUsuarioModificador);
}
