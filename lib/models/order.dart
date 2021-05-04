import 'package:flutter/material.dart';
import 'package:montana_mobile/utils/utils.dart';

class Order {
  int id;
  DateTime date;
  String code;
  double total;
  Status status;
  Client client;
  Seller seller;

  Order({this.id, this.date, this.code, this.total});

  get dateFormatted {
    final String year = date.year.toString();
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return "$day / $month / $year";
  }
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

  Seller({this.name, this.lastname});
}

class Client {
  String name;
  String lastname;

  Client({this.name, this.lastname});

  String get fullname => "$name $lastname";
}

List<Order> ordersListTest() {
  List<Map<String, dynamic>> list = [
    {
      "id_pedido": 23,
      "fecha": "2020-10-27",
      "codigo": "5f9876ea33765",
      "total": 1171500,
      "name_vendedor": "Carlos",
      "apellido_vendedor": "Duque",
      "name_cliente": "Juan Jose",
      "apellido_cliente": "Borrero",
      "estado": "cancelado",
      "id_estado": 3
    },
    {
      "id_pedido": 24,
      "fecha": "2021-01-07",
      "codigo": "5ff7308a94ab7",
      "total": -450000,
      "name_vendedor": "Alejandro",
      "apellido_vendedor": "Duque",
      "name_cliente": "Daniel",
      "apellido_cliente": "Martinez",
      "estado": "entregado",
      "id_estado": 1
    },
    {
      "id_pedido": 25,
      "fecha": "2021-01-07",
      "codigo": "5ff7315b68f8b",
      "total": 294000,
      "name_vendedor": "Carlos",
      "apellido_vendedor": "Duque",
      "name_cliente": "Daniel",
      "apellido_cliente": "Martinez",
      "estado": "cancelado",
      "id_estado": 3
    },
    {
      "id_pedido": 26,
      "fecha": "2021-01-07",
      "codigo": "5ff731df74912",
      "total": 288000,
      "name_vendedor": "Carlos",
      "apellido_vendedor": "Duque",
      "name_cliente": "Juan Jose",
      "apellido_cliente": "Borrero",
      "estado": "cancelado",
      "id_estado": 3
    },
    {
      "id_pedido": 27,
      "fecha": "2021-01-07",
      "codigo": "5ff759dea2ac7",
      "total": 582000,
      "name_vendedor": "Carlos",
      "apellido_vendedor": "Duque",
      "name_cliente": "Juan Jose",
      "apellido_cliente": "Borrero",
      "estado": "pendiente",
      "id_estado": 2
    },
    {
      "id_pedido": 28,
      "fecha": "2021-01-25",
      "codigo": "600e3a06860f9",
      "total": 297000,
      "name_vendedor": "sandra ximena",
      "apellido_vendedor": "gonzalez",
      "name_cliente": "Juan Jose",
      "apellido_cliente": "Borrero",
      "estado": "entregado",
      "id_estado": 1
    },
    {
      "id_pedido": 29,
      "fecha": "2021-01-25",
      "codigo": "600e3a9ee494e",
      "total": 450000,
      "name_vendedor": "sandra ximena",
      "apellido_vendedor": "gonzalez",
      "name_cliente": "Juan Jose",
      "apellido_cliente": "Borrero",
      "estado": "cancelado",
      "id_estado": 3
    },
    {
      "id_pedido": 30,
      "fecha": "2021-02-26",
      "codigo": "6039240faeecc",
      "total": 6123185625000,
      "name_vendedor": "Juan Camilo2",
      "apellido_vendedor": "Salazar Duque",
      "name_cliente": "Cliente 1",
      "apellido_cliente": "cli",
      "estado": "pendiente",
      "id_estado": 2
    },
    {
      "id_pedido": 31,
      "fecha": "2021-02-26",
      "codigo": "603925eac257c",
      "total": 36750000,
      "name_vendedor": "Juan Camilo2",
      "apellido_vendedor": "Salazar Duque",
      "name_cliente": "Cliente 1",
      "apellido_cliente": "cli",
      "estado": "pendiente",
      "id_estado": 2
    },
    {
      "id_pedido": 32,
      "fecha": "2021-02-26",
      "codigo": "6039276fbd9b0",
      "total": 53980500,
      "name_vendedor": "Juan Camilo2",
      "apellido_vendedor": "Salazar Duque",
      "name_cliente": "Cliente 1",
      "apellido_cliente": "cli",
      "estado": "pendiente",
      "id_estado": 2
    },
    {
      "id_pedido": 33,
      "fecha": "2021-03-31",
      "codigo": "6064a56a34556",
      "total": 1950000,
      "name_vendedor": "Nelson",
      "apellido_vendedor": "Zambrano",
      "name_cliente": "Diego",
      "apellido_cliente": "Ramirez",
      "estado": "entregado",
      "id_estado": 1
    },
    {
      "id_pedido": 34,
      "fecha": "2021-03-31",
      "codigo": "6064aa809d9d7",
      "total": 85500000,
      "name_vendedor": "Nelson",
      "apellido_vendedor": "Zambrano",
      "name_cliente": "Diego",
      "apellido_cliente": "Ramirez",
      "estado": "cancelado",
      "id_estado": 3
    },
    {
      "id_pedido": 35,
      "fecha": "2021-04-05",
      "codigo": "606b6388c1884",
      "total": 0,
      "name_vendedor": "Alejandro",
      "apellido_vendedor": "Duque",
      "name_cliente": "Daniel",
      "apellido_cliente": "Martinez",
      "estado": "pendiente",
      "id_estado": 2
    },
    {
      "id_pedido": 36,
      "fecha": "2021-04-08",
      "codigo": "606f37e61b0c8",
      "total": 3420000,
      "name_vendedor": "Nelson",
      "apellido_vendedor": "Zambrano",
      "name_cliente": "Diego",
      "apellido_cliente": "Ramirez",
      "estado": "pendiente",
      "id_estado": 2
    },
    {
      "id_pedido": 37,
      "fecha": "2021-04-09",
      "codigo": "6070c3c64994e",
      "total": 0,
      "name_vendedor": "Alejandro",
      "apellido_vendedor": "Duque",
      "name_cliente": "Andres",
      "apellido_cliente": "vaquiro",
      "estado": "pendiente",
      "id_estado": 2
    },
    {
      "id_pedido": 38,
      "fecha": "2021-04-12",
      "codigo": "607457f9d7000",
      "total": 300000,
      "name_vendedor": "Carlos",
      "apellido_vendedor": "Duque",
      "name_cliente": "Daniel",
      "apellido_cliente": "Martinez",
      "estado": "pendiente",
      "id_estado": 2
    },
    {
      "id_pedido": 39,
      "fecha": "2021-04-26",
      "codigo": "60873b64ba76a",
      "total": 873000,
      "name_vendedor": "sandra ximena",
      "apellido_vendedor": "gonzalez",
      "name_cliente": "Andres",
      "apellido_cliente": "vaquiro",
      "estado": "pendiente",
      "id_estado": 2
    },
    {
      "id_pedido": 40,
      "fecha": "2021-04-27",
      "codigo": "60881c8cb6e7a",
      "total": 873000,
      "name_vendedor": "sandra ximena",
      "apellido_vendedor": "gonzalez",
      "name_cliente": "Daniel",
      "apellido_cliente": "Martinez",
      "estado": "pendiente",
      "id_estado": 2
    },
    {
      "id_pedido": 41,
      "fecha": "2021-04-30",
      "codigo": "608c60c65c5fc",
      "total": 1152000,
      "name_vendedor": "Vendedor",
      "apellido_vendedor": "Montana",
      "name_cliente": "Nelson",
      "apellido_cliente": "Cliente",
      "estado": "entregado",
      "id_estado": 1
    }
  ];

  List<Order> listOrders = [];

  list.forEach((element) {
    var order = Order(
      id: int.parse(element["id_pedido"].toString()),
      date: DateTime.parse(element["fecha"]),
      code: element["codigo"],
      total: double.parse(element["total"].toString()),
    );
    order.seller = Seller(
      name: element["name_vendedor"],
      lastname: element["apellido_vendedor"],
    );
    order.client = Client(
      name: element["name_cliente"],
      lastname: element["apellido_cliente"],
    );
    order.status = Status(
      id: int.parse(element["id_estado"].toString()),
      status: element["estado"],
    );

    listOrders.add(order);
  });

  return listOrders;
}
