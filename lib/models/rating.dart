import 'dart:convert';
import 'package:montana_mobile/models/question_rating.dart';

Rating responseValoracionesFromJson(String str) =>
    Rating.fromJson(json.decode(str));

String responseValoracionesToJson(Rating data) => json.encode(data.toJson());

class Rating {
  Rating({
    this.productoId,
    this.cantidadValoraciones,
    this.usuarios,
    this.valoraciones,
  });

  String productoId;
  int cantidadValoraciones;
  List<int> usuarios;
  List<ValoracionPregunta> valoraciones;

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        productoId: json["producto_id"],
        cantidadValoraciones: json["cantidad_valoraciones"],
        usuarios: List<int>.from(json["usuarios"].map((x) => x)),
        valoraciones: List<ValoracionPregunta>.from(
            json["valoraciones"].map((x) => ValoracionPregunta.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "producto_id": productoId,
        "cantidad_valoraciones": cantidadValoraciones,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x)),
        "valoraciones": List<dynamic>.from(valoraciones.map((x) => x.toJson())),
      };
}
