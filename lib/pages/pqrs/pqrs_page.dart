import 'package:flutter/material.dart';
import 'package:montana_mobile/pages/catalogue/partials/empty_message.dart';
import 'package:montana_mobile/pages/catalogue/partials/loading_container.dart';
import 'package:montana_mobile/pages/pqrs/create_pqrs_page.dart';
import 'package:montana_mobile/pages/pqrs/partials/pqrs_card.dart';
import 'package:montana_mobile/pages/pqrs/partials/pqrs_filter.dart';
import 'package:montana_mobile/pages/pqrs/partials/search_box.dart';
import 'package:montana_mobile/providers/pqrs_provider.dart';
import 'package:montana_mobile/widgets/scaffold_logo.dart';
import 'package:provider/provider.dart';

class PqrsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PqrsProvider pqrsProvider = Provider.of<PqrsProvider>(context);
    final titleStyle = Theme.of(context).textTheme.headline6.copyWith(
          color: Colors.white,
        );

    return Scaffold(
      appBar: AppBar(
        title: ScaffoldLogo(),
        actions: [
          TextButton(
            onPressed: null,
            child: Text('Listado de PQRS', style: titleStyle),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
          ),
          SizedBox(width: 10.0),
        ],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(CreatePqrsPage.route);
        },
      ),
      body: pqrsProvider.isLoadingTickets
          ? const LoadingContainer()
          : pqrsProvider.tickets.length == 0
              ? EmptyMessage(
                  onPressed: () => pqrsProvider.loadTickets(),
                  message: 'No hay PQRS.',
                )
              : RefreshIndicator(
                  onRefresh: () => pqrsProvider.loadTickets(),
                  color: Theme.of(context).primaryColor,
                  child: _PqrsContent(),
                ),
    );
  }
}

class _PqrsContent extends StatelessWidget {
  const _PqrsContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PqrsProvider pqrsProvider = Provider.of<PqrsProvider>(context);
    return Column(
      children: [
        SearchBox(),
        PqrsFilter(),
        Expanded(
          child: ListView.separated(
            itemCount: pqrsProvider.tickets.length,
            padding: EdgeInsets.only(top: 15.0, bottom: 100.0),
            itemBuilder: (_, int index) {
              return PqrsCard(ticket: pqrsProvider.tickets[index]);
            },
            separatorBuilder: (_, int index) {
              return SizedBox(height: 20.0);
            },
          ),
        ),
      ],
    );
  }
}

class PqrsTemporal {
  int id;
  String code;
  DateTime datedAt;
  String status;
  ClientTemporal client;
  PqrsSellerTemporal seller;
  List<PqrsMessageTemporal> messages;

  PqrsTemporal(this.id, this.code, this.datedAt, this.status);
  PqrsTemporal.fromMessages({
    this.id,
    this.code,
    this.datedAt,
    this.status,
    this.seller,
    this.client,
  });
}

class PqrsSellerTemporal {
  int id;
  String name;
  String lastname;
  PqrsSellerTemporal(this.id, this.name, this.lastname);
}

class PqrsMessageTemporal {
  int id;
  int userId;
  int pqrsId;
  String message;
  String hour;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String lastname;
  int rolId;
  String initials;
  bool addressee;

  PqrsMessageTemporal({
    this.id,
    this.userId,
    this.pqrsId,
    this.message,
    this.hour,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.lastname,
    this.rolId,
    this.initials,
    this.addressee,
  });
}

class ClientTemporal {
  int id;
  String name;
  String code;
  ClientTemporal(this.id, this.name, this.code);

  String get initials {
    List<String> words = name.split(" ");

    if (words.length == 1) {
      return words[0].substring(0, 2).toUpperCase();
    } else if (words.length > 1) {
      String c1 = words[0].substring(0, 1);
      String c2 = words[1].substring(0, 1);
      return "$c1$c2";
    }

    return 'CL';
  }
}

List<ClientTemporal> clientsListTest() {
  return [
    ClientTemporal(1, 'Bejarano Garavito Bladimiro Alfonso', '464648654'),
    ClientTemporal(2, 'Ana María Urrutia Vasquez', '134467465'),
    ClientTemporal(3, 'Alicia Maldonado', '213216545'),
    ClientTemporal(4, 'Luis Restrepo', '798161354'),
    ClientTemporal(5, 'Alfonso Sallas', '715689485'),
    ClientTemporal(6, 'Julian Linarez Gonzalez', '363546156'),
    ClientTemporal(7, 'Laura Osorio', '846434645'),
  ];
}

List<PqrsTemporal> pqrsListTest() {
  List clients = clientsListTest();
  List<PqrsTemporal> pqrsList = [];

  clients.asMap().forEach((index, client) {
    final id = ((index + 1) * 2);
    final code = ((index + 5) * 798).toString();
    final datedAt = DateTime(2021, index + 1, index + 2 * 3);
    final status = index % 2 == 0 ? 'cerrado' : 'abierto';

    final pqrs = PqrsTemporal(id, code, datedAt, status);
    pqrs.seller = PqrsSellerTemporal(1, 'Oscar', 'Delmiro');
    pqrs.client = client;

    pqrsList.add(pqrs);
  });

  return pqrsList;
}

