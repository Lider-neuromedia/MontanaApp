import 'dart:convert';
import 'package:montana_mobile/models/user_data.dart';

Session sessionFromJson(String str) => Session.fromJson(json.decode(str));

String sessionToJson(Session data) => json.encode(data.toJson());

class Session {
  Session({
    this.accessToken,
    this.tokenType,
    this.expiresAt,
    this.permisos,
    this.id,
    this.email,
    this.name,
    this.apellidos,
    this.rol,
    this.dni,
    this.tipoIdentificacion,
    this.datos,
  });

  String accessToken;
  String tokenType;
  DateTime expiresAt;
  List<String> permisos;
  int id;
  String email;
  String name;
  String apellidos;
  int rol;
  String dni;
  String tipoIdentificacion;
  List<UserData> datos;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresAt: DateTime.parse(json["expires_at"]),
        permisos: List<String>.from(json["permisos"].map((x) => x)),
        id: json["id"],
        email: json["email"],
        name: json["name"],
        apellidos: json["apellidos"],
        rol: json["rol"],
        dni: json["dni"],
        tipoIdentificacion: json["tipo_identificacion"],
        datos: List<UserData>.from(
          json["datos"].map((x) => UserData.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_at": expiresAt.toIso8601String(),
        "permisos": List<dynamic>.from(permisos.map((x) => x)),
        "id": id,
        "email": email,
        "name": name,
        "apellidos": apellidos,
        "rol": rol,
        "dni": dni,
        "tipo_identificacion": tipoIdentificacion,
        "datos": List<dynamic>.from(datos.map((x) => x.toJson())),
      };

  bool get isVendedor => rol == 2;
  bool get isCliente => rol == 3;
}
