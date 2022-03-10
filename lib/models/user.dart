import 'dart:convert';
import 'package:montana_mobile/models/user_data.dart';

ResponseUsuarios responseUsuariosFromJson(String str) =>
    ResponseUsuarios.fromJson(json.decode(str));

String responseUsuariosToJson(ResponseUsuarios data) =>
    json.encode(data.toJson());

List<Usuario> responseVendedorClientesFromJson(String str) =>
    List<Usuario>.from(json.decode(str).map((x) => Usuario.fromJson(x)));

String responseVendedorClientesToJson(List<Usuario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Usuario responseUsuarioFromJson(String str) =>
    Usuario.fromJson(json.decode(str));

String responseUsuarioToJson(Usuario data) => json.encode(data.toJson());

class ResponseUsuarios {
  ResponseUsuarios({
    this.users,
  });

  Usuarios users;

  factory ResponseUsuarios.fromJson(Map<String, dynamic> json) =>
      ResponseUsuarios(
        users: Usuarios.fromJson(json["users"]),
      );

  Map<String, dynamic> toJson() => {
        "users": users.toJson(),
      };
}

class Usuarios {
  Usuarios({
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
  List<Usuario> data;
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

  factory Usuarios.fromJson(Map<String, dynamic> json) => Usuarios(
        currentPage: json["current_page"],
        data: List<Usuario>.from(json["data"].map((x) => Usuario.fromJson(x))),
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

class Usuario {
  Usuario({
    this.id,
    this.name,
    this.apellidos,
    this.email,
    this.tipoIdentificacion,
    this.dni,
    this.rolId,
    this.datos,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String apellidos;
  String email;
  String tipoIdentificacion;
  String dni;
  int rolId;
  List<UserData> datos;
  DateTime createdAt;
  DateTime updatedAt;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        name: json["name"] ?? "",
        apellidos: json["apellidos"] ?? "",
        email: json["email"] ?? "",
        tipoIdentificacion: json["tipo_identificacion"] ?? "",
        dni: json["dni"] ?? "",
        rolId: json["rol_id"],
        datos: json["datos"] != null
            ? List<UserData>.from(
                json["datos"].map((x) => UserData.fromJson(x)))
            : [],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "apellidos": apellidos,
        "email": email,
        "tipo_identificacion": tipoIdentificacion,
        "dni": dni,
        "rol_id": rolId,
        "datos": datos != null
            ? List<dynamic>.from(datos.map((x) => x.toJson()))
            : [],
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  String get nombreCompleto => ("$name $apellidos").trim();

  String getData(String key) {
    String value = "";

    datos.forEach((data) {
      if (data.fieldKey == key) {
        value = data.valueKey;
      }
    });

    return value;
  }

  String get iniciales {
    List<String> words = nombreCompleto.split(" ");
    String respuesta = "CL";

    if (words.length == 1) {
      respuesta = words[0].substring(0, 2).toUpperCase();
    } else if (words.length > 1) {
      final c1 = words[0].substring(0, 1);
      final c2 = words[1].substring(0, 1);
      respuesta = "$c1$c2";
    }

    return respuesta.toUpperCase();
  }

  bool hasMatch(search) {
    bool match = false;
    String _name = "${nombreCompleto.toLowerCase()}";
    String _email = "${email.toLowerCase()}";
    String _dni = "${dni.toLowerCase()}";
    String _id = "${id.toString().toLowerCase()}";
    String _nit = "${getData("nit").toLowerCase()}";
    String _razonSocial = "${getData("razon_social").toLowerCase()}";
    String _phone = "${getData("telefono").toLowerCase()}";

    if (_name.indexOf(search) != -1 ||
        _email.indexOf(search) != -1 ||
        _dni.indexOf(search) != -1 ||
        _id.indexOf(search) != -1 ||
        _nit.indexOf(search) != -1 ||
        _razonSocial.indexOf(search) != -1 ||
        _phone.indexOf(search) != -1) {
      match = true;
    }

    return match;
  }
}
