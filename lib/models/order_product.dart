import 'package:montana_mobile/models/product.dart';
import 'package:montana_mobile/models/store.dart';

class PedidoProducto {
  PedidoProducto({
    this.id,
    this.referencia,
    this.cantidadProducto,
    this.lugar,
    this.producto,
    this.tienda,
    this.pedidoId,
    this.productoId,
    this.tiendaId,
  });

  int id;
  String referencia;
  int cantidadProducto;
  String lugar;
  Producto producto;
  Tienda tienda;
  int pedidoId;
  int productoId;
  int tiendaId;

  factory PedidoProducto.fromJson(Map<String, dynamic> json) => PedidoProducto(
        id: json["id"],
        referencia: json["referencia"] ?? "",
        cantidadProducto: json["cantidad_producto"] ?? 0,
        lugar: json["lugar"] ?? "",
        producto: json["producto"] != null
            ? Producto.fromJson(json["producto"])
            : null,
        tienda: json["tienda"] != null ? Tienda.fromJson(json["tienda"]) : null,
        pedidoId: json["pedido_id"],
        productoId: json["producto_id"],
        tiendaId: json["tienda_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "referencia": referencia,
        "cantidad_producto": cantidadProducto,
        "lugar": lugar,
        "producto": producto != null ? producto.toJson() : null,
        "tienda": tienda != null ? tienda.toJson() : null,
        "pedido_id": pedidoId,
        "producto_id": productoId,
        "tienda_id": tiendaId,
      };
}
