import 'dart:convert';

Session sessionFromJson(String str) => Session.fromJson(json.decode(str));

String sessionToJson(Session data) => json.encode(data.toJson());

class Session {
  Session({
    this.accessToken,
    this.tokenType,
    this.expiresAt,
    this.id,
    this.email,
    this.name,
    this.rol,
    this.userdata,
    this.permisos,
  });

  String accessToken;
  String tokenType;
  DateTime expiresAt;
  int id;
  String email;
  String name;
  int rol;
  List<Userdatum> userdata;
  List<String> permisos;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresAt: DateTime.parse(json["expires_at"]),
        id: json["id"],
        email: json["email"],
        name: json["name"],
        rol: json["rol"],
        userdata: List<Userdatum>.from(
            json["userdata"].map((x) => Userdatum.fromJson(x))),
        permisos: List<String>.from(json["permisos"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_at": expiresAt.toIso8601String(),
        "id": id,
        "email": email,
        "name": name,
        "rol": rol,
        "userdata": List<dynamic>.from(userdata.map((x) => x.toJson())),
        "permisos": List<dynamic>.from(permisos.map((x) => x)),
      };
}

class Userdatum {
  Userdatum({
    this.id,
    this.userId,
    this.fieldKey,
    this.valueKey,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  String fieldKey;
  String valueKey;
  DateTime createdAt;
  DateTime updatedAt;

  factory Userdatum.fromJson(Map<String, dynamic> json) => Userdatum(
        id: json["id"],
        userId: json["user_id"],
        fieldKey: json["field_key"],
        valueKey: json["value_key"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "field_key": fieldKey,
        "value_key": valueKey,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
