import 'dart:convert';
import 'package:montana_mobile/models/message.dart';
import 'package:montana_mobile/models/ticket_order.dart';

ResponseTickets responseTicketsFromJson(String str) =>
    ResponseTickets.fromJson(json.decode(str));

String responseTicketsToJson(ResponseTickets data) =>
    json.encode(data.toJson());

ResponseTicket responseTicketFromJson(String str) =>
    ResponseTicket.fromJson(json.decode(str));

String responseTicketToJson(ResponseTicket data) => json.encode(data.toJson());

class ResponseTicket {
  ResponseTicket({
    this.response,
    this.status,
    this.ticket,
  });

  String response;
  int status;
  Ticket ticket;

  factory ResponseTicket.fromJson(Map<String, dynamic> json) => ResponseTicket(
        response: json["response"],
        status: json["status"],
        ticket: Ticket.fromJson(json["pqrs"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "pqrs": ticket.toJson(),
      };
}

class ResponseTickets {
  ResponseTickets({
    this.response,
    this.status,
    this.tickets,
  });

  String response;
  int status;
  List<Ticket> tickets;

  factory ResponseTickets.fromJson(Map<String, dynamic> json) =>
      ResponseTickets(
        response: json["response"],
        status: json["status"],
        tickets: List<Ticket>.from(json["pqrs"].map((x) => Ticket.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "pqrs": List<dynamic>.from(tickets.map((x) => x.toJson())),
      };
}

class Ticket {
  Ticket({
    this.idPqrs,
    this.codigo,
    this.fechaRegistro,
    this.idVendedor,
    this.idCliente,
    this.nameVendedor,
    this.apellidosVendedor,
    this.nameCliente,
    this.apellidosCliente,
    this.estado,
    this.mensajes,
    this.pedidos,
  });

  int idPqrs;
  String codigo;
  DateTime fechaRegistro;
  int idVendedor;
  int idCliente;
  String nameVendedor;
  String apellidosVendedor;
  String nameCliente;
  String apellidosCliente;
  String estado;
  List<Mensaje> mensajes;
  List<TicketPedido> pedidos;

  String get clienteNombre => "$nameCliente $apellidosCliente";
  String get vendedorNombre => "$nameVendedor $apellidosVendedor";

  String get iniciales {
    List<String> words = clienteNombre.split(" ");

    if (words.length == 1) {
      return words[0].substring(0, 2).toUpperCase();
    } else if (words.length > 1) {
      String c1 = words[0].substring(0, 1);
      String c2 = words[1].substring(0, 1);
      return "$c1$c2";
    }

    return "CL";
  }

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        idPqrs: json["id_pqrs"],
        codigo: json["codigo"],
        fechaRegistro: DateTime.parse(json["fecha_registro"]),
        nameVendedor: json["name_vendedor"],
        apellidosVendedor: json["apellidos_vendedor"],
        nameCliente: json["name_cliente"],
        apellidosCliente: json["apellidos_cliente"],
        estado: json["estado"],
        idVendedor: json["vendedor"] ?? null,
        idCliente: json["cliente"] ?? null,
        mensajes: json["messages_pqrs"] != null
            ? List<Mensaje>.from(
                json["messages_pqrs"].map((x) => Mensaje.fromJson(x)))
            : [],
        pedidos: json["pedidos"] != null
            ? List<TicketPedido>.from(
                json["pedidos"].map((x) => TicketPedido.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id_pqrs": idPqrs,
        "codigo": codigo,
        "fecha_registro":
            "${fechaRegistro.year.toString().padLeft(4, '0')}-${fechaRegistro.month.toString().padLeft(2, '0')}-${fechaRegistro.day.toString().padLeft(2, '0')}",
        "name_vendedor": nameVendedor,
        "apellidos_vendedor": apellidosVendedor,
        "name_cliente": nameCliente,
        "apellidos_cliente": apellidosCliente,
        "estado": estado,
        "vendedor": idVendedor,
        "cliente": idCliente,
        "messages_pqrs": List<dynamic>.from(mensajes.map((x) => x.toJson())),
        "pedidos": List<dynamic>.from(pedidos.map((x) => x.toJson())),
      };
}
