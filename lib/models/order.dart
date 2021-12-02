import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:montana_mobile/models/client.dart';
import 'package:montana_mobile/models/novelty.dart';
import 'package:montana_mobile/models/order_product.dart';
import 'package:montana_mobile/models/status.dart';

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
        pedido: Pedido.fromJson(json["pedido"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "pedido": pedido.toJson(),
      };
}

class Pedido {
  Pedido({
    this.idPedido,
    this.fecha,
    this.firma,
    this.codigo,
    this.metodoPago,
    this.subTotal,
    this.total,
    this.descuento,
    this.notas,
    this.idEstado,
    this.clienteId,
    this.vendedorId,
    this.productos,
    this.novedades,
    this.nameVendedor,
    this.apellidoVendedor,
    this.nameCliente,
    this.apellidoCliente,
    this.cliente,
    this.estado,
    this.createdAt,
    this.updatedAt,
  });

  int idPedido;
  DateTime fecha;
  String firma;
  String codigo;
  int clienteId;
  String metodoPago;
  double subTotal;
  double total;
  int descuento;
  String notas;
  int idEstado;
  int vendedorId;
  String nameVendedor;
  String apellidoVendedor;
  String nameCliente;
  String apellidoCliente;
  Cliente cliente;
  Estado estado;
  List<PedidoProducto> productos;
  List<Novedad> novedades;
  DateTime createdAt;
  DateTime updatedAt;

  factory Pedido.fromJson(Map<String, dynamic> json) {
    int temporalEstadoId;
    Estado temporalEstado;

    if (json.containsKey("id_estado")) {
      temporalEstadoId = json["id_estado"];
      temporalEstado = estadoValues.map[json["estado"]];
    } else if (json.containsKey("estado")) {
      if (int.tryParse(json["estado"].toString()) != null) {
        temporalEstadoId = int.parse(json["estado"].toString());
        temporalEstado = estadoValuesById[temporalEstadoId];
      }
    }

    return Pedido(
      idPedido: json["id_pedido"],
      fecha: DateTime.parse(json["fecha"]),
      firma: json["firma"] ?? null,
      codigo: json["codigo"],
      metodoPago: json["metodo_pago"] ?? null,
      total: double.parse(json["total"].toString()),
      subTotal: json["sub_total"] != null
          ? double.parse(json["sub_total"].toString())
          : null,
      descuento: json["descuento"] ?? null,
      notas: json["notas"] ?? null,
      vendedorId: json["vendedor"] ?? null,
      clienteId: json["cliente"] ?? null,
      idEstado: temporalEstadoId,
      estado: temporalEstado,
      cliente: json["info_cliente"] != null
          ? Cliente.fromJson(json["info_cliente"])
          : null,
      nameVendedor: json["name_vendedor"] ?? '',
      apellidoVendedor: json["apellido_vendedor"] ?? '',
      nameCliente: json["name_cliente"] ?? '',
      apellidoCliente: json["apellido_cliente"] ?? '',
      productos: json["productos"] != null
          ? List<PedidoProducto>.from(
              json["productos"].map((x) => PedidoProducto.fromJson(x)))
          : [],
      novedades: json["novedades"] != null
          ? List<Novedad>.from(
              json["novedades"].map((x) => Novedad.fromJson(x)))
          : [],
      createdAt: json["created_at"] != null
          ? DateTime.parse(json["created_at"])
          : DateTime.now(),
      updatedAt: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id_pedido": idPedido,
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "firma": firma,
        "codigo": codigo,
        "metodo_pago": metodoPago,
        "total": total,
        "sub_total": subTotal,
        "descuento": descuento,
        "notas": notas ?? null,
        "vendedor": vendedorId,
        "cliente": clienteId ?? null,
        "id_estado": idEstado,
        "estado": estadoValues.reverse[estado],
        "info_cliente": cliente != null ? cliente.toJson() : null,
        "name_vendedor": nameVendedor,
        "apellido_vendedor": apellidoVendedor,
        "name_cliente": nameCliente,
        "apellido_cliente": apellidoCliente,
        "productos": productos != null
            ? List<dynamic>.from(productos.map((x) => x.toJson()))
            : [],
        "novedades": novedades != null
            ? List<dynamic>.from(novedades.map((x) => x.toJson()))
            : [],
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  String get clienteNombre => "$nameCliente $apellidoCliente";

  Color get estadoColor {
    Color statusColor = const Color.fromRGBO(109, 109, 109, 1.0);

    if (estado == Estado.ENTREGADO) {
      statusColor = const Color.fromRGBO(55, 202, 8, 1.0);
    } else if (estado == Estado.CANCELADO) {
      statusColor = const Color.fromRGBO(229, 10, 32, 1.0);
    }

    return statusColor;
  }

  String get estadoFormatted {
    final temp = estado.toString().split('.')[1].toLowerCase();
    final firstLetter = temp.substring(0, 1).toUpperCase();
    final word = firstLetter + temp.substring(1, temp.length);
    return word;
  }
}
