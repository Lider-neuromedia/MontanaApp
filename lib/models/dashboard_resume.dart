import 'dart:convert';

DashboardResumen dashboardResumenFromJson(String str) =>
    DashboardResumen.fromJson(json.decode(str));

String dashboardResumenToJson(DashboardResumen data) =>
    json.encode(data.toJson());

class DashboardResumen {
  DashboardResumen({
    this.cantidadClientes,
    this.cantidadClientesAtendidos,
    this.cantidadTiendas,
    this.cantidadPqrs,
    this.cantidadPedidos,
  });

  int cantidadClientes;
  int cantidadClientesAtendidos;
  int cantidadTiendas;
  int cantidadPqrs;
  CantidadPedidos cantidadPedidos;

  factory DashboardResumen.fromJson(Map<String, dynamic> json) =>
      DashboardResumen(
        cantidadClientes: json["cantidad_clientes"],
        cantidadClientesAtendidos: json["cantidad_clientes_atendidos"],
        cantidadTiendas: json["cantidad_tiendas"],
        cantidadPqrs: json["cantidad_pqrs"],
        cantidadPedidos: CantidadPedidos.fromJson(json["cantidad_pedidos"]),
      );

  Map<String, dynamic> toJson() => {
        "cantidad_clientes": cantidadClientes,
        "cantidad_clientes_atendidos": cantidadClientesAtendidos,
        "cantidad_tiendas": cantidadTiendas,
        "cantidad_pqrs": cantidadPqrs,
        "cantidad_pedidos": cantidadPedidos.toJson(),
      };
}

class CantidadPedidos {
  CantidadPedidos({
    this.realizados,
    this.aprobados,
    this.rechazados,
    this.pendientes,
  });

  int realizados;
  int aprobados;
  int rechazados;
  int pendientes;

  factory CantidadPedidos.fromJson(Map<String, dynamic> json) =>
      CantidadPedidos(
        realizados: json["realizados"],
        aprobados: json["aprobados"],
        rechazados: json["rechazados"],
        pendientes: json["pendientes"],
      );

  Map<String, dynamic> toJson() => {
        "realizados": realizados,
        "aprobados": aprobados,
        "rechazados": rechazados,
        "pendientes": pendientes,
      };
}
