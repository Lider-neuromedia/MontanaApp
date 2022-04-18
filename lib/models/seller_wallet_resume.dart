import 'dart:convert';

ResumenCarteraVendedor resumenCarteraVendedorFromJson(String str) =>
    ResumenCarteraVendedor.fromJson(json.decode(str));

String resumenCarteraVendedorToJson(ResumenCarteraVendedor data) =>
    json.encode(data.toJson());

class ResumenCarteraVendedor {
  ResumenCarteraVendedor({
    this.vendedorId,
    this.comisionesPerdidas,
    this.comisionesProximasPerder,
    this.comisionesGanadas,
  });

  int vendedorId;
  int comisionesPerdidas;
  int comisionesProximasPerder;
  int comisionesGanadas;

  factory ResumenCarteraVendedor.fromJson(Map<String, dynamic> json) =>
      ResumenCarteraVendedor(
        vendedorId: json["vendedor_id"],
        comisionesPerdidas: json["comisiones_perdidas"],
        comisionesProximasPerder: json["comisiones_proximas_perder"],
        comisionesGanadas: json["comisiones_ganadas"],
      );

  Map<String, dynamic> toJson() => {
        "vendedor_id": vendedorId,
        "comisiones_perdidas": comisionesPerdidas,
        "comisiones_proximas_perder": comisionesProximasPerder,
        "comisiones_ganadas": comisionesGanadas,
      };
}
