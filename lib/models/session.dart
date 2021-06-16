import 'dart:convert';
import 'package:montana_mobile/models/user_data.dart';

Session sessionFromJson(String str) => Session.fromJson(json.decode(str));

String sessionToJson(Session data) => json.encode(data.toJson());

class Session {
  static const rolAdministrador = 1;
  static const rolVendedor = 2;
  static const rolCliente = 3;

  Session({
    this.accessToken,
    this.tokenType,
    this.expiresAt,
    this.id,
    this.email,
    this.name,
    this.apellidos,
    this.rol,
    this.dni,
    this.tipoIdentificacion,
    this.userdata,
    this.permisos,
  });

  String accessToken;
  String tokenType;
  DateTime expiresAt;
  int id;
  String email;
  String name;
  String apellidos;
  int rol;
  String dni;
  String tipoIdentificacion;
  List<UserData> userdata;
  List<String> permisos;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresAt: DateTime.parse(json["expires_at"]),
        id: json["id"],
        email: json["email"],
        name: json["name"],
        apellidos: json["apellidos"],
        rol: json["rol"],
        dni: json["dni"],
        tipoIdentificacion: json['tipo_identificacion'],
        userdata: List<UserData>.from(
          json["userdata"].map((x) => UserData.fromJson(x)),
        ),
        permisos: List<String>.from(json["permisos"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_at": expiresAt.toIso8601String(),
        "id": id,
        "email": email,
        "name": name,
        "apellidos": apellidos,
        "rol": rol,
        "dni": dni,
        "tipo_identificacion": tipoIdentificacion,
        "userdata": List<dynamic>.from(userdata.map((x) => x.toJson())),
        "permisos": List<dynamic>.from(permisos.map((x) => x)),
      };

  bool get isVendedor => rol == rolVendedor;
  bool get isCliente => rol == rolCliente;
}