PqrsTemporal pqrsWithMessagesTest() {
  Map<String, dynamic> data = messagesData();

  PqrsTemporal pqrs = PqrsTemporal.fromMessages(
    id: data["id_pqrs"],
    code: data["codigo"],
    datedAt: DateTime.parse(data["fecha_registro"]),
    status: data["estado"],
    seller: PqrsSellerTemporal(
      data["vendedor"],
      data["name_vendedor"],
      data["apellidos_vendedor"],
    ),
    client: ClientTemporal(
      data["cliente"],
      data["name_cliente"],
      data["apellidos_cliente"],
    ),
  );

  pqrs.messages = [];

  data["messages_pqrs"].forEach((message) {
    pqrs.messages.add(PqrsMessageTemporal(
      id: message["id_seguimiento"],
      userId: message["usuario"],
      pqrsId: message["pqrs"],
      message: message["mensaje"],
      hour: message["hora"],
      createdAt: DateTime.parse(message["created_at"]),
      updatedAt: DateTime.parse(message["updated_at"]),
      name: message["name"],
      lastname: message["apellidos"],
      rolId: message["rol_id"],
      initials: message["iniciales"],
      addressee: message["addressee"],
    ));
  });

  return pqrs;
}

Map<String, dynamic> messagesData() {
  return {
    "id_pqrs": 1,
    "codigo": "afsadfer3",
    "fecha_registro": "2020-11-13",
    "vendedor": 3,
    "cliente": 4,
    "name_vendedor": "Carlos",
    "apellidos_vendedor": "Duque",
    "name_cliente": "Juan Jose",
    "apellidos_cliente": "Borrero",
    "estado": "cerrado",
    "messages_pqrs": [
      {
        "id_seguimiento": 1,
        "usuario": 4,
        "pqrs": 1,
        "mensaje": "Tengo problemas con el envio. Tiene un retrazo de 2 dias",
        "hora": "10:48",
        "created_at": "2020-11-13 10:48:50",
        "updated_at": "2020-11-13 10:48:51",
        "name": "Juan Jose",
        "apellidos": "Borrero",
        "rol_id": 3,
        "iniciales": "JB",
        "addressee": false
      },
      {
        "id_seguimiento": 2,
        "usuario": 3,
        "pqrs": 1,
        "mensaje":
            "El envio se efectuo el mismo dia del pedido. El retraso es por la empresa de despacho, ya que tiene problemas debido a la pandemia. ",
        "hora": "10:49",
        "created_at": "2020-11-13 10:49:55",
        "updated_at": "2020-11-13 10:49:47",
        "name": "Carlos",
        "apellidos": "Duque",
        "rol_id": 2,
        "iniciales": "CD",
        "addressee": true
      },
      {
        "id_seguimiento": 11,
        "usuario": 108,
        "pqrs": 1,
        "mensaje": "prueba mensaje admin",
        "hora": "15:39",
        "created_at": "2020-11-28 15:39:49",
        "updated_at": "2020-11-28 15:39:49",
        "name": "Emanuel",
        "apellidos": "Buendia",
        "rol_id": 1,
        "iniciales": "EB",
        "addressee": true
      },
      {
        "id_seguimiento": 12,
        "usuario": 108,
        "pqrs": 1,
        "mensaje": "prueba mensaje",
        "hora": "16:55",
        "created_at": "2020-12-02 16:55:11",
        "updated_at": "2020-12-02 16:55:11",
        "name": "Emanuel",
        "apellidos": "Buendia",
        "rol_id": 1,
        "iniciales": "EB",
        "addressee": true
      },
      {
        "id_seguimiento": 13,
        "usuario": 4,
        "pqrs": 1,
        "mensaje": "prueba mensaje",
        "hora": "03:40",
        "created_at": "2020-12-10 03:40:55",
        "updated_at": "2020-12-10 03:40:55",
        "name": "Juan Jose",
        "apellidos": "Borrero",
        "rol_id": 3,
        "iniciales": "JB",
        "addressee": false
      },
      {
        "id_seguimiento": 14,
        "usuario": 4,
        "pqrs": 1,
        "mensaje": "prueba mensaje...",
        "hora": "19:38",
        "created_at": "2020-12-10 19:38:30",
        "updated_at": "2020-12-10 19:38:30",
        "name": "Juan Jose",
        "apellidos": "Borrero",
        "rol_id": 3,
        "iniciales": "JB",
        "addressee": false
      },
      {
        "id_seguimiento": 15,
        "usuario": 3,
        "pqrs": 1,
        "mensaje": "prueba mensaje...2",
        "hora": "19:39",
        "created_at": "2020-12-10 19:39:23",
        "updated_at": "2020-12-10 19:39:23",
        "name": "Carlos",
        "apellidos": "Duque",
        "rol_id": 2,
        "iniciales": "CD",
        "addressee": true
      },
      {
        "id_seguimiento": 16,
        "usuario": 3,
        "pqrs": 1,
        "mensaje": "Desde la app",
        "hora": "20:00",
        "created_at": "2020-12-10 20:00:34",
        "updated_at": "2020-12-10 20:00:34",
        "name": "Carlos",
        "apellidos": "Duque",
        "rol_id": 2,
        "iniciales": "CD",
        "addressee": true
      },
      {
        "id_seguimiento": 17,
        "usuario": 3,
        "pqrs": 1,
        "mensaje": "Buenas tardes",
        "hora": "22:10",
        "created_at": "2020-12-10 22:10:56",
        "updated_at": "2020-12-10 22:10:56",
        "name": "Carlos",
        "apellidos": "Duque",
        "rol_id": 2,
        "iniciales": "CD",
        "addressee": true
      },
      {
        "id_seguimiento": 22,
        "usuario": 145,
        "pqrs": 1,
        "mensaje": "asdasda",
        "hora": "17:04",
        "created_at": "2021-02-26 17:04:22",
        "updated_at": "2021-02-26 17:04:22",
        "name": "admin juan",
        "apellidos": "salazar",
        "rol_id": 1,
        "iniciales": "as",
        "addressee": true
      },
      {
        "id_seguimiento": 31,
        "usuario": 146,
        "pqrs": 1,
        "mensaje": "Hola",
        "hora": "19:31",
        "created_at": "2021-04-09 19:31:09",
        "updated_at": "2021-04-09 19:31:09",
        "name": "Nelson",
        "apellidos": "Zambrano",
        "rol_id": 1,
        "iniciales": "NZ",
        "addressee": true
      },
      {
        "id_seguimiento": 33,
        "usuario": 146,
        "pqrs": 1,
        "mensaje": "Hola",
        "hora": "19:48",
        "created_at": "2021-04-09 19:48:36",
        "updated_at": "2021-04-09 19:48:36",
        "name": "Nelson",
        "apellidos": "Zambrano",
        "rol_id": 1,
        "iniciales": "NZ",
        "addressee": true
      },
      {
        "id_seguimiento": 34,
        "usuario": 146,
        "pqrs": 1,
        "mensaje": "Hola",
        "hora": "19:48",
        "created_at": "2021-04-09 19:48:38",
        "updated_at": "2021-04-09 19:48:38",
        "name": "Nelson",
        "apellidos": "Zambrano",
        "rol_id": 1,
        "iniciales": "NZ",
        "addressee": true
      },
      {
        "id_seguimiento": 43,
        "usuario": 145,
        "pqrs": 1,
        "mensaje": "Hola prueba 1",
        "hora": "20:43",
        "created_at": "2021-05-04 20:43:30",
        "updated_at": "2021-05-04 20:43:30",
        "name": "admin juan",
        "apellidos": "salazar",
        "rol_id": 1,
        "iniciales": "as",
        "addressee": true
      }
    ],
    "pedidos": [
      {
        "id_pedido": 23,
        "fecha": "2020-10-27",
        "codigo": "5f9876ea33765",
        "metodo_pago": "contado",
        "sub_total": 495000,
        "total": 495000,
        "descuento": 70,
        "notas": "Ninguna",
        "firma": null,
        "vendedor": 3,
        "cliente": 4,
        "estado": 3,
        "created_at": "2020-10-27 19:38:19",
        "updated_at": "2021-05-07 16:37:14",
        "name": "Juan Jose",
        "apellidos": "Borrero",
        "rol_id": 3,
        "iniciales": "JB"
      },
      {
        "id_pedido": 26,
        "fecha": "2021-01-07",
        "codigo": "5ff731df74912",
        "metodo_pago": "contado",
        "sub_total": 300000,
        "total": 288000,
        "descuento": 4,
        "notas": null,
        "firma": null,
        "vendedor": 3,
        "cliente": 4,
        "estado": 3,
        "created_at": "2021-01-07 16:13:54",
        "updated_at": "2021-04-06 23:13:20",
        "name": "Juan Jose",
        "apellidos": "Borrero",
        "rol_id": 3,
        "iniciales": "JB"
      },
      {
        "id_pedido": 27,
        "fecha": "2021-01-07",
        "codigo": "5ff759dea2ac7",
        "metodo_pago": "contado",
        "sub_total": 600000,
        "total": 582000,
        "descuento": 3,
        "notas": "prueba1.2",
        "firma": null,
        "vendedor": 3,
        "cliente": 4,
        "estado": 1,
        "created_at": "2021-01-07 19:01:39",
        "updated_at": "2021-05-07 12:35:00",
        "name": "Juan Jose",
        "apellidos": "Borrero",
        "rol_id": 3,
        "iniciales": "JB"
      }
    ],
  };
}
