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
        cantidadClientes: json["cantidad_clientes"] ?? 0,
        cantidadClientesAtendidos: json["cantidad_clientes_atendidos"] ?? 0,
        cantidadTiendas: json["cantidad_tiendas"] ?? 0,
        cantidadPqrs: json["cantidad_pqrs"] ?? 0,
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
        realizados: json["realizados"] ?? 0,
        aprobados: json["aprobados"] ?? 0,
        rechazados: json["rechazados"] ?? 0,
        pendientes: json["pendientes"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "realizados": realizados,
        "aprobados": aprobados,
        "rechazados": rechazados,
        "pendientes": pendientes,
      };
}
