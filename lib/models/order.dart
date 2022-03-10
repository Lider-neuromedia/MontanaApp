import 'dart:convert';
import 'package:montana_mobile/models/novelty.dart';
import 'package:montana_mobile/models/order_product.dart';
import 'package:montana_mobile/models/status.dart';
import 'package:montana_mobile/models/user.dart';

ResponseOrders responseOrdersFromJson(String str) =>
    ResponseOrders.fromJson(json.decode(str));

String responseOrdersToJson(ResponseOrders data) => json.encode(data.toJson());

ResponseOrder responseOrderFromJson(String str) =>
    ResponseOrder.fromJson(json.decode(str));

String responseOrderToJson(ResponseOrder data) => json.encode(data.toJson());

class ResponseOrders {
  ResponseOrders({
    this.pedidos,
    this.response,
    this.status,
  });

  Pedidos pedidos;
  String response;
  int status;

  factory ResponseOrders.fromJson(Map<String, dynamic> json) => ResponseOrders(
        pedidos: Pedidos.fromJson(json["pedidos"]),
        response: json["response"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "pedidos": pedidos.toJson(),
        "response": response,
        "status": status,
      };
}

class ResponseOrder {
  ResponseOrder({
    this.status,
    this.response,
    this.pedido,
  });

  int status;
  String response;
  Pedido pedido;

  factory ResponseOrder.fromJson(Map<String, dynamic> json) => ResponseOrder(
        status: json["status"],
        response: json["response"],
        pedido: Pedido.fromJson(json["pedido"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response,
        "pedido": pedido.toJson(),
      };
}

class Pedidos {
  Pedidos({
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
  List<Pedido> data;
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

  factory Pedidos.fromJson(Map<String, dynamic> json) => Pedidos(
        currentPage: json["current_page"],
        data: List<Pedido>.from(json["data"].map((x) => Pedido.fromJson(x))),
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

class Pedido {
  Pedido({
    this.id,
    this.fecha,
    this.codigo,
    this.total,
    this.firma,
    this.vendedor,
    this.cliente,
    this.estado,
    this.estadoId,
    this.vendedorId,
    this.clienteId,
    this.metodoPago,
    this.subTotal,
    this.notas,
    this.notasFacturacion,
    this.detalles,
    this.novedades,
  });

  int id;
  DateTime fecha;
  String codigo;
  double total;
  String firma;
  Usuario vendedor;
  Usuario cliente;
  Estado estado;
  int estadoId;
  int vendedorId;
  int clienteId;
  String metodoPago;
  double subTotal;
  String notas;
  String notasFacturacion;
  List<PedidoProducto> detalles;
  List<Novedad> novedades;

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        id: json["id_pedido"],
        fecha: DateTime.parse(json["fecha"]),
        codigo: json["codigo"],
        metodoPago: json["metodo_pago"] ?? '',
        total:
            json["total"] != null ? double.parse(json["total"].toString()) : 0,
        firma: json["firma"] ?? null,
        subTotal: json["sub_total"] != null
            ? double.parse(json["sub_total"].toString())
            : 0,
        vendedor: json["vendedor"] != null
            ? Usuario.fromJson(json["vendedor"])
            : null,
        cliente:
            json["cliente"] != null ? Usuario.fromJson(json["cliente"]) : null,
        estado: json["estado"] != null ? Estado.fromJson(json["estado"]) : null,
        vendedorId: json["vendedor_id"] ?? null,
        clienteId: json["cliente_id"] ?? null,
        estadoId: json["estado_id"],
        notas: json["notas"] ?? '',
        notasFacturacion: json["notas_facturacion"] ?? '',
        detalles: json["detalles"] != null
            ? List<PedidoProducto>.from(
                json["detalles"].map((x) => PedidoProducto.fromJson(x)))
            : [],
        novedades: json["novedades"] != null
            ? List<Novedad>.from(
                json["novedades"].map((x) => Novedad.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id_pedido": id,
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "codigo": codigo,
        "total": total,
        "firma": firma,
        "vendedor": vendedor != null ? vendedor.toJson() : null,
        "cliente": cliente != null ? cliente.toJson() : null,
        "estado": estado != null ? estado.toJson() : null,
        "estado_id": estadoId,
        "vendedor_id": vendedorId,
        "cliente_id": clienteId,
        "metodo_pago": metodoPago ?? '',
        "sub_total": subTotal,
        "notas": notas ?? '',
        "notas_facturacion": notasFacturacion ?? '',
        "detalles": detalles != null
            ? List<dynamic>.from(detalles.map((x) => x.toJson()))
            : [],
        "novedades": novedades != null
            ? List<dynamic>.from(novedades.map((x) => x.toJson()))
            : [],
      };
}
