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
  String codigo;
  String firma;
  int clienteId;
  String metodoPago;
  double subTotal;
  double total;
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
        firma: json["firma"] ?? null,
        codigo: json["codigo"],
        total: double.parse(json["total"].toString()),
        estado: estadoValues.map[json["estado"]],
        idEstado: json["id_estado"],
        nameVendedor: json["name_vendedor"] ?? null,
        apellidoVendedor: json["apellido_vendedor"] ?? null,
        nameCliente: json["name_cliente"] ?? null,
        apellidoCliente: json["apellido_cliente"] ?? null,
        descuento: json["descuento"] ?? null,
        notas: json["notas"] ?? null,
        vendedorId: json["vendedor"] ?? null,
        metodoPago: json["metodo_pago"] ?? null,
        subTotal: json.containsKey("sub_total")
            ? double.parse(json["sub_total"].toString())
            : null,
        clienteId: json["cliente"] ?? null,
        cliente: json.containsKey("info_cliente")
            ? Cliente.fromJson(json["info_cliente"])
            : null,
        productos: json.containsKey("productos")
            ? List<PedidoProducto>.from(
                json["productos"].map((x) => PedidoProducto.fromJson(x)))
            : [],
        novedades: json.containsKey("novedades")
            ? List<Novedad>.from(
                json["novedades"].map((x) => Novedad.fromJson(x)))
            : [],
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
        "metodo_pago": metodoPago,
        "sub_total": subTotal,
        "descuento": descuento,
        "notas": notas,
        "vendedor": vendedorId,
        "cliente": clienteId,
        "info_cliente": cliente != null ? cliente.toJson() : null,
        "productos": productos != null
            ? List<dynamic>.from(productos.map((x) => x.toJson()))
            : [],
        "novedades": novedades != null
            ? List<dynamic>.from(novedades.map((x) => x.toJson()))
            : [],
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
    String temp = estado.toString().split('.')[1].toLowerCase();
    String firstLetter = temp.substring(0, 1).toUpperCase();
    String word = firstLetter + temp.substring(1, temp.length);
    return word;
  }
}
