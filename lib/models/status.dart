import 'package:flutter/material.dart';

class Estado {
  Estado({
    this.id,
    this.estado,
  });

  int id;
  EstadoEnum estado;

  factory Estado.fromJson(Map<String, dynamic> json) => Estado(
        id: json["id"],
        estado: estadoEnumValues.map[json["estado"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estado": estadoEnumValues.reverse[estado],
      };

  Color get color => _estadoColors[estado];

  String get estadoFormatted {
    final temp = estado.toString().split(".")[1].toLowerCase();
    final firstLetter = temp.substring(0, 1).toUpperCase();
    final word = firstLetter + temp.substring(1, temp.length);
    return word;
  }
}

const Map<EstadoEnum, Color> _estadoColors = {
  EstadoEnum.CANCELADO: const Color.fromRGBO(229, 10, 32, 1.0),
  EstadoEnum.ENTREGADO: const Color.fromRGBO(55, 202, 8, 1.0),
  EstadoEnum.PENDIENTE: const Color.fromRGBO(109, 109, 109, 1.0),
};

enum EstadoEnum { PENDIENTE, ENTREGADO, CANCELADO }

final estadoEnumValues = EnumValues({
  "cancelado": EstadoEnum.CANCELADO,
  "entregado": EstadoEnum.ENTREGADO,
  "pendiente": EstadoEnum.PENDIENTE
});

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
