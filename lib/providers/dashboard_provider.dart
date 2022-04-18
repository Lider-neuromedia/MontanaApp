import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/client_wallet_resume.dart';
import 'package:montana_mobile/models/dashboard_resume.dart';
import 'package:montana_mobile/models/seller_wallet_resume.dart';
import 'package:montana_mobile/providers/database_provider.dart';
import 'package:montana_mobile/utils/preferences.dart';

class DashboardProvider with ChangeNotifier {
  final String _url = dotenv.env["API_URL"];
  final _preferences = Preferences();

  final List<CalendarFilter> monthsFilter = _monthsFilter;
  final List<CalendarFilter> yearsFilter = _yearsFilter();

  String _currentClientsReadyDate;
  String get currentClientsReadyDate => _currentClientsReadyDate;

  String _clientsReadyYear = "";
  String get clientsReadyYear => _clientsReadyYear;

  set clientsReadyYear(String value) {
    _clientsReadyYear = value;
    notifyListeners();
  }

  String _clientsReadyMonth = "";
  String get clientsReadyMonth => _clientsReadyMonth;

  set clientsReadyMonth(String value) {
    _clientsReadyMonth = value;
    notifyListeners();
  }

  String get clientsReadyDate {
    if (_clientsReadyYear.isNotEmpty && _clientsReadyMonth.isNotEmpty) {
      return "$_clientsReadyYear-$_clientsReadyMonth";
    }

    return null;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DashboardResumen _resume;
  DashboardResumen get resume => _resume;

  ResumenCarteraVendedor _sellerResume;
  ResumenCarteraVendedor get sellerResume => _sellerResume;

  ResumenCarteraCliente _clientResume;
  ResumenCarteraCliente get clientResume => _clientResume;

  Future<void> loadDashboardResume({@required bool local}) async {
    _resume = null;
    _isLoading = true;
    _currentClientsReadyDate = clientsReadyDate;
    notifyListeners();

    _resume =
        local ? await getDashboardResumeLocal() : await getDashboardResume();

    if (_preferences.session.isVendedor) {
      _sellerResume = local
          ? await getResumeSellerWalletLocal()
          : await getResumeSellerWallet();
    } else {
      _clientResume = local
          ? await getResumeClientWalletLocal()
          : await getResumeClientWallet();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<DashboardResumen> getDashboardResume() async {
    Uri url = Uri.parse("$_url/dashboard-resumen");

    if (clientsReadyDate != null) {
      url = Uri.parse(
          "$_url/dashboard-resumen?fecha_atendidos=$clientsReadyDate");
    }

    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return dashboardResumenFromJson(response.body);
  }

  Future<DashboardResumen> getDashboardResumeLocal() async {
    final resume =
        await DatabaseProvider.db.getRecordById("dashboard_resume", 1);

    if (resume == null) {
      return DashboardResumen(
        cantidadClientes: 0,
        cantidadClientesAtendidos: 0,
        cantidadTiendas: 0,
        cantidadPqrs: 0,
        cantidadPedidos: CantidadPedidos(
          realizados: 0,
          aprobados: 0,
          rechazados: 0,
          pendientes: 0,
        ),
      );
    }

    Map<String, Object> resumeTemp = Map<String, Object>.of(resume);
    resumeTemp["cantidad_pedidos"] = jsonDecode(resumeTemp["cantidad_pedidos"]);

    return DashboardResumen.fromJson(resumeTemp);
  }

  Future<ResumenCarteraVendedor> getResumeSellerWallet() async {
    final path = "$_url/resumen/vendedor/${_preferences.session.id}";
    Uri url = Uri.parse(path);
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return resumenCarteraVendedorFromJson(response.body);
  }

  Future<ResumenCarteraVendedor> getResumeSellerWalletLocal() async {
    final record = await DatabaseProvider.db
        .getRecordById("sellers_resume", _preferences.session.id);

    if (record == null) return null;

    Map<String, Object> recordTemp = Map<String, Object>.of(record);
    return ResumenCarteraVendedor.fromJson(recordTemp);
  }

  Future<ResumenCarteraCliente> getResumeClientWallet() async {
    Uri url = Uri.parse("$_url/resumen/cliente/${_preferences.session.id}");
    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return resumenCarteraClienteFromJson(response.body);
  }

  Future<ResumenCarteraCliente> getResumeClientWalletLocal() async {
    final record = await DatabaseProvider.db
        .getRecordById("clients_resume", _preferences.session.id);

    if (record == null) return null;

    Map<String, Object> recordTemp = Map<String, Object>.of(record);
    return ResumenCarteraCliente.fromJson(recordTemp);
  }
}

class CalendarFilter {
  String name;
  String number;

  CalendarFilter(this.name, this.number);
}

List<CalendarFilter> _monthsFilter = [
  CalendarFilter("Seleccione mes", ""),
  CalendarFilter("Enero", "01"),
  CalendarFilter("Febrero", "02"),
  CalendarFilter("Marzo", "03"),
  CalendarFilter("Abril", "04"),
  CalendarFilter("Mayo", "05"),
  CalendarFilter("Junio", "06"),
  CalendarFilter("Julio", "07"),
  CalendarFilter("Agosto", "08"),
  CalendarFilter("Septiembre", "09"),
  CalendarFilter("Octubre", "10"),
  CalendarFilter("Noviembre", "11"),
  CalendarFilter("Diciembre", "12"),
];

List<CalendarFilter> _yearsFilter() {
  final currentDate = DateTime.now();
  List<CalendarFilter> list = [];

  list.add(CalendarFilter("Seleccione año", ""));

  for (int i = 2018; i <= currentDate.year; i++) {
    list.add(CalendarFilter("$i", "$i"));
  }

  return list;
}
