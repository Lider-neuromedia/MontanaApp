import 'dart:convert';

ResponseMensaje responseMensajeFromJson(String str) =>
    ResponseMensaje.fromJson(json.decode(str));

String responseMensajeToJson(ResponseMensaje data) =>
    json.encode(data.toJson());

class ResponseMensaje {
  ResponseMensaje({
    this.response,
    this.status,
    this.mensaje,
  });

  String response;
  int status;
  Mensaje mensaje;

  factory ResponseMensaje.fromJson(Map<String, dynamic> json) =>
      ResponseMensaje(
        response: json["response"],
        status: json["status"],
        mensaje: Mensaje.fromJson(json["mensaje"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "status": status,
        "mensaje": mensaje.toJson(),
      };
}

class Mensaje {
  Mensaje({
    this.idSeguimiento,
    this.pqrs,
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
  int pqrs;
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
        pqrs: json["pqrs"],
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
        "pqrs": idTicket ?? pqrs,
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
