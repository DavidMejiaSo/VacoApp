class ModeloPedido {
  final String id;
  final String numeroPedido;
  final String idCliente;
  final String idRestaurante;
  final String precio;
  final String estado;
  final String metodoPago;
  final dynamic productos;
  final dynamic toppings;
  final String observaciones;
  final String observacionesRestaurante;
  final String justificacionCancelacion;
  final String tiempoEntrega;
  final String fechaCreacion;
  final String fechaFinalizacion;

  ModeloPedido(
      this.id,
      this.numeroPedido,
      this.idCliente,
      this.idRestaurante,
      this.precio,
      this.estado,
      this.metodoPago,
      this.productos,
      this.toppings,
      this.observaciones,
      this.observacionesRestaurante,
      this.justificacionCancelacion,
      this.tiempoEntrega,
      this.fechaCreacion,
      this.fechaFinalizacion);
}
