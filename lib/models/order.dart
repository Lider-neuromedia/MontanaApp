import 'package:flutter/material.dart';
import 'dart:convert';

ResponseOrders responsePedidosFromJson(String str) =>
    ResponseOrders.fromJson(json.decode(str));

String responsePedidosToJson(ResponseOrders data) => json.encode(data.toJson());

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

class Pedido {
  Pedido({
    this.idPedido,
    this.fecha,
    this.firma,
    this.codigo,
    this.total,
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
  String nameVendedor;
  String apellidoVendedor;
  String nameCliente;
  String apellidoCliente;
  Estado estado;
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

// TODO: BORRAR LO DE ABAJO ------------------------------------------------

class Order {
  int id;
  DateTime date;
  String code;
  double total;
  Status status;
  Client client;
  Seller seller;

  Order({
    this.id,
    this.date,
    this.code,
    this.total,
  });

  String paymentMethod;
  double subTotal;
  int discount;
  String notes;
  List<OrderProduct> products;
  List<Novelty> novelties;

  Order.detail({
    this.id,
    this.date,
    this.code,
    this.total,
    this.paymentMethod,
    this.subTotal,
    this.discount,
    this.notes,
  });

  get dateFormatted {
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return "$day / $month / $year";
  }
}

class OrderProduct {
  String reference;
  int productQuantity;
  String place;

  OrderProduct({
    this.reference,
    this.productQuantity,
    this.place,
  });
}

class Novelty {
  int id;
  String type;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  Novelty({
    this.id,
    this.type,
    this.description,
    this.createdAt,
    this.updatedAt,
  });
}

class Status {
  int id;
  String status;

  Status({this.id, this.status});

  get color {
    Color statusColor = Color.fromRGBO(109, 109, 109, 1.0);

    if (status == 'entregado') {
      statusColor = Color.fromRGBO(55, 202, 8, 1.0);
    } else if (status == 'cancelado') {
      statusColor = Color.fromRGBO(229, 10, 32, 1.0);
    }

    return statusColor;
  }

  String get statusFormatted {
    String temp = status.toLowerCase().trim();
    String firstLetter = temp.substring(0, 1).toUpperCase();
    String word = firstLetter + temp.substring(1, temp.length);
    return word;
  }
}

class Seller {
  String name;
  String lastname;

  Seller({
    this.name,
    this.lastname,
  });
}

class Client {
  String name;
  String lastname;

  Client({
    this.name,
    this.lastname,
  });

  int id;
  int rolId;
  String email;
  String identificationType;
  String dni;
  String nit;

  Client.orderDetail({
    this.id,
    this.name,
    this.lastname,
    this.rolId,
    this.email,
    this.identificationType,
    this.dni,
    this.nit,
  });
  String get fullname => "$name $lastname";
}

Order orderDetailTest() {
  Map<String, dynamic> element = {
    "id_pedido": 23,
    "fecha": "2020-10-27",
    "codigo": "5f9876ea33765",
    "metodo_pago": "contado",
    "sub_total": 1650000,
    "total": 495000,
    "descuento": 70,
    "notas": "Ninguna",
    "vendedor": 3,
    "estado": "cancelado",
    "id_estado": 3,
    "cliente": 4,
    "info_cliente": {
      "id": 4,
      "rol_id": 3,
      "name": "Juan Jose",
      "apellidos": "Borrero",
      "email": "emanuel@gmail.com",
      "tipo_identificacion": "Cedula",
      "dni": "42424425",
      "email_verified_at": null,
      "created_at": "2020-07-30 02:18:47",
      "updated_at": "2021-01-25 03:20:40",
      "nit": "6516516"
    },
    "productos": [
      {"referencia": "ATH-30303", "cantidad_producto": 3, "lugar": "unico 2"},
      {"referencia": "ATH-30303", "cantidad_producto": 5, "lugar": "Unicentro"}
    ],
    "novedades": [
      {
        "id_novedad": 6,
        "tipo": "retraso en envio",
        "descripcion": "Hubo retraso",
        "pedido": 23,
        "created_at": "2020-10-28 23:17:58",
        "updated_at": "2020-10-28 23:17:58"
      },
      {
        "id_novedad": 7,
        "tipo": "retraso en envio",
        "descripcion": "PRUEBA1",
        "pedido": 23,
        "created_at": "2021-01-07 18:44:09",
        "updated_at": "2021-01-07 18:44:09"
      },
      {
        "id_novedad": 23,
        "tipo": "retraso en envio",
        "descripcion": "Prueba 1",
        "pedido": 23,
        "created_at": "2021-03-30 19:21:13",
        "updated_at": "2021-03-30 19:21:13"
      },
      {
        "id_novedad": 24,
        "tipo": "retraso en envío",
        "descripcion": "prueba 2",
        "pedido": 23,
        "created_at": "2021-03-30 19:21:50",
        "updated_at": "2021-03-30 19:21:50"
      },
      {
        "id_novedad": 25,
        "tipo": "retraso en envío",
        "descripcion": "Prueba 3",
        "pedido": 23,
        "created_at": "2021-03-30 19:39:17",
        "updated_at": "2021-03-30 19:39:17"
      },
      {
        "id_novedad": 26,
        "tipo": "retraso en envío",
        "descripcion": "Prueba 4",
        "pedido": 23,
        "created_at": "2021-03-30 19:42:37",
        "updated_at": "2021-03-30 19:42:37"
      },
      {
        "id_novedad": 28,
        "tipo": "retraso en envío",
        "descripcion": "Prueba 8",
        "pedido": 23,
        "created_at": "2021-04-05 23:02:22",
        "updated_at": "2021-04-05 23:02:22"
      },
      {
        "id_novedad": 29,
        "tipo": "retraso en envío",
        "descripcion": "Prueba 8",
        "pedido": 23,
        "created_at": "2021-04-06 22:59:17",
        "updated_at": "2021-04-06 22:59:17"
      }
    ]
  };

  var order = Order.detail(
    id: element["id_pedido"],
    date: DateTime.parse(element["fecha"]),
    code: element["codigo"],
    paymentMethod: element["metodo_pago"],
    subTotal: double.parse(element["sub_total"].toString()),
    total: double.parse(element["total"].toString()),
    discount: element["descuento"],
    notes: element["notas"],
  );

  var elementClient = element["info_cliente"];

  order.client = Client.orderDetail(
    id: elementClient["id"],
    name: elementClient["name"],
    lastname: elementClient["apellidos"],
    rolId: elementClient["rol_id"],
    email: elementClient["email"],
    identificationType: elementClient["tipo_identificacion"],
    dni: elementClient["dni"],
    nit: elementClient["nit"],
  );

  order.status = Status(
    id: int.parse(element["id_estado"].toString()),
    status: element["estado"],
  );

  order.products = [];
  order.novelties = [];

  if (element['productos'] != null) {
    List dataProducts = element['productos'];
    dataProducts.forEach((elementProduct) {
      order.products.add(OrderProduct(
        reference: elementProduct["referencia"],
        place: elementProduct["lugar"],
        productQuantity: elementProduct["cantidad_producto"],
      ));
    });
  }

  if (element['novedades'] != null) {
    List dataNovelties = element['novedades'];
    dataNovelties.forEach((elementNovelty) {
      order.novelties.add(Novelty(
        id: elementNovelty["id_novedad"],
        type: elementNovelty["tipo"],
        description: elementNovelty["descripcion"],
        createdAt: DateTime.parse(elementNovelty["created_at"]),
        updatedAt: DateTime.parse(elementNovelty["updated_at"]),
      ));
    });
  }

  return order;
}
