import 'dart:convert';

ResponseClientes responseClientesFromJson(String str) =>
    ResponseClientes.fromJson(json.decode(str));

String responseClientesToJson(ResponseClientes data) =>
    json.encode(data.toJson());

class ResponseClientes {
  ResponseClientes({
    this.fields,
    this.clientes,
  });

  List<Field> fields;
  List<Cliente> clientes;

  factory ResponseClientes.fromJson(Map<String, dynamic> json) =>
      ResponseClientes(
        fields: List<Field>.from(
          json["fields"].map((x) => fieldValues.map[x]),
        ),
        clientes: List<Cliente>.from(
          json["users"].map((x) => Cliente.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "fields": List<dynamic>.from(fields.map((x) => fieldValues.reverse[x])),
        "users": List<dynamic>.from(clientes.map((x) => x.toJson())),
      };
}

enum Field { NIT, RAZON_SOCIAL, DIRECCION, TELEFONO }

final fieldValues = EnumValues({
  "direccion": Field.DIRECCION,
  "nit": Field.NIT,
  "razon_social": Field.RAZON_SOCIAL,
  "telefono": Field.TELEFONO
});

class Cliente {
  Cliente({
    this.id,
    this.rolId,
    this.name,
    this.apellidos,
    this.email,
    this.tipoIdentificacion,
    this.dni,
    this.userData,
    this.iniciales,
    this.vendedor,
  });

  int id;
  int rolId;
  String name;
  String apellidos;
  String email;
  String tipoIdentificacion;
  String dni;
  List<UserData> userData;
  String iniciales;
  Vendedor vendedor;

  String get nombreCompleto => "$name $apellidos";

  String getData(Field key) {
    String value;

    userData.forEach((data) {
      if (data.fieldKey == key) {
        value = data.valueKey;
      }
    });

    return value;
  }

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        rolId: json["rol_id"],
        name: json["name"],
        apellidos: json["apellidos"],
        email: json["email"],
        tipoIdentificacion: json["tipo_identificacion"],
        dni: json["dni"],
        userData: List<UserData>.from(
            json["user_data"].map((x) => UserData.fromJson(x))),
        iniciales: json["iniciales"],
        vendedor: json["vendedor"] == null
            ? null
            : Vendedor.fromJson(json["vendedor"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rol_id": rolId,
        "name": name,
        "apellidos": apellidos,
        "email": email,
        "tipo_identificacion": tipoIdentificacion,
        "dni": dni,
        "user_data": List<dynamic>.from(userData.map((x) => x.toJson())),
        "iniciales": iniciales,
        "vendedor": vendedor == null ? null : vendedor.toJson(),
      };
}

class UserData {
  UserData({
    this.id,
    this.userId,
    this.fieldKey,
    this.valueKey,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  Field fieldKey;
  String valueKey;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        userId: json["user_id"],
        fieldKey: fieldValues.map[json["field_key"]],
        valueKey: json["value_key"] == null ? null : json["value_key"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "field_key": fieldValues.reverse[fieldKey],
        "value_key": valueKey == null ? null : valueKey,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Vendedor {
  Vendedor({
    this.idVendedorCliente,
    this.vendedor,
    this.cliente,
    this.id,
    this.rolId,
    this.name,
    this.apellidos,
    this.email,
    this.tipoIdentificacion,
    this.dni,
  });

  int idVendedorCliente;
  int vendedor;
  int cliente;
  int id;
  int rolId;
  String name;
  String apellidos;
  String email;
  String tipoIdentificacion;
  String dni;

  factory Vendedor.fromJson(Map<String, dynamic> json) => Vendedor(
        idVendedorCliente: json["id_vendedor_cliente"],
        vendedor: json["vendedor"],
        cliente: json["cliente"],
        id: json["id"],
        rolId: json["rol_id"],
        name: json["name"],
        apellidos: json["apellidos"],
        email: json["email"],
        tipoIdentificacion: json["tipo_identificacion"],
        dni: json["dni"],
      );

  Map<String, dynamic> toJson() => {
        "id_vendedor_cliente": idVendedorCliente,
        "vendedor": vendedor,
        "cliente": cliente,
        "id": id,
        "rol_id": rolId,
        "name": name,
        "apellidos": apellidos,
        "email": email,
        "tipo_identificacion": tipoIdentificacion,
        "dni": dni,
      };
}

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
