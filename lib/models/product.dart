import 'dart:convert';
import 'package:montana_mobile/models/brand.dart';
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
    this.status,
    this.productos,
  });

  String response;
  int status;
  Productos productos;

  factory ResponseProductos.fromJson(Map<String, dynamic> json) =>
      ResponseProductos(
        response: json["response"],
        status: json["status"],
        productos: Productos.fromJson(json["productos"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "productos": productos.toJson(),
      };
}

class ResponseProducto {
  ResponseProducto({
    this.producto,
    this.response,
    this.status,
  });

  Producto producto;
  String response;
  int status;

  factory ResponseProducto.fromJson(Map<String, dynamic> json) =>
      ResponseProducto(
        producto: Producto.fromJson(json["producto"]),
        response: json["response"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "producto": producto.toJson(),
        "response": response,
        "status": status,
      };
}

class Productos {
  Productos({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<Producto> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  factory Productos.fromJson(Map<String, dynamic> json) => Productos(
        currentPage: json["current_page"],
        data:
            List<Producto>.from(json["data"].map((x) => Producto.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Producto {
  Producto({
    this.id,
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
    this.catalogoId,
    this.image,
    this.imagenes,
    this.marcaId,
    this.marca,
    this.createdAt,
    this.updatedAt,
  });

  int id;
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
  int catalogoId;
  String image;
  List<Imagen> imagenes;
  int marcaId;
  Marca marca;
  DateTime createdAt;
  DateTime updatedAt;

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id_producto"],
        nombre: json["nombre"],
        codigo: json["codigo"],
        referencia: json["referencia"],
        stock: json["stock"],
        precio: double.parse(json["precio"].toString()),
        descripcion: json["descripcion"],
        sku: json["sku"] ?? '',
        total: double.parse(json["total"].toString()),
        descuento: json["descuento"],
        iva: json["iva"],
        catalogoId: json["catalogo"],
        image: json["image"] ?? '',
        imagenes: json["imagenes"] != null
            ? List<Imagen>.from(json["imagenes"].map((x) => Imagen.fromJson(x)))
            : [],
        marcaId: json["marca_id"],
        marca: json["marca"] != null ? Marca.fromJson(json["marca"]) : null,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_producto": id,
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
        "catalogo": catalogoId,
        "image": image,
        "imagenes": List<dynamic>.from(imagenes.map((x) => x.toJson())),
        "marca_id": marcaId,
        "marca": marca != null ? marca.toJson() : null,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
