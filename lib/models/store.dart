import 'dart:convert';
import 'package:montana_mobile/models/user.dart';

List<Tienda> responseTiendasFromJson(String str) =>
    List<Tienda>.from(json.decode(str).map((x) => Tienda.fromJson(x)));

String responseTiendasToJson(List<Tienda> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Tienda responseTiendaFromJson(String str) => Tienda.fromJson(json.decode(str));

String responseTiendaToJson(Tienda data) => json.encode(data.toJson());

class Tienda {
  Tienda({
    this.id,
    this.nombre,
    this.lugar,
    this.local,
    this.direccion,
    this.telefono,
    this.sucursal,
    this.fechaIngreso,
    this.fechaUltimaCompra,
    this.cupo,
    this.ciudadCodigo,
    this.zona,
    this.bloqueado,
    this.bloqueadoFecha,
    this.nombreRepresentante,
    this.plazo,
    this.escalaFactura,
    this.observaciones,
    this.clienteId,
    this.cliente,
    this.vendedores,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String nombre;
  String lugar;
  String local;
  String direccion;
  String telefono;
  String sucursal;
  DateTime fechaIngreso;
  DateTime fechaUltimaCompra;
  int cupo;
  String ciudadCodigo;
  String zona;
  String bloqueado;
  DateTime bloqueadoFecha;
  String nombreRepresentante;
  int plazo;
  String escalaFactura;
  String observaciones;
  int clienteId;
  Usuario cliente;
  List<Usuario> vendedores;
  DateTime createdAt;
  DateTime updatedAt;

  // Nuevo Pedido
  int stock = 0;

  factory Tienda.fromJson(Map<String, dynamic> json) => Tienda(
        id: json["id_tiendas"],
        nombre: json["nombre"],
        lugar: json["lugar"],
        local: json["local"] ?? '',
        direccion: json["direccion"] ?? '',
        telefono: json["telefono"] ?? '',
        sucursal: json["sucursal"],
        fechaIngreso: json["fecha_ingreso"] != null
            ? DateTime.parse(json["fecha_ingreso"])
            : DateTime.now(),
        fechaUltimaCompra: json["fecha_ultima_compra"] != null
            ? DateTime.parse(json["fecha_ultima_compra"])
            : DateTime.now(),
        cupo: json["cupo"],
        ciudadCodigo: json["ciudad_codigo"],
        zona: json["zona"],
        bloqueado: json["bloqueado"],
        bloqueadoFecha: json["bloqueado_fecha"] != null
            ? DateTime.parse(json["bloqueado_fecha"])
            : null,
        nombreRepresentante: json["nombre_representante"] ?? '',
        plazo: json["plazo"],
        escalaFactura: json["escala_factura"],
        observaciones: json["observaciones"] ?? '',
        clienteId: json["cliente_id"],
        cliente:
            json["cliente"] != null ? Usuario.fromJson(json["cliente"]) : null,
        vendedores: json["vendedores"] != null
            ? List<Usuario>.from(
                json["vendedores"].map((x) => Usuario.fromJson(x)))
            : [],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_tiendas": id,
        "nombre": nombre,
        "lugar": lugar,
        "local": local ?? '',
        "direccion": direccion ?? '',
        "telefono": telefono ?? '',
        "cliente_id": clienteId,
        "sucursal": sucursal,
        "fecha_ingreso": fechaIngreso.toIso8601String(),
        "fecha_ultima_compra": fechaUltimaCompra.toIso8601String(),
        "cupo": cupo,
        "ciudad_codigo": ciudadCodigo,
        "zona": zona,
        "bloqueado": bloqueado,
        "bloqueado_fecha": bloqueadoFecha != null
            ? "${bloqueadoFecha.year.toString().padLeft(4, '0')}-${bloqueadoFecha.month.toString().padLeft(2, '0')}-${bloqueadoFecha.day.toString().padLeft(2, '0')}"
            : null,
        "nombre_representante": nombreRepresentante,
        "plazo": plazo,
        "escala_factura": escalaFactura,
        "observaciones": observaciones,
        "cliente": cliente != null ? cliente.toJson() : null,
        "vendedores": vendedores != null
            ? List<dynamic>.from(vendedores.map((x) => x.toJson()))
            : [],
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  Map<String, dynamic> toStoreFormJson() => {
        "nombre": nombre,
        "lugar": lugar,
        "local": local,
        "direccion": direccion,
        "telefono": telefono,
      };
}
