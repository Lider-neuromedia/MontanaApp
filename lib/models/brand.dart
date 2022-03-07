class Marca {
  Marca({
    this.id,
    this.nombreMarca,
    this.codigo,
  });

  int id;
  String nombreMarca;
  String codigo;

  factory Marca.fromJson(Map<String, dynamic> json) => Marca(
        id: json["id_marca"],
        nombreMarca: json["nombre_marca"],
        codigo: json["codigo"],
      );

  Map<String, dynamic> toJson() => {
        "id_marca": id,
        "nombre_marca": nombreMarca,
        "codigo": codigo,
      };
}
