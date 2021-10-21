class PedidoProducto {
  PedidoProducto({
    this.referencia,
    this.cantidadProducto,
    this.lugar,
  });

  String referencia;
  int cantidadProducto;
  String lugar;

  factory PedidoProducto.fromJson(Map<String, dynamic> json) => PedidoProducto(
        referencia: json["referencia"],
        cantidadProducto: json["cantidad_producto"],
        lugar: json["lugar"],
      );

  Map<String, dynamic> toJson() => {
        "referencia": referencia,
        "cantidad_producto": cantidadProducto,
        "lugar": lugar,
      };
}
