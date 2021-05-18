import 'package:flutter/material.dart';
import 'dart:convert';

ResponseOrders responsePedidosFromJson(String str) =>
    ResponseOrders.fromJson(json.decode(str));
ResponseOrder responsePedidoFromJson(String str) =>
    ResponseOrder.fromJson(json.decode(str));

String responsePedidosToJson(ResponseOrders data) => json.encode(data.toJson());
String responsePedidoToJson(ResponseOrder data) => json.encode(data.toJson());

class ResponseOrders {
  ResponseOrders({
    this.response,
    this.status,
    this.pedidos,
  });

  String response;
  int status;
  List<Pedido> pedidos;

  factory ResponseOrders.fromJson(Map<String, dynamic> json) => ResponseOrders(
        response: json["response"],
        status: json["status"],
        pedidos:
            List<Pedido>.from(json["pedidos"].map((x) => Pedido.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "pedidos": List<dynamic>.from(pedidos.map((x) => x.toJson())),
      };
}

class ResponseOrder {
  ResponseOrder({
    this.response,
    this.status,
    this.pedido,
  });

  String response;
  int status;
  Pedido pedido;

  factory ResponseOrder.fromJson(Map<String, dynamic> json) => ResponseOrder(
        response: json["response"],
        status: json["status"],
        pedido: Pedido.detailFromJson(json["pedido"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "pedido": pedido.detailToJson(),
      };
}

class Pedido {
  Pedido({
    this.idPedido,
    this.fecha,
    this.firma,
    this.codigo,
    this.total,
    this.descuento,
    this.notas,
    this.vendedorId,
    this.clienteId,
    this.cliente,
    this.productos,
    this.novedades,
    this.metodoPago,
    this.subTotal,
    this.nameVendedor,
    this.apellidoVendedor,
    this.nameCliente,
    this.apellidoCliente,
    this.estado,
    this.idEstado,
  });

  int idPedido;
  DateTime fecha;
  String firma;
  String codigo;
  double total;
  int clienteId;
  String metodoPago;
  double subTotal;
  int descuento;
  String notas;
  int vendedorId;
  String nameVendedor;
  String apellidoVendedor;
  String nameCliente;
  String apellidoCliente;
  Estado estado;
  Cliente cliente;
  List<PedidoProducto> productos;
  List<Novedad> novedades;
  int idEstado;

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        idPedido: json["id_pedido"],
        fecha: DateTime.parse(json["fecha"]),
        firma: json["firma"],
        codigo: json["codigo"],
        total: double.parse(json["total"].toString()),
        nameVendedor: json["name_vendedor"],
        apellidoVendedor: json["apellido_vendedor"],
        nameCliente: json["name_cliente"],
        apellidoCliente: json["apellido_cliente"],
        estado: estadoValues.map[json["estado"]],
        idEstado: json["id_estado"],
      );

  Map<String, dynamic> toJson() => {
        "id_pedido": idPedido,
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "firma": firma,
        "codigo": codigo,
        "total": total,
        "name_vendedor": nameVendedor,
        "apellido_vendedor": apellidoVendedor,
        "name_cliente": nameCliente,
        "apellido_cliente": apellidoCliente,
        "estado": estadoValues.reverse[estado],
        "id_estado": idEstado,
      };

  factory Pedido.detailFromJson(Map<String, dynamic> json) => Pedido(
        idPedido: json["id_pedido"],
        fecha: DateTime.parse(json["fecha"]),
        firma: json["firma"],
        codigo: json["codigo"],
        metodoPago: json["metodo_pago"],
        subTotal: double.parse(json["sub_total"].toString()),
        total: double.parse(json["total"].toString()),
        descuento: json["descuento"],
        notas: json["notas"],
        vendedorId: json["vendedor"],
        estado: estadoValues.map[json["estado"]],
        idEstado: json["id_estado"],
        clienteId: json["cliente"],
        cliente: Cliente.fromJson(json["info_cliente"]),
        productos: List<PedidoProducto>.from(
            json["productos"].map((x) => PedidoProducto.fromJson(x))),
        novedades: List<Novedad>.from(
            json["novedades"].map((x) => Novedad.fromJson(x))),
      );

  Map<String, dynamic> detailToJson() => {
        "id_pedido": idPedido,
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "firma": firma,
        "codigo": codigo,
        "metodo_pago": metodoPago,
        "sub_total": subTotal,
        "total": total,
        "descuento": descuento,
        "notas": notas,
        "vendedor": vendedorId,
        "estado": estadoValues.reverse[estado],
        "id_estado": idEstado,
        "cliente": clienteId,
        "info_cliente": cliente.toJson(),
        "productos": List<dynamic>.from(productos.map((x) => x.toJson())),
        "novedades": List<dynamic>.from(novedades.map((x) => x.toJson())),
      };

  String get clienteNombre => "$nameCliente $apellidoCliente";

  Color get estadoColor {
    Color statusColor = Color.fromRGBO(109, 109, 109, 1.0);

    if (estado == Estado.ENTREGADO) {
      statusColor = Color.fromRGBO(55, 202, 8, 1.0);
    } else if (estado == Estado.CANCELADO) {
      statusColor = Color.fromRGBO(229, 10, 32, 1.0);
    }

    return statusColor;
  }

  String get estadoFormatted {
    String temp = estado.toString().split('.')[1].toLowerCase();
    String firstLetter = temp.substring(0, 1).toUpperCase();
    String word = firstLetter + temp.substring(1, temp.length);
    return word;
  }
}

enum Estado { ENTREGADO, PENDIENTE, CANCELADO }

final estadoValues = EnumValues({
  "cancelado": Estado.CANCELADO,
  "entregado": Estado.ENTREGADO,
  "pendiente": Estado.PENDIENTE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}

class Cliente {
  Cliente({
    this.id,
    this.rolId,
    this.name,
    this.apellidos,
    this.email,
    this.tipoIdentificacion,
    this.dni,
    this.nit,
  });

  int id;
  int rolId;
  String name;
  String apellidos;
  String email;
  String tipoIdentificacion;
  String dni;
  String nit;

  String get nombreCompleto => "$name $apellidos";

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        rolId: json["rol_id"],
        name: json["name"],
        apellidos: json["apellidos"],
        email: json["email"],
        tipoIdentificacion: json["tipo_identificacion"],
        dni: json["dni"],
        nit: json["nit"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rol_id": rolId,
        "name": name,
        "apellidos": apellidos,
        "email": email,
        "tipo_identificacion": tipoIdentificacion,
        "dni": dni,
        "nit": nit,
      };
}

class Novedad {
  Novedad({
    this.idNovedad,
    this.tipo,
    this.descripcion,
    this.pedido,
    this.createdAt,
    this.updatedAt,
  });

  int idNovedad;
  String tipo;
  String descripcion;
  int pedido;
  DateTime createdAt;
  DateTime updatedAt;

  factory Novedad.fromJson(Map<String, dynamic> json) => Novedad(
        idNovedad: json["id_novedad"],
        tipo: json["tipo"],
        descripcion: json["descripcion"],
        pedido: json["pedido"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_novedad": idNovedad,
        "tipo": tipo,
        "descripcion": descripcion,
        "pedido": pedido,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

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
