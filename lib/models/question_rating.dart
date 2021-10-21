class ValoracionPregunta {
  ValoracionPregunta({
    this.preguntaId,
    this.pregunta,
    this.calificacion,
    this.promedio,
    this.subtotal,
    this.valoraciones,
  });

  int preguntaId;
  String pregunta;
  int calificacion;
  double promedio;
  int subtotal;
  List<int> valoraciones;

  factory ValoracionPregunta.fromJson(Map<String, dynamic> json) =>
      ValoracionPregunta(
        preguntaId: json["pregunta_id"],
        pregunta: json["pregunta"],
        calificacion: json["calificacion"],
        promedio: json["promedio"].toDouble(),
        subtotal: json["subtotal"],
        valoraciones: List<int>.from(json["valoraciones"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "pregunta_id": preguntaId,
        "pregunta": pregunta,
        "calificacion": calificacion,
        "promedio": promedio,
        "subtotal": subtotal,
        "valoraciones": List<dynamic>.from(valoraciones.map((x) => x)),
      };
}
