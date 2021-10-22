class PedidoCliente {
  PedidoCliente({
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
  double subTotal;
  double total;
  int descuento;
  String notas;
  String firma;
  int vendedor;
  int cliente;
  int estado;
  DateTime createdAt;
  DateTime updatedAt;

  factory PedidoCliente.fromJson(Map<String, dynamic> json) => PedidoCliente(
        idPedido: json["id_pedido"],
        fecha: DateTime.parse(json["fecha"]),
        codigo: json["codigo"],
        metodoPago: json["metodo_pago"],
        subTotal: json.containsKey("sub_total")
            ? double.parse(json["sub_total"].toString())
            : null,
        total: double.parse(json["total"].toString()),
        descuento: json["descuento"],
        notas: json["notas"] ?? null,
        firma: json["firma"] ?? null,
        vendedor: json["vendedor"],
        cliente: json["cliente"],
        estado: json["estado"],
        createdAt: json.containsKey("created_at")
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        updatedAt: json.containsKey("updated_at")
            ? DateTime.parse(json["updated_at"])
            : DateTime.now(),
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
        "notas": notas ?? null,
        "firma": firma,
        "vendedor": vendedor,
        "cliente": cliente,
        "estado": estado,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
