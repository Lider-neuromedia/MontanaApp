import 'package:montana_mobile/models/user_data.dart';

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
        id: json["id"] ?? null,
        idVendedorCliente: json["id_vendedor_cliente"],
        idVendedor: json.containsKey("vendedor")
            ? json["vendedor"]
            : json["id_vendedor"],
        idCliente:
            json.containsKey("cliente") ? json["cliente"] : json["id_cliente"],
        rolId: json["rol_id"],
        name: json["name"],
        apellidos: json["apellidos"],
        email: json["email"],
        tipoIdentificacion: json["tipo_identificacion"] ?? null,
        dni: json["dni"] ?? null,
        userData: json.containsKey("user_data")
            ? List<UserData>.from(
                json["user_data"].map((x) => UserData.fromJson(x)))
            : [],
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
        "id_vendedor": idVendedor,
        "id_cliente": idCliente,
        "user_data": userData != null
            ? List<dynamic>.from(userData.map((x) => x.toJson()))
            : [],
      };
}
