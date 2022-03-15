import 'dart:convert';

ResumenCarteraCliente resumenCarteraClienteFromJson(String str) =>
    ResumenCarteraCliente.fromJson(json.decode(str));

String resumenCarteraClienteToJson(ResumenCarteraCliente data) =>
    json.encode(data.toJson());

class ResumenCarteraCliente {
  ResumenCarteraCliente({
    this.clienteId,
    this.cupoPreaprobado,
    this.cupoDisponible,
    this.saldoTotalDeuda,
    this.saldoMora,
  });

  int clienteId;
  int cupoPreaprobado;
  int cupoDisponible;
  int saldoTotalDeuda;
  int saldoMora;

  factory ResumenCarteraCliente.fromJson(Map<String, dynamic> json) =>
      ResumenCarteraCliente(
        clienteId: json["cliente_id"],
        cupoPreaprobado: json["cupo_preaprobado"],
        cupoDisponible: json["cupo_disponible"],
        saldoTotalDeuda: json["saldo_total_deuda"],
        saldoMora: json["saldo_mora"],
      );

  Map<String, dynamic> toJson() => {
        "cliente_id": clienteId,
        "cupo_preaprobado": cupoPreaprobado,
        "cupo_disponible": cupoDisponible,
        "saldo_total_deuda": saldoTotalDeuda,
        "saldo_mora": saldoMora,
      };
}
