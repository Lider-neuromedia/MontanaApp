import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:montana_mobile/models/dashboard_resume.dart';
import 'package:montana_mobile/utils/preferences.dart';

class DashboardProvider with ChangeNotifier {
  final String _url = dotenv.env['API_URL'];
  final _preferences = Preferences();

  final List<CalendarFilter> monthsFilter = _monthsFilter;
  final List<CalendarFilter> yearsFilter = _yearsFilter();

  String _currentClientsReadyDate;
  String get currentClientsReadyDate => _currentClientsReadyDate;

  String _clientsReadyYear = '';
  String get clientsReadyYear => _clientsReadyYear;

  set clientsReadyYear(String value) {
    _clientsReadyYear = value;
    notifyListeners();
  }

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

  String _clientsReadyMonth = '';
  String get clientsReadyMonth => _clientsReadyMonth;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DashboardResumen _resumen;
  DashboardResumen get resumen => _resumen;

  Future<void> loadDashboardResume() async {
    _resumen = null;
    _isLoading = true;
    _currentClientsReadyDate = clientsReadyDate;
    notifyListeners();
    _resumen = await getDashboardResume();
    _isLoading = false;
    notifyListeners();
  }

  Future<DashboardResumen> getDashboardResume() async {
    Uri url;

    if (clientsReadyDate != null) {
      url = Uri.parse(
          '$_url/dashboard-resumen?fecha_atendidos=$clientsReadyDate');
    } else {
      url = Uri.parse('$_url/dashboard-resumen');
    }

    final response = await http.get(url, headers: _preferences.signedHeaders);

    if (response.statusCode != 200) return null;
    return dashboardResumenFromJson(response.body);
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

  list.add(CalendarFilter("Seleccione mes", ""));

  for (int i = 2018; i <= currentDate.year; i++) {
    list.add(CalendarFilter("$i", "$i"));
  }

  return list;
}
