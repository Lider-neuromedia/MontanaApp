class Novedad {
  Novedad({
    this.idNovedad,
    this.tipo,
    this.descripcion,
    this.pedido,
    this.createdAt,
    this.updatedAt,
  });

  int idNovedad;
  String tipo;
  String descripcion;
  int pedido;
  DateTime createdAt;
  DateTime updatedAt;

  factory Novedad.fromJson(Map<String, dynamic> json) => Novedad(
        idNovedad: json["id_novedad"],
        tipo: json["tipo"],
        descripcion: json["descripcion"],
        pedido: json["pedido"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_novedad": idNovedad,
        "tipo": tipo,
        "descripcion": descripcion,
        "pedido": pedido,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
