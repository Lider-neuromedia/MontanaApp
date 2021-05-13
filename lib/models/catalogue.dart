import 'dart:convert';

ResponseCatalogos responseCatalogosFromJson(String str) =>
    ResponseCatalogos.fromJson(json.decode(str));

String responseCatalogosToJson(ResponseCatalogos data) =>
    json.encode(data.toJson());

class ResponseCatalogos {
  ResponseCatalogos({
    this.response,
    this.message,
    this.status,
    this.catalogos,
  });

  String response;
  String message;
  int status;
  List<Catalogo> catalogos;

  factory ResponseCatalogos.fromJson(Map<String, dynamic> json) =>
      ResponseCatalogos(
        response: json["response"],
        message: json["message"],
        status: json["status"],
        catalogos: List<Catalogo>.from(
            json["catalogos"].map((x) => Catalogo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        "status": status,
        "catalogos": List<dynamic>.from(catalogos.map((x) => x.toJson())),
      };
}

class Catalogo {
  Catalogo({
    this.id,
    this.estado,
    this.tipo,
    this.imagen,
    this.titulo,
    this.cantidad,
    this.descuento,
    this.etiqueta,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String estado;
  String tipo;
  String imagen;
  String titulo;
  int cantidad;
  int descuento;
  String etiqueta;
  DateTime createdAt;
  DateTime updatedAt;

  factory Catalogo.fromJson(Map<String, dynamic> json) => Catalogo(
        id: json["id_catalogo"],
        estado: json["estado"],
        tipo: json["tipo"],
        imagen: json["imagen"],
        titulo: json["titulo"],
        cantidad: json["cantidad"],
        descuento: json["descuento"] == null ? null : json["descuento"],
        etiqueta: json["etiqueta"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_catalogo": id,
        "estado": estado,
        "tipo": tipo,
        "imagen": imagen,
        "titulo": titulo,
        "cantidad": cantidad,
        "descuento": descuento == null ? null : descuento,
        "etiqueta": etiqueta,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  String get tipoFormatted {
    String temp = tipo.toLowerCase().trim();
    String firstLetter = temp.substring(0, 1).toUpperCase();
    String word = firstLetter + temp.substring(1, temp.length);
    return word;
  }
}
