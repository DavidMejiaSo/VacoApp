class ProductModel {
  final String id;
  final String idProductoOriginal;
  final String nombre;
  final String descripcion;
  final String precio;
  final String cantidad;
  final bool estado;
  final bool entregaInmediata;
  final List ingredientes;
  final List alergias;
  final List toppings;
  final String fechaCreacion;
  final String fechaModificacion;
  final String idCategoriaProducto;
  final String idUsuarioCreador;
  final String idImagen;
  final String idUsuarioModificador;
  final String idRestauranteCreador;
  final String fechaActualizacion;
  const ProductModel({
    required this.id,
    required this.idProductoOriginal,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.cantidad,
    required this.estado,
    required this.entregaInmediata,
    required this.ingredientes,
    required this.alergias,
    required this.toppings,
    required this.fechaCreacion,
    required this.fechaModificacion,
    required this.idCategoriaProducto,
    required this.idUsuarioCreador,
    required this.idImagen,
    required this.idUsuarioModificador,
    required this.idRestauranteCreador,
    required this.fechaActualizacion,
  });

  static ProductModel fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] == null ? '' : json['id'],
        idProductoOriginal: json['idProductoOriginal'] == null
            ? ''
            : json['idProductoOriginal'],
        nombre: json['nombre'] == null ? '' : json['nombre'],
        descripcion: json['descripcion'] == null ? '' : json['descripcion'],
        precio: json['precio'] == null ? '' : json['precio'],
        cantidad: json['cantidad'] == null ? '' : json['cantidad'],
        estado: json['estado'] == null ? false : json['estado'],
        entregaInmediata:
            json['entregaInmediata'] == null ? false : json['entregaInmediata'],
        ingredientes: json['ingredientes'] == null ? [] : json['ingredientes'],
        alergias: json['alergias'] == null ? [] : json['alergias'],
        toppings: json['toppings'] == null ? [] : json['toppings'],
        fechaCreacion:
            json['fechaCreacion'] == null ? '' : json['fechaCreacion'],
        fechaModificacion:
            json['fechaModificacion'] == null ? '' : json['fechaModificacion'],
        idCategoriaProducto: json['idCategoriaProducto'] == null
            ? ''
            : json['idCategoriaProducto'],
        idUsuarioCreador:
            json['idUsuarioCreador'] == null ? '' : json['idUsuarioCreador'],
        idImagen: json['idImagen'] == null ? '' : json['idImagen'],
        idUsuarioModificador: json['idUsuarioModificador'] == null
            ? ''
            : json['idUsuarioModificador'],
        idRestauranteCreador: json['idRestauranteCreador'] == null
            ? ''
            : json['idRestauranteCreador'],
        fechaActualizacion: json['fechaActualizacion'] == null
            ? ''
            : json['fechaActualizacion'],
      );
}
