enum Estado { ENTREGADO, PENDIENTE, CANCELADO }

final estadoValues = EnumValues({
  "cancelado": Estado.CANCELADO,
  "entregado": Estado.ENTREGADO,
  "pendiente": Estado.PENDIENTE
});

final estadoValuesById = {
  1: Estado.ENTREGADO,
  2: Estado.PENDIENTE,
  3: Estado.CANCELADO,
};

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
