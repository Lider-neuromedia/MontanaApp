import 'dart:convert';
import 'package:montana_mobile/models/user_data.dart';

ResponseClientes responseClientesFromJson(String str) =>
    ResponseClientes.fromJson(json.decode(str));
String responseClientesToJson(ResponseClientes data) =>
    json.encode(data.toJson());
List<Cliente> responseVendedorClientesFromJson(String str) =>
    List<Cliente>.from(json.decode(str).map(
          (x) => Cliente.fromVendedorClientesJson(x),
        ));

Cliente responseClienteFromJson(String str) =>
    Cliente.detailFromJson(json.decode(str));
String responseClienteToJson(Cliente data) => json.encode(data.detailToJson());

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
  List<UserData> userData;
  int vendedorId;
  Vendedor vendedor;
  List<Tienda> tiendas;
  List<Pedido> pedidos;

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

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        rolId: json["rol_id"],
        name: json["name"],
        apellidos: json["apellidos"],
        email: json["email"],
        tipoIdentificacion: json["tipo_identificacion"],
        dni: json["dni"],
        userData: List<UserData>.from(
          json["user_data"].map((x) => UserData.fromJson(x)),
        ),
        vendedor: json["vendedor"] == null
            ? null
            : Vendedor.fromJson(json["vendedor"]),
      );

  factory Cliente.fromVendedorClientesJson(Map<String, dynamic> json) =>
      Cliente(
        vendedorId: json["id_vendedor_cliente"],
        id: json["id_cliente"],
        rolId: json["rol_id"],
        name: json["name"],
        apellidos: json["apellidos"],
        email: json["email"],
        userData: List<UserData>.from(
          json["data"].map((x) => UserData.fromJson(x)),
        ),
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
        "vendedor": vendedor == null ? null : vendedor.toJson(),
      };

  factory Cliente.detailFromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        rolId: json["rol_id"],
        name: json["name"],
        apellidos: json["apellidos"],
        email: json["email"],
        tipoIdentificacion: json["tipo_identificacion"],
        dni: json["dni"],
        userData: List<UserData>.from(
            json["data_user"].map((x) => UserData.fromJson(x))),
        vendedor: json["vendedor"] == null
            ? null
            : Vendedor.detailFromJson(json["vendedor"]),
        tiendas:
            List<Tienda>.from(json["tiendas"].map((x) => Tienda.fromJson(x))),
        pedidos:
            List<Pedido>.from(json["pedidos"].map((x) => Pedido.fromJson(x))),
      );

  Map<String, dynamic> detailToJson() => {
        "id": id,
        "rol_id": rolId,
        "name": name,
        "apellidos": apellidos,
        "email": email,
        "tipo_identificacion": tipoIdentificacion,
        "dni": dni,
        "data_user": List<dynamic>.from(userData.map((x) => x.toJson())),
        "vendedor": vendedor.detailToJson(),
        "tiendas": List<dynamic>.from(tiendas.map((x) => x.toJson())),
        "pedidos": List<dynamic>.from(pedidos.map((x) => x.toJson())),
      };
}

class Pedido {
  Pedido({
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

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
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
      };
}

class Tienda {
  Tienda({
    this.idTiendas,
    this.nombre,
    this.lugar,
    this.local,
    this.direccion,
    this.telefono,
  });

  int idTiendas;
  String nombre;
  String lugar;
  String local;
  String direccion;
  String telefono;

  factory Tienda.fromJson(Map<String, dynamic> json) => Tienda(
        idTiendas: json["id_tiendas"],
        nombre: json["nombre"],
        lugar: json["lugar"],
        local: json["local"] == null ? null : json["local"],
        direccion: json["direccion"] == null ? null : json["direccion"],
        telefono: json["telefono"] == null ? null : json["telefono"],
      );

  Map<String, dynamic> toJson() => {
        "id_tiendas": idTiendas,
        "nombre": nombre,
        "lugar": lugar,
        "local": local == null ? null : local,
        "direccion": direccion == null ? null : direccion,
        "telefono": telefono == null ? null : telefono,
      };
}

class Vendedor {
  Vendedor({
    this.idVendedorCliente,
    this.idVendedor,
    this.idCliente,
    this.id,
    this.rolId,
    this.name,
    this.apellidos,
    this.email,
    this.userData,
    this.tipoIdentificacion,
    this.dni,
  });

  int idVendedorCliente;
  int idVendedor;
  int idCliente;
  int id;
  int rolId;
  String name;
  String apellidos;
  String email;
  List<UserData> userData;
  String tipoIdentificacion;
  String dni;

  factory Vendedor.fromJson(Map<String, dynamic> json) => Vendedor(
        idVendedorCliente: json["id_vendedor_cliente"],
        idVendedor: json["vendedor"],
        idCliente: json["cliente"],
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
        "vendedor": idVendedor,
        "cliente": idCliente,
        "id": id,
        "rol_id": rolId,
        "name": name,
        "apellidos": apellidos,
        "email": email,
        "tipo_identificacion": tipoIdentificacion,
        "dni": dni,
      };

  factory Vendedor.detailFromJson(Map<String, dynamic> json) => Vendedor(
        idVendedorCliente: json["id_vendedor_cliente"],
        idVendedor: json["id_vendedor"],
        idCliente: json["id_cliente"],
        rolId: json["rol_id"],
        name: json["name"],
        apellidos: json["apellidos"],
        email: json["email"],
        userData: List<UserData>.from(
          json["user_data"].map((x) => UserData.fromJson(x)),
        ),
      );

  Map<String, dynamic> detailToJson() => {
        "id_vendedor_cliente": idVendedorCliente,
        "id_vendedor": idVendedor,
        "id_cliente": idCliente,
        "rol_id": rolId,
        "name": name,
        "apellidos": apellidos,
        "email": email,
        "user_data": List<dynamic>.from(userData.map((x) => x.toJson())),
      };
}
