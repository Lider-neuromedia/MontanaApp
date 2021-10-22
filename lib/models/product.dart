import 'dart:convert';
import 'package:montana_mobile/models/image.dart';

ResponseProductos responseProductosFromJson(String str) =>
    ResponseProductos.fromJson(json.decode(str));

String responseProductosToJson(ResponseProductos data) =>
    json.encode(data.toJson());

ResponseProducto responseProductoFromJson(String str) =>
    ResponseProducto.fromJson(json.decode(str));

String responseProductoToJson(ResponseProducto data) =>
    json.encode(data.toJson());

class ResponseProductos {
  ResponseProductos({
    this.response,
    this.message,
    this.status,
    this.productos,
    this.showRoom,
  });

  String response;
  String message;
  int status;
  List<Producto> productos;
  bool showRoom;

  factory ResponseProductos.fromJson(Map<String, dynamic> json) =>
      ResponseProductos(
        response: json["response"],
        message: json["message"],
        status: json["status"],
        productos: List<Producto>.from(
            json["productos"].map((x) => Producto.fromJson(x))),
        showRoom: json["show_room"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        "status": status,
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
        "show_room": showRoom,
      };
}

class ResponseProducto {
  ResponseProducto({
    this.response,
    this.status,
    this.producto,
  });

  String response;
  int status;
  Producto producto;

  factory ResponseProducto.fromJson(Map<String, dynamic> json) =>
      ResponseProducto(
        response: json["response"],
        status: json["status"],
        producto: Producto.fromJson(json["producto"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "producto": producto.toJson(),
      };
}

class Producto {
  Producto({
    this.idProducto,
    this.nombre,
    this.codigo,
    this.referencia,
    this.stock,
    this.precio,
    this.descripcion,
    this.sku,
    this.total,
    this.descuento,
    this.iva,
    this.catalogo,
    this.marcaId,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.nombreMarca,
    this.imagenes,
  });

  int idProducto;
  String nombre;
  String codigo;
  String referencia;
  int stock;
  double precio;
  String descripcion;
  String sku;
  double total;
  int descuento;
  int iva;
  int catalogo;
  int marcaId;
  DateTime createdAt;
  DateTime updatedAt;
  String image;
  String nombreMarca;
  List<Imagen> imagenes;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        idProducto: json["id_producto"],
        nombre: json["nombre"],
        codigo: json["codigo"],
        referencia: json["referencia"],
        stock: json["stock"],
        precio: double.parse(json["precio"].toString()),
        descripcion: json["descripcion"],
        sku: json["sku"],
        total: double.parse(json["total"].toString()),
        descuento: json["descuento"],
        iva: json["iva"],
        catalogo: json["catalogo"],
        marcaId: json["marca"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        nombreMarca: json["nombre_marca"],
        image: json.containsKey("image") ? json["image"] : json["destacada"],
        imagenes: json["imagenes"] != null
            ? List<Imagen>.from(json["imagenes"].map((x) => Imagen.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id_producto": idProducto,
        "nombre": nombre,
        "codigo": codigo,
        "referencia": referencia,
        "stock": stock,
        "precio": precio,
        "descripcion": descripcion,
        "sku": sku,
        "total": total,
        "descuento": descuento,
        "iva": iva,
        "catalogo": catalogo,
        "marca": marcaId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "image": image,
        "destacada": image,
        "nombre_marca": nombreMarca,
        "imagenes": imagenes != null
            ? List<dynamic>.from(imagenes.map((x) => x.toJson()))
            : [],
      };
}
