import 'dart:convert';
import 'package:montana_mobile/models/client_order.dart';
import 'package:montana_mobile/models/seller.dart';
import 'package:montana_mobile/models/store.dart';
import 'package:montana_mobile/models/user_data.dart';

ResponseClientes responseClientesFromJson(String str) =>
    ResponseClientes.fromJson(json.decode(str));

String responseClientesToJson(ResponseClientes data) =>
    json.encode(data.toJson());

List<Cliente> responseVendedorClientesFromJson(String str) =>
    List<Cliente>.from(
      json.decode(str).map((x) => Cliente.fromJson(x)),
    );

Cliente responseClienteFromJson(String str) =>
    Cliente.fromJson(json.decode(str));

String responseClienteToJson(Cliente data) => json.encode(data.toJson());

class ResponseClientes {
  ResponseClientes({
    this.fields,
    this.clientes,
  });

  List<String> fields;
  List<Cliente> clientes;

  factory ResponseClientes.fromJson(Map<String, dynamic> json) =>
      ResponseClientes(
        fields: List<String>.from(json["fields"]),
        clientes: List<Cliente>.from(
          json["users"].map((x) => Cliente.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "fields": fields,
        "users": List<dynamic>.from(clientes.map((x) => x.toJson())),
      };
}

class Cliente {
  Cliente({
    this.id,
    this.rolId,
    this.name,
    this.apellidos,
    this.email,
    this.tipoIdentificacion,
    this.dni,
    this.nit,
    this.userData,
    this.vendedorId,
    this.vendedor,
    this.tiendas,
    this.pedidos,
  });

  int id;
  int rolId;
  String name;
  String apellidos;
  String email;
  String tipoIdentificacion;
  String dni;
  String nit;
  List<UserData> userData;
  int vendedorId;
  Vendedor vendedor;
  List<Tienda> tiendas;
  List<PedidoCliente> pedidos;

  String get nombreCompleto => "$name $apellidos";

  String getData(String key) {
    String value = '';

    userData.forEach((data) {
      if (data.fieldKey == key) {
        value = data.valueKey != null ? data.valueKey : '';
      }
    });

    return value;
  }

  String get iniciales {
    List<String> words = nombreCompleto.split(" ");

    if (words.length == 1) {
      return words[0].substring(0, 2).toUpperCase();
    } else if (words.length > 1) {
      String c1 = words[0].substring(0, 1);
      String c2 = words[1].substring(0, 1);
      return "$c1$c2";
    }

    return 'CL';
  }

  factory Cliente.fromJson(Map<String, dynamic> json) {
    List<UserData> userData = [];

    if (json.containsKey("user_data")) {
      userData = List<UserData>.from(
          json["user_data"].map((x) => UserData.fromJson(x)));
    } else if (json.containsKey("data_user")) {
      userData = List<UserData>.from(
          json["data_user"].map((x) => UserData.fromJson(x)));
    } else if (json.containsKey("data")) {
      userData =
          List<UserData>.from(json["data"].map((x) => UserData.fromJson(x)));
    }

    return Cliente(
      id: json.containsKey("id_cliente") ? json["id_cliente"] : json["id"],
      rolId: json["rol_id"],
      name: json["name"],
      apellidos: json["apellidos"],
      email: json["email"],
      tipoIdentificacion: json["tipo_identificacion"] ?? null,
      dni: json["dni"] ?? null,
      nit: json["nit"] ?? null,
      userData: userData,
      vendedorId: json["id_vendedor_cliente"] ?? null,
      vendedor: json.containsKey("vendedor")
          ? Vendedor.fromJson(json["vendedor"])
          : null,
      tiendas: json.containsKey("tiendas")
          ? List<Tienda>.from(json["tiendas"].map((x) => Tienda.fromJson(x)))
          : [],
      pedidos: json.containsKey("pedidos")
          ? List<PedidoCliente>.from(
              json["pedidos"].map((x) => PedidoCliente.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "rol_id": rolId,
        "name": name,
        "apellidos": apellidos,
        "email": email,
        "tipo_identificacion": tipoIdentificacion,
        "dni": dni,
        "nit": nit,
        "user_data": List<dynamic>.from(userData.map((x) => x.toJson())),
        "vendedor": vendedor != null ? vendedor.toJson() : null,
        "data_user": userData != null
            ? List<dynamic>.from(userData.map((x) => x.toJson()))
            : [],
        "tiendas": tiendas != null
            ? List<dynamic>.from(tiendas.map((x) => x.toJson()))
            : [],
        "pedidos": pedidos != null
            ? List<dynamic>.from(pedidos.map((x) => x.toJson()))
            : [],
      };
}
