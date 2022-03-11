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
    this.notasFacturacion,
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
  String notasFacturacion;
  String firma;
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
        descuento: json["descuento"] ?? 0,
        notas: json["notas"] == null ? null : json["notas"],
        notasFacturacion: json["notas_facturacion"] == null
            ? null
            : json["notas_facturacion"],
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
        "notas_facturacion": notasFacturacion == null ? null : notasFacturacion,
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
