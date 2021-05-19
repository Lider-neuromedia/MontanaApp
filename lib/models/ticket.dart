import 'dart:convert';

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
        ticket: Ticket.detailFromJson(json["pqrs"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "pqrs": ticket.detailToJson(),
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

    return 'CL';
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
      };

  factory Ticket.detailFromJson(Map<String, dynamic> json) => Ticket(
        idPqrs: json["id_pqrs"],
        codigo: json["codigo"],
        fechaRegistro: DateTime.parse(json["fecha_registro"]),
        idVendedor: json["vendedor"],
        idCliente: json["cliente"],
        nameVendedor: json["name_vendedor"],
        apellidosVendedor: json["apellidos_vendedor"],
        nameCliente: json["name_cliente"],
        apellidosCliente: json["apellidos_cliente"],
        estado: json["estado"],
        mensajes: List<Mensaje>.from(
            json["messages_pqrs"].map((x) => Mensaje.fromJson(x))),
        pedidos: List<TicketPedido>.from(
            json["pedidos"].map((x) => TicketPedido.fromJson(x))),
      );

  Map<String, dynamic> detailToJson() => {
        "id_pqrs": idPqrs,
        "codigo": codigo,
        "fecha_registro":
            "${fechaRegistro.year.toString().padLeft(4, '0')}-${fechaRegistro.month.toString().padLeft(2, '0')}-${fechaRegistro.day.toString().padLeft(2, '0')}",
        "vendedor": idVendedor,
        "cliente": idCliente,
        "name_vendedor": nameVendedor,
        "apellidos_vendedor": apellidosVendedor,
        "name_cliente": nameCliente,
        "apellidos_cliente": apellidosCliente,
        "estado": estado,
        "messages_pqrs": List<dynamic>.from(mensajes.map((x) => x.toJson())),
        "pedidos": List<dynamic>.from(pedidos.map((x) => x.toJson())),
      };
}

class Mensaje {
  Mensaje({
    this.idSeguimiento,
    this.idUsuario,
    this.idTicket,
    this.mensaje,
    this.hora,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.apellidos,
    this.rolId,
    this.iniciales,
    this.addressee,
  });

  int idSeguimiento;
  int idUsuario;
  int idTicket;
  String mensaje;
  String hora;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String apellidos;
  int rolId;
  String iniciales;
  bool addressee;

  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
        idSeguimiento: json["id_seguimiento"],
        idUsuario: json["usuario"],
        idTicket: json["pqrs"],
        mensaje: json["mensaje"],
        hora: json["hora"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"],
        apellidos: json["apellidos"],
        rolId: json["rol_id"],
        iniciales: json["iniciales"],
        addressee: json["addressee"],
      );

  Map<String, dynamic> toJson() => {
        "id_seguimiento": idSeguimiento,
        "usuario": idUsuario,
        "pqrs": idTicket,
        "mensaje": mensaje,
        "hora": hora,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "name": name,
        "apellidos": apellidos,
        "rol_id": rolId,
        "iniciales": iniciales,
        "addressee": addressee,
      };
}

class TicketPedido {
  TicketPedido({
    this.idPedido,
    this.fecha,
    this.codigo,
    this.metodoPago,
    this.subTotal,
    this.total,
    this.descuento,
    this.notas,
    this.firma,
    this.vendedor,
    this.cliente,
    this.estado,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.apellidos,
    this.rolId,
    this.iniciales,
  });

  int idPedido;
  DateTime fecha;
  String codigo;
  String metodoPago;
  int subTotal;
  int total;
  int descuento;
  String notas;
  dynamic firma;
  int vendedor;
  int cliente;
  int estado;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String apellidos;
  int rolId;
  String iniciales;

  factory TicketPedido.fromJson(Map<String, dynamic> json) => TicketPedido(
        idPedido: json["id_pedido"],
        fecha: DateTime.parse(json["fecha"]),
        codigo: json["codigo"],
        metodoPago: json["metodo_pago"],
        subTotal: json["sub_total"],
        total: json["total"],
        descuento: json["descuento"],
        notas: json["notas"] == null ? null : json["notas"],
        firma: json["firma"],
        vendedor: json["vendedor"],
        cliente: json["cliente"],
        estado: json["estado"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        name: json["name"],
        apellidos: json["apellidos"],
        rolId: json["rol_id"],
        iniciales: json["iniciales"],
      );

  Map<String, dynamic> toJson() => {
        "id_pedido": idPedido,
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "codigo": codigo,
        "metodo_pago": metodoPago,
        "sub_total": subTotal,
        "total": total,
        "descuento": descuento,
        "notas": notas == null ? null : notas,
        "firma": firma,
        "vendedor": vendedor,
        "cliente": cliente,
        "estado": estado,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "name": name,
        "apellidos": apellidos,
        "rol_id": rolId,
        "iniciales": iniciales,
      };
}
