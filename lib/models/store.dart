import 'dart:convert';

List<Tienda> responseTiendasFromJson(String str) =>
    List<Tienda>.from(json.decode(str).map((x) => Tienda.fromJson(x)));

String responseTiendasToJson(List<Tienda> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tienda {
  Tienda({
    this.idTiendas,
    this.nombre,
    this.lugar,
    this.local,
    this.direccion,
    this.telefono,
    this.cliente,
    this.createdAt,
    this.updatedAt,
  });

  int idTiendas;
  String nombre;
  String lugar;
  String local;
  String direccion;
  String telefono;
  int cliente;
  DateTime createdAt;
  DateTime updatedAt;

  int stock = 0;

  factory Tienda.fromJson(Map<String, dynamic> json) => Tienda(
        idTiendas: json["id_tiendas"],
        nombre: json["nombre"],
        lugar: json["lugar"],
        local: json["local"] == null ? null : json["local"],
        direccion: json["direccion"] == null ? null : json["direccion"],
        telefono: json["telefono"] == null ? null : json["telefono"],
        cliente: json["cliente"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_tiendas": idTiendas,
        "nombre": nombre,
        "lugar": lugar,
        "local": local == null ? null : local,
        "direccion": direccion == null ? null : direccion,
        "telefono": telefono == null ? null : telefono,
        "cliente": cliente,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
